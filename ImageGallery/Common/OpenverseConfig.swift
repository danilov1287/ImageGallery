//
//  OpenverseConfig.swift
//  ImageGallery
//
//  Created by Oleg on 16.09.2026.
//


import Foundation

enum OpenverseConfig {
    /// Базовый URL API Openverse.
    /// Инициализируется один раз; при ошибке выбрасывает fatalError,
    /// так как без валидного baseURL приложение не может работать.
    static let baseURL: URL = {
        guard let url = URL(string: "https://api.openverse.org/v1") else {
            fatalError("Не удалось распарсить baseURL для Openverse API")
        }
        return url
    }()
}