//
//  ContactRepository.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation

protocol ContactRepositoryProtocol {
    func fetchAll(completion: @escaping (Result<[Contact], Error>) -> Void)
    func fetch(criteria: @escaping (Contact) -> Bool, completion: @escaping (Result<[Contact], Error>) -> Void)
}
