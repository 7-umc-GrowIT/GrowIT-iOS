//
//  VoiceDiaryRecordErrorViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/20/25.
//

import UIKit

class VoiceDiaryRecordErrorViewController: UIViewController {
    
    weak var delegate: VoiceDiaryErrorDelegate?
    
    let errorView = ErrorView().then {
        $0.configure(
            icon: "diaryIcon",
            fisrtLabel: "나가면 기록한 일기가 사라져요", secondLabel: "페이지를 이탈하면 현재 기록한 일기가 사라져요\n그래도 처음화면으로 돌아갈까요?",
            firstColor: .white, secondColor: .gray300,
            title1: "나가기", title1Color1: .gray400, title1Background: .gray700,
            title2: "계속 대화하기", title1Color2: .black, title2Background: .primary400,
            targetText: "처음화면", viewColor: .gray800
        )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(errorView)
        errorView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        errorView.exitButton.addTarget(self, action: #selector(mainVC), for: .touchUpInside)
        errorView.continueButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        dismiss(animated: true)
    }
    
    @objc func mainVC() {
        dismiss(animated: true) { [weak self] in
            self?.delegate?.didTapExitButton()
        }
    }
}
