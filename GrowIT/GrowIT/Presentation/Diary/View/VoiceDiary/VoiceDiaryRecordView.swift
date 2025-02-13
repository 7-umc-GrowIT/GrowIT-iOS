//
//  VoiceDiaryRecordView.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit
import Lottie

class VoiceDiaryRecordView: UIView {
    
    private var timer: Timer?
    
    private var isRecording = false
    
    var remainingTime: Int = 180 {
        didSet {
            let minutes = remainingTime / 60
            let seconds = remainingTime % 60
            updateTimerLabel(minutes: minutes, seconds: seconds)
            onRemainingTimeChanged?(remainingTime)
        }
    }
    
    var onRemainingTimeChanged: ((Int) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        startTimer()
        startAnimation()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 그라데이션 적용
        setGradient(color1: .gray700, color2: .gray900)
        recordButton.setGradient(color1: .primary400, color2: .primary600)
    }
    
    private func startTimer() {
        stopTimer() // 기존 타이머 중지
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            if self.remainingTime > 0 {
                self.remainingTime -= 1
            } else {
                self.timer?.invalidate()
                self.timer = nil
                self.timeOverAction()
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimerLabel(minutes: Int, seconds: Int) {
        let allText = "대화 종료까지 \(minutes)분 \(seconds)초"
        timeLabel.text = allText
        timeLabel.setPartialTextStyle(text: allText, targetText: "\(minutes)분 \(seconds)초", color: .primary400, font: .heading2SemiBold())
    }
    
    private func timeOverAction() {
        print("타이머 종료!") // 여기서 추가 작업 (예: 알림 표시, 애니메이션 종료 등)
        stopAnimation()
    }
    
    private func startAnimation() {
        chatImage.play()
    }
    
    private func stopAnimation() {
        chatImage.stop()
    }
    
    
    // MARK: UI Components
    private let label1 = UILabel().then {
        $0.text = "편하게 말해보세요\n당신의 이야기를 듣고 있어요"
        $0.font = .subTitle1()
        $0.textColor = .white
        $0.numberOfLines = 0
    }
    
    private let label2 = UILabel().then {
        $0.text = "대화가 끝났다면 버튼을 눌러주세요"
        $0.font = .heading3SemiBold()
        $0.textColor = .gray100
    }
    
    var chatImage = LottieAnimationView(name: "Conversation").then {
        $0.frame = CGRect(x: 0, y: 0, width: 175, height: 100)
        $0.loopMode = .loop
    }
    
    let recordButton = UIButton().then {
        $0.setImage(UIImage(named: "recordIcon"), for: .normal)
        $0.layer.cornerRadius = 40
        $0.clipsToBounds = true
    }
    
    let endButton = AppButton(title: "대화 마무리하기", titleColor: .black).then {
        $0.backgroundColor = .primary400
    }
    
    let clockIcon = UIImageView().then {
        $0.image = UIImage(named: "clockicon")
    }
    
    let timeLabel = UILabel().then {
        let min = 3
        let sec = 0
        let allText = "대화 종료까지 \(min)분 \(sec)초"
        $0.text = allText
        $0.font = .heading2SemiBold()
        $0.textColor = .gray300
        $0.setPartialTextStyle(text: allText, targetText: "\(min)분 \(sec)초", color: .primary400, font: .heading2SemiBold())
    }
    
    let helpLabel = UILabel().then {
        $0.text = "문제가 발생했어요"
        $0.font = .body2Medium()
        $0.textColor = .gray400
        $0.isUserInteractionEnabled = true
    }
    
    let recordAnimation = LottieAnimationView(name: "Loading").then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
        $0.alpha = 0
        $0.isUserInteractionEnabled = true
    }
    
    // MARK: Setup UI
    private func setupUI() {
        backgroundColor = .gray700
        addSubview(label1)
        label1.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
        }
        
        addSubview(label2)
        label2.snp.makeConstraints { make in
            make.leading.equalTo(label1.snp.leading)
            make.top.equalTo(label1.snp.bottom).offset(12)
        }
        
        addSubview(chatImage)
        chatImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(label2.snp.bottom).offset(-70)
        }
        
        addSubview(endButton)
        endButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-84)
        }
        
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.bottom.equalTo(endButton.snp.top).offset(-150)
            make.centerX.equalToSuperview()
        }
        
        addSubview(recordButton)
        recordButton.snp.makeConstraints { make in
            make.top.equalTo(timeLabel.snp.bottom).offset(60)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(80)
        }
        
        addSubview(recordAnimation)
        recordAnimation.snp.makeConstraints { make in
            make.edges.equalTo(recordButton)
        }
        
        addSubview(clockIcon)
        clockIcon.snp.makeConstraints { make in
            make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
            make.centerY.equalTo(timeLabel)
        }
        
        addSubview(helpLabel)
        helpLabel.snp.makeConstraints { make in
            make.top.equalTo(endButton.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupActions() {
        recordButton.addTarget(self, action: #selector(toggleRecording), for: .touchUpInside)
        
        let animationTap = UITapGestureRecognizer(target: self, action: #selector(toggleRecording))
        recordAnimation.addGestureRecognizer(animationTap)
        
    }
    
    @objc private func toggleRecording() {
        if isRecording {
            recordButton.alpha = 1
            recordAnimation.alpha = 0
            recordAnimation.stop()
            
            bringSubviewToFront(recordButton)
        } else {
            recordButton.alpha = 0
            recordAnimation.alpha = 1
            recordAnimation.play()
            
            bringSubviewToFront(recordAnimation)
        }
        isRecording.toggle()
    }
}
