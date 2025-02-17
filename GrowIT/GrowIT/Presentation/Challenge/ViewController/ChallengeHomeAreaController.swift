//
//  ChallengeHomeAreaController.swift
//  GrowIT
//
//  Created by 허준호 on 1/22/25.
//

import UIKit
import SnapKit
import Then

class ChallengeHomeAreaController: UIViewController {
    private lazy var challengeHomeArea = ChallengeHomeArea()
    private lazy var pageControl = UIPageControl()
    private lazy var todayChallenges: [RecommendedChallengeDTO] = []
    private lazy var selectedIndex: Int = 0
    private lazy var challengeService = ChallengeService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeHomeArea
        view.backgroundColor = .gray50
        
        challengeHomeArea.todayChallengeCollectionView.delegate = self
        challengeHomeArea.todayChallengeCollectionView.dataSource = self
        
        getChallengeSummary()
        
    }
    
    private func setupPageControl() {
        pageControl.numberOfPages = todayChallenges.count  // 페이지 수 설정
        pageControl.currentPage = selectedIndex    // 현재 페이지 초기화
        pageControl.currentPageIndicatorTintColor = .primary600
        pageControl.pageIndicatorTintColor = .gray
        view.addSubview(pageControl)

        setupNotifications()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.snp.makeConstraints {
            $0.top.equalTo(challengeHomeArea.todayChallengeCollectionView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            
        }
        
        challengeHomeArea.challengeReportTitleStack.snp.remakeConstraints {
            $0.top.equalTo(pageControl.snp.bottom).offset(44)
            $0.left.equalToSuperview().offset(24)
        }
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateChallengeList), name: .challengeDidDelete, object: nil)
    }
    
    @objc private func updateChallengeList() {
        refreshData()
    }
    
    public func refreshData(){
        getChallengeSummary()
    }
    
    /// 챌린지 홈 조회 API
    private func getChallengeSummary(){
        challengeService.fetchChallengeHome(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                if(data.challengeKeywords.count == 0){
                    self.challengeHomeArea.setEmptyChallenge()
                    pageControl.isHidden = true
                    
                }else if(data.recommendedChallenges.count == 0){
                    pageControl.isHidden = true
                    self.challengeHomeArea.todayChallengeCollectionView.isHidden = true
                    self.challengeHomeArea.challengeReportTitleStack.snp.updateConstraints {
                        $0.top.equalTo(self.challengeHomeArea.hashTagStack.snp.bottom).offset(172)
                    }
                }
                else{
                    self.todayChallenges = data.recommendedChallenges
                    self.challengeHomeArea.showChallenge()
                    setupPageControl()
                }
                
                self.challengeHomeArea.setupChallengeKeywords(data.challengeKeywords)
                self.challengeHomeArea.setupChallengeReport(report: data.challengeReport)
                
                // 데이터 변경 후 컬렉션뷰를 리로드합니다.
                self.challengeHomeArea.todayChallengeCollectionView.reloadData()
                
            case .failure(let error):
                print("가져온 에러는 \(error)")
            }
        })
    }

}

extension ChallengeHomeAreaController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.todayChallenges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayChallengeCollectionViewCell.identifier, for: indexPath) as? TodayChallengeCollectionViewCell else { return UICollectionViewCell() }
        
        let challenge = todayChallenges[indexPath.row]
        cell.figure(title: challenge.title, time: challenge.time, completed: challenge.completed)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let challenge = todayChallenges[indexPath.row]
        let approximateWidthOfNameLabel = collectionView.frame.width * 0.5 // 아이콘, 패딩을 고려한 너비
        let size = CGSize(width: approximateWidthOfNameLabel, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font: UIFont.heading3Bold()]

        let estimatedFrame = NSString(string: challenge.title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)

        let lines = ceil(estimatedFrame.height / UIFont.heading3Bold().lineHeight) // 줄 수 계산
        let additionalHeightPerLine = UIFont.heading3Bold().lineHeight // 추가 높이 설정

        let cellHeight = 78 + (lines * additionalHeightPerLine) // 기본 높이 + 줄 수에 따른 추가 높이
        
        self.challengeHomeArea.todayChallengeCollectionView.snp.updateConstraints{
            $0.height.equalTo(cellHeight)
        }
        
        self.view.layoutIfNeeded()
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(todayChallenges[indexPath.row])
        selectedIndex = indexPath.row
        let challenge = todayChallenges[indexPath.row]
        if(challenge.completed == true){
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
                            self.view.frame.height * 0.45
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
            
            challengeVerifyModalVC.challengeId = challenge.id
            self.present(challengeVerifyModalVC, animated: true, completion: nil)
        }
        
    }
}

extension ChallengeHomeAreaController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: challengeHomeArea.todayChallengeCollectionView.contentOffset, size: challengeHomeArea.todayChallengeCollectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        if let visibleIndexPath = challengeHomeArea.todayChallengeCollectionView.indexPathForItem(at: visiblePoint) {
            selectedIndex = visibleIndexPath.row
            pageControl.currentPage = visibleIndexPath.row
            print("Current visible cell index: \(visibleIndexPath.row)")
            // 여기서 필요한 작업 수행, 예를 들면 인덱스 저장, UI 업데이트 등
        }
    }
}

extension ChallengeHomeAreaController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}

extension ChallengeHomeAreaController: ChallengeVerifyModalDelegate {
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
