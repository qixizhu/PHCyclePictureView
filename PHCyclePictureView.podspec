#
#  Be sure to run `pod spec lint PHCyclePictureView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  
  s.name         = "PHCyclePictureView"
  s.version      = "0.1.1"
  s.summary      = "图片轮播器"

  s.description  = <<-DESC
  循环播放本地或网络图片，可定制一些样式，比如自动播放，自动播放的时间间隔；图片占位图等。
                   DESC

  s.homepage     = "https://github.com/qixizhu/PHCyclePictureView"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "qixizhu" => "hanqi_ah@163.com" }

  s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  s.ios.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/qixizhu/PHCyclePictureView.git", :tag => "#{s.version}" }

  s.source_files  = "PHCyclePictureView/Sources/**/*"

end
