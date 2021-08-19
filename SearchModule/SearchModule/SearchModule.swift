//
//  SearchModule.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

public class SearchModule {
    
    public struct APIManagerOption {
        let url: String
        let function: APIManager.ApiManagerRequestFunction
        let header: [String: Any]?
        let param: [String: Any]?
        let requestType: APIManager.ApiRequestResponseType
        let responseType: APIManager.ApiRequestResponseType
        let searchParamKey: String
        let pagingParamKey: String?
    }
    
    // MARK: private property
    private let apiManager: APIManagerProtocol
    private let option: APIManagerOption
    
    // MARK: public property
    
    // MARK: life cycle
    
    init(apiManager: APIManagerProtocol, option: APIManagerOption) {
        self.apiManager = apiManager
        self.option = option
    }
    
    // MARK: private func
    
    // MARK: public func
    
    public func search(keyword: String, page: UInt, completeHandler: @escaping (Data) -> Void, failureHandler: @escaping (Error) -> Void) {
        var newParam = self.option.param
        if newParam != nil {
            newParam![self.option.searchParamKey] = keyword
            if self.option.pagingParamKey != nil {
                newParam![self.option.pagingParamKey!] = page
            }
        }
        let task = self.apiManager.query(url: self.option.url, function: self.option.function, header: self.option.header, param: newParam, requestType: self.option.requestType, responseType: self.option.responseType, timeout: 10, completeHanlder: {  responseData in
            completeHandler(responseData)
        }, failureHandler: { err in
            failureHandler(err)
        })
    }
    
    
    
    
}
