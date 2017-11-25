//
//  URLGrabber.swift
//  GrabberTry
//
//  Created by Rustam Galiullin on 10/12/2016.
//  Copyright © 2016 Rustam Galiullin. All rights reserved.
//

import AppKit

class URLGrabber: BaseGrabber {
    
    private var lastActiveBrowserBundleId: String?
    var compatibleBrowsersBundldIds = ["com.apple.Safari",
                                       "com.google.Chrome",
                                       "com.operasoftware.Opera",
                                       "org.mozilla.firefox",
                                       "ru.yandex.desktop.yandex-browser"]
    
    init(monitoring: Bool = false) {
        super.init()
        if monitoring {
            beginMonitoring()
        }
    }
    
    override func applicationBecomeActive(notification: NSNotification) {
        guard let application = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let bundleId = application.bundleIdentifier else {
                return
        }
        
        if compatibleBrowsersBundldIds.contains(bundleId) {
            lastActiveBrowserBundleId = bundleId
        }
    }
    
    //MARK: Grabber methods
    
    //grab url from last active browser
    func grabCurrentUrl() throws -> URL? {
        
        //check it has last active browser bundleId
        guard let bundleId = lastActiveBrowserBundleId else {
            throw URLGrabError.bundleIdNotFound
        }
        
        return try grabUrlFrom(bundleId: bundleId)
    }
    
    //grab url from bundleId
    func grabUrlFrom(bundleId: String) throws -> URL? {
        return try grabUrl(from: bundleId)
    }
    
    //MARK: - Private methods
    
    private func grabUrl(from bundleId: String) throws -> URL? {
        
        //check browser is running
        if NSRunningApplication.runningApplications(withBundleIdentifier: bundleId).count == 0 {
            throw URLGrabError.runningBrowserNotFound
        }
        
        //check apple script is available
        guard let scriptPath = Bundle.main.path(forResource: bundleId, ofType: "scpt") else {
            throw URLGrabError.scriptNotFound
        }
        
        var appleScriptError: NSDictionary?
        let appleScript = NSAppleScript(contentsOf: URL(fileURLWithPath: scriptPath), error: &appleScriptError)
        if let _ = appleScriptError {
            throw URLGrabError.scriptNotFound
        }
        
        //execute apple script
        var scriptExecutionError: NSDictionary?
        let scriptExecutionResult = appleScript?.executeAndReturnError(&scriptExecutionError)
        if let _ = scriptExecutionError {
            throw URLGrabError.scriptFailed
        }
        
        //check apple script executed successfully
        guard let stringUrl = scriptExecutionResult?.stringValue else {
            throw URLGrabError.scriptFailed
        }
        
        return URL(string: stringUrl)
    }
}

//Errors enum
enum URLGrabError: Error {
    
    case scriptNotFound
    case bundleIdNotFound
    case runningBrowserNotFound
    case scriptFailed
    
    var description: String {
        var _description = "Error"
        switch self {
        case .scriptNotFound:
            _description = "Apple script for browser not found"
        case .bundleIdNotFound:
            _description = "Active bundleId not found"
        case .runningBrowserNotFound:
            _description = "Running browser not found"
        case .scriptFailed:
            _description = "Execution of apple script failed"
        }
        return _description
    }
}
