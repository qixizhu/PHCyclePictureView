# PHCyclePictureView
图片轮播器，可循环播放本地图片或网络图片。可以定制是否自动播放，自动播放时间间隔，图片占位图片等。

![Screenshot]()

## Installation

[CocoaPods](https://cocoapods.org/) is the recommended method of installing `PHCyclePictureView`. Simply add the following line to your `Podfile`:

```ruby
# Podfile

pod 'PHCyclePictureView'
```

## Usage

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

iOS 9 or higher

## Author

qixizhu, hanqi_ah@163.com

## License

CopyableLabel is available under the MIT license. See the LICENSE file for more info.
