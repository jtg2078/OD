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
        self.myClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://loryn.dbx.tw"]];
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

- (void)login:(NSString *)code callback:(void (^)(BOOL result))callback
{
    NSLog(@"Now checking login code:[%@]", code);
    
    NSString *path = @"od/admin/admActionApp/login.php";
    NSDictionary *param = [NSDictionary dictionaryWithObject:code forKey:@"loginPw"];
    [self.myClient postPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [[NSString alloc] initWithBytes:[responseObject bytes]
                                                 length:[responseObject length]
                                               encoding:NSUTF8StringEncoding];
        BOOL result = [ret isEqualToString:@"0"] == YES;
        
        if(callback)
            callback(result);
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(callback)
            callback(NO);
        
    }];
}

- (void)checkScan:(NSString *)code callback:(void (^)(ScanResult result))callback
{
    NSString *path = @"";
    NSDictionary *param = [NSDictionary dictionaryWithObject:code forKey:@"code"];
    [self.myClient getPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

/*
 NSData *data = [myDic objectForKey:@"image"];
 
 NSMutableURLRequest *myRequest = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/app/xueCreatPaletteNew.php" parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
 [formData appendPartWithFileData:data name:@"upfile" fileName:@"upfile.jpg" mimeType:@"image/jpeg"];
 }];
 */

- (void)submitProfile:(NSDictionary *)profile photo:(UIImage *)photo callback:(void (^)(ProfileResult result))callback
{
    NSString *path = @"od/admin/admActionApp/vipAdd.php";
    /*
    [self.myClient postPath:path parameters:profile success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [NSString stringWithUTF8String:[responseObject bytes]];
        
        ProfileResult result = ProfileResultFAIL;
        
        if([ret isEqualToString:@"0"] == YES)
            result = ProfileResultOK;
        else if([ret isEqualToString:@"1"] == YES)
            result = ProfileResultFAIL;
        else if([ret isEqualToString:@"2"] == YES)
            result = ProfileResultEXISTED;
        
        if(callback)
            callback(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(callback)
            callback(ProfileResultFAIL);
        
    }];
     */
    
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.8);
    NSMutableURLRequest *request = [self.myClient multipartFormRequestWithMethod:@"post" path:path parameters:profile constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *op = [self.myClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [NSString stringWithUTF8String:[responseObject bytes]];
        
        ProfileResult result = ProfileResultFAIL;
        
        if([ret isEqualToString:@"0"] == YES)
            result = ProfileResultOK;
        else if([ret isEqualToString:@"1"] == YES)
            result = ProfileResultFAIL;
        else if([ret isEqualToString:@"2"] == YES)
            result = ProfileResultEXISTED;
        
        if(callback)
            callback(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(callback)
            callback(ProfileResultFAIL);
        
    }];
    
    [op start];
}

#pragma mark - utility methods

- (UIImage *)captureView:(UIView *)theView
{
    CGRect rect = theView.frame;
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [theView.layer renderInContext:context];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
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
