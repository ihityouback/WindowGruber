//
//  Grabber.swift
//  GrabberTry
//
//  Created by Rustam on 10/29/17.
//  Copyright © 2017 Rustam Galiullin. All rights reserved.
//

import AppKit

open class BaseGrabber {
    
    private let notificationCenter = NSWorkspace.shared.notificationCenter
    private let didActiveNotificationName = NSWorkspace.didActivateApplicationNotification
    
    private var monitoring = false
    
    public func beginMonitoring() {
        if monitoring == true { return }
        monitoring = true
        notificationCenter.addObserver(self, selector: #selector(applicationBecomeActive(notification:)), name: didActiveNotificationName, object: nil)
    }
    
    //Finish monitoring switches of apps
    public func finishMonitoring() {
        if monitoring == false { return }
        monitoring = false
        notificationCenter.removeObserver(self, name: didActiveNotificationName, object: nil)
    }
    
    @objc func applicationBecomeActive(notification: NSNotification) {
        assertionFailure("Override this method")
    }
    
    deinit {
        finishMonitoring()
    }
}

