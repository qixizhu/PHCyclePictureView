//
//  PHCycleImageView.swift
//  PHCyclePictureView
//
//  Created by Master on 2017/4/5.
//  Copyright © 2017年 pighome. All rights reserved.
//

import UIKit

class PHCycleImageView: UIImageView {

    private struct Constants {
        static let defaultPlaceholderImageTextFont = UIFont.systemFont(ofSize: 14.0)
    }
    
    // MARK: - 属性
    /// 数据源
    var imageSource: PHCycleImageSource? {
        didSet {
            updateImage()
        }
    }
    /// 占位图片
    var placeholderImage: UIImage = UIImage(text: NSLocalizedString("Loading", comment: "图片加载中..."), font: Constants.defaultPlaceholderImageTextFont, backgroundColor: .black)! {
        didSet {
            updateImage()
        }
    }
    
    // MARK: - 内部属性
    
    /// 设置图片
    private func updateImage() {
        guard let imageSource = self.imageSource else { return }
        
        switch imageSource {
        case let .local(name: name):
            image = UIImage(named: name)
        case let .network(urlString: urlString):
            let encodeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            imageFromURL(encodeString, placeholder: placeholderImage)
        }
    }

}
