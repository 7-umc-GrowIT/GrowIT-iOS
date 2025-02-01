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
    let navigationBarManager = NavigationManager()
    let termsService = TermsService()
    
    var termsList: [Term] = [] // 필수 약관
    var optionalTermsList: [Term] = [] // 선택 약관
    var agreedTerms: [String: Bool] = [:] // 약관 동의 상태 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        setupActions()
        fetchTerms()
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        view.addSubview(termsAgreeView)
        termsAgreeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.navigationController?.isNavigationBarHidden = false
        
        navigationBarManager.setTitle(
            to: self.navigationItem,
            title: "회원가입",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC)
        )
    }
    
    // MARK: - Setup Delegate
    private func setupDelegate() {
        termsAgreeView.termsTableView.tag = 0
        termsAgreeView.termsOptTableView.tag = 1
        
        termsAgreeView.termsTableView.dataSource = self
        termsAgreeView.termsTableView.delegate = self
        termsAgreeView.termsTableView.rowHeight = 60
        
        termsAgreeView.termsOptTableView.dataSource = self
        termsAgreeView.termsOptTableView.delegate = self
        termsAgreeView.termsOptTableView.rowHeight = 60
    }
    
    // MARK: - Setup Actions
    private func setupActions() {
        termsAgreeView.checkButton.addTarget(self, action: #selector(allCheck), for: .touchUpInside)
        termsAgreeView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - API 호출 (약관 목록 불러오기)
    private func fetchTerms() {
        termsService.fetchTerms { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let terms):
                    print("✅ 서버에서 받은 약관 데이터: \(terms)") // 약관 데이터 디버깅

                    // 필수 약관과 선택 약관으로 분리
                    self?.termsList = terms.filter { $0.type.uppercased() == "MANDATORY" }
                    self?.optionalTermsList = terms.filter { $0.type.uppercased() == "OPTIONAL" }

                    print("✅ 필수 약관 필터링 결과: \(self?.termsList ?? [])") // 필터링 결과 디버깅
                    print("✅ 선택 약관 필터링 결과: \(self?.optionalTermsList ?? [])") // 필터링 결과 디버깅

                    // 약관 동의 상태 초기화
                    self?.setupTermsView()

                    // 테이블 뷰 업데이트
                    self?.termsAgreeView.termsTableView.reloadData()
                    self?.termsAgreeView.termsOptTableView.reloadData()

                case .failure(let error):
                    print("❌ 약관 불러오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }

    
    private func setupTermsView() {
        // 약관 제목 → termId 매핑
        let termsMapping: [String: Int] = [
            "이용약관 (1)": 1,
            "이용약관 (2)": 2,
            "이용약관 (3)": 3,
            "이용약관 (4)": 4,
            "개인정보 수집 이용 동의": 5,
            "개인정보 제3자 제공 동의": 6
        ]

        // 필수 약관 동의 상태 초기화
        for term in termsList {
            if let termId = termsMapping[term.title] {
                agreedTerms[term.title] = false
            }
        }

        // 선택 약관 동의 상태 초기화
        for term in optionalTermsList {
            if let termId = termsMapping[term.title] {
                agreedTerms[term.title] = false
            }
        }

        print("✅ 필수 약관 목록: \(termsList)")
        print("✅ 선택 약관 목록: \(optionalTermsList)")
        print("✅ 약관 동의 상태: \(agreedTerms)")
    }

    
    private func validateAgreements() -> Bool {
        return !termsList.contains { term in
            agreedTerms[term.title] == false
        }
    }
    
    // MARK: @objc methods
    @objc private func allCheck() {
        let isSelected = termsAgreeView.checkButton.isSelectedState()
        
        // ✅ 모든 필수 및 선택 약관을 `true` 또는 `false`로 설정
        termsList.forEach { agreedTerms[$0.title] = isSelected }
        optionalTermsList.forEach { agreedTerms[$0.title] = isSelected }
        
        print("✅ 전체 동의 상태 업데이트: \(agreedTerms)") // 디버깅용 로그
        
        termsAgreeView.termsTableView.reloadData()
        termsAgreeView.termsOptTableView.reloadData()
        updateNextButtonState()
    }
    
    private func updateCheckButtonState() {
        let allTermsSelected = !termsList.contains { agreedTerms[$0.title] == false }
        let allOptionalTermsSelected = !optionalTermsList.contains { agreedTerms[$0.title] == false }
        
        let allSelected = allTermsSelected && allOptionalTermsSelected
        termsAgreeView.checkButton.isEnabledState = allSelected
        termsAgreeView.checkButton.updateButtonColor()
        
        updateNextButtonState()
    }
    
    private func updateNextButtonState() {
        let allTermsSelected = !termsList.contains { agreedTerms[$0.title] == false }
        
        termsAgreeView.nextButton.setButtonState(
            isEnabled: allTermsSelected,
            enabledColor: .black,
            disabledColor: .gray100,
            enabledTitleColor: .white,
            disabledTitleColor: .gray400
        )
    }
    
    @objc private func nextButtonTapped() {
        guard validateAgreements() else {
            print("❌ 필수 약관을 모두 동의해야 합니다.")
            return
        }

        // ✅ 약관 제목을 정확한 `termId` 값(1~6)으로 매핑
        let termsMapping: [String: Int] = [
            "이용약관 (1)": 1,
            "이용약관 (2)": 2,
            "이용약관 (3)": 3,
            "이용약관 (4)": 4,
            "개인정보 수집 이용 동의": 5,
            "개인정보 제3자 제공 동의": 6
        ]

        // ✅ 기존 `termsList`와 `optionalTermsList`를 합쳐 `UserTermDTO`로 변환
        let agreedList = (termsList + optionalTermsList).compactMap { term -> UserTermDTO? in
            guard let termId = termsMapping[term.title] else {
                print("❌ 매핑되지 않은 약관: \(term.title)")
                return nil
            }
            return UserTermDTO(termId: termId, agreed: agreedTerms[term.title] ?? false)
        }
        
        // EmailVerificationViewController로 약관 데이터 전달
        let emailVerificationVC = EmailVerificationViewController()
        emailVerificationVC.agreeTerms = agreedList // 약관 데이터 전달
        navigationController?.pushViewController(emailVerificationVC, animated: true)
    }


    // 약관 동의 데이터 저장
    private func saveAgreeTerms(_ terms: [UserTermDTO]) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(terms) {
            UserDefaults.standard.set(encoded, forKey: "agreeTerms")
        }
    }

    
    func getAgreeTerms() -> [UserTermDTO]? {
        if let savedData = UserDefaults.standard.data(forKey: "agreeTerms") {
            let decoder = JSONDecoder()
            if let loadedTerms = try? decoder.decode([UserTermDTO].self, from: savedData) {
                return loadedTerms
            }
        }
        return nil
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TermsAgreeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.tag == 0 { // 필수 약관 테이블
            return termsList.count
        } else if tableView.tag == 1 { // 선택 약관 테이블
            return optionalTermsList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView.tag == 0 { // 필수 약관
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeTableViewCell.identifier, for: indexPath) as? TermsAgreeTableViewCell else {
                return UITableViewCell()
            }
            
            let term = termsList[indexPath.row]
            cell.configure(title: term.title, content: term.content, isAgreed: agreedTerms[term.title] ?? false)
            
            // 약관 동의 버튼 클릭 이벤트 처리
            cell.onAgreeButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.agreedTerms[term.title] = !(self.agreedTerms[term.title] ?? false) // ✅ 값 토글
                print("✅ 업데이트된 약관 동의 상태: \(self.agreedTerms)") // 디버깅용 로그
                
                self.updateCheckButtonState() // 체크박스 상태 업데이트
            }
            
            return cell
        } else { // 선택 약관
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TermsAgreeOptionalTableViewCell.identifier, for: indexPath) as? TermsAgreeOptionalTableViewCell else {
                return UITableViewCell()
            }
            
            let term = optionalTermsList[indexPath.row]
            cell.configure(title: term.title, content: term.content, isAgreed: agreedTerms[term.title] ?? false)
            
            // 약관 동의 버튼 클릭 이벤트 처리
            cell.onAgreeButtonTapped = { [weak self] in
                guard let self = self else { return }
                self.agreedTerms[term.title] = !(self.agreedTerms[term.title] ?? false) // ✅ 값 토글
                print("✅ 업데이트된 약관 동의 상태: \(self.agreedTerms)") // 디버깅용 로그
                
                self.updateCheckButtonState() // 체크박스 상태 업데이트
            }
            
            return cell
        }
    }
}
