//
//  GalleryModels.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation

enum FullScreenImageModels {
    // View → Interactor
    struct Request {
        let item: GalleryModels.ImageViewModel
    }

    // Interactor → Presenter
    struct Response {
        let image: OpenverseImageDetailsResponse?
        let error: GalleryModels.GalleryError?
        var interactor: GalleryImageDetailsInteractorProtocol?
        init(image: OpenverseImageDetailsResponse?) {
            self.image = image
            self.error = nil
        }
        init (error: GalleryModels.GalleryError) {
            self.image = nil
            self.error = error
        }
    }

    // Presenter → View
    struct ViewModel {
        enum State {
            case loading
            case populated(OpenverseImageDetailsResponse)
            case error(String)
        }
        let state: State
    }
}

