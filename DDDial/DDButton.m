//
//  DDButton.m
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//
//

#import "DDButton.h"

@implementation DDButton
@synthesize midValue, value,title=_title,color=_color,image=_image,imageUrl=_imageUrl;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        cloveImage= [[UIImageView alloc] initWithFrame:CGRectMake(42.5, 15, 45, 45)];
        [self addSubview:cloveImage];
    }
    return self;
}
-(void)dealloc{
    self.image=nil;
    self.title=nil;
    self.color=nil;
    [cloveImage release];
    [super dealloc];
}
-(void)setImage:(UIImage *)image{
    if (![_image isEqual:image]) {
        [_image release];
        _image=[image retain];
        cloveImage.image = image;
    }
}
-(void)setImageUrl:(NSString *)imageUrl{
    if (imageUrl.length<1) {
        return;
    }
    if (![imageUrl isEqualToString:_imageUrl]) {
        [_imageUrl release];
        _imageUrl=[imageUrl retain];
    }
}
-(void)setColor:(UIColor *)color{
    [_color release];
    _color=[color retain];
    for (UILabel*view in self.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            view.textColor=color;
        }
    }
}
-(void)setTitle:(NSString *)title{
    if (![_title isEqualToString:title]) {
        [_title release];
        _title=[title retain];
        for (UILabel*lbl in self.subviews) {
            if ([lbl isKindOfClass:[UILabel class]]) {
                lbl.alpha=0;
                lbl.transform=CGAffineTransformMakeRotation(0);
            }
        }
        int length=title.length;
        if (length>5) {
            length=5;
        }
        for (int i=0; i<length; i++) {
            UILabel*lbl=(UILabel*)[self viewWithTag:i+100];
            if (!lbl) {
                lbl=[[UILabel alloc]init];
                lbl.backgroundColor=[UIColor clearColor];
                lbl.textColor=_color?_color:[UIColor blackColor];
                lbl.tag=i+100;
                lbl.textAlignment=UITextAlignmentCenter;
                lbl.font=[UIFont systemFontOfSize:15];
                [self addSubview:lbl];
                [lbl release];
            }
            lbl.alpha=1.0;
            lbl.text=[title substringWithRange:NSMakeRange(i, 1)];
            int angle=i-length/2;
            int center=60;
            if (length%2==0) {
                if (i>=length/2) {
                    angle=i-length/2+1;
                }
                center=70;
            }
            lbl.frame=CGRectMake(center+(i-length/2)*15, 10+fabsf(angle)*2, 20, 20);
            lbl.transform=CGAffineTransformMakeRotation(M_PI/28*angle);
        }
    }
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    // Drawing code
}


@end
