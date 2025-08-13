//
//  UserService+Combine.swift
//  GrowIT
//
//  Created by 강희정 on 7/21/25.
//

import Combine

extension UserService {
    func changePasswordPublisher(email: String, newPassword: String, confirmPassword: String) -> AnyPublisher<UserPatchResponseDTO, Error> {
        Future { promise in
            let dto = UserPatchRequestDTO(isVerified: true, email: email, password: newPassword, passwordCheck: confirmPassword)
            self.patchUserPassword(data: dto) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
