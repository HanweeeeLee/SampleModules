//
//  Presenter.swift
//  SearchModule
//
//  Created by hanwe on 2021/08/19.
//

import UIKit

protocol PresenterProtocol: AnyObject {
    var model: ModelProtocol { get }
    func search(keyword: String, complition: @escaping () -> ())
}

class Presenter: PresenterProtocol {
    
    let model: ModelProtocol
    
    init(model: ModelProtocol) {
        self.model = model
    }
    
    
    func search(keyword: String, complition: @escaping () -> ()) {
        self.model.getRepoModelList(keyword: keyword, page: 1) {
            complition()
        } failureHandler: { err in
            print("err: \(err.localizedDescription)")
        }

    }
}
