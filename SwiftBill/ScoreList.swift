//
//  ScoreList.swift
//  StepBill
//
//  Created by C.W. Betts on 5/25/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Cocoa

let maximumScores = 10

final class ScoreList: NSObject, NSTableViewDataSource {
	private var scores = [ScoreObject]()
	
	func readScoreList() {
		let defaults = NSUserDefaults.standardUserDefaults()
		
		if let tmpArray = defaults.arrayForKey("scores") as? [NSDictionary] {
			for scoreDict in tmpArray {
				if let score = ScoreObject(propertyListRepresentation: scoreDict) {
					scores.append(score)
				}
			}
		}
		
		while scores.count < maximumScores {
			scores.append(.anonymousScore)
		}
		
		sortScoreList()
	}
	
	private func sortScoreList() {
		scores.sort(>)
	}
	
	func writeScoreList() {
		let toDict = scores.map { (aVar) -> NSDictionary in
			return aVar.propertyListRepresentation
		}
		let defaults = NSUserDefaults.standardUserDefaults()
		defaults.setObject(toDict, forKey: "scores")
		defaults.synchronize()
	}
	
	func isHighScore(val: Int) -> Bool {
		return val > scores.last!.score
	}
	
	func addScore(name name1: String?, level: Int, score: Int) {
		var name = "Anonymous"
		if let otherName = name1 where count(otherName) != 0 {
			name = otherName
		}
		
		let newScore = ScoreObject(name: name, score: score, level: level)
		scores.append(newScore)
		sortScoreList()
		scores.removeLast()
	}
	
	func numberOfRowsInTableView(tableView: NSTableView) -> Int {
		return maximumScores
	}
	
	func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row rowIndex: Int) -> AnyObject? {
		assert(rowIndex >= 0 && rowIndex < maximumScores);
		let theRecord = scores[rowIndex]
		if let tableColumn = tableColumn, columnIdentifier = tableColumn.identifier {
			switch columnIdentifier {
			case kHighName:
				return theRecord.name
				
			case kHighLevel:
				return theRecord.level
				
			case kHighScore:
				return theRecord.score
				
			default:
				return nil
			}
		} else {
			return nil
		}
	}
}
