//
//  BaseViewController.h
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "ODMananger.h"  

@interface BaseViewController : UIViewController
{
    
}

@property (nonatomic, weak) ODMananger *manager;

- (BOOL)is4inchScreen;
- (BOOL)isRunningiOS6;


@end
