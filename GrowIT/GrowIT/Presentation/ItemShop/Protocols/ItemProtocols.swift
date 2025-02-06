//
//  ItemProtocols.swift
//  GrowIT
//
//  Created by 오현민 on 2/4/25.
//

import Foundation

// 아이템셀 선택 했을 때
protocol ItemListDelegate: AnyObject {
    func didSelectItem(_ isPurchased: Bool, selectedItem: ItemList?)
}
