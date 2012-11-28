//
//  PasswordViewController.h
//  OD
//
//  Created by jason on 11/28/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "BaseViewController.h"

@interface PasswordViewController : BaseViewController
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (weak, nonatomic) IBOutlet UIButton *myButton;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;
- (IBAction)closeKeyboardPressed:(id)sender;

- (IBAction)myButtonPressed:(id)sender;

@end
