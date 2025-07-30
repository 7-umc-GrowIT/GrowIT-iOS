//
//  ErrorPopupViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/23/25.
//

import Combine

final class ErrorPopupViewModel {
    enum Action {
        case exit
        case `continue`
    }
    
    private let actionSubject = PassthroughSubject<Action, Never>()
    var actionPublisher: AnyPublisher<Action, Never> {
        actionSubject.eraseToAnyPublisher()
    }
    
    func exitTapped() { actionSubject.send(.exit) }
    func continueTapped() { actionSubject.send(.continue) }
}
