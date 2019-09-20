//
//  NetworkContactRepository.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation
import NetworkKit

class NetworkContactRepository: ContactRepositoryProtocol {
    private let provider = NetworkProvider<ContactRequest>()
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return decoder
    }()
    
    func fetchAll(completion: @escaping (Result<[Contact], Error>) -> Void) {
        provider.request(.fetchContactList) { [jsonDecoder] (data, urlResponse, error) in
            if let theError = error {
                completion(.failure(theError))
                return
            }
            
            guard let theData = data else { return }
            
            do {
                let response = try jsonDecoder.decode(ContactListResponse.self, from: theData)
                completion(.success(response.data))
            } catch (let decodeError) {
                completion(.failure(decodeError))
            }
        }
    }
    
    func fetch(criteria: @escaping (Contact) -> Bool, completion: @escaping (Result<[Contact], Error>) -> Void) {
        fetchAll { (result) in
            switch result {
            case .success(let contacts):
                let filteredContacts = contacts.filter { criteria($0) }
                completion(.success(filteredContacts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
