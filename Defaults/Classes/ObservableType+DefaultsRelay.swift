//
//  ObservableType+DefaultsRelay.swift
//  RxToolkit
//
//  Created by Martin Daum on 16.11.18.
//

import Foundation
import RxSwift
import RxCocoa

extension ObservableType where E: Codable {
    public func bind(to relay: DefaultsRelay<E>) -> Disposable {
        return subscribe { e in
            switch e {
            case .next(let element):
                relay.accept(element)
            case .error:
                fatalError("error in binding")
            case .completed:
                break
            }
        }
    }
    
    public func bind(to relay: DefaultsRelay<E?>) -> Disposable {
        return self.map { $0 as E? }.bind(to: relay)
    }
}
