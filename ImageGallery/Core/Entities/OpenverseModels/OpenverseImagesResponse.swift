//
//  OpenverseImagesResponse.swift
//  ImageGallery
//
//  Created by Oleg on 19.09.2026.
//


import Foundation

/// Ответ на запрос списка изображений.
struct OpenverseImagesResponse: Decodable {
    let resultCount: Int
    let results: [OpenverseImage]
    init( results: [OpenverseImage] ){
        self.resultCount = results.count
        self.results = results
    }
    enum CodingKeys: String, CodingKey {
        case resultCount = "result_count"
        case results
    }
}
