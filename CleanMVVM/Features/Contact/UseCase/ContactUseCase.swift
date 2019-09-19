//
//  ContactUseCase.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

protocol ContactUseCaseProtocol {
    func fetchAllContacts(completion: (([Contact]) -> Void)?)
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
    private let dataProvider: ContactDataProviderProtocol
    
    init(dataProvider: ContactDataProviderProtocol) {
        self.dataProvider = dataProvider
    }
    
    func fetchAllContacts(completion: (([Contact]) -> Void)?) {
        dataProvider.fetchAll { (result) in
            switch result {
            case let .success(contacts):
                completion?(contacts)
            default:
                return
            }
        }
    }
    
    func fetchContact(byID id: Int, onSuccess: ((Contact) -> Void)?, onError: ((Error) -> Void)?) {
        dataProvider.fetch(predicate: { $0.id == id }) { (result) in
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
