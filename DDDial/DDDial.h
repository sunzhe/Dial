//
//  DDDial.h
//  DDDial
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import"DDRotaryWheel.h"
#import "DDOuterWheel.h"
@interface DDDial : UIView<DDRotaryProtocol>{
    UIView*initialWheel;
    UIView*initialOutWheel;
    UIView *bgView;
    UIView*theMask;
    UIButton *actionBtn;
    int outValue;
    int value;
    NSMutableDictionary *filter ;
    NSMutableDictionary *brandidDic ;
}
-(void)goNext;
+(DDDial*)defaultDial;
@property (nonatomic,readonly)DDRotaryWheel*wheel;
@property (nonatomic,readonly)DDOuterWheel*outWheel;
@property int state;
@property BOOL isAnimationing;
@property BOOL isAppear;
@property BOOL isFirstTime;
@end
