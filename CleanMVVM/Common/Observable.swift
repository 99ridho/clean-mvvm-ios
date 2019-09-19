//
//  Observable.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

final class Observable<Value> {
    enum Event {
        case next(Value)
    }
    
    private struct ObserverContainer {
        weak var observer: AnyObject?
        let queue: DispatchQueue
        let handler: (Value) -> Void
    }
    
    private var observers: [ObserverContainer] = []
    
    private var event: Event? {
        didSet {
            notifyObservers()
        }
    }
    
    func observe(on observer: AnyObject, queue: DispatchQueue = .main, handler: @escaping ((Value) -> Void)) {
        let observer = ObserverContainer(observer: observer, queue: queue, handler: handler)
        observers.append(observer)
    }
    
    func remove(observer: AnyObject) {
        observers = observers.filter { $0.observer !== observer }
    }
    
    func emit(_ event: Event) {
        self.event = event
    }
    
    private func notifyObservers() {
        for observer in observers {
            observer.queue.async {
                if case let .some(.next(value)) = self.event {
                    observer.handler(value)
                }
            }
        }
    }
}
