//
//  PHCyclePictureView.swift
//  PHCyclePictureView
//
//  Created by qixizhu on 2017/10/19.
//  Copyright © 2017年 PigHome. All rights reserved.
//

import UIKit

public enum PHPageControlPosition {
    case left, center, right
}

open class PHCyclePictureView: UIView {
    weak open var delegate: PHCyclePictureViewDelegate?
    
    // MARK: - 内部属性
    /// 图片视图容器
    fileprivate let scrollView = UIScrollView()
    /// 左侧图片视图
    fileprivate let leftImageView = PHCPImageView()
    /// 中间图片视图
    fileprivate var centerImageView = PHCPImageView()
    /// 右侧图片视图
    fileprivate var rightImageView = PHCPImageView()
    /// 下方容器视图
    fileprivate let anchorView =  UIView()
    /// 页码指示器
    fileprivate let pageControl = UIPageControl()
    /// 标题文本框
    fileprivate let titleLabel = UILabel()
    /// 定时器
    fileprivate var timer: Timer?
    
    /// 当前展示的图片索引
    fileprivate var currentIndex: Int = 0
    fileprivate var viewWith: CGFloat = 0
    fileprivate var viewHeight: CGFloat = 0
    
    /// 存放图片名称的数组
    open var imagePaths: [String] = [] {
        didSet {
            configurationImagePaths()
        }
    }
    /// 图片对应的描述文字
    open var imageTitles: [String] = []

    //========================================================
    // MARK: -- 自定义样式接口
    //========================================================
    /// 下方指示条的背景颜色
    open var anchorBackgroundColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            anchorView.backgroundColor = anchorBackgroundColor
        }
    }
    /// 是否显示页码指示器
    open var isShowPageControl = true {
        didSet {
            pageControl.isHidden = !isShowPageControl
        }
    }
    /// 页码指示器的位置
    open var pageControlPosition: PHPageControlPosition = .center {
        didSet {
            updatePageControlFrame()
        }
    }
    /// 页码指示器的默认颜色
    open var dotColor = UIColor.white {
        didSet {
            pageControl.pageIndicatorTintColor = dotColor
        }
    }
    /// 页码指示器的当前颜色
    open var currentDotColor = UIColor.red {
        didSet {
            pageControl.currentPageIndicatorTintColor = currentDotColor
        }
    }
    /// 图片内容模式
    open var pictureContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            leftImageView.contentMode   = pictureContentMode
            centerImageView.contentMode = pictureContentMode
            rightImageView.contentMode  = pictureContentMode
        }
    }
    /// 占位图片，当图片不能显示时显示的图片
    open var placeholderImage: UIImage? {
        didSet {
            leftImageView.placeholderImage   = placeholderImage
            centerImageView.placeholderImage = placeholderImage
            rightImageView.placeholderImage  = placeholderImage
        }
    }
    open var titleLabelFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            titleLabel.font = titleLabelFont
        }
    }
    open var titleLabelTextColor: UIColor = .white {
        didSet {
            titleLabel.textColor = titleLabelTextColor
        }
    }
    
    //========================================================
    // MARK: -- 滚动控制接口
    //========================================================
    /// 是否自动滚动，默认 true
    open var isAutoScroll = true {
        didSet {
            self.timer?.invalidate() //先取消先前定时器
            if isAutoScroll {
                setupTimer()   //重新设置定时器
            }
        }
    }
    /// 是否允许 scrollView 拖动
    open var isScrollEnabled = true {
        didSet {
            scrollView.isScrollEnabled = isScrollEnabled
        }
    }
    /// 开启自动滚动后，自动翻页的时间，默认 5 秒
    open var scrollTimeInterval: TimeInterval = 5.0 {
        didSet {
            if isAutoScroll {
                setupTimer()   //重新设置定时器
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
}
// MARK: - 初始化及配置
extension PHCyclePictureView {
    fileprivate func commonInit() {
        // 1. 视图容器
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(scrollView)
        
        // 2.三个图片视图
        leftImageView.placeholderImage = placeholderImage
        leftImageView.contentMode = pictureContentMode
        leftImageView.clipsToBounds = true
        centerImageView.placeholderImage = placeholderImage
        centerImageView.contentMode = pictureContentMode
        centerImageView.clipsToBounds = true
        rightImageView.placeholderImage = placeholderImage
        rightImageView.contentMode = pictureContentMode
        rightImageView.clipsToBounds = true
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(centerImageView)
        scrollView.addSubview(rightImageView)
        
        /// 给中间的图片视图添加单击手势
        centerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(PHCyclePictureView.tapBanner)
        )
        centerImageView.addGestureRecognizer(tap)
        
        // 3.下方视图
        anchorView.backgroundColor = anchorBackgroundColor
        addSubview(anchorView)
        
        // 4.页码指示器
        pageControl.isHidden = !isShowPageControl
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = currentDotColor
        pageControl.pageIndicatorTintColor = dotColor
        pageControl.isUserInteractionEnabled = false
        anchorView.addSubview(pageControl)
        
        // 5.页码指示器
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelTextColor
        anchorView.addSubview(titleLabel)
    }
    
    open override func layoutSubviews() {
        viewWith = bounds.width
        viewHeight = bounds.height
        
        scrollView.frame = bounds
        scrollView.contentSize = CGSize(width: 3 * viewWith, height: viewHeight)
        // 滚动视图内容区域向左偏移一个 view 的宽度
        scrollView.contentOffset = CGPoint(x: viewWith, y: 0)
        
        leftImageView.frame = CGRect(x: 0, y: 0, width: viewWith, height: viewHeight)
        centerImageView.frame = CGRect(x: viewWith, y: 0, width: viewWith, height: viewHeight)
        rightImageView.frame = CGRect(x: 2 * viewWith, y: 0, width: viewWith, height: viewHeight)
        
        anchorView.frame = CGRect(
            x: 0,
            y: bounds.height - 30,
            width: bounds.width,
            height: 30
        )
        
        updatePageControlFrame()
    }
    
    fileprivate func updatePageControlFrame() {
        switch pageControlPosition {
        case .center:
            let pageW: CGFloat = CGFloat(pageControl.numberOfPages * 15)
            let pageH: CGFloat = 20
            let pageX = (bounds.width - pageW) / 2
            let pageY = (30 - pageH) / 2
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            
            let titleX: CGFloat = 16
            let titleY: CGFloat = 0
            let titleW: CGFloat = bounds.width - 32
            let titleH: CGFloat = 30
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        case .left:
            let pageW: CGFloat = CGFloat(pageControl.numberOfPages * 15)
            let pageH: CGFloat = 20
            let pageX: CGFloat = 16
            let pageY = (30 - pageH) / 2
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            
            let titleX: CGFloat = pageX + pageW + 16
            let titleY: CGFloat = 0
            let titleW: CGFloat = bounds.width - titleX - 16
            let titleH: CGFloat = 30
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        case .right:
            let pageW: CGFloat = CGFloat(pageControl.numberOfPages * 15)
            let pageH: CGFloat = 20
            let pageX = bounds.width - pageW - 16
            let pageY = (30 - pageH) / 2
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            
            let titleX: CGFloat = 16
            let titleY: CGFloat = 0
            let titleW: CGFloat = bounds.width - (titleX + pageW)
            let titleH: CGFloat = 30
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
    }
    
    fileprivate func configurationImagePaths() {
        pageControl.numberOfPages = imagePaths.count
        
        if imagePaths.count == 0 || imagePaths.count == 1 {
            self.isAutoScroll = false
            self.isScrollEnabled = false
        }
        
        if isAutoScroll && timer == nil {
            setupTimer()
        }
    }
    
    fileprivate func resetImageViewSource() {
        guard imagePaths.count > 0 else { return }
        
        // 当前显示的是第一张图片
        if self.currentIndex == 0 {
            leftImageView.imagePath = imagePaths.last
            centerImageView.imagePath = imagePaths.first
            let rightImgaeIndex = imagePaths.count > 1 ? 1 : 0 //保护
            rightImageView.imagePath  = imagePaths[rightImgaeIndex]
        }//当前显示的是最后一张图片
        else if self.currentIndex == imagePaths.count - 1 {
            leftImageView.imagePath   = imagePaths[currentIndex - 1]
            centerImageView.imagePath = imagePaths.last
            rightImageView.imagePath  = imagePaths.first
        }//其他情况
        else{
            leftImageView.imagePath   = imagePaths[currentIndex - 1]
            centerImageView.imagePath = imagePaths[currentIndex]
            rightImageView.imagePath  = imagePaths[currentIndex + 1]
        }
    }
}

// MARK: - Timer
extension PHCyclePictureView {
    /// 设置定时器
    fileprivate func setupTimer() {
        let timer = Timer(
            timeInterval: scrollTimeInterval,
            target: self,
            selector: #selector(PHCyclePictureView.nextPage),
            userInfo: nil,
            repeats: true
        )
        RunLoop.main.add(timer, forMode: .commonModes)
        self.timer = timer
    }
    
    /// 移除定时器
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 下一页
    @objc fileprivate func nextPage() {
        let offset = CGPoint(x: 2 * self.bounds.size.width, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
}

// MARK: - Actions
extension PHCyclePictureView {
    @objc fileprivate func tapBanner() {
        delegate?.cyclePictureView?(self, didTapItemAt: currentIndex)
    }
}

// MARK: - UIScrollViewDelegate
extension PHCyclePictureView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        let count = imagePaths.count
        
        if offset >= 2 * viewWith {
            // 还原偏移量
            scrollView.contentOffset = CGPoint(x: viewWith, y: 0)
            
            // 视图索引 +1
            currentIndex += 1
            
            if currentIndex == count {
                currentIndex = 0
            }
        }
        
        // 如果向右滑动(显示上一张)
        if offset <= 0 {
            // 还原偏移量
            scrollView.contentOffset = CGPoint(x: viewWith, y: 0)
            // 视图索引 -1
            currentIndex -= 1
            
            if currentIndex == -1 {
                currentIndex = count - 1
            }
        }
        
        resetImageViewSource()
        
        // 设置页控制器当前页码
        pageControl.currentPage = currentIndex
        
        // 设置 Title
        guard imageTitles.count > 0 else { return }
        
        if imageTitles.count < imagePaths.count {
            for _ in 0..<(imagePaths.count - imageTitles.count) {
                imageTitles += [""]
            }
        }
        titleLabel.text = imageTitles[currentIndex]
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard imagePaths.count > 1 else { return }
        setupTimer()
    }
}

// MARK: - PHCyclePictureViewDelegate
@objc public protocol PHCyclePictureViewDelegate: NSObjectProtocol {
    @objc optional func cyclePictureView(_ cyclePictureView: PHCyclePictureView, didTapItemAt index: Int)
}
