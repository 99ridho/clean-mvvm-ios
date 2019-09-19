//
//  Observable.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

final class Observable<Value> {
    struct ObserverContainer<Value> {
        weak var observer: AnyObject?
        let queue: DispatchQueue
        let handler: (Value) -> Void
    }
    
    private var observers: [ObserverContainer<Value>] = []
    
    private var value: Value {
        didSet {
            notifyObservers()
        }
    }
    
    init(value: Value) {
        self.value = value
    }
    
    func observe(
        on observer: AnyObject,
        queue: DispatchQueue = .main,
        handler: @escaping ((Value) -> Void)
    ) {
        let observer = ObserverContainer(observer: observer, queue: queue, handler: handler)
        observers.append(observer)
        
        queue.async {
            handler(self.value)
        }
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    func emit(_ value: Value) {
        self.value = value
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.queue.async {
                observer.handler(self.value)
            }
        }
    }
}
