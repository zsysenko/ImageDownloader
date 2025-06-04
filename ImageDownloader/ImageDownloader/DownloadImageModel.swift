//
//  DownloadImageModel.swift
//  ImageDownloader
//
//  Created by EVGENY SYSENKA on 25/05/2025.

import SwiftUI
import Observation

@MainActor @Observable
final class DownloadImageModel {
    
    var image: UIImage? = nil
    var error: Error? = nil
    var isLoading = false
    
    private let apiService: DownloadImageProtocol
    private let cache: any ImageCacheProtocol
    
    @ObservationIgnored
    private var tasksInProgress: [String: Task<UIImage, Error>] = [:]
    
    init (
        apiService: DownloadImageProtocol,
        cache: any ImageCacheProtocol = ImageInMemoryCache()
    ) {
        self.apiService = apiService
        self.cache = cache
    }
    
    func fetchImage(from url: String) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let image = await cache.value(for: url) {
                self.image = image
            } else {
                let image = try await downloadImage(urlString: url)
                self.image = image
            }
        } catch {
            self.tasksInProgress[url] = nil
            self.error = error
        }
    }
    
    private func downloadImage(urlString: String) async throws -> UIImage {
        if let task = tasksInProgress[urlString] {
            print("Download in progress. Wait for value.")
            return try await task.value
        }
        
        let downloadTask = Task {
            let image = try await apiService.downloadRandomImage(urlString: urlString)
            tasksInProgress[urlString] = nil
            
            await cache.insert(value: image, for: urlString)
            return image
        }
        tasksInProgress[urlString] = downloadTask
        return try await downloadTask.value
    }
    
    func clearCache(for key: String) async {
        await cache.insert(value: nil, for: key)
    }
}
