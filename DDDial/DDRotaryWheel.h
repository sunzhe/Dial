//
//  DDRotaryWheel.h
//  DDRotaryProtocol.h
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.


#import <UIKit/UIKit.h>
#import "DDRotaryProtocol.h"
@class DDOuterWheel;
@interface DDRotaryWheel : UIControl{
    CGPoint beginPt;
    int numbersOfData;
    NSMutableArray*_titleList;
    CGAffineTransform arrowTransform;
    int lastValue;
    
}

@property (assign) id <DDRotaryProtocol> delegate;
@property (nonatomic, retain) UIView *container;
@property (assign)int numberOfSections;
@property CGAffineTransform startTransform;
@property (nonatomic, retain) NSMutableArray *cloves;
@property (assign)int currentValue;
@property (assign)int currentTag;
@property (assign)BOOL isClockwise;
@property (assign)BOOL isCanPress;
@property (assign)DDOuterWheel*outerWheel;
@property(nonatomic,retain)NSMutableArray*titleList;
@property(nonatomic,retain)NSMutableDictionary*urlList;
@property(nonatomic,retain)UIImageView*arrow;
-(void)reset;
- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber;


@end
