//
//  ViewController.swift
//  PHCyclePictureView
//
//  Created by qixizhu on 10/19/2017.
//  Copyright (c) 2017 qixizhu. All rights reserved.
//

import UIKit
import PHCyclePictureView

class ViewController: UIViewController {
    @IBOutlet weak var cyclePictureView: PHCyclePictureView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
                      "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                      "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                      "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
                      "http://imgsrc.baidu.com/forum/w%3D580/sign=4e0ee1bcd2c8a786be2a4a065709c9c7/bc71953eb13533fae99ad268abd3fd1f40345bf5.jpg"]
        let titles = ["标题一", "标题二", "标题三", "标题四", "标题五"]
        
        cyclePictureView.placeholderImage = #imageLiteral(resourceName: "loading")
        cyclePictureView.pageControlPosition = .left
        cyclePictureView.imagePaths = images
        cyclePictureView.imageTitles = titles
        // 底部容器的背景颜色
        //        cyclePictureView.anchorBackgroundColor = .clear
        cyclePictureView.delegate = self
        view.addSubview(cyclePictureView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        let cyclePVFrame = CGRect(
//            x: 0,
//            y: 64,
//            width: view.bounds.width,
//            height: view.bounds.width * 0.512
//        )
//        cyclePictureView.frame = cyclePVFrame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ViewController: PHCyclePictureViewDelegate {
    func cyclePictureView(_ cyclePictureView: PHCyclePictureView, didTapItemAt index: Int) {
        print("<#T##items: Any...##Any#>")
    }
}

