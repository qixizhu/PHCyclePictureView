//
//  ViewController.swift
//  PHCyclePictureView
//
//  Created by Master on 2017/4/5.
//  Copyright © 2017年 pighome. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var cyclePictureView: PHCyclePictureView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
                      "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                      "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                      "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
                      "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
        let titles = ["标题一", "标题二", "标题三", "标题四", "标题五"]
        
        cyclePictureView = PHCyclePictureView()
        let cyclePVFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.512)
        cyclePictureView.frame = cyclePVFrame
        cyclePictureView.pageControlPosition = .left
        cyclePictureView.imageURLStrings = images
        cyclePictureView.imageTitles = titles
        // 底部容器的背景颜色
//        cyclePictureView.anchorBackgroundColor = .clear
        cyclePictureView.delegate = self
        view.addSubview(cyclePictureView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

// MARK: - PHCyclePictureViewDelegate
extension ViewController: PHCyclePictureViewDelegate {
    func cyclePictureView(_ cyclePictureView: PHCyclePictureView, didTapItemAt index: Int) {
        print("点击了第\(index + 1)张图片")
    }
}
