//
//  KakaoTermsAgreeViewController.swift
//  GrowIT
//
//  Created by 강희정 on 2/13/25.
//

import UIKit
import Combine

final class KakaoTermsAgreeViewController: UIViewController {
    
    // MARK: - UI & Properties
    private let termsAgreeView = TermsAgreeView()
    private let navigationBarManager = NavigationManager()
    private let viewModel = TermsAgreeViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    var completionHandler: (([UserTermDTO]) -> Void)?
    private let oauthUserInfo: KakaoUserInfo
    
    // MARK: - Initializer
    init(oauthUserInfo: KakaoUserInfo) {
        self.oauthUserInfo = oauthUserInfo
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupActions()
        bindViewModel()
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
    
    private func setupActions() {
        termsAgreeView.checkButton.addTarget(self, action: #selector(allCheck), for: .touchUpInside)
        termsAgreeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    private func bindViewModel() {
        // 상태 변화
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
        
        // 버튼 활성화
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
        
        // 약관 동의 상태 변경 시 테이블 갱신
        viewModel.$agreedTerms
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.termsAgreeView.termsTableView.reloadData()
                self?.termsAgreeView.termsOptTableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Actions
    @objc private func allCheck() {
        let isSelected = termsAgreeView.checkButton.isSelectedState()
        viewModel.toggleAllAgreements(isSelected)
    }
    
    @objc private func nextButtonTapped() {
        guard viewModel.isAllMandatoryAgreed else {
            showToast("필수 약관에 동의해야 합니다.")
            return
        }
        completionHandler?(viewModel.getAgreedTerms())
        navigationController?.popViewController(animated: true)
    }
    
    private func showToast(_ message: String) {
        let toastImage = UIImage(named: "agreeIcon") ?? UIImage()
        CustomToast(containerWidth: 250).show(image: toastImage, message: message, font: UIFont.body2Medium())
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TableView
extension KakaoTermsAgreeViewController: UITableViewDataSource, UITableViewDelegate {
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
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeOptionalTableViewCell.identifier, for: indexPath) as? TermsAgreeOptionalTableViewCell else { return UITableViewCell() }
            
            let term = viewModel.optionalTerms[indexPath.row]
            cell.configure(title: term.title, content: term.content, isAgreed: viewModel.agreedTerms[term.termId] ?? false)
            cell.onAgreeButtonTapped = { [weak self] in
                self?.viewModel.toggleAgreement(termId: term.termId)
            }
            return cell
        }
    }
}
