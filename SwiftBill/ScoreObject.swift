//
//  ScoreObject.swift
//  StepBill
//
//  Created by C.W. Betts on 5/25/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Foundation

let kHighName = "name"
let kHighLevel = "level"
let kHighScore = "score"

func ==(lhs: ScoreObject, rhs: ScoreObject) -> Bool {
	return lhs.score == rhs.score && lhs.level == rhs.level && lhs.name == rhs.name
}

func <(lhs: ScoreObject, rhs: ScoreObject) -> Bool {
	return lhs.score < rhs.score
}

func <=(lhs: ScoreObject, rhs: ScoreObject) -> Bool {
	return lhs.score <= rhs.score
}

func >=(lhs: ScoreObject, rhs: ScoreObject) -> Bool {
	return lhs.score >= rhs.score
}

func >(lhs: ScoreObject, rhs: ScoreObject) -> Bool {
	return lhs.score > rhs.score
}


struct ScoreObject: Equatable {
	var score: Int
	var level: Int
	var name: String
	
	static let anonymousScore = ScoreObject(name: "Anonymous", score: 0, level: 0)
	
	init(name: String, score: Int, level: Int) {
		self.name = name
		self.score = score
		self.level = level
	}
	
	var propertyListRepresentation: NSDictionary {
		return [kHighName: name,
			kHighLevel: level,
			kHighScore: score]
	}
	
	init?(propertyListRepresentation propList: NSDictionary) {
		if let tmpName = propList[kHighName] as? String, tmpLevel = propList[kHighLevel] as? Int, tmpScore = propList[kHighScore] as? Int {
			name = tmpName
			score = tmpScore
			level = tmpLevel
		} else {
			return nil
		}
	}
}
