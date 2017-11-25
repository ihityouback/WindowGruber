//
//  Window.swift
//  GrabberTry
//
//  Created by Rustam on 10/28/17.
//  Copyright © 2017 Rustam Galiullin. All rights reserved.
//

import Foundation

struct Window {
    
    var name: String = ""
    let owner: String
    var fullName: String {
        return "\(owner) \(name)"
    }
    var bundleId: String?
    var browserURL: URL?
    
    init(with dictionary: NSDictionary) {
        if let tempName = dictionary[kCGWindowName] as? String {
            name = tempName
        } else if let tempName = dictionary[kCGWindowOwnerName] as? String {
            name = tempName
        }
        owner = dictionary[kCGWindowOwnerName] as? String ?? ""
    }
}
