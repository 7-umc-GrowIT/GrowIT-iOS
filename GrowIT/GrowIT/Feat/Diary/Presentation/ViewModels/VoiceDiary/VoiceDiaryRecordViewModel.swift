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
    @Published var responseText = ""
    
    // MARK: - Private Properties
    private var cancellables = Set<AnyCancellable>()
    private let diaryService: DiaryService
    private let speechAPIProvider: SpeechAPIProvider
    private var shouldNavigateAfterAPI = false  // API 완료 후 네비게이션 플래그
    private var isNavigating = false  // 네비게이션 중인지 확인하는 플래그
    
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
                // 네비게이션 중이면 타이머 이벤트 무시
                guard self?.isNavigating == false else { return }
                
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
            // API 완료 후 네비게이션하도록 플래그 설정
            shouldNavigateAfterAPI = true
            isLoading = true  // 로딩 상태 표시
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
                        self?.responseText = data.chat
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
                    self?.isLoading = false
                    switch result {
                    case .success(let data):
                        self?.diaryContent = data.content
                        self?.diaryId = data.diaryId
                        self?.selectedDate = date
                        
                        // API 성공 후 네비게이션이 필요한 경우 실행
                        if self?.shouldNavigateAfterAPI == true {
                            self?.shouldNavigateAfterAPI = false
                            self?.isNavigating = true  // 네비게이션 시작
                            // 타이머 관련 이벤트를 더 이상 처리하지 않도록 설정
                            self?.shouldShowTimeWarning = false
                            self?.shouldNavigateToLoading = true
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                        self?.shouldNavigateAfterAPI = false
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
