//
//  CoreDataStackProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 25.09.2026.
//

protocol ImageGalleryStorageProtocol {
    func addToFavorites(_ image: OpenverseImage) throws
    func removeFromFavorites(_ image: OpenverseImage) throws
    func isFavorite(id: String) -> Bool
}

protocol ImageGalleryStorageListProtocol {
    func fetchAllFavorites() throws -> [OpenverseImage]
}
