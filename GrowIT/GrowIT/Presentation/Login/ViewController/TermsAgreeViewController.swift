//
//  TermsAgreeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import UIKit

class TermsAgreeViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    let termsAgreeView = TermsAgreeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupActions()
    }
    
    
    // MARK: SetupUI
    private func setupUI() {
        view.addSubview(termsAgreeView)
        termsAgreeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        termsAgreeView.termsTableView.dataSource = self
        termsAgreeView.termsTableView.delegate = self
        termsAgreeView.termsTableView.rowHeight = 60
        
        termsAgreeView.termsOptTableView.dataSource = self
        termsAgreeView.termsOptTableView.delegate = self
        termsAgreeView.termsOptTableView.rowHeight = 60
    }
    
    // MARK: Setup Actions
    private func setupActions() {
        termsAgreeView.checkButton.addTarget(self, action: #selector(allCheck), for: .touchUpInside)
    }
    
    // MARK: @objc methods
    @objc func allCheck() {
        let isSelected = termsAgreeView.checkButton.isSelectedState()
        
        // 필수 약관 테이블뷰 업데이트
        termsAgreeView.termsTableView.visibleCells.forEach { cell in
            guard let termsCell = cell as? TermsAgreeTableViewCell else { return }
            termsCell.agreeButton.isEnabledState = isSelected
            termsCell.agreeButton.updateButtonColor()
        }
        
        // 선택 약관 테이블뷰 업데이트
        termsAgreeView.termsOptTableView.visibleCells.forEach { cell in
            guard let termsCell = cell as? TermsAgreeOptionalTableViewCell else { return }
            termsCell.agreeButton.isEnabledState = isSelected
            termsCell.agreeButton.updateButtonColor()
        }
        
        updateNextButtonState()
    }
    
    private func updateCheckButtonState() {
        // 필수 약관 테이블뷰의 상태 확인
        let allTermsSelected = termsAgreeView.termsTableView.visibleCells.allSatisfy { cell in
            guard let termsCell = cell as? TermsAgreeTableViewCell else { return true }
            return termsCell.agreeButton.isEnabledState
        }
        
        // 선택 약관 테이블뷰의 상태 확인
        let allOptionalTermsSelected = termsAgreeView.termsOptTableView.visibleCells.allSatisfy { cell in
            guard let termsCell = cell as? TermsAgreeOptionalTableViewCell else { return true }
            return termsCell.agreeButton.isEnabledState
        }
        
        // 모든 버튼 상태를 확인하여 체크박스 상태 갱신
        let allSelected = allTermsSelected && allOptionalTermsSelected
        termsAgreeView.checkButton.isEnabledState = allSelected
        termsAgreeView.checkButton.updateButtonColor()
        
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        // 필수 약관 상태 확인
        let allTermsSelected = termsAgreeView.termsTableView.visibleCells.allSatisfy { cell in
            guard let termsCell = cell as? TermsAgreeTableViewCell else { return true }
            return termsCell.agreeButton.isEnabledState
        }
        
        // 필수 약관 4개가 모두 선택되었을 때만 활성화
        termsAgreeView.nextButton.setButtonState(
            isEnabled: allTermsSelected,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
}

extension TermsAgreeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 {
            4
        } else {
            2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeTableViewCell.identifier, for: indexPath) as? TermsAgreeTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: indexPath.row + 1)
            
            cell.onAgreeButtonTapped = { [weak self] in
                self?.updateCheckButtonState()
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeOptionalTableViewCell.identifier, for: indexPath) as? TermsAgreeOptionalTableViewCell else {
                return UITableViewCell()
            }
            
            cell.configure(with: indexPath.row + 1)
            
            cell.onAgreeButtonTapped = { [weak self] in
                self?.updateCheckButtonState()
            }
            
            return cell
        }
        
    }
}
