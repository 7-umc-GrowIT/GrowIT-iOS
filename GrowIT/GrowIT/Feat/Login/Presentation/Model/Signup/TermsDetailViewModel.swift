//
//  TermsDetailViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine
import Foundation

final class TermsDetailViewModel {
    
    enum State {
        case idle
        case readyToAgree
        case agreed
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var content: String
    
    let termId: Int
    
    init(termId: Int, content: String) {
        self.termId = termId
        self.content = content
    }
    
    func userScrolledToBottom() {
        state = .readyToAgree
    }
    
    func agree() {
        state = .agreed
    }
}
