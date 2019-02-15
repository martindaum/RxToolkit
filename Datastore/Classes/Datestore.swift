//
//  Datastore.swift
//  RxToolkit
//
//  Created by Martin Daum on 11.02.19.
//

import Foundation
import RealmSwift
import RxSwift

private struct ThreadSafeWrapper<T: Object> {
    let object: T
    let reference: ThreadSafeReference<T>?
    
    init(for object: T) {
        self.object = object
        reference = object.realm != nil ? ThreadSafeReference(to: object) : nil
    }
    
    func resolve(with realm: Realm) -> T? {
        if let reference = reference {
            return realm.resolve(reference)
        }
        return object
    }
}

public final class Datastore {
    private let configuration: Realm.Configuration
    private let queue = DispatchQueue(label: NSUUID().uuidString)
    
    public init(configuration: Realm.Configuration) {
        self.configuration = configuration
        
        if let path = configuration.fileURL?.relativePath {
            print("open \(path)")
        }
    }
    
    private var defaultRealm: Realm {
        do {
            return try Realm(configuration: configuration)
        } catch {
            fatalError("realm error")
        }
    }
    
    public func objects<T: Object>(for type: T.Type) -> Results<T> {
        return defaultRealm.objects(type)
    }
    
    public func save(_ closure: @escaping (_ realm: Realm) -> Void) -> Completable {
        return Completable.create { [unowned self] completable in
            self.queue.async {
                autoreleasepool {
                    do {
                        let realm = try Realm(configuration: self.configuration)
                        realm.beginWrite()
                        closure(realm)
                        try realm.commitWrite()
                        completable(.completed)
                    } catch {
                        completable(.error(error))
                    }
                }
            }
            return Disposables.create()
        }
    }
    
    public func save<T: Object>(object: T, using closure: @escaping (_ realm: Realm, _ object: T?) -> Void) -> Completable {
        let reference = ThreadSafeWrapper(for: object)
        
        return save({ realm in
            let object = reference.resolve(with: realm)
            closure(realm, object)
        })
    }
    
    public func save<T: Object>(objects: [T], using closure: @escaping (_ realm: Realm, _ objects: [T]) -> Void) -> Completable {
        let references = objects.map({ ThreadSafeWrapper(for: $0) })
        
        return save({ realm in
            let objects = references.compactMap({ $0.resolve(with: realm) })
            closure(realm, objects)
        })
    }
}

extension Results {
    func asObservable() -> Observable<Results> {
        return Observable.from(self)
    }
}
