//
//  ScanViewController.h
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "BaseViewController.h"

@interface ScanViewController : BaseViewController <ZBarReaderViewDelegate>
{
    SystemSoundID OKSound;
    SystemSoundID FAILSound;
}
@property (weak, nonatomic) IBOutlet ZBarReaderView *myReaderView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *overlayView;

@property (strong, nonatomic) UIImage *bgImage;
@property (strong, nonatomic) UIImage *defaultOverLayImage;
@property (strong, nonatomic) UIImage *okOverLayImage;
@property (strong, nonatomic) UIImage *noLayImage;

@end
