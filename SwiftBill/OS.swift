//
//  OS.swift
//  StepBill
//
//  Created by C.W. Betts on 5/25/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation

enum OSes: Int {
	case Off = -1
	case Wingdows = 0
	case Apple
	case NeXT
	case SGI
	case Sun
	case Palm
	case OS2
	case BSD
	case Linux
	case RedHat
	case Hurd
	case BeOS
	
	var stringValue: String {
		switch self {
		case .Off:
			return ""
			
		case .Wingdows:
			return "wingdows"
			
		case .Apple:
			return "apple"
			
		case .NeXT:
			return "next"
			
		case .SGI:
			return "sgi"
			
		case .Sun:
			return "sun"
			
		case .Palm:
			return "palm"
			
		case .OS2:
			return "os2"
			
		case .BSD:
			return "bsd"
			
		case .Linux:
			return "linux"
			
		case .RedHat:
			return "redhat"
			
		case .Hurd:
			return "hurd"
			
		case .BeOS:
			return "beos"
		}
	}
	
	var PC: Bool {
		return self.rawValue >= 6
	}
}
