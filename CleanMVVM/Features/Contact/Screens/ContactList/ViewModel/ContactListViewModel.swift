//
//  ContactListViewModel.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

class ContactListViewModel: NSObject {
    struct Output {
        let onContactSelectedByID: Observable<Int>
        let onDataRefreshed: Observable<Void>
    }
    
    private let usecase: ContactUseCaseProtocol
    public private(set) var output: Output
    
    private var contacts: [Contact] = []
    
    init(usecase: ContactUseCaseProtocol) {
        self.usecase = usecase
        self.output = Output(
            onContactSelectedByID: Observable<Int>(),
            onDataRefreshed: Observable<Void>()
        )
        
        super.init()
    }
    
    func fetchContactList() {
        usecase.fetchAllContacts(onSuccess: { [weak self] (contacts) in
            DispatchQueue.main.async {
                self?.contacts = contacts
                self?.output.onDataRefreshed.emit(.next(()))
            }
        }, onError: nil)
    }
}

// MARK: - Table view data source & delegates will be implemented here
