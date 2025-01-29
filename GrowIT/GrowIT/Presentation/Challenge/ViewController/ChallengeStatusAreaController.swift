//
//  ChallengeStatusAreaController.swift
//  GrowIT
//
//  Created by 허준호 on 1/23/25.
//

import UIKit

class ChallengeStatusAreaController: UIViewController {
    
    private lazy var challengeStatusArea = ChallengeStatusArea()
    private lazy var challengeStatusType : [String] = ["전체", "완료", "랜덤 챌린지", "데일리 챌린지"]
    private var selectedStatusIndex: Int = 0 // 선택된 현황 타입을 추적하는 변수
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeStatusArea
        view.backgroundColor = .gray50
        
        challengeStatusArea.challengeStatusBtnGroup.dataSource = self
        challengeStatusArea.challengeStatusBtnGroup.delegate = self
        challengeStatusArea.challengeAllList.dataSource = self
        challengeStatusArea.challengeAllList.delegate = self
    
    }
    
}

extension ChallengeStatusAreaController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomChallengeListCell.identifier) as? CustomChallengeListCell else {
            return UITableViewCell()
        }
        
        let status = challengeStatusType[selectedStatusIndex]
        cell.figure(status: status)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108 // 셀 높이에 컨테이너 뷰의 패딩을 포함
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        print("리스트 클릭됨")
        if(challengeStatusType[selectedStatusIndex] == "완료"){
            let challengeCompleteVC = ChallengeCompleteViewController()
            
            challengeCompleteVC.modalPresentationStyle = .pageSheet
            
            if let sheet = challengeCompleteVC.sheetPresentationController {
                        
                //지원할 크기 지정
                if #available(iOS 16.0, *){
                    sheet.detents = [.large()]
                }else{
                    sheet.detents = [.medium(), .large()]
                }
                
                // 시트의 상단 둥근 모서리 설정
                if #available(iOS 15.0, *) {
                    sheet.preferredCornerRadius = 40
                }
                
                //크기 변하는거 감지
                sheet.delegate = self
               
                //시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = false
                
                //처음 크기 지정 (기본 값은 가장 작은 크기)
                sheet.selectedDetentIdentifier = .large
            }
            
            self.present(challengeCompleteVC, animated: true, completion: nil)
        }else{
            let challengeVerifyModalVC = ChallengeVerifyModalController()
            
            challengeVerifyModalVC.modalPresentationStyle = .pageSheet
            challengeVerifyModalVC.delegate = self

            if let sheet = challengeVerifyModalVC.sheetPresentationController {
                        
                //지원할 크기 지정
                if #available(iOS 16.0, *){
                    sheet.detents = [
                        .custom{ _ in
                        358.0
                    }]
                }else{
                    sheet.detents = [.medium(), .large()]
                }
                
                // 시트의 상단 둥근 모서리 설정
                if #available(iOS 15.0, *) {
                    sheet.preferredCornerRadius = 40
                }
                
                //크기 변하는거 감지
                sheet.delegate = self
               
                //시트 상단에 그래버 표시 (기본 값은 false)
                sheet.prefersGrabberVisible = false
            }
            
            self.present(challengeVerifyModalVC, animated: true, completion: nil)
        }
        
        
    }
}

extension ChallengeStatusAreaController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return challengeStatusType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeStatusBtnGroupCell.identifier, for: indexPath) as? ChallengeStatusBtnGroupCell else {
            return UICollectionViewCell()
        }
        
        let isSelected = indexPath.row == selectedStatusIndex
        cell.figure(titleText: challengeStatusType[indexPath.row], isClicked: isSelected)
        

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = challengeStatusType[indexPath.row]
        let font = UIFont.heading3SemiBold()
        let textWidth = title.size(withAttributes: [.font: font]).width
        let cellWidth = textWidth + 32 // 좌우 패딩 추가
        
        return CGSize(width: cellWidth, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedStatusIndex = indexPath.row
        collectionView.reloadData()
        self.challengeStatusArea.challengeAllList.reloadData()
        print(challengeStatusType[indexPath.row])
    }
    
    
}

extension ChallengeStatusAreaController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}

extension ChallengeStatusAreaController: ChallengeVerifyModalDelegate {
    func presentChallengeVerifyModal() {
        let modalVC = ChallengeVerifyModalController()
        modalVC.delegate = self
        present(modalVC, animated: true, completion: nil)
    }

    func didRequestVerification() {
        let nextVC = ChallengeVerifyViewController()
        navigationController?.pushViewController(nextVC, animated: true)
    }
}
