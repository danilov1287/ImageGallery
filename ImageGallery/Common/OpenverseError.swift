//
//  OpenverseError.swift
//  ImageGallery
//
//  Created by Oleg on 16.09.2026.
//


import Foundation

/// Ошибки, которые могут возникнуть при формировании запроса к Openverse.
enum OpenverseError: Error, LocalizedError {
    case invalidURL
    case invalidAccessToken

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Не удалось сформировать корректный URL для запроса."
        case .invalidAccessToken:
            return "Не задан access token."
        }
    }
}
