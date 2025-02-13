//
//  GroSetNameViewController.swift
//  GrowIT
//
//  Created by 오현민 on 1/18/25.
//

import UIKit

class GroSetNameViewController: UIViewController {
    //MARK: - Properties
    let groService = GroService()
    var isValidName: Bool = false
    
    private let selectedBackground: Int
    let selectedColors: [CGColor]
    var selectedIcon = UIImage()
    
    var groName: String?
    
    // MARK: - Data
    let colors = [
        [UIColor.itemColorYellow!.cgColor, UIColor.white.cgColor],
        [UIColor.itemColorGreen!.cgColor, UIColor.white.cgColor],
        [UIColor.itemColorPink!.cgColor, UIColor.white.cgColor]
    ]
    let icons = [
        UIImage(named: "Item_Background_Star"),
        UIImage(named: "Item_Background_Tree"),
        UIImage(named: "Item_Background_Heart")
    ]
    let backgrounItem = [
        "별 배경화면",
        "나무 배경화면",
        "하트 배경화면"
    ]
    
    // MARK: - NetWork
    func callPostGroCreate() {
        groService.postGroCreate(data: GroRequestDTO(name: groName ?? "", backgroundItem: backgrounItem[selectedBackground]), completion: {
            [weak self] result in
                guard let self = self else { return }
            switch result {
            case .success(let data):
                print("Success: \(data)")
            case .failure(let error):
                switch error {
                case .serverError(let statusCode, let message):
                    if message == "이미 사용 중인 닉네임입니다." {
                        groSetNameView.nickNameTextField.setError(message: "다른 닉네임과 중복되는 닉네임입니다")
                    }
                default:
                    break
                }
            }
        })
    }
    
    //MARK: - Views
    private lazy var groSetNameView = GroSetNameView(
        gradientColors: selectedColors,
        iconImage: selectedIcon
    ).then {
        $0.nickNameTextField.textField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        $0.startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    //MARK: - init
    init(selectedBackground: Int) {
        self.selectedBackground = selectedBackground
        self.selectedColors = colors[selectedBackground]
        self.selectedIcon = icons[selectedBackground]!
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = groSetNameView
        updateNextButtonState()
        
        groSetNameView.nickNameTextField.onClearButtonTapped = { [weak self] in
            self?.updateNextButtonState()
        }
    }
    
    //MARK: - 기능
    @objc
    private func textFieldsDidChange() {
        groName = groSetNameView.nickNameTextField.textField.text ?? ""
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        isValidName = groSetNameView.nickNameTextField.validationRule?(groName ?? "") ?? false
        groSetNameView.startButton.isEnabled = isValidName
        
        groSetNameView.startButton.setButtonState(
            isEnabled: isValidName,
            enabledColors: [UIColor.primaryColor400!.cgColor, UIColor.primaryColor600!.cgColor],
            disabledColors: [UIColor.grayColor100!.cgColor, UIColor.grayColor100!.cgColor],
            enabledTitleColor: UIColor.white,
            disabledTitleColor: UIColor.grayColor400!)
    }
    
    @objc
    private func didTapStartButton() {
        print("다음화면으로")
        callPostGroCreate()
    }
}
