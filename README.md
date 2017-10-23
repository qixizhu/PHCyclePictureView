# PHCyclePictureView

[![CI Status](http://img.shields.io/travis/qixizhu/PHCyclePictureView.svg?style=flat)](https://travis-ci.org/qixizhu/PHCyclePictureView)
[![CI Status](https://img.shields.io/badge/Swift-3.1-orange.svg)](https://swift.org/)
[![CI Status](https://img.shields.io/badge/Swift-4.0-orange.svg)](https://swift.org/)
[![Version](https://img.shields.io/cocoapods/v/PHCyclePictureView.svg?style=flat)](http://cocoapods.org/pods/PHCyclePictureView)
[![License](https://img.shields.io/cocoapods/l/PHCyclePictureView.svg?style=flat)](http://cocoapods.org/pods/PHCyclePictureView)
[![Platform](https://img.shields.io/cocoapods/p/PHCyclePictureView.svg?style=flat)](http://cocoapods.org/pods/PHCyclePictureView)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

![img](https://github.com/qixizhu/PHCyclePictureView/blob/master/ScreenShots/1.gif)

```swift
let images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
"http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
"http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
"http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
"http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
let titles = ["标题一", "标题二", "标题三", "标题四", "标题五"]

cyclePictureView = PHCyclePictureView()
let cyclePVFrame = CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width * 0.512)
cyclePictureView.frame = cyclePVFrame
cyclePictureView.pageControlPosition = .right
cyclePictureView.imageURLStrings = images
cyclePictureView.imageTitles = titles
view.addSubview(cyclePictureView)
```

### PHCyclePictureViewDelegate
```swift
cyclePictureView.delegate = self

extension ViewController: PHCyclePictureViewDelegate {
func cyclePictureView(_ cyclePictureView: PHCyclePictureView, didTapItemAt index: Int) {
print("点击了第\(index + 1)张图片")
}
}
```

## Requirements
* Xcode 8 +
* iOS 8 +
* Swift 3 +

## Installation
### CocoaPods
PHCyclePictureView is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

Swift 4:
```ruby
pod 'PHCyclePictureView'
```
Swift 3:
```ruby
pod 'PHCyclePictureView', '0.2.2'
```

## Thanks
[航歌-做最好的开发者知识平台](http://www.hangge.com/)，[Swift - 图片循环轮播组件的实现（附样例）](http://www.hangge.com/blog/cache/detail_1314.html)

[走心的 Swift 翻译组](http://swift.gg/)，[基于 Swift 创建 CocoaPods 完全指南](http://www.swift.gg/2016/12/15/cocoapods-making-guide/)

@[roshanman](https://github.com/roshanman)

## Author

qixizhu, hanqi_ah@163.com

## License

PHCyclePictureView is available under the MIT license. See the LICENSE file for more info.
