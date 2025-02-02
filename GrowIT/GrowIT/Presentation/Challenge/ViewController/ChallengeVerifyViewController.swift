//
//  ChallengeVerifyViewController.swift
//  GrowIT
//
//  Created by 허준호 on 1/24/25.
//

import UIKit
import Photos
import SnapKit

class ChallengeVerifyViewController: UIViewController {
    
    private lazy var challengeVerifyView = ChallengeVerifyView() // 챌린지 인증화면 뷰
    private lazy var navigationBarManager = NavigationManager()
    private let imagePicker = UIImagePickerController() // 인증샷 이미지 피커
    private var reviewLength: Int = 0 // 작성한 한줄소감 글자 수
    private var uploadImage: UIImage? // 인증샷 이미지
    private var isImageSelected: Bool = false // 이미지 인증샷 유무
    private var isReviewValidate: Bool = false // 한줄소감 유효성 검증
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = challengeVerifyView
        view.backgroundColor = .gray50
        
        setupNavigationBar() // 네비게이션 바 설정 함수
        setupImagePicker() // 이미지 선택 관련 함수
        setupDismissKeyboardGesture() // 키보드 해제 함수
        
        challengeVerifyView.reviewTextView.delegate = self
        challengeVerifyView.challengeVerifyButton.addTarget(self, action: #selector(challengeVerifyButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleImage(_:)), name: NSNotification.Name("ImageSelected"), object: nil)
        
    }
    @objc func handleImage(_ notification: Notification) {
        if let userInfo = notification.userInfo, let image = userInfo["image"] as? UIImage {
            challengeVerifyView.imageUploadCompleted(image)
            challengeVerifyView.imageContainer.superview?.layoutIfNeeded()
        }
    }
    
    private func setupNavigationBar() {
        navigationBarManager.addBackButton(
            to: navigationItem,
            target: self,
            action: #selector(prevVC),
            tintColor: .black
        )
        
        navigationBarManager.setTitle(
            to: navigationItem,
            title: "챌린지 인증하기",
            textColor: .gray900,
            font: .heading1Bold()
        )
        
        // 네비게이션 바 스타일 설정
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white  // 배경색을 흰색으로 설정

        // iOS 15 이상에서는 scrollEdgeAppearance도 설정해야 함
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupImagePicker() {
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        
        let imageContainerTabGesture = UITapGestureRecognizer(target: self, action: #selector(imageContainerTapped))
        challengeVerifyView.imageContainer.addGestureRecognizer(imageContainerTabGesture)
    }
    
    @objc private func prevVC() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func imageContainerTapped() {
        let challengeImageModalController = ChallengeImageModalController()
        challengeImageModalController.modalPresentationStyle = .pageSheet
        
        if let sheet = challengeImageModalController.sheetPresentationController {
                    
            //지원할 크기 지정
            if #available(iOS 16.0, *){
                sheet.detents = [.custom{ _ in
                    360.0
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
            
            //처음 크기 지정 (기본 값은 가장 작은 크기)
            sheet.selectedDetentIdentifier = .large
        }
        
        self.present(challengeImageModalController, animated: true, completion: nil)
    }
    
    private func openImagePicker(sourceType: UIImagePickerController.SourceType) {
        imagePicker.sourceType = sourceType
        present(imagePicker, animated: true, completion: nil)
    }
    
    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: "권한 필요", message: "사진 앨범 접근 권한이 필요합니다. 설정에서 이 앱의 사진 접근 권한을 허용해주세요.", preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            if let settingsUrl = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    // 바깥 영역 터치 시 키보드 숨기기
    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func challengeVerifyButtonTapped() {
        
        if(uploadImage == nil){
            isImageSelected = false
            Toast.show(image: UIImage(named: "challengeToastIcon") ?? UIImage(), message: "인증샷을 업로드해 주세요", font: .heading3SemiBold())
        }else{
            if(isReviewValidate){
                navigationController?.popViewController(animated: false)
                Toast.show(image: UIImage(named: "challengeToastIcon") ?? UIImage(), message: "챌린지 인증을 완료했어요", font: .heading3SemiBold())
            }else{
                if(reviewLength > 0 && reviewLength < 50){
                    isReviewValidate = false
                    challengeVerifyView.validateTextView(errorMessage: "챌린지 한줄소감은 50자 이상 적어야 합니다", textColor: .negative400, bgColor: .negative50, borderColor: .negative400, hintColor: .negative400)
                }else{
                    challengeVerifyView.reviewTextView.text = ""
                    isReviewValidate = false
                    challengeVerifyView.reviewTextView.text = "챌린지 소감을 간단하게 입력해주세요"
                    challengeVerifyView.validateTextView(errorMessage: "챌린지 한줄소감은 필수로 입력해야 합니다", textColor: .negative400, bgColor: .negative50, borderColor: .negative400, hintColor: .negative400)
                }
            }
            
        }
        
    }
}

extension ChallengeVerifyViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            uploadImage = image
            if let uploadImage = uploadImage {
                challengeVerifyView.imageUploadCompleted(uploadImage)
                challengeVerifyView.imageContainer.superview?.layoutIfNeeded()
            }
            
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ChallengeVerifyViewController: UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // "Done" 버튼을 눌렀을 때 키보드 내리기
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.gray300 || textView.textColor == UIColor.negative400{
                textView.text = nil
                textView.textColor = .gray900
            }
        }
    
    func textViewDidChange(_ textView: UITextView) {
        reviewLength = textView.text?.count ?? 0
        print(reviewLength)
        
       if(reviewLength < 50){
           isReviewValidate = false
           challengeVerifyView.validateTextView(errorMessage: "챌린지 한줄소감은 50자 이상 적어야 합니다", textColor: .negative400, bgColor: .negative50, borderColor: .negative400, hintColor: .negative400)
        }else{
            isReviewValidate = true
            challengeVerifyView.validateTextView(errorMessage: "챌린지 한줄소감을 50자 이상 적어 주세요", textColor: .gray900, bgColor: .white, borderColor: .black.withAlphaComponent(0.1), hintColor: .gray500)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        reviewLength = textView.text?.count ?? 0
        
        if(reviewLength == 0){
            isReviewValidate = false
            challengeVerifyView.reviewTextView.text = "챌린지 소감을 간단하게 입력해주세요"
            challengeVerifyView.validateTextView(errorMessage: "챌린지 한줄소감은 필수로 입력해야 합니다", textColor: .negative400, bgColor: .negative50, borderColor: .negative400, hintColor: .negative400)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // 키보드 숨기기
        return true
    }
}

extension ChallengeVerifyViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        //크기 변경 됐을 경우
        print(sheetPresentationController.selectedDetentIdentifier == .large ? "large" : "medium")
    }
}
