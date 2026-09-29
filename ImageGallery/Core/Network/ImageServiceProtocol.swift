//
//  ImageServiceProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 17.09.2026.
//

import Foundation


protocol ImageServiceProtocol{
    func fetchImages(pageSize: Int) async throws -> OpenverseImagesResponse
    func fetchImages(_ request: URLRequest) async throws -> OpenverseImagesResponse
    func fetchAccessToken(clientId: String, clientSecret: String) async throws
    func fetchAccessToken() async throws
    func getAccessToken() -> String?
    func fetchImageDetails(id: String) async throws -> OpenverseImageDetailsResponse
}
