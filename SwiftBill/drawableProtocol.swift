//
//  drawableProtocol.swift
//  StepBill
//
//  Created by C.W. Betts on 7/6/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import AppKit

protocol DrawableSprite: class {
	var width: Int { get }
	var height: Int { get }
	func drawSprite() -> NSImage
}
