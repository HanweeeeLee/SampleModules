//
//  StubAPIManager.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

class StubAPIManager: APIManagerProtocol {
    func query(url: String, function: APIManager.ApiManagerRequestFunction, header: [String : Any]?, param: [String : Any]?, requestType: APIManager.ApiRequestResponseType, responseType: APIManager.ApiRequestResponseType, timeout: UInt, completeHanlder: @escaping (Data) -> (), failureHandler: @escaping (Error) -> ()) -> URLSessionTask? {
        let testResponse = "더미 응답"
        completeHanlder(testResponse.data(using: .utf8)!)
        return nil
    }
}
