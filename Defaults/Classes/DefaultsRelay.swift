//
//  DefaultsRelay.swift
//  RxToolkit
//
//  Created by Martin Daum on 16.11.18.
//

import Foundation
import RxSwift
import RxCocoa

private struct DefaultsWrapper<T: Codable>: Codable {
    let wrappedValue: T
}

public final class DefaultsRelay<T: Codable>: ObservableType {
    public typealias E = T
    
    private let relay: BehaviorRelay<T>
    private let defaults: UserDefaults
    private let key: String
    private let defaultValue: T
    
    private let encoder = PropertyListEncoder()
    private let decoder = PropertyListDecoder()
    
    public init(defaults: UserDefaults, key: String, defaultValue: T) {
        self.defaults = defaults
        self.key = key
        self.defaultValue = defaultValue
        
        var value = defaultValue
        if let data = defaults.data(forKey: key),
            let existingValue = try? decoder.decode(DefaultsWrapper<T>.self, from: data) {
            value = existingValue.wrappedValue
        }
        relay = BehaviorRelay(value: value)
    }
    
    public func accept(_ event: T?) {
        relay.accept(event ?? defaultValue)
        saveValue(event)
    }
    
    private func saveValue(_ data: T?) {
        if let data = data {
            do {
                let value = try encoder.encode(DefaultsWrapper(wrappedValue: data))
                defaults.set(value, forKey: key)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        } else {
            defaults.removeObject(forKey: key)
        }
    }
    
    public var value: T {
        return relay.value
    }
    
    public func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E {
        return relay.subscribe(observer)
    }

    public func asObservable() -> Observable<T> {
        return relay.asObservable()
    }
}
