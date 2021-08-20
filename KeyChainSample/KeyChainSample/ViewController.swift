//
//  ViewController.swift
//  KeyChainSample
//
//  Created by hanwe on 2021/08/20.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("hello")
        let manager = KeyChainManager.init(service: "a")
    }


}

