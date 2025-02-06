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

// 구매 완료한 뒤 전달
protocol PurchaseDelegate: AnyObject {
    func didCompletePurchase()
    func updateCredit()
}
