//
//  DownloadImageModelTests.swift
//  ImageDownloaderTests
//
//  Created by EVGENY SYSENKA on 27/05/2025.
//

import XCTest
@testable import ImageDownloader

@MainActor
final class DownloadImageModelTests: XCTestCase {
    
    private var mockApiService = DownloadImageMockService()
    private var testURL = "https://picsum.photos/200/300"
    
    func testImageDownloadFromApi() async throws {
        let model = DownloadImageModel(apiService: mockApiService)
        
        await model.fetchImage(from: testURL)
        
        XCTAssertNotNil(model.image)
    }
    
    func testImageInsertedInCache() async throws {
        let cache = ImageCacher()
        let model = DownloadImageModel(apiService: mockApiService, cache: cache)
        
        await model.fetchImage(from: testURL)
        
        let image = try XCTUnwrap(model.image)
        let cachedImage = await cache.value(for: testURL)
        
        XCTAssertEqual(image, cachedImage)
    }
    
    func testImageFetchedFromCache() async throws {
        let cache = ImageCacher()
        let model = DownloadImageModel(apiService: mockApiService, cache: cache)
        let testImage = UIImage(systemName: "star")
        
        await cache.insert(value: testImage, for: testURL)
        await model.fetchImage(from: testURL)
        
        XCTAssertEqual(testImage, model.image)
    }
    
    func testClearCache() async throws {
        let cache = ImageCacher()
        let model = DownloadImageModel(apiService: mockApiService, cache: cache)
        let testImage = UIImage(systemName: "star")
        
        await cache.insert(value: testImage, for: testURL)
        await model.clearCache(for: testURL)
        
        let image = await cache.value(for: testURL)
        XCTAssertNil(image)
    }
}
