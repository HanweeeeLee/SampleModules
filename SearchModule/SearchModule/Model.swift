//
//  Model.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

protocol ModelProtocol: AnyObject {
    func getRepoModelList(keyword: String, page: UInt, complition: @escaping () -> Void, failureHandler: @escaping (Error) -> Void)
    var searchResults: [RepoModel] { get }
}

class Model: ModelProtocol {
    var searchResults: [RepoModel] = []
    
    private var searchModule: SearchModule
    
    init() {
        var param: [String: Any] = [:]
        param["sort"] = "start"
        let option: SearchModule.APIManagerOption = SearchModule.APIManagerOption(url: "https://api.github.com/search/repositories", function: .get, header: nil, param: param, requestType: .json, responseType: .json, searchParamKey: "q", pagingParamKey: "page")
        self.searchModule = SearchModule(apiManager: APIManager(), option: option)
    }
    
    public func getRepoModelList(keyword: String, page: UInt, complition: @escaping () -> Void, failureHandler: @escaping (Error) -> Void) {
        self.searchModule.search(keyword: keyword, page: 1, completeHandler: { responseData in
            print(String(data: responseData, encoding: .utf8) ?? "-")
            let arr = Util.convertToDictionary(text: String(data: responseData, encoding: .utf8)!)
            self.searchResults.removeAll()
            let items = arr!["items"] as! [Any]
            for item in items {
                let modelObj: RepoModel = RepoModel(name: (item as! [String: Any])["name"] as! String)
                self.searchResults.append(modelObj)
            }
            complition()
            
        }, failureHandler: { err in
            failureHandler(err)
        })
    }
}

struct RepoModel {
    let name: String
}
