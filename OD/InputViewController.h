//
//  InputViewController.h
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface InputViewController : BaseViewController <UITextFieldDelegate>
{
    BOOL shouldBringUpKeyboard;
}

@property (weak, nonatomic) IBOutlet UILabel *myLabel;
@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIDatePicker *myDatePicker;
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegement;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@property (strong, nonatomic) NSString *titleText;
@property (strong, nonatomic) NSString *detailText;
@property (weak, nonatomic) UILabel *writeBackLabel;
@property (strong, nonatomic) NSDateFormatter *df;

- (IBAction)datePickerValueChanged:(id)sender;
- (IBAction)segControlValueChanged:(id)sender;

@end
