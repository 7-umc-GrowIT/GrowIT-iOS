//
//  VoiceDiaryFixViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/16/25.
//

import UIKit

class DiaryPostFixViewController: UIViewController {
    
    // MARK: Properties
    let text: String
    let diaryPostFixView = DiaryPostFixView()
    
    
    init(text: String) {
        self.text = text
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupActions()
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(diaryPostFixView)
        diaryPostFixView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        diaryPostFixView.configure(text: text)
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        diaryPostFixView.cancelButton.addTarget(self, action: #selector(prevVC), for: .touchUpInside)
        diaryPostFixView.fixButton.addTarget(self, action: #selector(nextVC), for: .touchUpInside)
        
        let labelAction = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        diaryPostFixView.deleteLabel.addGestureRecognizer(labelAction)
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        diaryPostFixView.textView.delegate = self
    }
    
    // MARK: @objc methods
    @objc func prevVC() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func nextVC() {
        // 수정하기 api 추가 필요
        dismiss(animated: true)
    }
    
    @objc func labelTapped() {
        let nextVC = DiaryDeleteViewController()
        let navController = UINavigationController(rootViewController: nextVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.37)
    }
}

extension DiaryPostFixViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let changedState = textView.text == self.text ? false : true
        diaryPostFixView.fixButton.setButtonState(
            isEnabled: changedState,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400)
    }
}
