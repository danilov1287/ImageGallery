//
//  NetworkError.swift
//  ImageGallery
//
//  Created by Oleg on 16.09.2026.
//


enum NetworkError: Error {
    case timeout
    case noInternet
    case httpError(Int)
    case decodingError(Error)
    case invalidURL
    case unknown(Error)
}