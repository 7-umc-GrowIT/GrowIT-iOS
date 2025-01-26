//
//  ItemObjectModel.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import Foundation
import UIKit

struct ItemAccModel: ItemDisplayable {
    var credit: Int
    var backgroundColor: UIColor
    var Item: UIImage
    var isPurchased: Bool
}

extension ItemAccModel {
    static func dummy() -> [ItemAccModel] {
        return [
            ItemAccModel(credit: 120, backgroundColor: .itemPink, Item: .itemAccCherry, isPurchased: false),
            ItemAccModel(credit: 120, backgroundColor: .itemGreen, Item: .itemAccSprout, isPurchased: true),
            ItemAccModel(credit: 120, backgroundColor: .itemYellow, Item: .itemAccAngelring, isPurchased: false)
        ]
    }
    
    static func myItemsDummy() -> [ItemAccModel] {
        return [
            ItemAccModel(credit: 0, backgroundColor: .itemPink, Item: .itemAccCherry, isPurchased: true),
            ItemAccModel(credit: 0, backgroundColor: .itemGreen, Item: .itemAccSprout, isPurchased: true)
        ]
    }
}
