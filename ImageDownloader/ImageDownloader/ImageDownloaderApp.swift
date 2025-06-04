//
//  ImageDownloaderApp.swift
//  ImageDownloader
//
//  Created by EVGENY SYSENKA on 23/05/2025.
//

import SwiftUI

@main
struct ImageDownloaderApp: App {
    
    let apiService = ApiService()
    let imageCache = ImageCacher()
    
    var body: some Scene {
        WindowGroup {
            DownloadScreen()
                .environment(DownloadImageModel(apiService: apiService, cache: imageCache))
        }
    }
}
