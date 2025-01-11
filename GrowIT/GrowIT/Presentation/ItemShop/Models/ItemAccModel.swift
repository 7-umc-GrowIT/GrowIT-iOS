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
}

extension ItemAccModel {
    static func dummy() -> [ItemAccModel] {
        return [
            ItemAccModel(credit: 120, backgroundColor: .itemPink, Item: .itemAccCherry),
            ItemAccModel(credit: 120, backgroundColor: .itemGreen, Item: .itemAccSprout),
            ItemAccModel(credit: 120, backgroundColor: .itemYellow, Item: .itemAccAngelring)
        ]
    }
}
