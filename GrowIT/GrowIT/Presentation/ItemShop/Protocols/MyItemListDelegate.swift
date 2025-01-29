//
//  ItemListDelegate.swift
//  GrowIT
//
//  Created by 오현민 on 1/26/25.
//

import Foundation

protocol MyItemListDelegate: AnyObject {
    func didSelectPurchasedItem(_ isPurchased: Bool, selectedItem: ItemList?)
}
