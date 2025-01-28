//
//  DiaryService.swift
//  GrowIT
//
//  Created by 이수현 on 1/18/25.
//

import Foundation
import Moya

final class DiaryService: NetworkManager {
    typealias Endpoint = DiaryEndpoint
    
    let provider: MoyaProvider<DiaryEndpoint>
    
    init(provider: MoyaProvider<DiaryEndpoint>? = nil) {
        let plugins: [PluginType] = [
            NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
        ]
        
        self.provider = provider ?? MoyaProvider<DiaryEndpoint>(plugins: plugins)
    }
    
    /// Post Text Diary API
    func postTextDiary(data: DiaryRequestDTO, completion: @escaping (Result<DiaryPostResponseDTO, NetworkError>) -> Void) {
        request(target: .postTextDiary(Data: data), decodingType: DiaryPostResponseDTO.self, completion: completion)
    }
    
    /// Post Voice Diary API
    func postVoiceDiary(data: DiaryRequestDTO, completion: @escaping (Result<DiaryPostResponseDTO, NetworkError>) -> Void) {
        request(target: .postVoiceDiary(data: data), decodingType: DiaryPostResponseDTO.self, completion: completion)
    }
    
    /// Diary Id를 받아 Diary를 삭제하는 API
    func deleteDiary(diaryId: Int, completion: @escaping (Result<String, NetworkError>) -> Void) {
        request(target: .deleteDiary(diaryId: diaryId), decodingType: String.self, completion: completion)
    }
    
    /// Diary Id를 받아 특정 일기를 조회하는 API
    func fetchDiary(diaryId: Int, completion: @escaping (Result<DiaryGetDatesResponseDTO, NetworkError>) -> Void) {
        request(target: .getDiaryID(diaryId: diaryId), decodingType: DiaryGetDatesResponseDTO.self, completion: completion)
    }
    
    /// 월별 일기 수 조회 API
    func fetchAllDiaries(year: Int, month: Int, completion: @escaping (Result<DiaryGetAllResponseDTO?, NetworkError>) -> Void) {
        requestOptional(
            target: .getAllDiary(year: year, month: month),
            decodingType: DiaryGetAllResponseDTO.self,
            completion: completion
        )
    }
    
    /// 월별 일기 작성 날짜 및 일기 Id 조회 API
    func fetchDiaryDates(year: Int, month: Int, completion: @escaping (Result<DiaryGetDatesResponseDTO?, NetworkError>) -> Void) {
        requestOptional(
            target: .getDiaryDates(year: year, month: month),
            decodingType: DiaryGetDatesResponseDTO.self,
            completion: completion
        )
    }
    
    func patchFixDiary(diaryId: Int, data: DiaryPatchDTO, completion: @escaping (Result<DiaryPatchResponseDTO, NetworkError>) -> Void) {
        request(target: .patchFixDiary(diaryId: diaryId, data: data), decodingType: DiaryPatchResponseDTO.self, completion: completion)
    }
}

