//
//  Window.swift
//  GrabberTry
//
//  Created by Rustam on 10/28/17.
//  Copyright © 2017 Rustam Galiullin. All rights reserved.
//

import Foundation

public struct Window {
    
    public var name: String = ""
    public let owner: String
    public var fullName: String {
        return "\(owner) \(name)"
    }
    public var bundleId: String?
    public var browserURL: URL?
    
    init(with dictionary: NSDictionary) {
        if let tempName = dictionary[kCGWindowName] as? String {
            name = tempName
        } else if let tempName = dictionary[kCGWindowOwnerName] as? String {
            name = tempName
        }
        owner = dictionary[kCGWindowOwnerName] as? String ?? ""
    }
}

