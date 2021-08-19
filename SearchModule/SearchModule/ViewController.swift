//
//  ViewController.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

class ViewController: UIViewController {
    
//    "https://api.github.com/search/repositories?q=\(text)&sort=start&page=\(page)"
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchModule: SearchModule?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
        var param: [String: Any] = [:]
        param["sort"] = "start"
        let option: SearchModule.APIManagerOption = SearchModule.APIManagerOption(url: "https://api.github.com/search/repositories", function: .get, header: nil, param: param, requestType: .json, responseType: .json, searchParamKey: "q", pagingParamKey: "page")
        self.searchModule = SearchModule(apiManager: StubAPIManager(), option: option)
        self.searchModule?.search(keyword: "rxSwift", page: 1, completeHandler: { responseData in
            print(String(data: responseData, encoding: .utf8) ?? "-")
        }, failureHandler: { _ in
            
        })
        self.searchModule = SearchModule(apiManager: APIManager(), option: option)
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색: \(String(describing: self.searchBar.text))")
        self.searchModule?.search(keyword: self.searchBar.text!, page: 1, completeHandler: { responseData in
            print(String(data: responseData, encoding: .utf8) ?? "-")
        }, failureHandler: { _ in
            
        })
    }
}

