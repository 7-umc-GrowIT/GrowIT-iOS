//
//  ItemDisplayable.swift
//  GrowIT
//
//  Created by 오현민 on 1/12/25.
//

import Foundation
import UIKit

protocol ItemDisplayable {
    var credit: Int { get }
    var backgroundColor: UIColor { get }
    var Item: UIImage { get }
}
