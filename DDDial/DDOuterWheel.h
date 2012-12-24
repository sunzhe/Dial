//
//  DDOuterWheel.h
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//
//

#import <UIKit/UIKit.h>
#import "DDRotaryProtocol.h"
@class DDRotaryWheel;
@interface DDOuterWheel : UIControl
{
    CGPoint beginPt;
    int numbersOfData;
    NSMutableArray*_titleList;
    
    CGAffineTransform arrowTransform;
    float arrowAngle;
    int lastValue;
}
@property (assign) id <DDRotaryProtocol> delegate;
@property (nonatomic, strong) UIView *container;
@property (assign)int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, strong) NSMutableArray *cloves;
@property (assign)int currentValue;
@property (assign)int currentTag;
@property(assign)int beginValue;
@property (assign)BOOL isClockwise;
@property (assign)BOOL goClockwise;
@property (assign)BOOL isClick;
@property (assign)DDRotaryWheel*rotaryWheel;
@property(nonatomic,retain)NSMutableArray*titleList;
@property(nonatomic,retain)UIImageView*arrow;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;
-(void)reset;
@end
