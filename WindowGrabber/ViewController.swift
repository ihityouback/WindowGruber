//
//  ViewController.swift
//  GrabberTry
//
//  Created by Rustam Galiullin on 10/12/2016.
//  Copyright © 2016 Rustam Galiullin. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    let grabber = URLGrabber(monitoring: true)
    let otherGrabber = WindowGrabber()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        grabber.beginMonitoring()
        push()
    }
    
    @objc func push() {
        
        self.perform(#selector(self.push), with: nil, afterDelay: 3)

        do {
            print("Source: \(try otherGrabber.getCurrentAppWindow())")
        } catch {
            print("Error: \((error as! WindowGrabError).description)")
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

