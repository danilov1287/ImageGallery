//
//  OpenverseImage.swift
//  ImageGallery
//
//  Created by Oleg on 19.09.2026.
//


import Foundation

/// Модель одного изображения из ответа API.
struct OpenverseImage: Decodable, Identifiable {
    let id: String
    let title: String?
    let url: String              // прямая ссылка на изображение
    let thumbnail: String?       // превью
    let width: Int?
    let height: Int?
    let license: String?
    let creator: String?
    
    init(openverseImageDetails: OpenverseImageDetailsResponse){
        let urlString: String = openverseImageDetails.thumbnail?.absoluteString ?? ""
        self.id = openverseImageDetails.id
        self.title = openverseImageDetails.title
        self.url = urlString
        self.thumbnail = urlString
        self.width = openverseImageDetails.width
        self.height = openverseImageDetails.height
        self.license = openverseImageDetails.license
        self.creator = openverseImageDetails.creator
    }
    init(id: String, title: String?, url: String, thumbnail: String?, width: Int?, height: Int?, license: String?, creator: String?) {
        self.id = id
        self.title = title
        self.url = url
        self.thumbnail = thumbnail
        self.width = width
        self.height = height
        self.license = license
        self.creator = creator
    }
}
