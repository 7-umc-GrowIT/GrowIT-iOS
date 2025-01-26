//
//  IsOwnedModel.swift
//  GrowIT
//
//  Created by 오현민 on 1/26/25.
//

import Foundation
import UIKit

struct IsOwnedModel {
    var credit: Int?
    var isOwned: String?
    var backgroundColor: UIColor
    var Item: UIImage
}

extension IsOwnedModel {
    static func dummy() -> [IsOwnedModel] {
        return [
            IsOwnedModel(isOwned: "보유 중", backgroundColor: .itemPink, Item: .itemAccCherry),
            IsOwnedModel(isOwned: "보유 중", backgroundColor: .itemGreen, Item: .itemAccSprout),
            IsOwnedModel(isOwned: "보유 중", backgroundColor: .itemYellow, Item: .itemAccAngelring)
        ]
    }
}
