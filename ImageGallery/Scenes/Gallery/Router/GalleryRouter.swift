//
//  GalleryRouter.swift
//  ImageGallery
//
//  Created by Oleg on 13.09.2026.
//

import UIKit

final class GalleryRouter: GalleryRouterProtocol {
    let factory: AppFactory
    private weak var view: UIViewController?
    init(factory: AppFactory, view: UIViewController? = nil) {
        self.factory = factory
        self.view = view
    }
    func presentFullScreenImage(for item: OpenverseImage, interactor: GalleryImageDetailsInteractorProtocol?) {
        let fullScreenVC = FullScreenImageViewController(imageItem: item)
        fullScreenVC.modalPresentationStyle = .popover

        fullScreenVC.interactor = interactor
        fullScreenVC.isFavorite = interactor?.isFavorite(image: item) ?? false
        view?.present(fullScreenVC, animated: true)
    }
}
