//
//  DDOuterWheel.m
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//
//

#import "DDOuterWheel.h"
#import <QuartzCore/QuartzCore.h>
#import"DDButton.h"
@interface DDOuterWheel()
- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (DDButton *) getCloveByTag:(int)tag;
- (int)getValueByTag:(int)tag;
@end
static float deltaAngle;
@implementation DDOuterWheel

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentTag,currentValue,isClockwise;
@synthesize rotaryWheel,titleList=_titleList,beginValue,goClockwise,arrow,isClick;
-(void)dealloc{
    self.titleList=nil;
    self.arrow=nil;
    self.container=nil;
    self.cloves=nil;
    [super dealloc];
}
- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawWheel];
        self.backgroundColor=[UIColor clearColor];
        self.currentValue = 4;
        currentTag=4;
	}
    return self;
}
- (void) drawWheel {
    if (!container) {
        container = [[UIView alloc] initWithFrame:self.frame];
        cloves = [NSMutableArray arrayWithCapacity:numberOfSections];
    }
    UIImageView *bg5 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    bg5.image = [UIImage imageNamed:@"bg5.png"];
    bg5.center = CGPointMake(180, 180);
    [self addSubview:bg5];
    [bg5 release];
    UIImageView *mask = [[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)]autorelease];
    mask.image =[UIImage imageNamed:@"bg4.png"] ;
    mask.center = CGPointMake(180, 180);
    [container addSubview:mask];
    [self addSubview:container];
    arrow=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    arrow.image =[UIImage imageNamed:@"arrow.png"] ;
    arrow.center = CGPointMake(180, 180);
    [self addSubview:arrow];
    
    CGFloat angleSize = 2*M_PI/numberOfSections;
    for (int i =0 ; i < numberOfSections; i++) {
        DDButton *btn = [[DDButton alloc] initWithFrame:CGRectMake(0, 0, 140, 180)];
        btn.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
        btn.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                         container.bounds.size.height/2.0-container.frame.origin.y);
        btn.transform = CGAffineTransformMakeRotation(angleSize*(i-3));
        btn.tag = i+1;
        btn.midValue = angleSize*(i-3);
        [container addSubview:btn];
    }
    container.userInteractionEnabled = NO;
}
-(void)setTitleList:(NSMutableArray *)titleList{
    if (titleList!=_titleList) {
        [_titleList release];
        _titleList =[titleList retain];
        
        numbersOfData=_titleList.count;
        beginValue=0;
        if (numbersOfData<6) {
            beginValue=3-(numbersOfData-1)/2;
        }
    }
    float radians = atan2f(container.transform.b, container.transform.a);
    if (fabsf(radians)<M_PI*5/180) {
        container.transform=CGAffineTransformMakeRotation(goClockwise?-M_PI/6:M_PI/6);
    }
    [self reset];
}
-(void)reset{
    float radians = atan2f(container.transform.b, container.transform.a);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(arrowReset)];
    if (radians<0||radians>M_PI*178/180) {
        arrow.transform=CGAffineTransformMakeRotation(M_PI/12-M_PI/180);
    }else if (radians>0){
        arrow.transform=CGAffineTransformMakeRotation(-M_PI/12+M_PI/180);
    }
    container.transform=CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    currentValue = 4;
    currentTag=4;
    for (int i = 0; i < numberOfSections; i++) {
        DDButton*btn=(DDButton*)[container viewWithTag:i+1];
        if (i == 3) {
            btn.color = SELECTEDCOLOR;
        }else{
            btn.color=NOMORCOLOR;
        }
        
        btn.value = i+1;
        if (i>numberOfSections/2) {
            btn.value = numbersOfData-(numberOfSections-i-1);
        }
        
        if (numbersOfData<6&&(i-beginValue>numbersOfData)) {
            btn.title=@"";
            continue;
        }
        if ((i>=beginValue&&btn.value<numbersOfData+beginValue+1))  {
            int index=btn.value-4;
            while (index<0) {
                index+=numbersOfData;
            }
            btn.title=[_titleList objectAtIndex:(index%numbersOfData)];
        }else{
            btn.title=@"";
        }
    }
    
}

- (DDButton *) getCloveByTag:(int)tag {
    return (DDButton*)[container viewWithTag:tag];
}
-(int)getValueByTag:(int)tag{
    DDButton*theBtn=(DDButton*)[container viewWithTag:tag];
    return theBtn.value;
}
- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
}
-(void)arrowReset{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    arrow.transform=CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    beginPt=touchPoint;
    float dist = [self calculateDistanceFromCenter:touchPoint];
    if (dist>180)
    {
        return NO;
    }
    
	float dx = touchPoint.x - container.center.x;
	float dy = touchPoint.y - container.center.y;
	deltaAngle = atan2(dy,dx);
    startTransform = container.transform;
    arrowTransform = arrow.transform;
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint pt = [touch locationInView:self];
    
    float dist = [self calculateDistanceFromCenter:pt];
    
    if (dist < 40 || dist > 100)
    {
    }
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    isClockwise=angleDifference<0;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    float radians = atan2f(container.transform.b, container.transform.a);
    
    arrow.transform=CGAffineTransformRotate(arrowTransform,-angleDifference/3);
    float arrowRadians = atan2f(arrow.transform.b, arrow.transform.a);
    if (arrowRadians<-M_PI/12) {
        arrow.transform=CGAffineTransformMakeRotation(-M_PI/12+M_PI/180);
    }else if(arrowRadians>M_PI/12){
        arrow.transform=CGAffineTransformMakeRotation(M_PI/12-M_PI/180);
    }
    
    //当选择的数量过少时 限制转动范围.
    if (numbersOfData<6) {
        float thisRadians=((3-beginValue)*2+1)*M_PI/12-M_PI/180;
        float thisRadians2=((4-beginValue-numbersOfData)*2-1)*M_PI/12+M_PI/180;
        if (radians>thisRadians) {
            radians=thisRadians;
        }else if (radians<thisRadians2) {
            radians=thisRadians2;
        }
        container.transform = CGAffineTransformMakeRotation(radians);
    }
    if(radians<0){
        radians=2*M_PI+radians;
    }
    
    int thisTag;
    for (DDButton *c in container.subviews) {
        if ([c isKindOfClass:[DDButton class]]) {
            CGFloat theVal=c.midValue+radians;
            if (theVal>2*M_PI) {
                theVal-=2*M_PI;
            }
            if ((theVal>-M_PI/numberOfSections&&theVal<M_PI/numberOfSections)||(theVal>M_PI*(2*numberOfSections-1)/numberOfSections&&theVal<M_PI*(numberOfSections*2+1)/numberOfSections)) {
                thisTag=c.tag;
                break;
            }
        }
    }
    if (currentTag!=thisTag) {
        //如果改变了选项
        //取消当前选中
        DDButton*theBtn=nil;
        
        theBtn=[self getCloveByTag:currentTag];
        theBtn.color=NOMORCOLOR;
        
        currentTag=thisTag;
        currentValue=[self getValueByTag:currentTag];
        int theTag;
        int theValue;
        int temp=2;
        if (isClockwise) {
            //如果顺时针 加载前面的
            theTag=currentTag-temp<1?currentTag-temp+numberOfSections:currentTag-temp;
            theBtn=[self getCloveByTag:theTag];
            theValue=[self getValueByTag:currentTag];
            theValue=theValue-temp<1?theValue-temp+numbersOfData:theValue-temp;
        }else{
            //如果逆时针 加载后面的
            theTag=currentTag+temp>numberOfSections?currentTag+temp-numberOfSections:currentTag+temp;
            theBtn=[self getCloveByTag:theTag];
            theValue=[self getValueByTag:currentTag];
            theValue=theValue+temp>numbersOfData?theValue+temp-numbersOfData:theValue+temp;
        }
        if (numbersOfData>5) {
            theBtn.value=theValue;
            int index=theBtn.value-4;
            while (index<0) {
                index+=numbersOfData;
            }
            theBtn.title=[_titleList objectAtIndex:(index%numbersOfData)];
        }
        theBtn=[self getCloveByTag:currentTag];
        theBtn.color=SELECTEDCOLOR;
        //        for (DDButton *c in container.subviews) {
        //            if ([c isKindOfClass:[DDButton class]]) {
        //                if (c.tag==thisTag) {
        //                    c.color=[UIColor redColor];
        //                }else{
        //                    c.color=[UIColor blackColor];
        //                }
        //            }
        //        }
    }
    return YES;
}
- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
    self.userInteractionEnabled=NO;
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    if(radians<0){
        radians=2*M_PI+radians;
    }
    CGFloat newVal = ((((int)(radians*numberOfSections/M_PI))+1)/2)*M_PI*2/numberOfSections;
    CGPoint endPt=[touch locationInView:self];
    float dx = beginPt.x - endPt.x;
	float dy = beginPt.y - endPt.y;
    if (sqrt(dx*dx + dy*dy)<10&&touch) {
        //单击事件
        CGFloat theRadians = atan2f(endPt.x-container.center.x,container.center.y-endPt.y);
        if (fabsf(theRadians)>M_PI/numberOfSections*5) {
            theRadians=theRadians+((theRadians<0)?M_PI/numberOfSections:(-M_PI/numberOfSections));
        }
        if (fabsf(theRadians)<M_PI/numberOfSections) {
            //选择最上端的选项;
            int index=currentValue-4;
            while (index<0) {
                index+=numbersOfData;
            }
            if (_titleList.count>0) {
                //[self.delegate wheelDidChangeValue:self withIndex:index%numbersOfData  withTitle:[_titleList objectAtIndex:index%numbersOfData]];
            }
            //self.userInteractionEnabled=YES;
            //return;
            isClick=YES;
        }else{
            isClick=YES;
            //取消上次选择的高亮
            DDButton *im = [self getCloveByTag:currentTag];
            im.color=NOMORCOLOR;
        }
        //当选择的数量过少时 限制转动范围.
        if (numbersOfData<6) {
            isClick=NO;
            CGFloat radians2 = atan2f(container.transform.b, container.transform.a);
            float thisRadians=((3-beginValue)*2+1)*M_PI/12-M_PI/180;
            float thisRadians2=((4-beginValue-numbersOfData)*2-1)*M_PI/12+M_PI/180;
            if (theRadians<radians2-thisRadians) {
                theRadians=radians2-thisRadians;
                theRadians=M_PI/180-M_PI/numberOfSections;
            }else if(theRadians>radians2-thisRadians2){
                theRadians=radians2-thisRadians2;
                theRadians=M_PI/numberOfSections-M_PI/180;
            }else{
                isClick=YES;
            }
        }
        //判断动画时间
        int times=(int)ceilf(fabsf(theRadians*numberOfSections)/(M_PI*2));
        //判断顺时针逆时针
        isClockwise=theRadians<0;
        int theTag;
        DDButton*theBtn;
        int theValue;
        int temp=3;
        if (isClockwise) {
            //如果顺时针 加载前面的
            theTag=currentTag-temp<1?currentTag-temp+numberOfSections:currentTag-temp;
            theBtn=[self getCloveByTag:theTag];
            theValue=[self getValueByTag:currentTag];
            theValue=theValue-temp<1?theValue-temp+numbersOfData:theValue-temp;
        }else{
            //如果逆时针 加载后面的
            theTag=currentTag+temp>numberOfSections?currentTag+temp-numberOfSections:currentTag+temp;
            theBtn=[self getCloveByTag:theTag];
            theValue=[self getValueByTag:currentTag];
            theValue=theValue+temp>numbersOfData?theValue+temp-numbersOfData:theValue+temp;
        }
        
        if (numbersOfData>5) {
            theBtn.value=theValue;
            int index=theBtn.value-4;
            while (index<0) {
                index+=numbersOfData;
            }
            theBtn.title=[_titleList objectAtIndex:(index%numbersOfData)];
        }
        if (times>1) {
            temp=4;
            if (isClockwise) {
                //如果顺时针 加载前面的
                theTag=currentTag-temp<1?currentTag-temp+numberOfSections:currentTag-temp;
                theBtn=[self getCloveByTag:theTag];
                theValue=[self getValueByTag:currentTag];
                theValue=theValue-temp<1?theValue-temp+numbersOfData:theValue-temp;
            }else{
                temp=4;
                theTag=currentTag+temp>numberOfSections?currentTag+temp-numberOfSections:currentTag+temp;
                theBtn=[self getCloveByTag:theTag];
                theValue=[self getValueByTag:currentTag];
                theValue=theValue+temp>numbersOfData?theValue+temp-numbersOfData:theValue+temp;
            }
            if (numbersOfData>5) {
                theBtn.value=theValue;
                int index=theBtn.value-4;
                while (index<0) {
                    index+=numbersOfData;
                }
                theBtn.title=[_titleList objectAtIndex:(index%numbersOfData)];
            }
        }
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1*times];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endTrackingWithTouch:withEvent:)];
        CGAffineTransform t=CGAffineTransformMakeRotation(radians-theRadians);
        container.transform = t;
        if (isClockwise) {
            arrow.transform=CGAffineTransformMakeRotation(M_PI/12-M_PI/180);
        }else{
            arrow.transform=CGAffineTransformMakeRotation(-M_PI/12+M_PI/180);
        }
        [UIView commitAnimations];
        return;
    }
    int thisTag;
    for (DDButton *c in container.subviews) {
        if ([c isKindOfClass:[DDButton class]]){
            CGFloat theVal=c.midValue+newVal;
            if (theVal>2*M_PI) {
                theVal-=2*M_PI;
            }
            if ((theVal>-M_PI/numberOfSections&&theVal<M_PI/numberOfSections)||(theVal>M_PI*(2*numberOfSections-1)/numberOfSections&&theVal<M_PI*(numberOfSections*2+1)/numberOfSections)) { // anomalous case
                //            NSLog(@"c.midValue=%f",c.midValue/M_PI*180);
                //            NSLog(@"theRadians=%f",theVal/M_PI*180);
                thisTag=c.tag;
                break;
            }
        }
    }
    //    NSLog(@"theRadians=%f",newVal/M_PI*180);
    DDButton *im = [self getCloveByTag:thisTag];
    currentValue=im.value;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(goNext2)];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGAffineTransform t=CGAffineTransformMakeRotation(newVal);
    container.transform = t;
    currentTag=thisTag;
    im.color = SELECTEDCOLOR;
    arrow.transform=CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    
}
-(void)goNext2{
    if (isClick) {
        int index=currentValue-4;
        while (index<0) {
            index+=numbersOfData;
        }
        [self.delegate wheelDidChangeValue:self withIndex:index%numbersOfData  withTitle:[_titleList objectAtIndex:index%numbersOfData]];
        isClick=NO;
    }
    self.userInteractionEnabled=YES;
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
