//
//  TermsAgreeViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/26/25.
//

import UIKit
import Combine

class TermsAgreeViewController: UIViewController {
    
    private let termsAgreeView = TermsAgreeView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = TermsAgreeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        bindViewModel()
        setupActions()
        viewModel.fetchTerms()
    }
    
    private func setupUI() {
        view.addSubview(termsAgreeView)
        termsAgreeView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        navigationBarManager.setTitle(to: navigationItem, title: "회원가입", textColor: .gray900, font: .heading1Bold())
        navigationBarManager.addBackButton(to: navigationItem, target: self, action: #selector(prevVC))
    }
    
    private func setupTableView() {
        termsAgreeView.termsTableView.delegate = self
        termsAgreeView.termsTableView.dataSource = self
        termsAgreeView.termsTableView.rowHeight = UITableView.automaticDimension
        termsAgreeView.termsTableView.estimatedRowHeight = 80
        
        termsAgreeView.termsOptTableView.delegate = self
        termsAgreeView.termsOptTableView.dataSource = self
        termsAgreeView.termsOptTableView.rowHeight = UITableView.automaticDimension
        termsAgreeView.termsOptTableView.estimatedRowHeight = 80
    }
    
    private func bindViewModel() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded:
                    self?.termsAgreeView.termsTableView.reloadData()
                    self?.termsAgreeView.termsOptTableView.reloadData()
                case .failure(let error):
                    self?.showToast("오류: \(error)")
                default: break
                }
            }
            .store(in: &cancellables)
        
        viewModel.$isAllMandatoryAgreed
            .sink { [weak self] isAgreed in
                self?.termsAgreeView.nextButton.setButtonState(
                    isEnabled: isAgreed,
                    enabledColor: .black,
                    disabledColor: .gray100,
                    enabledTitleColor: .white,
                    disabledTitleColor: .gray400
                )
            }
            .store(in: &cancellables)
        
        // 동의 상태 변경 시 테이블뷰 갱신
        viewModel.$agreedTerms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.termsAgreeView.termsTableView.reloadData()
                self?.termsAgreeView.termsOptTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func setupActions() {
        termsAgreeView.checkButton.addTarget(self, action: #selector(allCheck), for: .touchUpInside)
        termsAgreeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func allCheck() {
        let isSelected = termsAgreeView.checkButton.isSelectedState()
        viewModel.toggleAllAgreements(isSelected)
    }
    
    @objc private func nextButtonTapped() {
        guard viewModel.isAllMandatoryAgreed else {
            showToast("필수 이용약관 동의가 필요합니다")
            return
        }
        let emailVerificationVC = EmailVerificationViewController()
        emailVerificationVC.agreeTerms = viewModel.getAgreedTerms()
        navigationController?.pushViewController(emailVerificationVC, animated: true)
    }
    
    private func showToast(_ message: String) {
        let toastImage = UIImage(named: "agreeIcon") ?? UIImage()
        CustomToast(containerWidth: 250).show(image: toastImage, message: message, font: UIFont.body2Medium())
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}

extension TermsAgreeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == termsAgreeView.termsTableView ? viewModel.mandatoryTerms.count : viewModel.optionalTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == termsAgreeView.termsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeTableViewCell.identifier, for: indexPath) as? TermsAgreeTableViewCell else { return UITableViewCell() }
            
            let term = viewModel.mandatoryTerms[indexPath.row]
            let numberedTitle = "이용약관 (\(indexPath.row + 1))"
            
            cell.configure(title: numberedTitle, content: term.content, isAgreed: viewModel.agreedTerms[term.termId] ?? false)
            cell.onAgreeButtonTapped = { [weak self] in
                self?.viewModel.toggleAgreement(termId: term.termId)
            }
            cell.detailButton.addTarget(self, action: #selector(showTermsDetail(_:)), for: .touchUpInside)
            cell.detailButton.tag = term.termId
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeOptionalTableViewCell.identifier, for: indexPath) as? TermsAgreeOptionalTableViewCell else { return UITableViewCell() }
            
            let term = viewModel.optionalTerms[indexPath.row]
            
            cell.configure(title: term.title, content: term.content, isAgreed: viewModel.agreedTerms[term.termId] ?? false)
            cell.onAgreeButtonTapped = { [weak self] in
                self?.viewModel.toggleAgreement(termId: term.termId)
            }
            cell.detailButton.addTarget(self, action: #selector(showTermsDetail(_:)), for: .touchUpInside)
            cell.detailButton.tag = term.termId
            return cell
        }
    }
    
    @objc private func showTermsDetail(_ sender: UIButton) {
        let termId = sender.tag
        guard let term = (viewModel.mandatoryTerms + viewModel.optionalTerms).first(where: { $0.termId == termId }) else { return }
        
        let detailVC = TermsDetailViewController()
        detailVC.configure(termId: term.termId, content: term.content, parentViewModel: viewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
