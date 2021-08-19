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
    
    private struct QueryParam {
        let keyword: String
        let page: UInt?
        let completeHandler: (Data) -> Void
        let failureHandler: (Error) -> Void
    }
    
    // MARK: private property
    private let apiManager: APIManagerProtocol
    private let option: APIManagerOption
    
    private var queryTimer: Timer?
    
    // MARK: public property
    
    // MARK: life cycle
    
    init(apiManager: APIManagerProtocol, option: APIManagerOption) {
        self.apiManager = apiManager
        self.option = option
    }
    
    // MARK: private func
    
//    @objc func fire(timer: Timer)
//    {
//        if  let userInfo = timer.userInfo as? [String: Int],
//            let score = userInfo["score"] {
//            print("You scored \(score) points!")
//        }
//    }
    
    @objc private func query() {
        guard let searchInfo = self.queryTimer?.userInfo as? QueryParam else {
            self.queryTimer = nil
            return
        }
        print("쿼리 :\(searchInfo.keyword)")
        var newParam = self.option.param
        if newParam != nil {
            newParam![self.option.searchParamKey] = searchInfo.keyword
            if self.option.pagingParamKey != nil {
                newParam![self.option.pagingParamKey!] = searchInfo.page
            }
        }
        self.apiManager.query(url: self.option.url, function: self.option.function, header: self.option.header, param: newParam, requestType: self.option.requestType, responseType: self.option.responseType, timeout: 10, completeHanlder: {  responseData in
            searchInfo.completeHandler(responseData)
        }, failureHandler: { err in
            searchInfo.failureHandler(err)
        })
        self.queryTimer = nil
    }
    
    // MARK: public func
    
    public func search(keyword: String, page: UInt, completeHandler: @escaping (Data) -> Void, failureHandler: @escaping (Error) -> Void) {
        print("대기")
        if let timer = self.queryTimer {
            timer.invalidate()
            self.queryTimer = nil
        }
        self.queryTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(query), userInfo: QueryParam(keyword: keyword, page: page, completeHandler: completeHandler, failureHandler: failureHandler), repeats: false)
    }
    
    
    
    
}
