//
//  VoiceDiaryRecordViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import AVFoundation
import Combine

protocol VoiceDiaryRecordDelegate: AnyObject {
    func didFinishRecording(diaryContent: String)
}

class VoiceDiaryRecordViewController: UIViewController, VoiceDiaryErrorDelegate, AVAudioRecorderDelegate {
    
    // MARK: Properties
    let voiceDiaryRecordView = VoiceDiaryRecordView()
    let navigationBarManager = NavigationManager()
    private var audioRecorder: AVAudioRecorder?
    private var audioPlayer: AVAudioPlayer?
    private var isRecording = false
    
    private let viewModel = VoiceDiaryRecordViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
        setupBindings()
        observeRemainingTime()
        requestMicrophonePermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupBindings() {
        viewModel.$shouldPresentRecordError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldPresent in
                if shouldPresent {
                    self?.presentRecordError()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldNavigateToLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldNavigate in
                if shouldNavigate {
                    self?.navigateToLoading()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowTimeWarning
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.showTimeWarning()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowMinimumTimeToast
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.showMinimumTimeToast()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldStartRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldStart in
                if shouldStart {
                    self?.startRecording()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldStopRecording
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldStop in
                if shouldStop {
                    self?.stopRecording()
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldShowTipView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldShow in
                if shouldShow {
                    self?.voiceDiaryRecordView.tipView2.isHidden = false
                }
            }
            .store(in: &cancellables)
        
        viewModel.$shouldProcessAudio
            .receive(on: DispatchQueue.main)
            .sink { [weak self] shouldProcess in
                if shouldProcess, let audioURL = self?.viewModel.audioFileURL {
                    self?.viewModel.processAudioFile(audioFilePath: audioURL)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$responseText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] responseText in
                if !responseText.isEmpty {
                    self?.handleTTSResponse(text: responseText)
                }
            }
            .store(in: &cancellables)
        
        // 로딩 상태 바인딩 추가
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    // 로딩 인디케이터 표시 (필요한 경우)
                    print("API 호출 중...")
                } else {
                    // 로딩 완료
                    print("API 호출 완료")
                }
            }
            .store(in: &cancellables)
    }
    
    private func observeRemainingTime() {
        voiceDiaryRecordView.onRemainingTimeChanged = { [weak self] remainingTime in
            guard let self = self else { return }
            self.viewModel.remainingTimeChanged.send(remainingTime)
        }
    }
    
    private func presentRecordError() {
        let prevVC = VoiceDiaryRecordErrorViewController()
        prevVC.delegate = self
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    private func navigateToLoading() {
        // diaryId가 유효한지 확인
        guard viewModel.diaryId > 0 else {
            print("Error: diaryId가 유효하지 않습니다. diaryId: \(viewModel.diaryId)")
            return
        }
        
        let nextVC = VoiceDiaryLoadingViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            print("Navigating with diaryId: \(self.viewModel.diaryId)")
            nextVC.navigateToNextScreen(
                with: self.viewModel.diaryContent,
                diaryId: self.viewModel.diaryId,
                date: self.viewModel.selectedDate
            )
        }
    }
    
    private func showTimeWarning() {
        CustomToast(containerWidth: 239).show(
            image: UIImage(named: "warningIcon") ?? UIImage(),
            message: "30초 후 대화가 종료돼요",
            font: .heading3SemiBold()
        )
    }
    
    private func showMinimumTimeToast() {
        CustomToast(containerWidth: 225).show(
            image: UIImage(named: "warningIcon") ?? UIImage(),
            message: "1분 이상 대화해 주세요",
            font: .heading3SemiBold()
        )
    }
    
    private func handleTTSResponse(text: String) {
        viewModel.synthesizeSpeech(text: text) { [weak self] audioData in
            if let data = audioData {
                self?.playAudio(data: data)
            }
        }
    }
    
    // MARK: Setup Navigation Bar
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .white
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "",
            textColor: .black
        )
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(voiceDiaryRecordView)
        voiceDiaryRecordView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        voiceDiaryRecordView.endButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        voiceDiaryRecordView.recordButton.addTarget(self, action: #selector(beginRecord), for: .touchUpInside)
        
        voiceDiaryRecordView.loadingButton.addTarget(self, action: #selector(stopRecord), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        viewModel.backButtonTapped.send()
    }
    
    @objc func nextVC() {
        let remainingTime = voiceDiaryRecordView.remainingTime
        viewModel.endButtonTapped.send(remainingTime)
    }
    
    @objc func beginRecord() {
        viewModel.recordButtonTapped.send()
    }
    
    @objc func stopRecord() {
        viewModel.stopRecordButtonTapped.send()
    }
    
    func didTapExitButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: Setup STT
    private func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .defaultToSpeaker)
            try audioSession.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatLinearPCM),
                AVSampleRateKey: 16000,
                AVNumberOfChannelsKey: 1,
                AVLinearPCMBitDepthKey: 16,
                AVLinearPCMIsBigEndianKey: false,
                AVLinearPCMIsFloatKey: false
            ]
            
            let tempDir = NSTemporaryDirectory()
            let audioFilePath = tempDir + "speech-to-text.wav"
            let audioFileURL = URL(fileURLWithPath: audioFilePath)
            
            audioRecorder = try AVAudioRecorder(url: audioFileURL, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            
            isRecording = true
        } catch {
            print("녹음 오류 발생: \(error.localizedDescription)")
        }
    }
    
    private func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print("녹음 성공")
            viewModel.audioRecordingFinished.send(recorder.url)
        } else {
            print("녹음 실패. 다시 시도해주세요.")
        }
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                print("마이크 사용 허용됨")
            } else {
                print("마이크 사용 거부됨")
                DispatchQueue.main.async {
                    print("마이크 사용 권한이 필요합니다.")
                }
            }
        }
    }
    
    // MARK: Setup TTS
    private func playAudio(data: Data) {
        do {
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.play()
        } catch {
            print("음성 파일 재생 실패: \(error.localizedDescription)")
        }
    }
    
}
