//
//  VoiceDiaryRecordViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import AVFoundation

class VoiceDiaryRecordViewController: UIViewController, VoiceDiaryErrorDelegate, AVAudioRecorderDelegate {
    
    // MARK: Properties
    let voiceDiaryRecordView = VoiceDiaryRecordView()
    let navigationBarManager = NavigationManager()
    private var speechAPIProvider = SpeechAPIProvider()
    private var audioRecorder: AVAudioRecorder?
    private var isRecording = false // 녹음 상태 관리
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupNavigationBar()
        observeRemainingTime()
        requestMicrophonePermission()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startRecording()
    }
    
    private func observeRemainingTime() {
        voiceDiaryRecordView.onRemainingTimeChanged = { [weak self] remainingTime in
            guard let self = self else { return }
            if remainingTime == 30 {
                Toast.show(
                    image: UIImage(named: "warningIcon") ?? UIImage(),
                    message: "30초 후 대화가 종료돼요",
                    font: .heading3SemiBold()
                )
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
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        let prevVC = VoiceDiaryRecordErrorViewController()
        prevVC.delegate = self
        let navController = UINavigationController(rootViewController: prevVC)
        navController.modalPresentationStyle = .fullScreen
        
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
    
    @objc func nextVC() {
        let remainingTime = voiceDiaryRecordView.remainingTime
        if remainingTime > 170 {
            Toast.show(
                image: UIImage(named: "warningIcon") ?? UIImage(),
                message: "1분 이상 대화해 주세요",
                font: .heading3SemiBold()
            )
        } else {
            stopRecording()
            let nextVC = VoiceDiaryLoadingViewController()
            nextVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(nextVC, animated: true)
        }
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
            processAudioFile(audioFilePath: recorder.url)
        } else {
            print("녹음 실패. 다시 시도해주세요.")
        }
    }
    
    private func processAudioFile(audioFilePath: URL) {
        guard let audioData = try? Data(contentsOf: audioFilePath) else {
            print("오디오 파일을 읽을 수 없습니다.")
            return
        }
        
        let audioBase64 = audioData.base64EncodedString()
        print("Base64 인코딩된 오디오 데이터 준비 완료")
        // 여기에서 Google Speech-to-Text API 호출 로직 추가
        speechAPIProvider.recognize(audioContent: audioBase64) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let transcript):
                    print("변환된 텍스트: \(transcript)")
                case .failure(let error):
                    print("변환 실패: \(error.localizedDescription)")
                    print("API 호출 실패: \(error.localizedDescription)")
                }
            }
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
    
}
