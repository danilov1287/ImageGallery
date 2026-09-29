//
//  GalleryPresenter.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import Foundation

final class GalleryPresenter: GalleryPresenterProtocol {
    private weak var view: GalleryViewControllerProtocol?
    var router: GalleryRouter?
    
    init(view: GalleryViewControllerProtocol) {
        self.view = view
    }
    
    func presentDataImages(result: GalleryModels.Response) {
        let images: [GalleryModels.ImageViewModel] = result.images.map { image in
            GalleryModels.ImageViewModel(
                id: image.id,
                thumbnailURL: getImageUrl(from: image.thumbnail),
                title: image.title ?? "",
                loadState: .loading
            )
        }
        let viewModel = GalleryModels.ViewModel(state: .populated(images))
        view?.display(with: viewModel.state)
    }
    
    private func getImageUrl(from urlString: String?) -> URL? {
        guard let urlString,
              let url: URL = URL(string: urlString) else { return nil }
        return url
    }
    
    func presentError(response: GalleryModels.Response) {// Преобразуем ошибку в одну из понятных UI
        let galleryError: GalleryModels.GalleryError = response.error ?? .network
        let errorString = galleryError.message
        let viewModel = GalleryModels.ViewModel(state: .error(errorString) )
        view?.display(with: viewModel.state)
    }
    
    func presentIsLoading(_ isLoading: Bool) {
        let viewModel = isLoading ? GalleryModels.ViewModel(state: .loading) : GalleryModels.ViewModel(state: .showTable)
        view?.display(with: viewModel.state)
    }
    
    func presentImageDetailsModal(result: FullScreenImageModels.Response) {
        guard let openverseImageDetailsResponse = result.image else { return }
        let openverseImage: OpenverseImage = OpenverseImage(openverseImageDetails: openverseImageDetailsResponse)
        let interactor: GalleryImageDetailsInteractorProtocol? = result.interactor
        router?.presentFullScreenImage(for: openverseImage, interactor: interactor)
        
    }
}
