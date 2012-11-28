//
//  PasswordViewController.m
//  OD
//
//  Created by jason on 11/28/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@end

@implementation PasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.myTextField.inputAccessoryView = self.myToolbar;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMyTextField:nil];
    [self setMyButton:nil];
    [self setMyToolbar:nil];
    [super viewDidUnload];
}
- (IBAction)closeKeyboardPressed:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)myButtonPressed:(id)sender
{
    NSString *defaultPassword = @"0000";
    
    if([self.myTextField.text isEqualToString:defaultPassword] == YES)
    {
        [self performSegueWithIdentifier:@"goToVIPMainView" sender:self];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"密碼不正確"];
    }
}
@end
