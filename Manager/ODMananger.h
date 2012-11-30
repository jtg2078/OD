//
//  ODMananger.h
//  OD
//
//  Created by jason on 11/30/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "AppDelegate.h"

@interface ODMananger : NSObject <MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDelegate;
}

+ (ODMananger *)sharedInstance;

- (void)sendEmailWithImage:(UIImage *)image;

@end
