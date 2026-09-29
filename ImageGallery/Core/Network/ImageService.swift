//
//  ImageService.swift
//  ImageGallery
//
//  Created by Oleg on 16.09.2026.
//


import Foundation

enum ImageServiceError: Error, CustomStringConvertible {
    case accessTokenNotSet
    case clientIdNotSet
    var description: String {
        switch self {
        case .accessTokenNotSet:
            return "accessTokenNotSet"
        case .clientIdNotSet:
            return "clientIdNotSet"
        }
    }
}

final class ImageService: ImageServiceProtocol {
    private let client: APIClient
    private var accessToken: String?
    private let requestBuilder = OpenverseRequestBuilder.shared
    var clientId: String?
    var clientSecret: String?
    
    init(
        client: APIClient = APIClient(),
        accessToken: String? = nil
    ) {
        self.client = client
        guard let accessTokenString: String = accessToken else {
            return
        }
        self.setAccessToken(accessTokenString)
    }
    
    /// Асинхронная версия: возвращает массив картинок или выбрасывает ошибку.
    func fetchImages(pageSize: Int = 10) async throws -> OpenverseImagesResponse {
        let request = try requestBuilder.makeImagesRequest(pageSize: pageSize)
        return try await fetchImages(request)
    }
    
    /// Асинхронная версия: возвращает массив картинок или выбрасывает ошибку.
    func fetchImages(_ request: URLRequest) async throws -> OpenverseImagesResponse {
        // 2. Выполняем запрос через APIClient (используем async-версию)
        let response: OpenverseImagesResponse = try await client.sendAsync(request)
        // 3. Возвращаем только массив картинок, скрывая служебные поля ответа
        return response
    }
    
    func fetchImageDetails(id: String) async throws -> OpenverseImageDetailsResponse {
        let request = try requestBuilder.makeImagesDetailsRequest(id: id)
        let response: OpenverseImageDetailsResponse = try await client.sendAsync(request)
        return response
    }
    
    func fetchAccessToken(clientId: String, clientSecret: String) async throws {
        if getAccessToken() != nil {
            return
        }
        let request = try requestBuilder.makeAccessToken(clientId: clientId, clientSecret: clientSecret)
        let response: TokenResponse = try await client.sendAsync(request)
        setAccessToken(response.accessToken)
    }
    func fetchAccessToken() async throws{
        if getAccessToken() != nil {
            return
        }
        try await fetchAccessToken(
            clientId: self.clientId ?? Secrets.shared.clientId,
            clientSecret: self.clientSecret ?? Secrets.shared.clientSecret
        )
    }
    func getAccessToken() -> String? {
        return Secrets.shared.accessToken
    }
    private func setAccessToken(_ accessToken: String) {
        requestBuilder.setAccessToken(token: accessToken)
        Secrets.shared.setAccessToken(accessToken)
    }
}
