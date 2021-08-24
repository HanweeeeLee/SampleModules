//
//  TestViewController1.swift
//  TabAndOthersTest
//
//  Created by hanwe lee on 2021/08/24.
//

import UIKit

class TestViewController1: UIViewController {

    var flag: Bool = true {
        didSet {
            if self.flag {
                setTabBarHidden(false)
            } else {
                setTabBarHidden(true)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "1"
    }

    @IBAction func testAction(_ sender: Any) {
        self.flag = !self.flag
    }
}

extension UIViewController {

    func setTabBarHidden(_ hidden: Bool, animated: Bool = true, duration: TimeInterval = 0.3) {
        if animated {
            if let frame = self.tabBarController?.tabBar.frame {
                let factor: CGFloat = hidden ? 1 : -1
                let y = frame.origin.y + (frame.size.height * factor)
                UIView.animate(withDuration: duration, animations: {
                    self.tabBarController?.tabBar.frame = CGRect(x: frame.origin.x, y: y, width: frame.width, height: frame.height)
                })
                return
            }
        }
        self.tabBarController?.tabBar.isHidden = hidden
    }

}


private var isHideTabBarFlagObjectKey: Bool?

protocol HideTabbarProtocol where Self: UIViewController {
    func hideTabbar()
    func showTabbar()
}

extension HideTabbarProtocol {
    private var isHideTabbar: Bool {
        get {
            var isHide = objc_getAssociatedObject(self, &isHideTabBarFlagObjectKey) as? Bool
            if isHide == nil {
                self.isHideTabbar = false
                isHide = self.isHideTabbar
            }
            return isHide!
        }
        set {
            objc_setAssociatedObject(self, &isHideTabBarFlagObjectKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)
        }
    }
    
    func hideTabbar() {
        if !self.isHideTabbar {
            self.isHideTabbar = true
            setTabBarHidden(true)
        }
    }
    
    func showTabbar() {
        if self.isHideTabbar {
            self.isHideTabbar = false
            setTabBarHidden(false)
        }
    }
}
