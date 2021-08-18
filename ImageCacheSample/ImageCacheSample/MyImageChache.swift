//
//  MyImageChache.swift
//  ImageCacheSample
//
//  Created by hanwe lee on 2021/08/18.
//

import UIKit

extension UIImageView {
    
    func myImageCacheSetImage(url: String, placeholderImage: UIImage?, completion: (() -> Void)?) {
        
        if let placeholderImage = placeholderImage {
            self.image = placeholderImage
        }
        
        let cacheManager = ImageCacheManager.shared
        cacheManager.setImage(imageView: self, url: url, completion: completion)
    }
    
}

fileprivate class ImageCacheManager: NSObject {
    
    static let shared: ImageCacheManager = {
        let instance = ImageCacheManager()
        return instance
    }()
    
    private let cache = NSCache<NSString, UIImage>()
    private var isDownloadingPool: Set<String> = []
    private var isWatingImageViewPool: [String: [MyImageObject]] = [:]
    
    private struct MyImageObject {
        weak var imageView: UIImageView?
        var completion: (() -> Void)?
    }
    
    // MARK: internal function
    
    func setImage(imageView: UIImageView?, url: String, completion: (() -> Void)?) {
        DispatchQueue.global(qos: .default).async {
            if let cachedImage = self.cache.object(forKey: url as NSString) {
                DispatchQueue.main.async {
                    imageView?.image = cachedImage
                    completion?()
                }
            } else {
                if self.isDownloadingPool.contains(url) { // 이미 다운로드 중
                    self.isWatingImageViewPool[url]?.append(MyImageObject(imageView: imageView, completion: completion))
                } else { // 다운로드 받고있지 않다.
                    self.isDownloadingPool.insert(url)
                    self.isWatingImageViewPool[url] = [MyImageObject]()
                    self.isWatingImageViewPool[url]?.append(MyImageObject(imageView: imageView, completion: completion))
                    if let imageUrl = URL(string: url) {
                        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
                            guard let data = data else { return }
                            if error != nil {
                                self.isWatingImageViewPool[url] = nil
                                self.isDownloadingPool.remove(url)
                                return
                            }
                            if let image = UIImage(data: data) {
                                DispatchQueue.main.async {
                                    ImageCacheManager.shared.cache.setObject(image, forKey: url as NSString)
                                    guard let pool = self.isWatingImageViewPool[url] else { self.isDownloadingPool.remove(url) ; return }
                                    self.isWatingImageViewPool[url] = nil
                                    for item in pool {
                                        item.imageView?.image = image
                                        item.completion?()
                                    }
                                    self.isDownloadingPool.remove(url)
                                }
                            }
                        }.resume()
                    } else {
                        self.isWatingImageViewPool[url] = nil
                        self.isDownloadingPool.remove(url)
                    }
                }
            }
        }
    }
    
}
