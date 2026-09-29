//
//  TokenResponse.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

struct TokenResponse: Codable {
    let accessToken: String
    let expiresIn: Int?

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
    }
}
