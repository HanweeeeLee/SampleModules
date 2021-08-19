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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var presenter: Presenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchBar.delegate = self
//        var param: [String: Any] = [:]
//        param["sort"] = "start"
//        let option: SearchModule.APIManagerOption = SearchModule.APIManagerOption(url: "https://api.github.com/search/repositories", function: .get, header: nil, param: param, requestType: .json, responseType: .json, searchParamKey: "q", pagingParamKey: "page")
//        self.searchModule = SearchModule(apiManager: StubAPIManager(), option: option)
//        self.searchModule?.search(keyword: "rxSwift", page: 1, completeHandler: { responseData in
//            print(String(data: responseData, encoding: .utf8) ?? "-")
//        }, failureHandler: { _ in
//
//        })
//        self.searchModule = SearchModule(apiManager: APIManager(), option: option)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.loadingIndicator.isHidden = true
        self.presenter = Presenter(model: Model())
    }


}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("검색: \(String(describing: self.searchBar.text))")
        self.loadingIndicator.isHidden = false
        self.loadingIndicator.startAnimating()
        self.presenter?.search(keyword: self.searchBar.text!, complition: {
            DispatchQueue.main.async { [weak self] in
                self?.loadingIndicator.stopAnimating()
                self?.loadingIndicator.isHidden = true
                self?.tableView.reloadData()
            }
        })
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter?.model.searchResults.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell()
        cell.textLabel?.text = self.presenter?.model.searchResults[indexPath.row].name
        return cell
    }
}
