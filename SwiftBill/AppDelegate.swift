//
//  AppDelegate.swift
//  SwiftBill
//
//  Created by C.W. Betts on 5/25/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Cocoa

//#define RAND(lb, ub) (random() % ((ub) - (lb) + 1) + (lb))
internal func RAND(lb: Int, ub: Int) -> Int {
	return random() % ((ub) - (lb) + 1) + (lb)
}

func loadPicture(#named: String) -> NSImage? {
	return NSImage(named: named)
}

func loadPicture(#named: String, #index: Int) -> NSImage? {
	return NSImage(named: named + "_\(index)")
}


@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
	@IBOutlet weak var window: NSWindow!

	func applicationDidFinishLaunching(aNotification: NSNotification) {
		// get userdefaults
		let defaults = NSUserDefaults.standardUserDefaults()
		if let s = NSBundle.mainBundle().URLForResource("Defaults", withExtension: "plist"), dict = NSDictionary(contentsOfURL: s) {
			defaults.registerDefaults(dict as [NSObject : AnyObject])
		}
		
		// if we don't have a value already
		// set default for animation interval
		if defaults.integerForKey("interval") == 0 {
			defaults.setInteger(200, forKey: "interval")
		}
		
	}

	func applicationWillTerminate(aNotification: NSNotification) {
		// Insert code here to tear down your application
	}

}

