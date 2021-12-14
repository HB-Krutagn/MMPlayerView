//
//  MMPlayerCache.swift
//  Pods
//
//  Created by Millman YANG on 2017/6/20.
//
//

import UIKit
import AVFoundation
class MMPlayerCache: NSObject {
    
    var cacheCount = 20
    private var cache = [URL : AVPlayerItem]()
    private var queueURL = [URL]()
    
    func appendCache(key: URL , item: AVPlayerItem) {
        if cache.keys.count >= cacheCount {
            if let f = queueURL.first {
                self.removeCache(key: f)
            }
        } else if !cache.keys.contains(key) {
            queueURL.append(key)
            cache[key] = item
        } else {
            queueURL.append(key)
            cache[key] = item
        }
    }
    
    func getItem(key: URL) -> AVPlayerItem? {
//         if #available(iOS 15, *) {
//             return nil
//         }
        return cache[key]
    }
    
    func removeCache(key: URL) {
        if cache.keys.count >= cacheCount {
            if let idx = queueURL.firstIndex(of: key) {
                queueURL.remove(at: idx)
            }
            cache.removeValue(forKey: key)
        }
    }
    
    func removeAll() {
        queueURL.removeAll()
        cache.removeAll()
    }
}
