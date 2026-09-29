//
//  AuthError.swift
//  ImageGallery
//
//  Created by Oleg on 16.09.2026.
//

import Foundation

enum AuthError: Error, CustomStringConvertible {
    case missingCredentials
    case invalidURL
    case networkError(Error)
    case httpError(Int)
    case decodingError(Error)

    var description: String {
        switch self {
        case .missingCredentials:
            return "Missing client_id or client_secret"
        case .invalidURL:
            return "Invalid URL for token request"
        case let .networkError(error):
            return "Network error: \(error.localizedDescription)"
        case let .httpError(code):
            return "HTTP error with status code: \(code)"
        case let .decodingError(error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
