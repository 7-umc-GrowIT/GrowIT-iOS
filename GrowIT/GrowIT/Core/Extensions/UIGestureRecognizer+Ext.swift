//
//  UIGestureRecognizer+Ext.swift
//  GrowIT
//
//  Created by 이수현 on 6/21/25.
//

import UIKit
import Combine

extension UIGestureRecognizer {
    func publisher() -> AnyPublisher<UIGestureRecognizer, Never> {
        let subject = PassthroughSubject<UIGestureRecognizer, Never>()
        addTarget(ClosureSleeve { [weak self] in
            if let self = self { subject.send(self) }
        }, action: #selector(ClosureSleeve.invoke))
        return subject.eraseToAnyPublisher()
    }
}

private class ClosureSleeve {
    let closure: () -> Void
    init (_ closure: @escaping () -> Void) { self.closure = closure }
    @objc func invoke() { closure() }
}
