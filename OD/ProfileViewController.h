//
//  ProfileViewController.h
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SVProgressHUD.h"

@interface ProfileViewController : UITableViewController <UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    
}

@property (nonatomic, strong) UILabel *currentCellLabel;
@property (nonatomic, strong) UILabel *currentCellDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *otherIndustryTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)closeKeyboardPressed:(id)sender;
- (IBAction)screenshotButtonPressed:(id)sender;

@end
