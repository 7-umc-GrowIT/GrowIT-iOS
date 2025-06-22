//
//  VoiceDiaryRecordViewModel.swift
//  GrowIT
//
//  Created by SOOHYUN on 2025-06-22.
//

import UIKit
import Combine
import AVFoundation

class VoiceDiaryRecordViewModel: ObservableObject {
    
    // MARK: - Input Subjects
    let backButtonTapped = PassthroughSubject<Void, Never>()
    let endButtonTapped = PassthroughSubject<Int, Never>()
    let recordButtonTapped = PassthroughSubject<Void, Never>()
    let stopRecordButtonTapped = PassthroughSubject<Void, Never>()
    let remainingTimeChanged = PassthroughSubject<Int, Never>()
    let audioRecordingFinished = PassthroughSubject<URL, Never>()
    let speechRecognized = PassthroughSubject<String, Never>()
    
    // MARK: - Output Publishers
    @Published var shouldPresentRecordError = false
    @Published var shouldNavigateToLoading = false
    @Published var shouldShowTimeWarning = false
    @Published var shouldShowMinimumTimeToast = false
    @Published var shouldStartRecording = false
    @Published var shouldStopRecording = false
    @Published var shouldShowTipView = false
    @Published var isLoading = false
    @Published var shouldProcessAudio = false
    @Published var audioFileURL: URL?
    @Published var recognizedText = ""
    @Published var diaryContent = ""
    @Published var diaryId = 0
    @Published var selectedDate = ""
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let diaryService: DiaryService
    private let speechAPIProvider: SpeechAPIProvider
    
    // MARK: - Initialization
    init(diaryService: DiaryService = DiaryService(), speechAPIProvider: SpeechAPIProvider = SpeechAPIProvider()) {
        self.diaryService = diaryService
        self.speechAPIProvider = speechAPIProvider
        setupBindings()
    }
    
    // MARK: - Private Methods
    private func setupBindings() {
        backButtonTapped
            .sink { [weak self] in
                self?.shouldPresentRecordError = true
            }
            .store(in: &cancellables)
        
        endButtonTapped
            .sink { [weak self] remainingTime in
                self?.handleEndButtonTap(remainingTime: remainingTime)
            }
            .store(in: &cancellables)
        
        recordButtonTapped
            .sink { [weak self] in
                self?.shouldStartRecording = true
                self?.shouldShowTipView = true
            }
            .store(in: &cancellables)
        
        stopRecordButtonTapped
            .sink { [weak self] in
                self?.shouldStopRecording = true
            }
            .store(in: &cancellables)
        
        remainingTimeChanged
            .sink { [weak self] remainingTime in
                if remainingTime == 30 {
                    self?.shouldShowTimeWarning = true
                }
            }
            .store(in: &cancellables)
        
        audioRecordingFinished
            .sink { [weak self] audioURL in
                self?.audioFileURL = audioURL
                self?.shouldProcessAudio = true
            }
            .store(in: &cancellables)
        
        speechRecognized
            .sink { [weak self] transcript in
                self?.recognizedText = transcript
                self?.callPostVoiceDiary(userVoice: transcript)
            }
            .store(in: &cancellables)
    }
    
    private func handleEndButtonTap(remainingTime: Int) {
        if remainingTime > 120 {
            shouldShowMinimumTimeToast = true
        } else {
            shouldStopRecording = true
            shouldNavigateToLoading = true
            callPostVoiceDiaryDate()
        }
    }
    
    private func callPostVoiceDiary(userVoice: String) {
        diaryService.postVoiceDiary(
            data: DiaryVoiceRequestDTO(chat: userVoice),
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        // Handle TTS response if needed
                        break
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            })
    }
    
    private func callPostVoiceDiaryDate() {
        let date = UserDefaults.standard.string(forKey: "VoiceDate") ?? ""
        diaryService.postVoiceDiaryDate(
            data: DiaryVoiceDateRequestDTO(date: date),
            completion: { [weak self] result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self?.diaryContent = data.content
                        self?.diaryId = data.diaryId
                        self?.selectedDate = date
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            })
    }
    
    // MARK: - Public Methods
    func processAudioFile(audioFilePath: URL) {
        guard let audioData = try? Data(contentsOf: audioFilePath) else {
            print("오디오 파일을 읽을 수 없습니다.")
            return
        }
        
        let audioBase64 = audioData.base64EncodedString()
        speechAPIProvider.recognize(audioContent: audioBase64) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transcript):
                    self?.speechRecognized.send(transcript)
                case .failure(let error):
                    print("변환 실패: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func synthesizeSpeech(text: String, completion: @escaping (Data?) -> Void) {
        speechAPIProvider.synthesizeSpeech(text: text) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let audioData):
                    completion(audioData)
                case .failure(let error):
                    print("TTS 변환 실패: \(error.localizedDescription)")
                    completion(nil)
                }
            }
        }
    }
}