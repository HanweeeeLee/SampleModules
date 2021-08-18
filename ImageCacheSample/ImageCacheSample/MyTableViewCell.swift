//
//  MyTableViewCell.swift
//  ImageCacheSample
//
//  Created by hanwe lee on 2021/08/18.
//

import UIKit

class MyTableViewCell: UITableViewCell {

    @IBOutlet weak var myImageView: UIImageView!
    
    var imageUrl: String? = nil {
        didSet {
            guard let url = imageUrl else { return }
            self.myImageView.myImageCacheSetImage(url: url, placeholderImage: UIImage(named: "cat"), completion: {
                print("얍")
                self.myImageView.fadeInTransition(0.5)
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}

extension UIView {
    
    func fadeInTransition(_ duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
       // animation.subtype = CATransitionSubtype.fromTop
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
