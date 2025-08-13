//
//  TermsService_Combine.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine

extension TermsService {
    func fetchTermsPublisher() -> AnyPublisher<[TermsData], Error> {
        Future { promise in
            self.fetchTerms { result in
                switch result {
                case .success(let terms):
                    promise(.success(terms))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
