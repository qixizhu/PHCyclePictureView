#
# Be sure to run `pod lib lint PHCyclePictureView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PHCyclePictureView'
  s.version          = '1.0.2'
  s.summary          = '图片轮播器'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
循环播放本地或网络图片，可定制一些样式，比如自动播放，自动播放的时间间隔；图片占位图等。
                       DESC

  s.homepage         = 'https://github.com/qixizhu/PHCyclePictureView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qixizhu' => 'hanqi_ah@163.com' }
  s.source           = { :git => 'https://github.com/qixizhu/PHCyclePictureView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'PHCyclePictureView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'PHCyclePictureView' => ['PHCyclePictureView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Kingfisher'
end
