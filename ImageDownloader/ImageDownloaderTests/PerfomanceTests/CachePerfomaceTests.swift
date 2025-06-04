//
//  CachePerfomaceTests.swift
//  ImageDownloaderTests
//
//  Created by EVGENY SYSENKA on 04/06/2025.
//

import XCTest
@testable import ImageDownloader

final class CachePerfomaceTests: XCTestCase {
    
    private let testKey = "testKey"
    private let testImageName = "test_image"
    private let totalCount = 10_000
    
    func testInMemoryCacheInsertPerformance() throws {
        let cache = ImageInMemoryCache()
        let testImage = UIImage(named: testImageName)
        
        measure {
            Task {
                for index in 0..<totalCount {
                    await cache.insert(value: testImage, for: "\(testKey) + \(index)")
                }
            }
        }
    }
    
    func testNSCacheInsertPerformance() throws {
        let cache = ImageCacher(limitItemCount: 10_000, limitItemSize: 1_000 * 1024 * 1024)
        let testImage = UIImage(named: testImageName)
        
        measure {
            Task {
                for index in 0..<totalCount {
                    await cache.insert(value: testImage, for: "\(testKey) + \(index)")
                }
            }
        }
    }
}
