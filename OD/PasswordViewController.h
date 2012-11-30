//
//  PasswordViewController.h
//  OD
//
//  Created by jason on 11/28/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "BaseViewController.h"

@interface PasswordViewController : BaseViewController <UITextFieldDelegate>
{
    
}

@property (weak, nonatomic) IBOutlet UITextField *myTextField;
@property (strong, nonatomic) IBOutlet UIToolbar *myToolbar;

- (IBAction)closeKeyboardPressed:(id)sender;

@end
