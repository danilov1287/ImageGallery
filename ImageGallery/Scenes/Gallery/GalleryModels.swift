//
//  GalleryModels.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation

enum GalleryModels {
    // View → Interactor
    struct Request {
        let pageSize: Int
        let page: Int?
        let query: String?
        init(pageSize: Int, page: Int? = nil, query: String? = nil) {
            self.pageSize = pageSize
            self.query = query
            self.page = page
        }
    }
    
    struct RequestImageDetails{
        
    }

    // Interactor → Presenter
    struct Response {
        let images: [OpenverseImage]
        let totalCount: Int
        let error: GalleryError?
        init(images: [OpenverseImage]){
            self.images = images
            self.totalCount = images.count
            self.error = nil
        }
        init(error: GalleryError){
            self.images = []
            self.totalCount = 0
            self.error = error
        }
    }

    // Presenter → View
    struct ViewModel {
        enum State {
            case loading
            case loadImageList
            case populated([ImageViewModel])
            case showTable
            case error(String)
            case tryAgain
        }

        let state: State
    }

    enum ImageLoadState: Equatable {
        case loading
        case loaded
        case failed
    }
    // Упрощённая модель для ячейки, только те поля которые используются+статус загрузки изображения в ячейке
    struct ImageViewModel {
        let id: String
        let thumbnailURL: URL?
        let title: String
        var loadState: ImageLoadState
    }
    struct FullScreenImageView {
        let id: String
        let thumbnailURL: URL?
        let title: String
        let creator: String
    }

    enum GalleryError: Error {
        case decoding
        case network
        case unauthorized

        var message: String {
            switch self {
                case .decoding:     return "Не удалось обработать данные"
                case .network:      return "Проблемы с сетью"
                case .unauthorized: return "Требуется авторизация. Заполните данные в разделе Настройки"
            }
        }
    }
}

