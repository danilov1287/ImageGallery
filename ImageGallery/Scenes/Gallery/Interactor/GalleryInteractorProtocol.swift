//
//  GalleryInteractorProtocol.swift
//  ImageGallery
//
//  Created by Oleg on 19.09.2026.
//

import Foundation

protocol GalleryInteractorProtocol: AnyObject {
    func loadImageList(_ request: GalleryModels.Request) async
    func loadImageDetails(_ request: FullScreenImageModels.Request) async
}
