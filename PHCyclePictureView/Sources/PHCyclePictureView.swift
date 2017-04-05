//
//  PHCyclePictureView.swift
//  PHCyclePictureView
//
//  Created by Master on 2017/4/5.
//  Copyright © 2017年 pighome. All rights reserved.
//

import UIKit

public enum PHPageControlPosition {
    case center, right, left
}

open class PHCyclePictureView: UIView {
    
    private struct Constants {
        static let defaultPlaceholderImageTextFont = UIFont.systemFont(ofSize: 14.0)
        static let defaultPlaceholderImage: UIImage = {
            let text = NSLocalizedString("Loading", comment: "图片加载中...")
            let placeholderImage = UIImage(text: text, font: defaultPlaceholderImageTextFont, color: .white, backgroundColor: .black)
            
            return placeholderImage!
        }()
    }
    
    // MARK: - 数据源
    
    /// 存放本地图片名称的数组
    open var imageNames: [String] = [] {
        didSet {
            configurationLoaclImageNames()
        }
    }
    /// 存放网络图片地址字符串的数组
    open var imageURLStrings: [String] = [] {
        didSet {
            configurationImageURLStrings()
        }
    }
    /// 图片对应的描述文字
    open var imageTitles: [String] = []
    
    // MARK: - 对外接口属性
    
    weak open var dataSource: PHCyclePictureViewDataSource?
    weak open var delegate: PHCyclePictureViewDelegate?
    
    //========================================================
    // MARK: -- 自定义样式接口
    //========================================================
    /// 下方指示条的背景颜色
    open var anchorBackgroundColor: UIColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.2) {
        didSet {
            anchorView.backgroundColor = anchorBackgroundColor
        }
    }
    
    /// 是否显示页码指示器
    open var isShowPageControl = true {
        didSet {
            self.pageControl.isHidden = !isShowPageControl
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
            self.pageControl.pageIndicatorTintColor = dotColor
        }
    }
    /// 页码指示器的当前颜色
    open var currentDotColor = UIColor.red {
        didSet {
            self.pageControl.currentPageIndicatorTintColor = currentDotColor
        }
    }
    open var pictureContentMode: UIViewContentMode = .scaleAspectFill {
        didSet {
            leftImageView.contentMode   = pictureContentMode
            centerImageView.contentMode = pictureContentMode
            rightImageView.contentMode  = pictureContentMode
        }
    }
    
    /// 占位图片，当图片不能显示时显示的图片
    open var placeholderImage: UIImage = Constants.defaultPlaceholderImage {
        didSet {
            leftImageView.placeholderImage   = placeholderImage
            centerImageView.placeholderImage = placeholderImage
            rightImageView.placeholderImage  = placeholderImage
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
                self.setupTimer()   //重新设置定时器
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
                self.setupTimer()   //重新设置定时器
            }
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
    
    // MARK: - 内部属性
    /// 当前展示的图片索引
    fileprivate var currentIndex: Int = 0
    /// 图片视图容器
    fileprivate var scrollView: UIScrollView!
    /// 左侧图片视图
    fileprivate var leftImageView: PHCycleImageView!
    /// 中间图片视图
    fileprivate var centerImageView: PHCycleImageView!
    /// 右侧图片视图
    fileprivate var rightImageView: PHCycleImageView!
    /// 下方容器视图
    fileprivate var anchorView: UIView!
    /// 标题文本框
    fileprivate var titleLabel: UILabel!
    /// 定时器
    fileprivate var timer: Timer?
    /// 页码指示器
    fileprivate var pageControl: UIPageControl!
    
    fileprivate var viewWith: CGFloat = 0
    fileprivate var viewHeight: CGFloat = 0
    /// 存储封装数据
    fileprivate var imageBox: PHCycleImageBox?
    
    // MARK: - 初始化方法
    
    /// 传入一个 frame 时调用该方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    /// 用于 Interface Builder，暂时不实现
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 公共初始化
    private func commonInit() {
        // 1. 视图容器
        scrollView = UIScrollView()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.bounces = false
        scrollView.isScrollEnabled = isScrollEnabled
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        addSubview(scrollView)
        
        // 2.三个图片视图
        leftImageView = PHCycleImageView()
        leftImageView.contentMode = pictureContentMode
        leftImageView.clipsToBounds = true
        centerImageView = PHCycleImageView()
        centerImageView.contentMode = pictureContentMode
        centerImageView.clipsToBounds = true
        rightImageView = PHCycleImageView()
        rightImageView.contentMode = pictureContentMode
        rightImageView.clipsToBounds = true
        scrollView.addSubview(leftImageView)
        scrollView.addSubview(centerImageView)
        scrollView.addSubview(rightImageView)
        
        centerImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(PHCyclePictureView.tapBanner))
        centerImageView.addGestureRecognizer(tap)
        
        // 3.下方视图
        anchorView = UIView()
        anchorView.backgroundColor = anchorBackgroundColor
        addSubview(anchorView)
        
        pageControl = UIPageControl()
        pageControl.isHidden = !isShowPageControl
        pageControl.hidesForSinglePage = true
        pageControl.currentPageIndicatorTintColor = self.currentDotColor
        pageControl.pageIndicatorTintColor = self.dotColor
        pageControl.isUserInteractionEnabled = false
        anchorView.addSubview(pageControl)
        
        titleLabel = UILabel()
        titleLabel.font = titleLabelFont
        titleLabel.textColor = titleLabelTextColor
        anchorView.addSubview(titleLabel)
        
        
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        self.viewWith  = self.bounds.size.width
        self.viewHeight = self.bounds.size.height
        
        self.scrollView.frame = self.bounds
        self.scrollView.contentSize = CGSize(width: 3 * viewWith, height: viewHeight)
        // 滚动视图内容区域向左偏移一个 view 的宽度
        self.scrollView.contentOffset = CGPoint(x: viewWith, y: 0)
        
        leftImageView.frame = CGRect(x: 0, y: 0, width: viewWith, height: viewHeight)
        centerImageView.frame = CGRect(x: viewWith, y: 0, width: viewWith, height: viewHeight)
        rightImageView.frame = CGRect(x: 2 * viewWith, y: 0, width: viewWith, height: viewHeight)
        
        anchorView.frame = CGRect(x: 0, y: self.bounds.size.height - 30, width: self.bounds.size.width, height: 30)
        
        updatePageControlFrame()
        
        // 处理默认占位图片
        placeholderImage = UIImage(text: NSLocalizedString("Loading", comment: "图片加载中..."), font: Constants.defaultPlaceholderImageTextFont, backgroundColor: .black, size: CGSize(width: viewWith, height: viewHeight))!
    }
    
    func updatePageControlFrame() {
        switch self.pageControlPosition {
        case .center:
            let pageW: CGFloat = CGFloat(pageControl.numberOfPages * 15)
            let pageH: CGFloat = 20
            let pageX = (self.bounds.size.width - pageW) / 2
            let pageY = (30 - pageH) / 2
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            
            let titleX: CGFloat = 16
            let titleY: CGFloat = 0
            let titleW: CGFloat = self.bounds.size.width - 32
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
            let titleW: CGFloat = self.bounds.size.width - titleX - 16
            let titleH: CGFloat = 30
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        case .right:
            let pageW: CGFloat = CGFloat(pageControl.numberOfPages * 15)
            let pageH: CGFloat = 20
            let pageX = self.bounds.size.width - pageW - 16
            let pageY = (30 - pageH) / 2
            pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
            
            let titleX: CGFloat = 16
            let titleY: CGFloat = 0
            let titleW: CGFloat = self.bounds.size.width - (titleX + pageW)
            let titleH: CGFloat = 30
            titleLabel.frame = CGRect(x: titleX, y: titleY, width: titleW, height: titleH)
        }
    }
    
    private func configurationLoaclImageNames() {
        self.imageBox = PHCycleImageBox(imageType: .local, imageStringArray: self.imageNames)
        pageControl.numberOfPages = self.imageBox!.imageArray.count
        
        if imageNames.count == 0 || imageNames.count == 1 {
            self.isAutoScroll = false
            self.isScrollEnabled = false
        }
        
        if isAutoScroll && timer == nil {
            setupTimer()
        }
    }
    
    private func configurationImageURLStrings() {
        self.imageBox = PHCycleImageBox(imageType: .network, imageStringArray: self.imageURLStrings)
        pageControl.numberOfPages = self.imageBox!.imageArray.count
        
        for (index, _) in self.imageNames.enumerated() {
            imageTitles[index] = ""
        }
        
        if imageURLStrings.count == 0 || imageURLStrings.count == 1 {
            self.isAutoScroll = false
            self.isScrollEnabled = false
        }
        
        if isAutoScroll && timer == nil {
            setupTimer()
        }
    }
    
    fileprivate func resetImageViewSource() {
        guard let imageBox = self.imageBox else { return }
        
        // 当前显示的是第一张图片
        if self.currentIndex == 0 {
            leftImageView.imageSource   = imageBox.imageArray.last!
            centerImageView.imageSource = imageBox.imageArray.first!
            let rightImgaeIndex = imageBox.imageArray.count > 1 ? 1 : 0 //保护
            rightImageView.imageSource  = imageBox.imageArray[rightImgaeIndex]
        }//当前显示的是最后一张图片
        else if self.currentIndex == imageBox.imageArray.count - 1 {
            leftImageView.imageSource   = imageBox.imageArray[self.currentIndex - 1]
            centerImageView.imageSource = imageBox.imageArray.last!
            rightImageView.imageSource  = imageBox.imageArray.first!
        }//其他情况
        else{
            leftImageView.imageSource   = imageBox.imageArray[self.currentIndex - 1]
            centerImageView.imageSource = imageBox.imageArray[self.currentIndex]
            rightImageView.imageSource  = imageBox.imageArray[self.currentIndex + 1]
        }
    }
    
    /// 点击事件
    @objc private func tapBanner() {
        delegate?.cyclePictureView!(self, didTapItemAt: self.currentIndex)
    }
    
    // MARK: - 定时器相关
    /// 设置定时器
    fileprivate func setupTimer() {
        let timer = Timer(timeInterval: scrollTimeInterval, target: self, selector: #selector(PHCyclePictureView.nextPage), userInfo: nil, repeats: true)
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

// MARK: - UIScrollViewDelegate
extension PHCyclePictureView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = self.scrollView.contentOffset.x
        
        guard let imageBox = self.imageBox else { return }
        let count = imageBox.imageArray.count
        
        if offset >= 2 * self.viewWith {
            // 还原偏移量
            scrollView.contentOffset = CGPoint(x: self.viewWith, y: 0)
            
            // 视图索引 +1
            self.currentIndex += 1
            
            if self.currentIndex == count {
                self.currentIndex = 0
            }
        }
        
        // 如果向右滑动(显示上一张)
        if offset <= 0 {
            // 还原偏移量
            scrollView.contentOffset = CGPoint(x: self.viewWith, y: 0)
            // 视图索引 -1
            self.currentIndex -= 1
            
            if self.currentIndex == -1 {
                self.currentIndex = count - 1
            }
        }
        
        resetImageViewSource()
        
        // 设置页控制器当前页码
        guard let pageControl = self.pageControl else { return }
        pageControl.currentPage = self.currentIndex
        
        // 设置 Title
        guard imageTitles.count > 0 else { return }
        
        if imageTitles.count < imageBox.imageArray.count {
            for _ in 0..<(imageBox.imageArray.count - imageTitles.count) {
                imageTitles += [""]
            }
        }
        titleLabel.text = imageTitles[self.currentIndex]
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let imageBox = imageBox else { return }
        
        guard imageBox.imageArray.count > 1 else { return }
        
        setupTimer()
    }
}

/// MARK: - PHCyclePictureViewDelegate
@objc public protocol PHCyclePictureViewDelegate: NSObjectProtocol {
    /// 当点击某个图片时调用的代理方法
    ///
    /// - Parameters:
    ///   - cyclePictureView: PHCyclePictureView
    ///   - index: 图片的索引
    @objc optional func cyclePictureView(_ cyclePictureView: PHCyclePictureView, didTapItemAt index: Int)
}

// MARK: - PHCyclePictureViewDataSource
@objc public protocol PHCyclePictureViewDataSource : NSObjectProtocol {
    @objc optional func numberOfItems(in cyclePictureView: PHCyclePictureView) -> Int
    @objc optional func cyclePictureView(_ cyclePictureView: PHCyclePictureView, titleForItemAt index: Int) -> UIImage
    @objc optional func cyclePictureView(_ cyclePictureView: PHCyclePictureView, titleForItemAt index: Int) -> String?
}
