//
//  ODMananger.h
//  OD
//
//  Created by jason on 11/30/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "AFNetworking.h"

typedef enum{
    ScanResultEnterOK,
    ScanResultEnterFAIL,
    ScanResultDrinkOK,
    ScanResultDrinkFAIL,
}ScanResult;

typedef enum{
    ProfileResultOK,
    ProfileResultFAIL,
    ProfileResultEXISTED,
}ProfileResult;

typedef enum{
    DownloadResultOK,
    DownloadResultFAIL,
}DownloadResult;


@interface ODMananger : NSObject <MFMailComposeViewControllerDelegate>
{
    AppDelegate *appDelegate;
}

@property (nonatomic, strong) AFHTTPClient *myClient;
@property (nonatomic, assign) BOOL IS_DEBUG;
@property (nonatomic, strong) NSArray *questions;

+ (ODMananger *)sharedInstance;
- (void)sendEmailWithImage:(UIImage *)image;

- (void)login:(NSString *)code
     callback:(void (^)(BOOL result))callback;

- (void)checkScan:(NSString *)code
         callback:(void (^)(ScanResult result))callback;

- (void)submitProfile:(NSDictionary *)profile
                photo:(UIImage *)photo
             callback:(void (^)(ProfileResult result))callback;

- (void)downloadQuestion:(void (^)(DownloadResult result))callback;

- (UIImage *)captureView:(UIView *)theView;

@end
