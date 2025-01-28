//
//  DiaryAllViewController.swift
//  GrowIT
//
//  Created by 이수현 on 1/24/25.
//

import UIKit

class DiaryAllViewController: UIViewController, UITableViewDelegate {
    
    // MARK: Properties
    private let diaryAllView = DiaryAllView()
    private let diaryService = DiaryService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupDelegate()
        print(DiaryModel.dummy().count)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Setup UI
    private func setupUI() {
        view.addSubview(diaryAllView)
        diaryAllView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Setup Delegate
    private func setupDelegate() {
        diaryAllView.diaryTableView.dataSource = self
        diaryAllView.diaryTableView.delegate = self
    }
    
    // MARK: Setup Actions
    
    // MARK: Setup APIs
    private func callGetAllDiaries() {
        diaryService.fetchAllDiaries(
            year: <#T##Int#>,
            month: <#T##Int#>,
            completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    print("Success: \(data)")
                case .failure(let error):
                    print("Error: \(error)")
                }
            })
    }
    
}

extension DiaryAllViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        DiaryModel.dummy().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DiaryAllViewTableViewCell.identifier, for: indexPath) as? DiaryAllViewTableViewCell else {
            return UITableViewCell()
        }
        
        // Dummy 데이터로 셀 구성
        let diary = DiaryModel.dummy()[indexPath.row]
        cell.contentLabel.text = diary.content
        cell.dateLabel.text = diary.date
        cell.delegate = self
        return cell
    }
}

extension DiaryAllViewController: DiaryAllViewCellDelegate {
    func didTapButton(in cell: DiaryAllViewTableViewCell) {
        print("Tapped")
        let fixVC = DiaryPostFixViewController(text: "13231")
        let navController = UINavigationController(rootViewController: fixVC)
        navController.modalPresentationStyle = .fullScreen
        presentPageSheet(viewController: navController, detentFraction: 0.65)
    }
}
