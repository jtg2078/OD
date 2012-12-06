//
//  ScanViewController.m
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()

@end

@implementation ScanViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - zbar related

- (void)zbarSetup
{
    self.myReaderView.readerDelegate = self;
}

- (void)zbarCleanUp
{
    self.myReaderView.readerDelegate = nil;
    [self setMyReaderView:nil];
}

- (void)startZbar
{
    [self.myReaderView start];
}

- (void)stopZbar
{
    [self.myReaderView stop];
}

#pragma mark - init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.confirmButton.hidden = YES;
    
    [self zbarSetup];
    
    if([self is4inchScreen])
    {
        self.defaultOverLayImage = [UIImage imageNamed:@"640x910-w.png"];
        self.okOverLayImage = [UIImage imageNamed:@"640x910-g.png"];
        self.noLayImage = [UIImage imageNamed:@"640x910-r.png"];
        self.bgImage = [UIImage imageNamed:@"640x910-bg.png"];
        self.confirmButton.frame = CGRectMake(60, 340, 200, 45);
    }
    else
    {
        self.defaultOverLayImage = [UIImage imageNamed:@"640x734-w.png"];
        self.okOverLayImage = [UIImage imageNamed:@"640x734-g.png"];
        self.noLayImage = [UIImage imageNamed:@"640x734-r.png"];
        self.bgImage = [UIImage imageNamed:@"640x734-bg.png"];
        self.confirmButton.frame = CGRectMake(60, 296, 200, 45);
    }
    
    self.backgroundView.image = self.bgImage;
    self.overlayView.image = self.defaultOverLayImage;
    
    NSString *successPath = [[NSBundle mainBundle] pathForResource:@"success" ofType:@"wav"];
    NSURL *successURL = [NSURL fileURLWithPath:successPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)successURL, &OKSound);
    
    NSString *failPath = [[NSBundle mainBundle] pathForResource:@"fail" ofType:@"aif"];
    NSURL *failURL = [NSURL fileURLWithPath:failPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)failURL, &FAILSound);
}

- (void)viewDidUnload
{
    [self zbarCleanUp];
    [self setBackgroundView:nil];
    [self setOverlayView:nil];
    [self setConfirmButton:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startZbar];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopZbar];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    [super viewWillDisappear:animated];
}

#pragma mark - user interaction

- (IBAction)confirmButtonPressed:(id)sender
{
    [self scanNormalWithDelay:NO];
    self.confirmButton.hidden = YES;
}

#pragma mark - zbar delegate

- (void)readerView:(ZBarReaderView*)readerView
    didReadSymbols:(ZBarSymbolSet*)symbols
         fromImage:(UIImage*)image
{
    for(ZBarSymbol *sym in symbols)
    {
        NSString *code = sym.data;
        if(self.manager.IS_DEBUG)
        {
            code = @"3c86bed3fc88319c7d594ab0ac0e84e2";
            self.title = code;
        }
        
        [self stopZbar];
        [self.manager checkScan:code callback:^(ScanResult result) {
            
            if(result == ScanResultEnterOK)
            {
                [self scanOk];
                [self scanNormalWithDelay:YES];
            }
            else if (result == ScanResultDrinkOK)
            {
                [self scanOk];
                self.confirmButton.hidden = NO;
            }
            else
            {
                [self scanFail];
                [self scanNormalWithDelay:YES];
            }
            
        }];
        break;
    }
}

- (void)scanOk
{
    AudioServicesPlaySystemSound(OKSound);
    self.overlayView.image = self.okOverLayImage;
}

- (void)scanFail
{
    AudioServicesPlaySystemSound(FAILSound);
    self.overlayView.image = self.noLayImage;
}

- (void)scanNormalWithDelay:(BOOL)delay
{
    if(delay)
    {
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if(self.manager.IS_DEBUG)
                self.title = @"Passbook 掃描";
            
            [self startZbar];
            self.overlayView.image = self.defaultOverLayImage;
        });
    }
    else
    {
        if(self.manager.IS_DEBUG)
            self.title = @"Passbook 掃描";
        
        [self startZbar];
        self.overlayView.image = self.defaultOverLayImage;
    }
}

@end
