//
//  ODMananger.m
//  OD
//
//  Created by jason on 11/30/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "ODMananger.h"
#import "SVProgressHUD.h"

@implementation ODMananger

- (id)init
{
    self = [super init];
    if (self) {
        appDelegate = [UIApplication sharedApplication].delegate;
    }
    return self;
}

- (void)sendEmailWithImage:(UIImage *)image
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"OD app"];
    
    // Set up recipients
    NSArray *toRecipients = [NSArray arrayWithObject:@""];
    [picker setToRecipients:toRecipients];
    
    // Attach the image to the email
    NSData* data = UIImagePNGRepresentation(image);
    [picker addAttachmentData:data mimeType:@"image/png" fileName:@"screenshot"];
    
    // Fill out the email body text
    NSString *emailBody = @"";
    [picker setMessageBody:emailBody isHTML:NO];
    
    [appDelegate.window.rootViewController presentModalViewController:picker animated:YES];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if(error)
    {
        [SVProgressHUD showErrorWithStatus:error.description];
    }
    else
    {
        if(result == MFMailComposeResultSent)
            [SVProgressHUD showSuccessWithStatus:@"傳送成功"];
    }
    
    [appDelegate.window.rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - singleton implementation code

static ODMananger *singletonManager = nil;
+ (ODMananger *)sharedInstance {
    
    static dispatch_once_t pred;
    static ODMananger *manager;
    
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (singletonManager == nil) {
            singletonManager = [super allocWithZone:zone];
            return singletonManager;  // assignment and return on first allocation
        }
    }
    return nil; // on subsequent allocation attempts return nil
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
