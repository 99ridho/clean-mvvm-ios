//
//  ContactUseCase.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

protocol ContactUseCaseProtocol {
    func fetchAllContacts(onSuccess: (([Contact]) -> Void)?, onError: ((Error) -> Void)?)
    func fetchContact(byID id: Int, onSuccess: ((Contact) -> Void)?, onError: ((Error) -> Void)?)
}

enum ContactUseCaseError: Error {
    case dataNotFound
    
    var localizedDescription: String {
        switch self {
        case .dataNotFound:
            return "Data kontak tidak ditemukan"
        }
    }
}

class ContactUseCase: ContactUseCaseProtocol {
    private let dataProvider: ContactRepositoryProtocol
    
    init(dataProvider: ContactRepositoryProtocol = NetworkContactRepository()) {
        self.dataProvider = dataProvider
    }
    
    func fetchAllContacts(onSuccess: (([Contact]) -> Void)?, onError: ((Error) -> Void)?) {
        dataProvider.fetchAll { (result) in
            switch result {
            case let .success(contacts):
                onSuccess?(contacts)
            case let .failure(error):
                onError?(error)
            }
        }
    }
    
    func fetchContact(byID id: Int, onSuccess: ((Contact) -> Void)?, onError: ((Error) -> Void)?) {
        dataProvider.fetch(criteria: { $0.id == id }) { (result) in
            switch result {
            case let .success(contacts):
                guard let foundContact = contacts.first else {
                    onError?(ContactUseCaseError.dataNotFound)
                    return
                }
                
                onSuccess?(foundContact)
            case let .failure(error):
                onError?(error)
            }
        }
    }
}
