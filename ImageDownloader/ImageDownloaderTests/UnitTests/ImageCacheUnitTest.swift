//
//  ImageCacheUnitTest.swift
//  ImageDownloaderTests
//
//  Created by EVGENY SYSENKA on 26/05/2025.
//

import XCTest
@testable import ImageDownloader

final class ImageCacheUnitTest: XCTestCase {

    func testCacheInsert() async throws {
        let testKey = "test_key"
        let testImage = UIImage(systemName: "star")
        let cache = ImageCacher()
        
        await cache.insert(value: testImage, for: testKey)
        
        let imageOptional = await cache.value(for: testKey)
        let image = try XCTUnwrap(imageOptional)
        
        XCTAssertEqual(image, testImage)
    }
    
    func testCacheRemove() async throws {
        let testKey = "test_key"
        let testImage = UIImage(systemName: "star")
        let cache = ImageCacher()
        
        await cache.insert(value: testImage, for: testKey)
        await cache.insert(value: nil, for: testKey)
        let image = await cache.value(for: testKey)
        
        XCTAssertNil(image)
    }
    
    func testUnknownKey() async throws {
        let testUnknownKey = "unknown_key"
        let cache = ImageCacher()
        
        let image = await cache.value(for: testUnknownKey)
        
        XCTAssertNil(image)
    }
}
