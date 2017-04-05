//
//  PHCyclePictureHelper.swift
//  PHCyclePictureView
//
//  Created by Master on 2017/4/5.
//  Copyright © 2017年 pighome. All rights reserved.
//

import Foundation

//========================================================
// MARK: - 图片类型处理
//========================================================
enum PHCycleImageSource {
    case local(name: String)
    case network(urlString: String)
}

enum PHCycleImageType {
    case local
    case network
}

struct PHCycleImageBox {
    private(set) var imageType: PHCycleImageType
    private(set) var imageArray: [PHCycleImageSource]
    
    init(imageType type: PHCycleImageType, imageStringArray images: [String]) {
        self.imageType = type
        self.imageArray = []
        
        switch type {
        case .local:
            for str in images {
                self.imageArray.append(PHCycleImageSource.local(name: str))
            }
        case .network:
            for str in images {
                self.imageArray.append(PHCycleImageSource.network(urlString: str))
            }
        }
    }
    
    subscript (index: Int) -> PHCycleImageSource {
        get {
            return self.imageArray[index]
        }
    }
}
