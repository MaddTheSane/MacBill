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

class Bill {
	// MARK: private data types shared between all objects
	private static var didStaticInit: dispatch_once_t = 0
	static func loadImages() {
		dispatch_once(&didStaticInit) {
			
		}
	}
	//static MBPicture *lcels[WCELS], *rcels[WCELS], *acels[ACELS], *dcels[DCELS];
	private static var walkLeftCells: [NSImage] = []
	private static var walkRightCells: [NSImage] = []
	private static var switchCells: [NSImage] = []
	private static var deathCells: [NSImage] = []

	
	private(set) var state = BillState.In
	
	init() {
		
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
