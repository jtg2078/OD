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
    
    [self zbarSetup];
    
    if([self is4inchScreen])
    {
        self.defaultOverLayImage = [UIImage imageNamed:@"640x910-w.png"];
        self.okOverLayImage = [UIImage imageNamed:@"640x910-g.png"];
        self.noLayImage = [UIImage imageNamed:@"640x910-r.png"];
        self.bgImage = [UIImage imageNamed:@"640x910-bg.png"];        
    }
    else
    {
        self.defaultOverLayImage = [UIImage imageNamed:@"640x734-w.png"];
        self.okOverLayImage = [UIImage imageNamed:@"640x734-g.png"];
        self.noLayImage = [UIImage imageNamed:@"640x734-r.png"];
        self.bgImage = [UIImage imageNamed:@"640x734-bg.png"];
        CGRect frame = self.myReaderView.frame;
        frame.origin.y -= 44;
        self.myReaderView.frame = frame;
    }
    
    self.backgroundView.image = self.bgImage;
    self.overlayView.image = self.defaultOverLayImage;
}

- (void)viewDidUnload
{
    [self zbarCleanUp];
    [self setBackgroundView:nil];
    [self setOverlayView:nil];
    [super viewDidUnload];
}

- (void) viewDidAppear: (BOOL) animated
{
    [super viewDidAppear:animated];
    [self startZbar];
}

- (void) viewWillDisappear: (BOOL) animated
{
    [self stopZbar];
    [super viewWillDisappear:animated];
}

#pragma mark - zbar delegate

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    self.overlayView.image = self.okOverLayImage;
    int64_t delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.overlayView.image = self.defaultOverLayImage;
    });
}

@end
