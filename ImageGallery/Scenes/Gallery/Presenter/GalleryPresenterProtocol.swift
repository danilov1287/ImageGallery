//
//  GalleryPresenterProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 19.09.2026.
//

import Foundation

protocol GalleryPresenterProtocol {
    func presentDataImages(result: GalleryModels.Response)
    func presentImageDetailsModal(result: FullScreenImageModels.Response)
    func presentError(response: GalleryModels.Response)
    func presentIsLoading(_ isLoading: Bool)
}
