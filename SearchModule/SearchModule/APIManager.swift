//
//  APIManager.swift
//  URLSessionSample
//
//  Created by hanwe lee on 2021/08/18.
//

import UIKit

protocol APIManagerProtocol: AnyObject {
    @discardableResult func query(url: String, function: APIManager.ApiManagerRequestFunction, header: [String: Any]?, param:[String:Any]?, requestType: APIManager.ApiRequestResponseType, responseType: APIManager.ApiRequestResponseType, timeout: UInt, completeHanlder: @escaping (Data) -> (), failureHandler: @escaping (Error) -> ()) -> URLSessionTask?
}

class APIManager: APIManagerProtocol {
    
    enum ApiManagerRequestFunction {
        case get
        case post
        case delete
        case upload
    }

    enum ApiRequestResponseType {
        case json
        case xml
        case html
    }
    
    @discardableResult func query(url: String, function: ApiManagerRequestFunction = .post, header: [String: Any]? = nil, param:[String:Any]? = nil, requestType: ApiRequestResponseType = .json, responseType: ApiRequestResponseType = .json, timeout: UInt  = 10, completeHanlder: @escaping (Data) -> (), failureHandler: @escaping (Error) -> ()) -> URLSessionTask? {
        guard let realUrl = URL(string: url) else {
            // 처리하고싶으면 에러처리
            return nil
        }
        var request: URLRequest = URLRequest(url: realUrl)
        // header
        switch requestType {
        case .json:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            break
        case .xml:
            request.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Content-Type")
            break
        case .html:
            request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Content-Type") //테스트 안해봄
            break
        }
        
        switch responseType {
        case .json:
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
            break
        case .xml:
            request.setValue("application/xml; charset=utf-8", forHTTPHeaderField: "Accept")
            break
        case .html:
            request.setValue("text/html; charset=utf-8", forHTTPHeaderField: "Accept")
            break
        }
        if header != nil {
            let keys = Array(header!.keys)
            for i in 0..<header!.count {
                request.setValue((header![keys[i]] as! String), forHTTPHeaderField: keys[i])
            }
        }
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(Float(timeout))
        //        sessionConfig.timeoutIntervalForResource = 60.0
        sessionConfig.allowsCellularAccess = true //셀룰러로 데이터를 사용하는것을 허용?
        //        sessionConfig.waitsForConnectivity = true //세션이 연결을 사용할수 있을때까지 기다릴것인가 아니면 즉시 실패처리할것인가
        //등등...
        let session = URLSession(configuration: sessionConfig)
        
        switch function {
        case .get:
            request.httpMethod = "GET"
            if let param = param {
                if param.count > 0 {
                    var newUrl = url + "?"
                    let allKeys = Array(param.keys)
                    for i in 0..<allKeys.count {
                        let key: String = allKeys[i]
                        let value = param[key]
                        if i != 0 {
                            newUrl.append("&")
                        }
                        newUrl.append(key)
                        newUrl.append("=")
                        newUrl.append("\(value!)")
                    }
                    request.url = URL(string: newUrl)
                }
            }
        case .post:
            request.httpMethod = "POST"
            if param != nil {
                let bodyData = try? JSONSerialization.data(
                    withJSONObject: param!,
                    options: []
                )
                request.httpBody = bodyData
            }
        case .delete:
            //미구현
            break
        case .upload:
            //미구현
            break
        }
        
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                failureHandler(error)
                return
            } else {
                let response = response as? HTTPURLResponse //처리하고싶으면 해야함
                completeHanlder(data ?? Data())
                return
            }
        }
        task.resume()
        return task
    }
}
