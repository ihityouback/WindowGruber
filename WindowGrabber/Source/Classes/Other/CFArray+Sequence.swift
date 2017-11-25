//
//  CFArray+Sequence.swift
//  GrabberTry
//
//  Created by Rustam on 10/28/17.
//  Copyright © 2017 Rustam Galiullin. All rights reserved.
//

import Foundation

extension CFArray: Sequence {
    public func makeIterator() -> AnyIterator<AnyObject> {
        var index = -1
        let maxIndex = CFArrayGetCount(self)
        return AnyIterator {
            index = index + 1
            guard index < maxIndex else {
                return nil
            }
            let unmanagedObject: UnsafeRawPointer = CFArrayGetValueAtIndex(self, index)
            let rec = unsafeBitCast(unmanagedObject, to: AnyObject.self)
            return rec
        }
    }
}
