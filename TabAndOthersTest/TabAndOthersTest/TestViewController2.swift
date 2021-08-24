//
//  TestViewController2.swift
//  TabAndOthersTest
//
//  Created by hanwe lee on 2021/08/24.
//

import UIKit

class TestViewController2: UIViewController, HideTabbarProtocol {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "2"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationController?.hidesBarsOnSwipe = true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension TestViewController2: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0 {
//            DispatchQueue.main.async { [weak self] in
//            }
//            self.setTabBarHidden(true)
            self.hideTabbar()
        } else {
//            self.setTabBarHidden(false)
//            DispatchQueue.main.async { [weak self] in
//            }
            self.showTabbar()
       }
    }

    
    
    
}
