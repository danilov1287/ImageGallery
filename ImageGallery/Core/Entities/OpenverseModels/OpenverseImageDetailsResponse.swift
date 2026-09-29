//
//  OpenverseImageDetailsResponse.swift
//  ImageGallery
//
//  Created by Oleg on 22.09.2026.
//
import Foundation

struct OpenverseImageDetailsResponse: Decodable, Identifiable {
    let id: String
    let title: String?
    let creator: String?
    let creatorURL: String?
    let thumbnail: URL?
    let height: Int?
    let width: Int?
    let license: String?
    let licenseURL: URL?
    let provider: String?
    let foreignLandingURL: URL?

    enum CodingKeys: String, CodingKey {
        case id, title, creator
        case creatorURL = "creator_url"
        case thumbnail, height, width, license
        case licenseURL = "license_url"
        case provider
        case foreignLandingURL = "foreign_landing_url"
    }
}
