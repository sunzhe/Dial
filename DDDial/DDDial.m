//
//  DDDial.m
//  DDDial
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//

#import "DDDial.h"
#import "DDButton.h"
@implementation DDDial
@synthesize outWheel,wheel,state,isAnimationing,isAppear,isFirstTime;
-(void)dealloc{
    [outWheel release];
    [wheel release];
    [super dealloc];
}
static DDDial*theDial=nil;
+(DDDial*)defaultDial{
    @synchronized(self){
        if (!theDial) {
            theDial=[[DDDial alloc]initWithFrame:CGRectMake(0, 0, 375, 375)];
        }
        return theDial;
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString*tmpB=[[NSUserDefaults standardUserDefaults]objectForKey:@"DIALISFIRSTUSED"];
        if (tmpB.length<1) {
            isFirstTime=NO;
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"DIALISFIRSTUSED"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else{
            isFirstTime=NO;//[tmpB boolValue];
        }
        theMask=[[UIView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        theMask.backgroundColor=[UIColor colorWithWhite:0 alpha:0.6];
        theMask.alpha=0;
        [self insertSubview:theMask atIndex:0];
        bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 375)];
        bgView.center=CGPointMake(160, [[UIScreen mainScreen] bounds].size.height-18);
        bgView.backgroundColor=[UIColor clearColor];
        [self addSubview:bgView];
        
        outWheel = [[DDOuterWheel alloc] initWithFrame:CGRectMake(0, 0, 360, 360)
                                           andDelegate:self
                                          withSections:12];
        outWheel.center = CGPointMake(187.5, 187.5+180);
        [bgView addSubview:outWheel];
        wheel = [[DDRotaryWheel alloc] initWithFrame:CGRectMake(0, 0, 260, 260)
                                         andDelegate:self
                                        withSections:6];
        
        wheel.outerWheel=outWheel;
        wheel.isCanPress=!isFirstTime;
        wheel.center = CGPointMake(187.5, 187.5+180);
        [bgView addSubview:wheel];
        
        UIImageView *bg1 = [[UIImageView alloc] initWithFrame:bgView.bounds];
        bg1.image = [UIImage imageNamed:@"bg1.png"];
//        [bgView addSubview:bg1];
        [bg1 release];
        
        actionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame=CGRectMake(0, 0, 122, 122);
        actionBtn.center=CGPointMake(187.5, 187.5);
        [actionBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:actionBtn];
        [self loadData];
    }
    return self;
}
-(void)loadData{
    //美食等 分类
    if (!filter) {
        NSString *path=[[NSBundle mainBundle]pathForResource:@"filter" ofType:@"plist"];
        filter = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        wheel.titleList=[NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"class1" ofType:@"plist"]];
        outWheel.titleList=[filter objectForKey:[wheel.titleList objectAtIndex:0]];
        [wheel reset];
        wheel.container.transform=CGAffineTransformMakeRotation(-AnimationRotation);
        outWheel.container.transform=CGAffineTransformMakeRotation(AnimationRotation);
    }
}
-(void)goNext{
    isAppear=!isAppear;
    if (!isAppear) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"HIDETHEDIAL" object:nil];
    }
    if (isAppear&&wheel.titleList.count<1) {
//        [UIAlertView popAlertWithTitle:@"提示" message:@"该城市分类数据没有加载成功哦."];
        [self goNext];
        return;
    }
    self.userInteractionEnabled=NO;
    isAnimationing=YES;
    [UIView beginAnimations:@"animations" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    theMask.alpha=isAppear;
    [UIView commitAnimations];
    state=0;
    [self animations1];
}
-(void)animations1{
    float time=0.1f;
    [UIView beginAnimations:@"animations4" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    wheel.arrow.transform=CGAffineTransformMakeRotation(0);
    [UIView commitAnimations];
    state++;
    time=0.6f;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    if (isAppear){
        [UIView setAnimationDidStopSelector:@selector(animations2)];
        if (state<3) {
            wheel.center=CGPointMake(187.5, 187.5);
        }else{
            [self performSelector:@selector(changeTheArrow) withObject:nil afterDelay:0.1*160.0/180.0];
            outWheel.center=CGPointMake(187.5, 187.5);
        }
    }else{
        bgView.transform=CGAffineTransformMakeScale(0.01, 0.01);
        [UIView setAnimationDidStopSelector:@selector(theEnd)];
    }
    [UIView setAnimationDuration:time];
    [UIView commitAnimations];
}
-(void)animations2{
    state++;
    float time=0.1f;
    [UIView beginAnimations:@"animations2" context:nil];
    [UIView setAnimationDuration:time];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    if (isAppear) {
        if (state<4) {
            
            if (isFirstTime){
                [UIView setAnimationDidStopSelector:@selector(theEnd)];
            }else{
                //[self performSelector:@selector(animations1) withObject:nil afterDelay:0.01];
                [UIView setAnimationDidStopSelector:@selector(animations1)];
            }
            wheel.container.transform=CGAffineTransformRotate(wheel.container.transform,AnimationRotation);
            wheel.arrow.transform=CGAffineTransformMakeRotation(M_PI/12-M_PI/180);
        }else{
            [UIView setAnimationDidStopSelector:@selector(theEnd)];
            outWheel.container.transform=CGAffineTransformRotate(outWheel.container.transform,-AnimationRotation);
            outWheel.arrow.transform=CGAffineTransformMakeRotation(-M_PI/12+M_PI/180);
        }
    }
    [UIView commitAnimations];
}
-(void)theEnd{
    
    
    isAnimationing=NO;
    if (!isAppear) {
        wheel.container.transform=CGAffineTransformRotate(wheel.container.transform,-AnimationRotation);
        if (!isFirstTime) {
            outWheel.container.transform=CGAffineTransformRotate(outWheel.container.transform,AnimationRotation);
        }
        wheel.arrow.hidden=isAppear;
        wheel.arrow.center=CGPointMake(130, 130);
        bgView.transform=CGAffineTransformMakeScale(1, 1);
        wheel.center=CGPointMake(187.5, 187.5+180);
        outWheel.center=CGPointMake(187.5, 187.5+180);
        self.userInteractionEnabled=YES;
    }else{
        float time=0.1f;
        [UIView beginAnimations:@"animations4" context:nil];
        [UIView setAnimationDuration:time];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        if (state<4) {
            wheel.arrow.transform=CGAffineTransformMakeRotation(0);
        }else{
            outWheel.arrow.transform=CGAffineTransformMakeRotation(0);
            self.userInteractionEnabled=YES;
        }
        [UIView commitAnimations];
    }
    
}
-(void)changeTheArrow{
    wheel.arrow.hidden=isAppear;
    if (!isAppear) {
        [self animations1];
    }
}
- (void) wheelDidChangeValue:(id)theWheel withIndex:(int)index withTitle:(NSString*)title{
    if (theWheel==wheel) {
        
        if (isFirstTime) {
            isFirstTime=NO;
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"DIALISFIRSTUSED"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        NSString*title=[wheel.titleList objectAtIndex:index];
        outWheel.titleList=[filter objectForKey:title];
        if (state==2) {
            outWheel.container.transform=CGAffineTransformMakeRotation(AnimationRotation);
            [self animations1];
        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    float dist = [self calculateDistanceFromCenter:point];
    UIView*view=[super hitTest:point withEvent:event];
    if (self.userInteractionEnabled) {
        if (dist>375/2) {
            if (!isAnimationing&&isAppear) {
                //收回转盘
                [self goNext];
            }
            return view;
        }else if (dist > 130) {
            if (isFirstTime&&!isAnimationing&&isAppear) {
                //收回转盘
                [self goNext];
            }
            return outWheel;
        }else if (dist > 60) {
            return wheel;
        }else{
            if (!isAnimationing) {
                //收回转盘
                [self goNext];
            }
            return actionBtn;
        }
    }
    return view;
}

- (float) calculateDistanceFromCenter:(CGPoint)point {
    CGPoint center = bgView.center;
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return sqrt(dx*dx + dy*dy);
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
