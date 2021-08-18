//
//  ViewController.swift
//  PagerViewSample
//
//  Created by hanwe lee on 2021/08/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pagerView: MyPagerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        self.pagerView.delegate = self
        self.pagerView.dataSource = self
        self.pagerView.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        self.pagerView.cellSizePercent = 0.9
        self.pagerView.minimumLineSpacing = 10
    }

}

extension ViewController: MyPagerViewDelegate {
    func myPagerView(_ pagerView: MyPagerView, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
    
    func myPagerView(_ pagerView: MyPagerView, didScrolledIndex: UInt) {
        print("didScrolledIndex: \(didScrolledIndex)")
    }
    
    func myPagerView(_ pagerView: MyPagerView, willScrolledIndex: UInt) {
        print("willScrolledIndex: \(willScrolledIndex)")
    }
    
    func myPagerView(_ pagerView: MyPagerView, willScrolledButAlreadyLastIndex: UInt) {
        print("!!")
    }
    
    func myPagerView(_ pagerView: MyPagerView, willScrolledButAlreadyFirstIndex: UInt) {
        print("??")
    }
    
    
    
}

extension ViewController: MyPagerViewDatasource {
    func myPagerView(_ collectionView: MyPagerView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func myPagerView(_ collectionView: MyPagerView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = pagerView.dequeueReusableCell(withReuseIdentifier: "MyCollectionViewCell", for: indexPath) as! MyCollectionViewCell
        if indexPath.item%2 == 0 {
            cell.mainContainerView.backgroundColor = .brown
        }
        else {
            cell.mainContainerView.backgroundColor = .darkGray
        }
        return cell
    }
    
    
    
    
}

