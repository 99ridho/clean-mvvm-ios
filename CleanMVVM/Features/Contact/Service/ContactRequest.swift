//
//  ContactRequest.swift
//  CleanMVVM
//
//  Created by Ridho Pratama on 19/09/19.
//  Copyright © 2019 Ridho Pratama. All rights reserved.
//

import Foundation
import NetworkKit

enum ContactRequest {
    case fetchContactList
}

extension ContactRequest: RequestProtocol {
    var baseURL: URL {
        switch self {
        case .fetchContactList:
            return "https://gist.githubusercontent.com/99ridho/cbbeae1fa014522151e45a766492233c/raw/8935d40ae0650f12b452d6a5e9aa238a02b05511/contacts.json"
        }
    }
    
    var path: String {
        switch self {
        case .fetchContactList:
            return ""
        }
    }
    
    var parameters: Parameters {
        return [:]
    }
    
    var headers: [String : String] {
        return [:]
    }
    
    var parameterEncoder: ParameterEncoder {
        return URLParameterEncoder.defaultInstance
    }
    
    var method: RequestMethod {
        switch self {
        case .fetchContactList:
            return .get
        }
    }
}
