//
//  DownloadImageMockService.swift
//  ImageDownloaderTests
//
//  Created by EVGENY SYSENKA on 27/05/2025.
//

import UIKit
@testable import ImageDownloader

actor DownloadImageMockService: DownloadImageProtocol {
    
    func downloadRandomImage(urlString: String) async throws -> UIImage {
        
        try await Task.sleep(for: .seconds([0.25, 2].randomElement()!))
        
        guard let image = UIImage(systemName: "star") else {
            throw ApiService.ApiError.custom(message: "[DownloadImageMockService]: nil image.")
        }
        return image
    }
}
