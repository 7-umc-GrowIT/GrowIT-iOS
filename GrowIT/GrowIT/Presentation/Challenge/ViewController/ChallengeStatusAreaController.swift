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
    private lazy var challengeStatusList : [UserChallenge] = []
    private var selectedChallenge : UserChallenge?
    private lazy var challengeService = ChallengeService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeStatusArea
        view.backgroundColor = .gray50
        
        setupNotifications()
        
        challengeStatusArea.challengeStatusBtnGroup.dataSource = self
        challengeStatusArea.challengeStatusBtnGroup.delegate = self
        challengeStatusArea.challengeStatusBtnGroup.tag = 2
        challengeStatusArea.challengeAllList.dataSource = self
        challengeStatusArea.challengeAllList.delegate = self
        challengeStatusArea.challengeAllList.tag = 1
        
        getChallengeStatusList(dtype: "", completed: false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateChallengeList), name: .challengeDidDelete, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(moveChallengeVerfiyVC), name: .closeModalAndMoveVC, object: nil)
    }
    
    @objc private func updateChallengeList() {
        refreshData()
    }
    
    @objc private func moveChallengeVerfiyVC() {
        let nextVC = ChallengeVerifyViewController()
        if let challenge = selectedChallenge{
            nextVC.challenge = challenge
        }
        navigationController?.pushViewController(nextVC, animated: true)
    }
    
    public func refreshData(){
        if(selectedStatusIndex == 0){
            getChallengeStatusList(dtype: "", completed: false)
        }else if(selectedStatusIndex == 1){
            getChallengeStatusList(dtype: "", completed: true)
        }else if(selectedStatusIndex == 2){
            getChallengeStatusList(dtype: "RANDOM", completed: false)
        }else{
            getChallengeStatusList(dtype: "DAILY", completed: false)
        }
        self.challengeStatusArea.challengeAllList.reloadData()
    }
    
    /// 챌린지 현황 조회 API
    private func getChallengeStatusList(dtype: String, completed: Bool) {
        challengeService.fetchChallengeStatus(dtype: dtype, completed: completed, completion: { [weak self] result in
            guard let self = self else {return}
            switch result{
            case .success(let data):
                print("챌린지 현황 \(data)")
                challengeStatusList = data.userChallenges
                challengeStatusArea.challengeStatusNum.text = "\(challengeStatusList.count)"
                challengeStatusArea.challengeAllList.reloadData()
                
            case .failure(let error):
                print("챌린지 현황 에러 \(error)")
            }
        })
    }
}



extension ChallengeStatusAreaController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag{
        case 1:
            return challengeStatusList.count
        case 2:
            return challengeStatusType.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView.tag{
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomChallengeListCell.identifier, for: indexPath) as? CustomChallengeListCell else {
                    return UICollectionViewCell()
                }
        
            let userChallenge = challengeStatusList[indexPath.row]
                cell.figure(challenge: userChallenge)
        
        
                return cell
        case 2:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChallengeStatusBtnGroupCell.identifier, for: indexPath) as? ChallengeStatusBtnGroupCell else {
                return UICollectionViewCell()
            }
            
            let isSelected = indexPath.row == selectedStatusIndex
            cell.figure(titleText: challengeStatusType[indexPath.row], isClicked: isSelected)
            

            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView.tag{
        case 1:
            let challenge = challengeStatusList[indexPath.row]
            let approximateWidthOfNameLabel = collectionView.frame.width * 0.5 // 아이콘, 패딩을 고려한 너비
            let size = CGSize(width: approximateWidthOfNameLabel, height: CGFloat.greatestFiniteMagnitude)
            let attributes = [NSAttributedString.Key.font: UIFont.heading3Bold()]

            let estimatedFrame = NSString(string: challenge.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

            let lines = ceil(estimatedFrame.height / UIFont.heading3Bold().lineHeight) // 줄 수 계산
            let additionalHeightPerLine = UIFont.heading3Bold().lineHeight // 추가 높이 설정

            let cellHeight = 78 + (lines * additionalHeightPerLine) // 기본 높이 + 줄 수에 따른 추가 높이
            return CGSize(width: collectionView.frame.width, height: cellHeight)
        case 2:
            let title = challengeStatusType[indexPath.row]
            let font = UIFont.heading3SemiBold()
            let textWidth = title.size(withAttributes: [.font: font]).width
            let cellWidth = textWidth + 32 // 좌우 패딩 추가
            
            return CGSize(width: cellWidth, height: 40)
        default:
            return CGSize(width: 0, height: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag{
        case 1:
        selectedChallenge = challengeStatusList[indexPath.row]
        if(challengeStatusType[selectedStatusIndex] == "완료"){
            let challengeCompleteVC = ChallengeCompleteViewController()

            challengeCompleteVC.challengeId = selectedChallenge!.id
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

            challengeVerifyModalVC.challengeId = selectedChallenge!.id
            self.present(challengeVerifyModalVC, animated: true, completion: nil)
        }
        case 2:
            selectedStatusIndex = indexPath.row
            if(indexPath.row == 0){
                getChallengeStatusList(dtype: "", completed: false)
            }else if(indexPath.row == 1){
                getChallengeStatusList(dtype: "", completed: true)
            }else if(indexPath.row == 2){
                getChallengeStatusList(dtype: "RANDOM", completed: false)
            }else{
                getChallengeStatusList(dtype: "DAILY", completed: false)
            }
            collectionView.reloadData()
            self.challengeStatusArea.challengeAllList.reloadData()
        default:
            break
        }
    }
}

extension ChallengeStatusAreaController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}

extension ChallengeStatusAreaController: ChallengeVerifyModalDelegate {
    func didRequestVerification() {
        if let challenge = selectedChallenge {
            // 모달 해제 직후 뷰 컨트롤러 이동
            self.dismiss(animated: true, completion: {
                let nextVC = ChallengeVerifyViewController()
                nextVC.challenge = challenge
                self.navigationController?.pushViewController(nextVC, animated: true)
            })
        }
    }
}
