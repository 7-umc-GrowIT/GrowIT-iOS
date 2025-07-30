//
//  TermsAgreeViewModel.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine
import Foundation

final class TermsAgreeViewModel {
    
    enum State {
        case idle
        case loading
        case loaded
        case failure(String)
    }
    
    @Published private(set) var state: State = .idle
    @Published private(set) var mandatoryTerms: [TermsData] = []
    @Published private(set) var optionalTerms: [TermsData] = []
    @Published private(set) var agreedTerms: [Int: Bool] = [:]
    @Published private(set) var isAllMandatoryAgreed: Bool = false
    
    private let termsService: TermsService
    private var cancellables = Set<AnyCancellable>()
    
    init(termsService: TermsService = TermsService()) {
        self.termsService = termsService
    }
    
    func fetchTerms() {
        state = .loading
        termsService.fetchTermsPublisher()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.state = .failure(error.localizedDescription)
                }
            }, receiveValue: { [weak self] terms in
                guard let self = self else { return }
                self.mandatoryTerms = terms.filter { $0.type.uppercased() == "MANDATORY" }
                self.optionalTerms = terms.filter { $0.type.uppercased() == "OPTIONAL" }
                self.agreedTerms = Dictionary(uniqueKeysWithValues: terms.map { ($0.termId, false) })
                self.updateMandatoryStatus()
                self.state = .loaded
            })
            .store(in: &cancellables)
    }
    
    func toggleAgreement(termId: Int) {
        agreedTerms[termId]?.toggle()
        updateMandatoryStatus()
    }
    
    func toggleAllAgreements(_ isSelected: Bool) {
        for termId in agreedTerms.keys {
            agreedTerms[termId] = isSelected
        }
        updateMandatoryStatus()
    }
    
    func updateTermAgreement(termId: Int) {
        agreedTerms[termId] = true
        updateMandatoryStatus()
    }
    
    private func updateMandatoryStatus() {
        isAllMandatoryAgreed = !mandatoryTerms.contains { agreedTerms[$0.termId] == false }
    }
    
    func getAgreedTerms() -> [UserTermDTO] {
        (mandatoryTerms + optionalTerms).map {
            UserTermDTO(termId: $0.termId, agreed: agreedTerms[$0.termId] ?? false)
        }
    }
}
