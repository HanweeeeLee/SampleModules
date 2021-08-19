//
//  ViewController.swift
//  SearchBar
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.searchController = UISearchController()
        navigationItem.hidesSearchBarWhenScrolling = false
//        let titleView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 200))
//        titleView.backgroundColor = .brown
//        self.navigationItem.titleView = titleView
//        navigationController?.hidesBarsOnSwipe = true
//        self.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.title = "asd"
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        if(velocity.y>0) {
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(true, animated: true)
//                self.navigationController?.setToolbarHidden(true, animated: true)
//                print("Hide")
//            }, completion: nil)
        } else {
//            UIView.animate(withDuration: 0.3, delay: 0, options: UIView.AnimationOptions(), animations: {
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.navigationController?.setToolbarHidden(false, animated: true)
//                print("Unhide")
//            }, completion: nil)
          }
       }
}

