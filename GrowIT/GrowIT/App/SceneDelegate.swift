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

            // LaunchScreenViewController를 첫 화면으로 설정
            let window = UIWindow(windowScene: windowScene)
            let launchVC = LaunchScreenViewController()
            window.rootViewController = launchVC
            self.window = window
            window.makeKeyAndVisible()

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                
                // 앱 시작 시 로그아웃 처리
                TokenManager.shared.clearTokens()

                // 토큰 확인 후 화면 선택
                let nextViewController: UIViewController
                if let _ = TokenManager.shared.getAccessToken() {
                    nextViewController = CustomTabBarController()
                } else {
                    nextViewController = LoginViewController()
                }

                // NavigationController 설정
                let navigationController = UINavigationController(rootViewController: nextViewController)
                navigationController.isNavigationBarHidden = true

                // LaunchScreen → 다음 화면 전환
                self.window?.rootViewController = navigationController
                self.window?.makeKeyAndVisible()
            }
        }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                AuthController.handleOpenUrl(url: url)
            }

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
