//
//  ODMananger.m
//  OD
//
//  Created by jason on 11/30/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "ODMananger.h"
#import "SVProgressHUD.h"
#import "TestFlight.h"

#define NSLog(__FORMAT__, ...) TFLog((@"%s [Line %d] " __FORMAT__), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

@implementation ODMananger

- (id)init
{
    self = [super init];
    if (self) {
        
        BOOL development_mode = NO;
        
        NSString *baseURL = development_mode ? @"http://loryn.dbx.tw/odasia/" : @"http://www.o-d.asia";
        
        appDelegate = [UIApplication sharedApplication].delegate;
        self.myClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
        self.IS_DEBUG = NO;
        
        [self.myClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            
            if(status == AFNetworkReachabilityStatusNotReachable)
            {
                [SVProgressHUD showWithStatus:@"無法連上後台, 請確認網路是否正常"
                                     maskType:SVProgressHUDMaskTypeBlack];
            }
            else
            {
                [SVProgressHUD dismiss];
            }
        }];
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
    NSString *path = @"admin/admActionApp/login.php";
    NSDictionary *param = [NSDictionary dictionaryWithObject:code forKey:@"loginPw"];
    [self.myClient postPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [[[NSString alloc] initWithBytes:[responseObject bytes]
                                                 length:[responseObject length]
                                               encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        BOOL result = [ret isEqualToString:@"0"] == YES;
        
        NSLog(@"Login code:[%@] check result:%d", code, result);
        
        if(callback)
            callback(result);
            
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(callback)
            callback(NO);
        
        NSLog(@"Login code:[%@] checked resulted in error:%@", code, error.description);
        
    }];
}

- (void)checkScan:(NSString *)code callback:(void (^)(ScanResult result))callback
{
    NSString *path = @"admin/admActionApp/qrcode.php";
    NSDictionary *param = [NSDictionary dictionaryWithObject:code forKey:@"qrcode"];
    [self.myClient postPath:path parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [[[NSString alloc] initWithBytes:[responseObject bytes]
                                                  length:[responseObject length]
                                                encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        if(self.IS_DEBUG)
            [SVProgressHUD showSuccessWithStatus:ret];
        
        NSLog(@"Scan code:[%@] check result:%@", code, ret);
        
        ScanResult result = ScanResultEnterFAIL;
        
        if([ret isEqualToString:@"1"] == YES)
            result = ScanResultEnterOK;
        else if([ret isEqualToString:@"2"] == YES)
            result = ScanResultEnterFAIL;
        else if([ret isEqualToString:@"3"] == YES)
            result = ScanResultDrinkOK;
        else if([ret isEqualToString:@"4"] == YES)
            result = ScanResultDrinkFAIL;
        
        if(callback)
            callback(result);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(callback)
            callback(ScanResultEnterFAIL);
        
        NSLog(@"Scan code:[%@] checked resulted in error:%@", code, error.description);
        
    }];
}

- (void)submitProfile:(NSDictionary *)profile photo:(UIImage *)photo callback:(void (^)(ProfileResult result))callback
{
    NSString *path = @"admin/admActionApp/vipAdd.php";
    
    NSData *imageData = UIImageJPEGRepresentation(photo, 0.8);
    NSMutableURLRequest *request = [self.myClient multipartFormRequestWithMethod:@"POST" path:path parameters:profile constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:@"image" fileName:@"image.jpg" mimeType:@"image/jpeg"];
    }];
    
    AFHTTPRequestOperation *op = [self.myClient HTTPRequestOperationWithRequest:request success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *ret = [[[NSString alloc] initWithBytes:[responseObject bytes]
                                                 length:[responseObject length]
                                               encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        
        NSLog(@"Profile submitted: %@ Result: %@", profile, ret);
        
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
        
        NSLog(@"Profile submitted: %@ Errored: %@", profile, error.description);
        
    }];
    
    [op start];
}

- (void)downloadQuestion:(void (^)(DownloadResult result))callback
{
    NSString *url = @"http://loryn.dbx.tw/odasia/admin/admActionApp/vipQuestion.php";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFJSONRequestOperation *op = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        //NSLog(@"downloadQuestion: %@", [JSON description]);
        
        self.questions = (NSArray *)JSON;
        
        DownloadResult result = DownloadResultFAIL;
        
        if(self.questions.count)
            result = DownloadResultOK;
        
        if(callback)
            callback(result);
            
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        if(callback)
            callback(DownloadResultFAIL);
        
        NSLog(@"downloadQuestion - url: %@ error: %@", [JSON description], error);
        
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
