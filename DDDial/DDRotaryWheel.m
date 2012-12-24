//
//  DDRotaryWheel.m
//  RotaryWheelProject
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.


#import "DDRotaryWheel.h"

#import "DDOuterWheel.h"
@interface DDRotaryWheel()
- (void)drawWheel;
- (float) calculateDistanceFromCenter:(CGPoint)point;
- (DDButton *) getCloveByTag:(int)tag;
- (int)getValueByTag:(int)tag;
@end

static float deltaAngle;

@implementation DDRotaryWheel

@synthesize delegate, container, numberOfSections, startTransform, cloves, currentTag,currentValue,isClockwise;
@synthesize outerWheel,titleList=_titleList,arrow,urlList,isCanPress;

- (id) initWithFrame:(CGRect)frame andDelegate:(id)del withSections:(int)sectionsNumber {
    
    if ((self = [super initWithFrame:frame])) {
        numbersOfData=20;
        lastValue=self.currentValue=2;
        self.currentTag = 2;
        self.numberOfSections = sectionsNumber;
        self.delegate = del;
		[self drawWheel];
	}
    return self;
}

- (void) drawWheel {
    //,@"icon4",@"icon5",@"icon6"
    //_titleList=[[NSMutableArray alloc]initWithObjects:@"icon1",@"icon2",@"icon3",@"icon4",@"icon5",@"icon6", nil];
    self.backgroundColor=[UIColor clearColor];
    container = [[UIView alloc] initWithFrame:self.bounds];
    container.backgroundColor=[UIColor clearColor];
    UIImageView *bg3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    bg3.image = [UIImage imageNamed:@"bg3.png"];
    bg3.center = CGPointMake(130, 130);
    [self addSubview:bg3];
    [bg3 release];
    
    UIImageView *mask = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    mask.image =[UIImage imageNamed:@"bg2.png"] ;
    mask.center = CGPointMake(130, 130);
    [container addSubview:mask];
    
    [self addSubview:container];
    
    arrow=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    arrow.image =[UIImage imageNamed:@"arrow_2.png"] ;
    arrow.center = CGPointMake(130, 130);
    //arrow.hidden=YES;
    [self addSubview:arrow];
    
    UIImageView *bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    bg1.image = [UIImage imageNamed:@"bg1.png"];
    bg1.center=CGPointMake(130, 134);
    //[self addSubview:bg1];
    [bg1 release];
    
    numbersOfData=_titleList.count;
    CGFloat angleSize = 2*M_PI/numberOfSections;
    for (int i = 0; i < numberOfSections; i++) {
        DDButton *btn = [[DDButton alloc] initWithFrame:CGRectMake(0, 0, 130, 130)];
        btn.layer.anchorPoint = CGPointMake(0.5f, 1.0f);
        btn.layer.position = CGPointMake(container.bounds.size.width/2.0-container.frame.origin.x,
                                         container.bounds.size.height/2.0-container.frame.origin.y);
        btn.transform = CGAffineTransformMakeRotation(angleSize*(i-1));
        btn.tag = i+1;
        
        btn.midValue = angleSize*(i-1);
        [container addSubview:btn];
    }
    container.userInteractionEnabled = NO;
}
-(void)setTitleList:(NSMutableArray *)titleList{
    if (titleList!=_titleList) {
        [_titleList release];
        _titleList =[titleList retain];
        
        numbersOfData=_titleList.count;
    }
}
-(void)reset{
    
    [outerWheel reset];
    container.transform=CGAffineTransformMakeRotation(0);
    for (int i = 0; i < numberOfSections; i++) {
        DDButton*btn=(DDButton*)[container viewWithTag:i+1];
        btn.value = i+1;
        if (i>numberOfSections/2) {
            btn.value = numbersOfData-(numberOfSections-i-1);
        }
        
        int index=btn.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        NSString*aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
        if (urlList.count>0) {
            NSDictionary*aDic=[urlList objectForKey:aTitle];
            NSString*aUrl;
            if (i == 1) {
                aUrl=[aDic objectForKey:@"img2"];
            }else{
                aUrl=[aDic objectForKey:@"img"];
            }
            if (aUrl) {
                btn.imageUrl=aUrl;
            }
        }else{
            btn.title=aTitle;
            if (i == 1) {
                btn.color=SELECTEDCOLOR;
            }else{
                btn.color=NOMORCOLOR;
            }
        }
       
        
    }
    lastValue=currentValue = 2;
    currentTag=2;
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
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchPoint = [touch locationInView:self];
    beginPt=touchPoint;
    //    float dist = [self calculateDistanceFromCenter:touchPoint];
    //    NSLog(@"bbbb1111ignoring tap (%f,%f)  dist=%f", touchPoint.x, touchPoint.y,dist);
    //
    //    if (dist < 30 || dist > 130)
    //    {
    //        NSLog(@"bbbb2222ignoring tap (%f,%f)  dist=%f", touchPoint.x, touchPoint.y,dist);
    //        return NO;
    //    }
    
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
    
    if (dist < 30 || dist > 130)
    {
    }
	float dx = pt.x  - container.center.x;
	float dy = pt.y  - container.center.y;
	float ang = atan2(dy,dx);
    
    float angleDifference = deltaAngle - ang;
    isClockwise=angleDifference<0;
    outerWheel.goClockwise=isClockwise;
    container.transform = CGAffineTransformRotate(startTransform, -angleDifference);
    
    CGFloat radians = atan2f(container.transform.b, container.transform.a);
    
    arrow.transform=CGAffineTransformRotate(arrowTransform,-angleDifference/3);
    float arrowRadians = atan2f(arrow.transform.b, arrow.transform.a);
    if (arrowRadians<-M_PI/12) {
        arrow.transform=CGAffineTransformMakeRotation(-M_PI/12+M_PI/180);
    }else if(arrowRadians>M_PI/12){
        arrow.transform=CGAffineTransformMakeRotation(M_PI/12-M_PI/180);
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
            if ((theVal>-M_PI/6&&theVal<M_PI/6)||(theVal>M_PI*11/6&&theVal<M_PI*13/6)) {
                thisTag=c.tag;
                break;
            }
        }
    }
    if (currentTag!=thisTag) {
        //如果改变了选项
        //取消当前选中
        DDButton*theBtn=[self getCloveByTag:currentTag];
        int index=theBtn.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        NSString*aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
        if (urlList.count>0) {
            NSDictionary*aDic=[urlList objectForKey:aTitle];
            theBtn.imageUrl=[aDic objectForKey:@"img"];
        }else{
            theBtn.color=NOMORCOLOR;
        }
        
        
        currentTag=thisTag;
        currentValue=[self getValueByTag:currentTag];
        //高亮本次选择
        theBtn=[self getCloveByTag:currentTag];
        index=theBtn.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
        if (urlList.count>0){
            NSDictionary*aDic=[urlList objectForKey:aTitle];
            theBtn.imageUrl=[aDic objectForKey:@"img2"];
        }else{
            theBtn.color=SELECTEDCOLOR;
        }
        
        
        
        //预加载图片
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
        theBtn.value=theValue;
        index=theBtn.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
        if (urlList.count>0){
            NSDictionary*aDic=[urlList objectForKey:aTitle];
            theBtn.imageUrl=[aDic objectForKey:@"img"];
        }else{
            theBtn.title=aTitle;
            theBtn.color=NOMORCOLOR;
        }
        
        
        //        for (DDButton *btn in container.subviews) {
        //            if ([btn isKindOfClass:[DDButton class]]) {
        //                index=btn.value-2;
        //                while (index<0) {
        //                    index+=numbersOfData;
        //                }
        //                if (btn.tag==thisTag) {
        //                    btn.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon%i_1.png", index%numbersOfData]];
        //                }else{
        //                    btn.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon%i.png", index%numbersOfData]];
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
    CGFloat newVal = ((((int)(radians*6/M_PI))+1)/2)*M_PI/3;
    CGPoint endPt=[touch locationInView:self];
    float dx = beginPt.x - endPt.x;
	float dy = beginPt.y - endPt.y;
    if (sqrt(dx*dx + dy*dy)<10&&touch) {
        //单击事件
        DDButton *im = [self getCloveByTag:currentTag];
        int index=im.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        CGFloat theRadians = atan2f(endPt.x-container.center.x,container.center.y-endPt.y);
        outerWheel.goClockwise=theRadians<0;
        if (fabsf(theRadians)<M_PI/6) {
            //选择最上端的选项;
            isCanPress=YES;
        }else{
            //取消上次选择的
            NSString* aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
            if (urlList.count>0){
                NSDictionary* aDic=[urlList objectForKey:aTitle];
                im.imageUrl=[aDic objectForKey:@"img"];
            }else{
                im.color=NOMORCOLOR;
            }
            
        }
        //设置动画时间
        int times=(int)ceilf(theRadians*3/M_PI);
        if (times<1) {
            times=1;
        }
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
        //加载图片
        theBtn.value=theValue;
        index=theBtn.value-2;
        while (index<0) {
            index+=numbersOfData;
        }
        NSString* aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
        if (urlList.count>0){
            NSDictionary* aDic=[urlList objectForKey:aTitle];
            theBtn.imageUrl=[aDic objectForKey:@"img"];
        }else{
            theBtn.color=NOMORCOLOR;
            theBtn.title=aTitle;
        }
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2*times];
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
    //查找选择项
    int thisTag;
    for (DDButton *c in container.subviews) {
        if ([c isKindOfClass:[DDButton class]]) {
            CGFloat theVal=c.midValue+newVal;
            if (theVal>2*M_PI) {
                theVal-=2*M_PI;
            }
            if ((theVal>-M_PI/6&&theVal<M_PI/6)||(theVal>M_PI*11/6&&theVal<M_PI*13/6)) {
                thisTag=c.tag;
                break;
            }
        }
    }
    DDButton *im = [self getCloveByTag:thisTag];
    currentValue=im.value;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    CGAffineTransform t=CGAffineTransformMakeRotation(newVal);
    container.transform = t;
    currentTag=thisTag;
    arrow.transform=CGAffineTransformMakeRotation(0);
    
    //高亮本次选择
    int index=im.value-2;
    while (index<0) {
        index+=numbersOfData;
    }
    NSString*aTitle=[_titleList objectAtIndex:(index%numbersOfData)];
    if (urlList.count>0) {
        NSDictionary* aDic=[urlList objectForKey:aTitle];
        im.imageUrl=[aDic objectForKey:@"img2"];
        [UIView commitAnimations];
    }else{
        im.title=aTitle;
        im.color=SELECTEDCOLOR;
    }
    if (isCanPress) {
        [self.delegate wheelDidChangeValue:self withIndex:index%numbersOfData  withTitle:[_titleList objectAtIndex:index%numbersOfData]];
        lastValue=currentValue;
    }
    self.userInteractionEnabled=YES;
}

@end
