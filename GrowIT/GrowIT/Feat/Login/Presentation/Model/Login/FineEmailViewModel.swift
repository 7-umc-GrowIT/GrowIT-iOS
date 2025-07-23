//
//  FineEmailViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine
import Foundation

final class FindEmailViewModel {
    
    enum State {
        case idle
        case loading
        case success(String)  // 이메일 또는 메시지
        case failure(String)
    }
    
    @Published private(set) var state: State = .idle
    
    func findEmail() {
        // 향후 이메일 찾기 로직 추가
        // 지금은 상태 변화만 예시로 구현
        state = .loading
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.state = .success("test@example.com")
        }
    }
}
