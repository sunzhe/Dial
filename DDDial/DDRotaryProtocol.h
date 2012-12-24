//
//  SMRotaryProtocol.h
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DDButton.h"
#define AnimationRotation (M_PI/3)
#define SELECTEDCOLOR [UIColor redColor]
#define NOMORCOLOR [UIColor blackColor]
@protocol DDRotaryProtocol <NSObject>

- (void) wheelDidChangeValue:(id)theWheel withIndex:(int)index withTitle:(NSString*)title;

@end
