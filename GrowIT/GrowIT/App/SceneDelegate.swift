//
//  SceneDelegate.swift
//  GrowIT
//
//  Created by 허준호 on 1/7/25.
//

import UIKit
import KakaoSDKAuth
import KakaoSDKCommon

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 앱 시작 시 로그아웃 처리
        TokenManager.shared.clearTokens()
 
        // 화면을 구성하는 UIWindow 인스턴스 생성
        let window = UIWindow(windowScene: windowScene)
        // 실제 첫 화면이 되는 MainViewController 인스턴스 생성

        let vc = LoginViewController()
        
        // NavigationController을 사용할 경우, MainViewController를 rootViewController로 갖는 NavigationController을 생성해야한다.
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = true
        // UIWindow의 시작 ViewController를 생성한 NavigationController로 지정
        window.rootViewController = navigationController
        
        if let accessToken = TokenManager.shared.getAccessToken() {
                let homeVC = HomeViewController()
                let navigationController = UINavigationController(rootViewController: homeVC)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
            } else {
                let loginVC = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginVC)
                navigationController.isNavigationBarHidden = true
                window.rootViewController = navigationController
            }
        
        // window 표시.
        self.window = window
        // makeKeyAndVisible() 메서드 호출
        window.makeKeyAndVisible()
        
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                print("✅ SceneDelegate: 카카오 로그인 URL 감지")
                AuthController.handleOpenUrl(url: url)
            }

            print("✅ SceneDelegate: handleAuthorizationCode 호출")
            KakaoLoginManager.shared.handleAuthorizationCode(from: url)
        }
    }
    
      
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}
