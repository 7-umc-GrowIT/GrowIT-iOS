//
//  SignUpCompleteViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/23/25.
//

import Foundation
import Combine

final class SignUpCompleteViewModel {
    
    enum Action {
        case goToGroSetBackground
    }
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    func onLoginButtonTap() {
        actionSubject.send(.goToGroSetBackground)
    }
}
