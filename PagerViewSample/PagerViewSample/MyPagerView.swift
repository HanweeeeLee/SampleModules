//
//  MyPagerView.swift
//  PagerViewSample
//
//  Created by hanwe lee on 2021/08/18.
//

import UIKit

@objc protocol MyPagerViewDelegate: AnyObject {
    @objc optional func myPagerView(_ pagerView: MyPagerView, willScrolledButAlreadyFirstIndex: UInt)
    @objc optional func myPagerView(_ pagerView: MyPagerView, willScrolledButAlreadyLastIndex: UInt)
    @objc optional func myPagerView(_ pagerView: MyPagerView, willScrolledIndex: UInt)
    @objc optional func myPagerView(_ pagerView: MyPagerView, didScrolledIndex: UInt)
}

@objc protocol MyPagerViewDatasource: AnyObject {
    func myPagerView(_ pagerView: MyPagerView, numberOfItemsInSection section: Int) -> Int
    func myPagerView(_ pagerView: MyPagerView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
}

public struct SideEdgeInsets {
    let left: CGFloat
    let right: CGFloat
}

class MyPagerView: UIView {
    
    // MARK: private property
    
    private let flowLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: self.bounds, collectionViewLayout: self.flowLayout)
    
    private var numberOfItems: UInt = 0
    private var currentIndex: UInt = 0
    private var edgeInsets: SideEdgeInsets = .init(left: 0, right: 0)
    
    // MARK: public property
    
    public weak var dataSource: MyPagerViewDatasource?
    public weak var delegate: MyPagerViewDelegate?
    
    public var isScrollEnabled: Bool = true {
        didSet {
            self.collectionView.isScrollEnabled = self.isScrollEnabled
        }
    }
    
    public var showScrollIndicator: Bool = true {
        didSet {
            self.collectionView.showsHorizontalScrollIndicator = self.showScrollIndicator
        }
    }
    
    public var index: UInt {
        get {
            return self.currentIndex
        }
    }
    
    public var minimumLineSpacing: CGFloat = 0
    public var cellSizePercent: CGFloat = 1.0
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.cellSizePercent != 1 && self.edgeInsets.left == 0 {
            setInitialOffset()
        }
    }
    
    // MARK: private function
    
    private func initUI() {
        self.addSubview(self.collectionView)
        self.collectionView.backgroundColor = .clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        let constraint1 = NSLayoutConstraint(item: self.collectionView, attribute: .leading, relatedBy: .equal,
                                             toItem: self, attribute: .leading,
                                             multiplier: 1.0, constant: 0)

        let constraint2 = NSLayoutConstraint(item: self.collectionView, attribute: .trailing, relatedBy: .equal,
                                             toItem: self, attribute: .trailing,
                                             multiplier: 1.0, constant: 0)

        let constraint3 = NSLayoutConstraint(item: self.collectionView, attribute: .top, relatedBy: .equal,
                                             toItem: self, attribute: .top,
                                             multiplier: 1.0, constant: 0)

        let constraint4 = NSLayoutConstraint(item: self.collectionView, attribute: .bottom, relatedBy: .equal,
                                             toItem: self, attribute: .bottom,
                                             multiplier: 1.0, constant: 0)
        self.addConstraints([constraint1, constraint2, constraint3, constraint4])

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.isPagingEnabled = false
        self.flowLayout.scrollDirection = .horizontal
        self.collectionView.decelerationRate = .fast
    }
    
    private func setInitialOffset() {
        let percent: CGFloat = self.cellSizePercent > 1 ? 1 : self.cellSizePercent
        let some = ((1 - percent)/2) * self.bounds.width
        self.edgeInsets = .init(left: some, right: some)
    }
    
    // MARK: public function
    
    public func register(_ nib: UINib?, forCellWithReuseIdentifier identifier: String) {
        self.collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func reloadData() {
        self.collectionView.reloadData()
    }
    
    public func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell {
        return self.collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    
}

extension MyPagerView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.x > 0 { // 왼쪽으로 가기 (-)
            if self.currentIndex == 0 {
                self.delegate?.myPagerView?(self, willScrolledButAlreadyFirstIndex: 0)
            } else {
                self.delegate?.myPagerView?(self, willScrolledIndex: self.currentIndex - 1)
            }
        } else { // 오른쪽으로 가기 (+)
            if self.currentIndex == self.numberOfItems - 1 {
                self.delegate?.myPagerView?(self, willScrolledButAlreadyLastIndex: self.numberOfItems - 1)
            } else {
                self.delegate?.myPagerView?(self, willScrolledIndex: self.currentIndex + 1)
            }
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.x > 0 { // 왼쪽으로 가기 (-)
            if currentIndex != 0 {
                let totalCellMargins = CGFloat(currentIndex - 1) * minimumLineSpacing
                let percent: CGFloat = self.cellSizePercent > 1 ? 1 : self.cellSizePercent
                let totalCellWidths = CGFloat(currentIndex - 1) * (self.bounds.width * percent)
                targetContentOffset.pointee = CGPoint(x: totalCellMargins + totalCellWidths, y: -scrollView.contentInset.top)
                self.currentIndex -= 1
            }
            
        } else { // 오른쪽으로 가기 (+)
            if self.currentIndex != self.numberOfItems - 1 {
                let totalCellMargins = CGFloat(currentIndex + 1) * minimumLineSpacing
                let percent: CGFloat = self.cellSizePercent > 1 ? 1 : self.cellSizePercent
                let totalCellWidths = CGFloat(currentIndex + 1) * (self.bounds.width * percent)
                targetContentOffset.pointee = CGPoint(x: totalCellMargins + totalCellWidths, y: -scrollView.contentInset.top)
                self.currentIndex += 1
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let translation = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if translation.x > 0 { // 왼쪽으로 가기 (-)
            self.delegate?.myPagerView?(self, didScrolledIndex: self.currentIndex)
        } else { // 오른쪽으로 가기 (+)
            self.delegate?.myPagerView?(self, didScrolledIndex: self.currentIndex)
        }
    }
    
}

extension MyPagerView: UICollectionViewDataSource {
    
    func collectionView(_ pagerView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let ds = self.dataSource  else { return 0 }
        self.numberOfItems = UInt(ds.myPagerView(self, numberOfItemsInSection: section))
        return Int(self.numberOfItems)
    }
    
    func collectionView(_ pagerView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return self.dataSource!.myPagerView(self, cellForItemAt: indexPath)
    }
}

extension MyPagerView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 0, left: self.edgeInsets.left, bottom: 0, right: self.edgeInsets.right)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let percent: CGFloat = self.cellSizePercent > 1 ? 1 : self.cellSizePercent
        return CGSize(width: self.bounds.width * percent, height: self.bounds.height)
    }
    
}

