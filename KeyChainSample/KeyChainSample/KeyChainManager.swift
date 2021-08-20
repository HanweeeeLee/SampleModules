//
//  KeyChainManager.swift
//  KeyChainSample
//
//  Created by hanwe on 2021/08/20.
//

import UIKit

class KeyChainManager {
    
    // MARK: private property
    private let service: String
    
    // MARK: public property
    
    // MARK: life cycle
    
    init(service: String) {
        self.service = service
    }
    
    // MARK: private func
    
    private func write(account: String, data: Data) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: self.service,
                                      kSecAttrAccount: account,
                                      kSecAttrGeneric: data]
        return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
    }
    
    private func fetch(account: String) -> Data? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: self.service,
                                      kSecAttrAccount: account,
                                      kSecMatchLimit: kSecMatchLimitOne,
                                      kSecReturnAttributes: true,
                                      kSecReturnData: true]
        
        var item: CFTypeRef?
        if SecItemCopyMatching(query as CFDictionary, &item) != errSecSuccess { return nil }
        
        guard let existingItem = item as? [String: Any],
              let data = existingItem[kSecAttrGeneric as String] as? Data else { return nil }
        
        return data
    }
    
    private func update(account: String, data: Data) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: self.service,
                                      kSecAttrAccount: account]
        
        let attributes: [CFString: Any] = [kSecAttrAccount: account,
                                           kSecAttrGeneric: data]
        
        return SecItemUpdate(query as CFDictionary, attributes as CFDictionary) == errSecSuccess
    }
    
    // MARK: public func
    
    public func delete(account: String) -> Bool {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrService: self.service,
                                      kSecAttrAccount: account]
        return SecItemDelete(query as CFDictionary) == errSecSuccess
    }
    
    public func writeData(account: String, data: Data) -> Bool {
        return write(account: account, data: data)
    }
    
    public func writeString(account: String, _ inputedStr: String) -> Bool {
        guard let data = inputedStr.data(using: .utf8) else {
            return false
        }
        return write(account: account, data: data)
    }
    
    public func fetchData(accont: String) -> Data? {
        return fetch(account: accont)
    }
    
    public func fetchString(account: String) -> String? {
        guard let data = fetch(account: account) else { return nil }
        return String(data: data, encoding: .utf8)
    }
    
    public func updateData(account: String, data: Data) -> Bool {
        return update(account: account, data: data)
    }
    
    public func updateString(account: String, _ inputedStr: String) -> Bool {
        guard let data = inputedStr.data(using: .utf8) else {
            return false
        }
        return update(account: account, data: data)
    }
    
    
}
