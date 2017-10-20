//
//  PHCPImageView.swift
//  PHCyclePictureView
//
//  Created by qixizhu on 2017/10/19.
//  Copyright © 2017年 PigHome. All rights reserved.
//

import UIKit
import Kingfisher

class PHCPImageView: UIImageView {
    // MARK: - 属性
    var imagePath: String? {
        didSet {
            updateImage()
        }
    }
    /// 占位图片
    var placeholderImage: UIImage? {
        didSet {
            updateImage()
        }
    }
    
    // MARK: - 内部属性
    
    /// 设置图片
    private func updateImage() {
        guard let path = imagePath else {
            if let phImage = placeholderImage {
                image = phImage
            }
            return
        }
        
        if path.hasPrefix("http://") || path.hasPrefix("https://") {
            let imageURLOptional = URL(string: path)
            var imageResource: ImageResource?
            if let imageURL = imageURLOptional {
                imageResource = ImageResource(downloadURL: imageURL, cacheKey: path)
            } else {
                imageResource = nil
            }
            kf.setImage(with: imageResource, placeholder: placeholderImage)
        } else {
            image = UIImage(named: path)
        }
    }
}
