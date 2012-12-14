//
//  BaseViewController.m
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.manager = [ODMananger sharedInstance];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - utilities

- (BOOL)is4inchScreen
{
    return [[UIScreen mainScreen ] bounds].size.height >= 568.0f;
}

- (BOOL)isRunningiOS6
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0;
}

@end
