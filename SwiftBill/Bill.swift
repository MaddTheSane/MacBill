//
//  Bill.swift
//  StepBill
//
//  Created by C.W. Betts on 5/25/15.
//  Copyright (c) 2015 C.W. Betts. All rights reserved.
//

import Cocoa

/** Bill's states */
enum BillState {
	case In
	case At
	case Out
	case Dying
	case Stray
}

/* Offsets from upper right of computer */
let BillOffsetX = 20
let BillOffsetY = 3


/** speed at which OS drops */
private let Gravity = 3

/* speed of moving Bill */
let SLOW = 0
let FAST = 1

/** # of bill walking animation frames */
private let walkingCells = 4

/** # of bill dying animation frames */
private let dyingCells = 5

/** # of bill switching OS frames */
private let switchingCells = 13

final class Bill {
	// MARK: private data types shared between all objects
	private static var didStaticInit: dispatch_once_t = 0
	static func loadImages() {
		dispatch_once(&didStaticInit) {
			for i in 0..<(walkingCells - 1) {
				if let lImage = loadPicture(named: "billL", index: i), rImage = loadPicture(named: "billR", index: i) {
					self.walkLeftCells.append(lImage)
					self.walkRightCells.append(rImage)
				}
				self.walkLeftCells.append(self.walkLeftCells[1])
				self.walkRightCells.append(self.walkRightCells[1])
				
				for i in 0 ..< dyingCells {
					if let dieBill = loadPicture(named: "billD", index: i) {
						self.deathCells.append(dieBill)
					}
				}
				
				for i in 0 ..< switchingCells {
					if let billS = loadPicture(named: "billA", index: i) {
						self.switchCells.append(billS)
					}
				}
			}
		}
	}
	//static MBPicture *lcels[WCELS], *rcels[WCELS], *acels[ACELS], *dcels[DCELS];
	private static var walkLeftCells: [NSImage] = []
	private static var walkRightCells: [NSImage] = []
	private static var switchCells: [NSImage] = []
	private static var deathCells: [NSImage] = []

	
	private(set) var state = BillState.In
	private var index = 0
	private var cels = walkLeftCells
	private(set) var cargo = OSes.Wingdows
	//private(set) weak var targetComputer: Computer!

	init() {
		
	}
	
	func draw() {
		
	}
	
	func update() {
		
	}
}
/*
@interface MBBill : NSObject
{
@public
BillState state;		/* what is it doing? */
int index;		/* index of animation frame */
MBPicture **cels;		/* array of animation frames */
int x, y;		/* location */
int target_x;		/* target x position */
int target_y;		/* target y position */
int target_c;		/* target computer */
int cargo;		/* which OS carried */
int x_offset;		/* accounts for width differences */
int y_offset;		/* 'bounce' factor for OS carried */
int sx, sy;		/* used for drawing extra OS during switch */
MBBill *prev, *next;
}

@property (readonly) BillState state;
@property (readonly) int height;

@property (readonly) int x;
@property (readonly) int y;

+ (void)Bill_class_init:g :h :n :o :u;

+ (instancetype)newBill;
- (void)draw;
- (void)update;
- (void)killBill;
- (BOOL)clickedAtX:(int)locx y:(int)locy;
- (BOOL)clickedStrayAtX:(int)locx y:(int)locy;
+ (void)Bill_load_pix;
+ (int)width;

@end
*/
