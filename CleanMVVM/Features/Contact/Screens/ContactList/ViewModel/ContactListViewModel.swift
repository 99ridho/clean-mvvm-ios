//
//  ContactListViewModel.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation
import UIKit

class ContactListViewModel: NSObject {
    struct Output {
        let onContactSelectedByID: Observable<Int>
        let onDataRefreshed: Observable<Void>
    }
    
    private let usecase: ContactUseCaseProtocol
    public private(set) var output: Output
    
    private var contactsCellData: [ContactListCellData] = []
    private var rawContacts: [Contact] = []
    
    init(usecase: ContactUseCaseProtocol = ContactUseCase()) {
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
                self?.rawContacts = contacts
                self?.contactsCellData = contacts.map {
                    ContactListCellData(imageURL: $0.imageUrl, name: $0.name)
                }
                self?.output.onDataRefreshed.emit(.next(()))
            }
        }, onError: nil)
    }
}

// MARK: - Table view data source & delegates will be implemented here
extension ContactListViewModel: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsCellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellData = contactsCellData[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ContactListTableViewCell.reuseIdentifier) as! ContactListTableViewCell
        cell.configureCell(with: cellData)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let contactID = rawContacts[indexPath.row].id
        output.onContactSelectedByID.emit(.next(contactID))
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
