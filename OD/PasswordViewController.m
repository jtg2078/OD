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

#pragma mark - memeory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    self.myTextField.inputAccessoryView = self.myToolbar;
}

- (void)viewDidUnload
{
    [self setMyTextField:nil];
    [self setMyToolbar:nil];
    [super viewDidUnload];
}

#pragma mark - main methods

- (BOOL)processEntry
{
    NSString *defaultPassword = @"0000";
    BOOL result = NO;
    
    if([self.myTextField.text isEqualToString:defaultPassword] == YES)
    {
        [self performSegueWithIdentifier:@"goToVIPMainView" sender:self];
        result = YES;
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"密碼不正確"];
    }
    
return result;
}

#pragma mark - user interaction

- (IBAction)closeKeyboardPressed:(id)sender {
    
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goToVIPMainView"])
    {
        UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"登出"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:nil
                                                                  action:nil];
        
        self.navigationItem.backBarButtonItem = button;
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self processEntry];
}


@end
