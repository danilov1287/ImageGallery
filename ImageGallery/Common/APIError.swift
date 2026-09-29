//
//  APIError 2.swift
//  ImageGallery
//
//  Created by Oleg on 20.09.2026.
//


import Foundation

enum APIError: Error, LocalizedError {
    case invalidResponse
    case unexpectedStatus(Int, Data?)
    case decoding(Error)
    case transport(Error)
    case missingCredentials
    
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Не удалось получить корректный HTTP-ответ от сервера."
        case .unexpectedStatus(let code, _):
            return "Сервер вернул неожиданный статус: \(code)."
        case .decoding(let error):
            return "Ошибка декодирования JSON: \(error)"
        case .transport(let error):
            return "Ошибка доставки: \(error.localizedDescription)"
        case .missingCredentials:
            return "Отсутствует client_id или client_secret"
        }
    }
}
