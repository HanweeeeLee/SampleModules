//
//  MyDataProtocol.swift
//  KeyChainSample
//
//  Created by hanwe on 2021/08/20.
//

import UIKit

protocol MyDataProtocol: Codable, Equatable {
    func toJson() -> String
    static func fromJson<T: MyDataProtocol>(jsonData: Data?, object: T) -> T?
}

extension MyDataProtocol {
    func toJson() -> String {
        var jsonString: String = ""
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        encoder.outputFormatting = .sortedKeys
        let jsonData = try? encoder.encode(self)
        if jsonData != nil {
            jsonString = String(data: jsonData!, encoding: .utf8) ?? ""
        }
        return jsonString
    }
    
    static func fromJson<T: MyDataProtocol>(jsonData: Data?, object: T) -> T? {
        var returnValue: T? = nil
        let decoder = JSONDecoder()
        if let data = jsonData, let result = try? decoder.decode(T.self, from: data) {
            returnValue = result
        }
        return returnValue
    }
}
