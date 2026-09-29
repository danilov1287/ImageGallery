//
//  APIClient.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//  (обёртка над URLSession)
import Foundation

final class APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .init()) {
        self.session = session
        self.decoder = decoder
        // Если нужно, можно настроить decoder глобально, например:
        // decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    // MARK: - Async/await версия (для ImageService и SwiftUI)

    /// Выполняет запрос и декодирует ответ в тип T: Decodable
    func sendAsync<T: Decodable>(_ request: URLRequest) async throws -> T {
        do {
            let (data, response) = try await session.data(for: request)
            try validate(response, data: data)
            do{
                return try decoder.decode(T.self, from: data)
            } catch let DecodingError as DecodingError {
                throw APIError.decoding(DecodingError)
            }
        } catch let APIError.decoding(error) {
            throw APIError.decoding(error)
        } catch let APIError.unexpectedStatus(code, data) {
            throw APIError.unexpectedStatus(code, data)
        } catch {
            // Все остальные ошибки (сеть, таймаут и т.п.) — как transport
            throw APIError.transport(error)
        }
    }

    // MARK: - Closure версия (для Clean Swift)

    func send<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, APIError>) -> Void
    ) {
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.transport(error!)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.invalidResponse))
                return
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                let statusCode = httpResponse.statusCode
                // Если есть данные (например, JSON с описанием ошибки), можно их передать
                completion(.failure(.unexpectedStatus(statusCode, data)))
                return
            }

            guard let data else {
                completion(.failure(.invalidResponse))
                return
            }

            do {
                let result = try self.decoder.decode(T.self, from: data)
                completion(.success(result))
            } catch {
                completion(.failure(.decoding(error)))
            }
        }.resume()
    }

    // MARK: - Вспомогательный метод валидации

    private func validate(_ response: URLResponse, data: Data?) throws {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard (200..<300).contains(http.statusCode) else {
            throw APIError.unexpectedStatus(http.statusCode, data)
        }
    }
    
    private func debug(_ response: URLResponse, data: Data?) {
        // Сырой ответ (чтобы понять, JSON это или HTML)
        if let data = data, let bodyString = String(data: data, encoding: .utf8) {
            print("Raw body (first 500 chars):")
            print(String(bodyString.prefix(1000)))
        } else {
            print("Empty body or non-UTF8")
        }
    }
}
