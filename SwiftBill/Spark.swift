//
//  Spark.swift
//  StepBill
//
//  Created by C.W. Betts on 7/6/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation
import AppKit.NSImage

/*
#define SPARK_SPEED 4
#define SPARK_DELAY(level) (MAX(20 - (level), 0))
*/


final class Spark: DrawableSprite {
	private var index: Int = 0
	static let SparkSpeed = 4
	class func sparkDelay(level: Int) -> Int {
		return max(20 - level, 0)
	}
	
	private static let pictures: [NSImage] = {
		var toRet = [NSImage]()
		
		for i in 0 ..< 2 {
			toRet.append(loadPicture(named: "spark", index: i)!)
		}
		
		return toRet
	}()
	
	func toggleIndex() {
		if index == 0 {
			index = 1
		} else {
			index = 0
		}
	}
	var width: Int {
		return Int(Spark.pictures.first!.size.width)
	}
	
	var height: Int {
		return Int(Spark.pictures.first!.size.height)
	}

	func drawSprite() -> NSImage {
		return Spark.pictures[index]
	}
}
