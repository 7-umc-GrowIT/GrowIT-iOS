//
//  DiaryDeleteViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/24/25.
//

import UIKit

class DiaryDeleteViewController: UIViewController {
    
    var onDismiss: (() -> Void)?
    
    let deleteView = ErrorView().then {
        $0.configure(icon: "trashIcon", fisrtLabel: "정말 일기를 삭제할까요?", secondLabel: "삭제한 일기는 복구하기 어렵습니다\n 그래도 일기를 삭제할까요?", firstColor: .gray900, secondColor: .gray700, title1: "나가기", title1Color1: .gray400, title1Background: .gray100, title2: "삭제하기", title1Color2: .white, title2Background: .negative400, targetText: "", viewColor: .white)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    
    private func setupUI() {
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        deleteView.exitButton.addTarget(self, action: #selector(mainVC), for: .touchUpInside)
        deleteView.continueButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        // 삭제하기 api 연결 필요
        Toast.show(image: UIImage(named: "toasttrash") ?? UIImage(), message: "일기를 삭제했어요", font: .heading3SemiBold(), in: self.deleteView)
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @objc func mainVC() {
        dismiss(animated: true)
    }
}
