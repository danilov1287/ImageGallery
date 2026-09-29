//
//  GalleryRouterProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 22.09.2026.
//
import Foundation

protocol GalleryRouterProtocol: AnyObject {
    func presentFullScreenImage(for item: OpenverseImage, interactor: GalleryImageDetailsInteractorProtocol?)
}
