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

@interface ProfileViewController : UITableViewController <UIImagePickerControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    int dynamicContentSection;
    int selectedDynamicContentRow;
}

@property (nonatomic, strong) UILabel *currentCellLabel;
@property (nonatomic, strong) UILabel *currentCellDetailLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UITextField *otherIndustryTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *keyboardToolbar;
@property (strong, nonatomic) UIActionSheet *photoActionSheet;
@property (assign, nonatomic) int gender;
@property (strong, nonatomic) NSString *job;

@property (weak, nonatomic) IBOutlet UILabel *imagePlaceholderLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (strong, nonatomic) NSMutableDictionary *preferences;

- (IBAction)submitButtonPressed:(id)sender;
- (IBAction)closeKeyboardPressed:(id)sender;
- (IBAction)screenshotButtonPressed:(id)sender;

@end
