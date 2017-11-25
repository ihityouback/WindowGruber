//
//  WindowGrabber.swift
//  GrabberTry
//
//  Created by Rustam on 10/28/17.
//  Copyright © 2017 Rustam Galiullin. All rights reserved.
//

import Foundation
import AppKit

class WindowGrabber: BaseGrabber {
    
    //MARK: - Config
    
    private let urlGrabber = URLGrabber()
    private var lastUsedApp: NSRunningApplication?

    override init() {
        super.init()
        beginMonitoring()
    }
    
    override func applicationBecomeActive(notification: NSNotification) {
        if let userInfo = notification.userInfo,
            let activeApp = userInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            activeApp.bundleIdentifier != Bundle.main.bundleIdentifier {
            lastUsedApp = activeApp
        }
    }
    
    //MARK: - Public methods
    
    func getAppWindow(app: NSRunningApplication) throws -> Window {
        do {
            return try getWindowOf(app)
        } catch {
            print(error)
            throw error
        }
    }
    
    func getCurrentAppWindow() throws -> Window {
        //check for frontmost app existance
        guard let app = NSWorkspace.shared.frontmostApplication else {
            throw WindowGrabError.frontmostAppNotFound
        }
        
        //check that focused app not a current app
        if app.bundleIdentifier != Bundle.main.bundleIdentifier {
            return try getWindowOf(app)
        }
        
        //check for last used app existance
        if let lastUsedApp = lastUsedApp {
            return try getWindowOf(lastUsedApp)
        } else {
            throw WindowGrabError.lastUsedAppNotExistOrItsSameApp
        }
    }
    
    //MARK: - Private methods
    
    private func getWindowOf(_ app: NSRunningApplication) throws -> Window {
        //check that app has acitve window
        guard var window = windows.filter({ $0.owner == app.localizedName && $0.name.count > 0 }).first else {
            throw WindowGrabError.windowNotFound
        }
        
        window.bundleId = app.bundleIdentifier
        window.browserURL = getTabUrlIfThisOneIsBrowser(app.bundleIdentifier)
        return window
    }
    
    private func getTabUrlIfThisOneIsBrowser(_ bundle: String?) -> URL? {
        guard let bundle = bundle else { return nil }
        
        if urlGrabber.compatibleBrowsersBundldIds.contains(bundle) {
            do {
                return try urlGrabber.grabUrlFrom(bundleId: bundle)
            } catch {
                print("URL grabbing error: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
    
    private var windows: [Window] {
        guard let windowList = CGWindowListCopyWindowInfo(CGWindowListOption.optionOnScreenOnly, 0) as? [NSDictionary] else {
            return [Window]()
        }
        
        return windowList.map(Window.init)
    }
}

//Errors enum
enum WindowGrabError: Error {
    
    case windowNotFound
    case frontmostAppNotFound
    case lastUsedAppNotExistOrItsSameApp
    
    var description: String {
        var _description = "Error"
        switch self {
        case .windowNotFound:
            _description = "App window not found"
        case .frontmostAppNotFound:
            _description = "Frontmost app not found"
        case .lastUsedAppNotExistOrItsSameApp:
            _description = "Last user app not exist or last app is the your app"
            if let appInfo = Bundle.main.infoDictionary, let appName = appInfo["CFBundleName"] as? String {
                _description = _description + ": \"\(appName)\""
            }
        }
        return _description
    }
}
