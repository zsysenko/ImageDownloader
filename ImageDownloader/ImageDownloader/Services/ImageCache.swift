//
//  ImageCache.swift
//  ImageDownloader
//
//  Created by EVGENY SYSENKA on 25/05/2025.
//

import SwiftUI

protocol CacheProtocol: Actor {
    associatedtype Value
    
    func value(for key: String) -> Value?
    func insert(value: Value?, for key: String)
}

protocol ImageCacheProtocol: CacheProtocol where Value == UIImage {}

actor ImageInMemoryCache: ImageCacheProtocol {
    
    private var imageCache: [String: UIImage] = [:]
    
    func value(for key: String) -> UIImage? {
        return imageCache[key]
    }
    
    func insert(value: UIImage?, for key: String) {
        guard let value else {
            imageCache[key] = nil
//            print("[ImageInMemoryCache]: Image cleared.")
            return
        }
        imageCache[key] = value
//        print("[ImageInMemoryCache]: Image inserted in cache.")
    }
}

actor ImageCacher: ImageCacheProtocol {
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    init(limitItemCount: Int = 100, limitItemSize: Int = 50 * 1024 * 1024) {
        imageCache.countLimit = limitItemSize
        imageCache.totalCostLimit = limitItemSize
    }
    
    func value(for key: String) -> UIImage? {
        let nsKey = NSString(string: key)
        guard let cached = imageCache.object(forKey: nsKey) else { return nil }
        print("[ImageCacher]: Return cached image for key: \(nsKey)")
        return cached
    }
    
    func insert(value: UIImage?, for key: String) {
        let nsKey = NSString(string: key)
        guard let value else {
            print("[ImageCacher]: Remove object for key: \(nsKey)")
            imageCache.removeObject(forKey: nsKey)
            return
        }
        print("[ImageCacher]: Insert object for key: \(nsKey)")
        let cost = value.pngData()?.count ?? 1
        imageCache.setObject(value, forKey: nsKey, cost: cost)
    }
}
