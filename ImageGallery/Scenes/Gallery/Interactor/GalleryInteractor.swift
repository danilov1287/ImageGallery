//
//  GalleryInteractor.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation

final class GalleryInteractor: GalleryInteractorProtocol, GalleryImageDetailsInteractorProtocol {
    var service: ImageServiceProtocol?
    let presenter: GalleryPresenterProtocol
    let serviceCoreData: ImageGalleryStorageProtocol
    init(
        presenter: GalleryPresenterProtocol,
        service: ImageServiceProtocol? = nil,
        serviceCoreData: ImageGalleryStorageProtocol
    ) {
        self.presenter = presenter
        self.service = service
        self.serviceCoreData = serviceCoreData
    }
    
    func loadImageList(_ requestViewModel: GalleryModels.Request) async {
        presenter.presentIsLoading(true)
        do {
            if(self.service == nil){
                do {
                    let service = try ServiceFactory().makeImageService()
                    self.service = service
                } catch{
                    throw ImageServiceError.clientIdNotSet
                }
            }
            if self.service?.getAccessToken() == nil {// Если токена нет — получаем его
                try await self.service?.fetchAccessToken()
            }
            
            let request = try OpenverseRequestBuilder.shared.makeImagesRequest(
                pageSize: requestViewModel.pageSize,
                page: requestViewModel.page,
                query: requestViewModel.query
            )
            let openverseImages = try await self.service?.fetchImages(request)
            let images = openverseImages?.results ?? []
            let response = GalleryModels.Response(images: images)
            self.presenter.presentDataImages(result: response)
        } catch {
            let galleryError = getGalleryError(from: error)
            let response = GalleryModels.Response(error: galleryError)
            self.presenter.presentError(response: response)
        }
    }
    private func getGalleryError(from error: Error) -> GalleryModels.GalleryError {
        let galleryError: GalleryModels.GalleryError
        switch error {
        case APIError.decoding:
            galleryError = .decoding
        case OpenverseError.invalidAccessToken,
            ImageServiceError.clientIdNotSet,
            ImageServiceError.accessTokenNotSet:
            galleryError = .unauthorized
        default:
            galleryError = .network
        }
        return galleryError
    }
    func loadImageDetails(_ request: FullScreenImageModels.Request) async {
        let item = request.item
        if item.loadState != .loaded {
            return
        }
        let id = item.id
        presenter.presentIsLoading(true)
        do{
            if self.service?.getAccessToken() == nil {// Если токена нет — получаем его
                try await self.service?.fetchAccessToken()
            }
            let openverseImage = try await self.service?.fetchImageDetails(id: id)
            var response = FullScreenImageModels.Response(image: openverseImage)
            response.interactor = self
            self.presenter.presentImageDetailsModal(result: response)
        } catch {
            presentError(from: error)
        }
    }
    
    private func presentError(from error: Error){
        presenter.presentIsLoading(false)
        let galleryError = getGalleryError(from: error)
        let response = GalleryModels.Response(error: galleryError)
        self.presenter.presentError(response: response)
    }
    
    // снять загрузку у окна родителя после загрузки модального
    func isModalLoaded(){
        self.presenter.presentIsLoading(false)
    }

    func setFavorite(for image: OpenverseImage) {
        
        do{
            try serviceCoreData.addToFavorites(image)
        } catch {
            presentError(from: error)
        }
    }
    
    func unsetFavorite(for image: OpenverseImage) {
        do{
            try serviceCoreData.removeFromFavorites(image)
        } catch {
            presentError(from: error)
        }
    }
    
    func isFavorite(image: OpenverseImage) -> Bool {
        return serviceCoreData.isFavorite(id: image.id)
    }
}
