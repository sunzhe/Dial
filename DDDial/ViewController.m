//
//  ViewController.m
//  DDDial
//
//  Created by ddmap on 12-10-9.
//  Copyright (c) 2012年 ddmap. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    dial=[[DDDial alloc]initWithFrame:self.view.bounds];
    //dial.center=CGPointMake(160, [[UIScreen mainScreen] bounds].size.height-18);
    [self.view addSubview:dial];
    UIImageView *bg1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 375, 375)];
    bg1.image = [UIImage imageNamed:@"bg1.png"];
    bg1.center=CGPointMake(160, [[UIScreen mainScreen] bounds].size.height-18);
    [self.view addSubview:bg1];
    [bg1 release];
    
//    UIButton*actionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//    actionBtn.frame=CGRectMake(0, 0, 122, 122);
//    actionBtn.center=CGPointMake(187.5, 187.5);
//    [actionBtn addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:actionBtn];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)goNext{
    [dial goNext];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
