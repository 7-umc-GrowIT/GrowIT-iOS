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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = jDiaryHomeView
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        setupCalendarView()
        setupActions()
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
    
    private func setupActions() {
        // Diary 뷰 관련 액션
        let voiceAction = UITapGestureRecognizer(target: self, action: #selector(voiceVC))
        let textAction = UITapGestureRecognizer(target: self, action: #selector(textVC))
        
        jDiaryHomeView.diaryHomeBanner.diaryDirectWriteButton.addGestureRecognizer(textAction)
        jDiaryHomeView.diaryHomeBanner.diaryWriteButton.addGestureRecognizer(voiceAction)
    }
    
    // MARK: Diary View
    @objc func textVC() {
        let nextVC = TextDiaryViewController()
        nextVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func voiceVC() {
        let nextVC = VoiceDiaryEntryViewController()
        let navigationController = UINavigationController(rootViewController: nextVC) // 감싸기
        navigationController.modalPresentationStyle = .fullScreen // 화면 전환 스타일 설정
        present(navigationController, animated: true, completion: nil) // 모달로 표시
    }
}


