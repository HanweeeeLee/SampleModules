//
//  Util.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

class Util: NSObject {
    static func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
