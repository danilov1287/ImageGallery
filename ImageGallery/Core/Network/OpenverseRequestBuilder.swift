//
//  OpenverseRequestBuilder.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//  endpoint'ы, модели ответов

import Foundation

final class OpenverseRequestBuilder {
    static let shared = OpenverseRequestBuilder()
    private init(){}
    private var accessToken: String?

    func setAccessToken(token: String){
        self.accessToken = token
    }
    func makeAccessToken(clientId:String, clientSecret:String) throws -> URLRequest {
        let fullURL = OpenverseConfig.baseURL.appendingPathComponent("auth_tokens/token/")
        var request = URLRequest(url: fullURL)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        var components = URLComponents()
        components.queryItems = [
            URLQueryItem(name: "grant_type", value: "client_credentials"),
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "client_secret", value: clientSecret)
        ]
        request.httpBody = components.percentEncodedQuery?.data(using: .utf8)

        return request
    }

    func makeImagesDetailsRequest(id: String) throws -> URLRequest {
        let fullURL = OpenverseConfig.baseURL.appendingPathComponent("images/\(id)")
        // 2. Создаём компоненты URL (безопасный конструктор)
        guard let components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw OpenverseError.invalidURL
        }
        // 4. Получаем итоговый URL из компонентов
        guard let url = components.url else {
            throw OpenverseError.invalidURL
        }
        guard let token = accessToken else {
            throw OpenverseError.invalidAccessToken
        }
        // 5. Настраиваем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
    
    /// Формирует GET-запрос к /images с параметром page_size.
    func makeImagesRequest(pageSize: Int = 10, page: Int? = nil, query: String? = nil) throws -> URLRequest {
        // 1. Базовый URL + путь
        let fullURL = OpenverseConfig.baseURL.appendingPathComponent("images/")

        // 2. Создаём компоненты URL (безопасный конструктор)
        guard var components = URLComponents(url: fullURL, resolvingAgainstBaseURL: false) else {
            throw OpenverseError.invalidURL
        }

        // 3. Добавляем query-параметры
        components.queryItems = [
            URLQueryItem(name: "page_size", value: String(pageSize))
        ]
        if let page {
            components.queryItems?.append(URLQueryItem(name: "page", value: String(page)))
        }
        if let query {
            components.queryItems?.append(URLQueryItem(name: "query", value: String(query)))
        }

        // 4. Получаем итоговый URL из компонентов
        guard let url = components.url else {
            throw OpenverseError.invalidURL
        }
        guard let token = accessToken else {
            throw OpenverseError.invalidAccessToken
        }
        // 5. Настраиваем запрос
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        return request
    }
}
