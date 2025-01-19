//
//  DiaryEndpoint.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation
import Moya

enum DiaryEndpoint {
    case getDiary(diaryId: Int)
    case getAllDiary(year: Int, month: Int)
    case postVoiceDiary(
}
