//
//  DDButton.h
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//
//

#import <UIKit/UIKit.h>
@interface DDButton : UIButton{
    NSString*_title;
    UIColor *_color;
    UIImage *_image;
    NSString*_imageUrl;
    UIImageView *cloveImage;
}
@property(nonatomic,retain)UIImage*image;
@property(nonatomic,retain)NSString*imageUrl;
@property float midValue;
@property int value;
@property(nonatomic,retain)NSString*title;
@property(nonatomic,retain)UIColor *color;
@end
