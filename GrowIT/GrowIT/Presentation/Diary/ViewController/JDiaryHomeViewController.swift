//
//  JDiaryHomeViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/14/25.
//

import UIKit
import SnapKit

class JDiaryHomeViewController: UIViewController {
    
    private lazy var jDiaryHomeView = JDiaryHomeView()
    private lazy var jDiaryCalendarVC = JDiaryCalendarController()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = jDiaryHomeView
        view.backgroundColor = .white
        
        
        jDiaryHomeView.diaryHomeBanner.diaryDirectWriteButton.addTarget(self, action: #selector(diaryDirectWriteButtonTapped), for: .touchUpInside)
        
        setupCalendarView()
    }
    
    @objc private func diaryDirectWriteButtonTapped() {
        let textDiaryVC = TextDiaryViewController()
        
        //textDiaryVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(textDiaryVC, animated: false)
    }
    
    private func setupCalendarView() {
        // 캘린더 뷰 컨트롤러를 자식으로 추가
        addChild(jDiaryCalendarVC)
        jDiaryCalendarVC.didMove(toParent: self)
        
        // 캘린더 뷰를 JDiaryHomeView에 추가
        jDiaryHomeView.diaryHomeStack.addArrangedSubview(jDiaryCalendarVC.view)
        setupCalendarViewConstraints()
    }
    
    private func setupCalendarViewConstraints() {
        //secondVC.view.translatesAutoresizingMaskIntoConstraints = false
        jDiaryCalendarVC.view.snp.makeConstraints{
            //$0.top.equalTo(jdiaryHomeView.diaryHomeCalendar.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
            $0.height.equalTo(366)
        }
    }
}


