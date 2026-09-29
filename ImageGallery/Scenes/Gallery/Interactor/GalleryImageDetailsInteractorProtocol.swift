//
//  GalleryImageInteractorProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 24.09.2026.
//

import Foundation

protocol GalleryImageDetailsInteractorProtocol {
    func setFavorite(for image: OpenverseImage)
    func unsetFavorite(for image: OpenverseImage)
    func isFavorite(image: OpenverseImage) -> Bool
    func isModalLoaded()// снимает загрузку в модальном окне
}
