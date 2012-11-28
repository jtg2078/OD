//
//  InputViewController.m
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
    
    self.myLabel.text = self.titleText;
    self.myTextField.text = self.detailText;
    
    if([self.myLabel.text isEqualToString:@"生日"] == YES)
    {
        if([self is4inchScreen] == NO)
        {
            CGRect frame = self.myDatePicker.frame;
            frame.origin.y -= 88;
            self.myDatePicker.frame = frame;
        }
        
        self.myDatePicker.hidden = NO;
        self.mySegement.hidden = YES;
        self.myTextField.enabled = NO;
        
        self.df = [[NSDateFormatter alloc] init];
        self.df.dateFormat = @"yyyy/MM/dd";
        
        NSDate *date = [self.df dateFromString:self.myTextField.text];
        if(date)
           [self.myDatePicker setDate:date];
    }
    else
    {
        self.myDatePicker.hidden = YES;
        
        if([self.myLabel.text isEqualToString:@"性別"] == YES)
        {
            self.myTextField.enabled = NO;
            self.mySegement.hidden = NO;
            [self.mySegement removeAllSegments];
            [self.mySegement insertSegmentWithTitle:@"男性" atIndex:0 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"女性" atIndex:1 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"中性" atIndex:2 animated:NO];
            
            if([self.myTextField.text isEqualToString:@"男性"] == YES)
                self.mySegement.selectedSegmentIndex = 0;
            else if([self.myTextField.text isEqualToString:@"女性"] == YES)
                self.mySegement.selectedSegmentIndex = 1;
            else
                self.mySegement.selectedSegmentIndex = 2;
        }
        else if([self.myLabel.text isEqualToString:@"性向"] == YES)
        {
            self.myTextField.enabled = NO;
            self.mySegement.hidden = NO;
            [self.mySegement removeAllSegments];
            [self.mySegement insertSegmentWithTitle:@"異性戀" atIndex:0 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"雙性戀" atIndex:1 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"同性戀" atIndex:2 animated:NO];
            
            if([self.myTextField.text isEqualToString:@"異性戀"] == YES)
                self.mySegement.selectedSegmentIndex = 0;
            else if([self.myTextField.text isEqualToString:@"雙性戀"] == YES)
                self.mySegement.selectedSegmentIndex = 1;
            else
                self.mySegement.selectedSegmentIndex = 2;
        }
        else if([self.myLabel.text isEqualToString:@"是否吸菸"] == YES)
        {
            self.myTextField.enabled = NO;
            self.mySegement.hidden = NO;
            [self.mySegement removeAllSegments];
            [self.mySegement insertSegmentWithTitle:@"是" atIndex:0 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"否" atIndex:1 animated:NO];
            
            if([self.myTextField.text isEqualToString:@"是"] == YES)
                self.mySegement.selectedSegmentIndex = 0;
            else
                self.mySegement.selectedSegmentIndex = 1;
        }
        else if([self.myLabel.text isEqualToString:@"是否飲酒"] == YES)
        {
            self.myTextField.enabled = NO;
            self.mySegement.hidden = NO;
            [self.mySegement removeAllSegments];
            [self.mySegement insertSegmentWithTitle:@"是" atIndex:0 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"否" atIndex:1 animated:NO];
            
            if([self.myTextField.text isEqualToString:@"是"] == YES)
                self.mySegement.selectedSegmentIndex = 0;
            else
                self.mySegement.selectedSegmentIndex = 1;
        }
        else if([self.myLabel.text isEqualToString:@"是否有聽演唱會的習慣"] == YES)
        {
            self.myTextField.enabled = NO;
            self.mySegement.hidden = NO;
            [self.mySegement removeAllSegments];
            [self.mySegement insertSegmentWithTitle:@"是" atIndex:0 animated:NO];
            [self.mySegement insertSegmentWithTitle:@"否" atIndex:1 animated:NO];
            
            if([self.myTextField.text isEqualToString:@"是"] == YES)
                self.mySegement.selectedSegmentIndex = 0;
            else
                self.mySegement.selectedSegmentIndex = 1;
        }
        else
        {
            self.myTextField.enabled = YES;
            self.mySegement.hidden = YES;
            self.myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
            
            if([self.myLabel.text isEqualToString:@"電話"] == YES)
            {
                self.myTextField.keyboardType = UIKeyboardTypeNumberPad;
            }
            else if([self.myLabel.text isEqualToString:@"Email"] == YES)
            {
                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
            }
            
            shouldBringUpKeyboard = YES;
        }
        
    }
}

- (void)viewDidUnload {
    [self setMyLabel:nil];
    [self setMyTextField:nil];
    [self setMyDatePicker:nil];
    [self setMySegement:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(shouldBringUpKeyboard)
    {
        [self.myTextField becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.writeBackLabel.text = self.myTextField.text;
    [super viewWillDisappear:animated];
}

- (IBAction)datePickerValueChanged:(id)sender
{
    
    self.myTextField.text = [self.df stringFromDate:self.myDatePicker.date];
}

- (IBAction)segControlValueChanged:(id)sender
{
    self.myTextField.text = [self.mySegement titleForSegmentAtIndex:self.mySegement.selectedSegmentIndex];
}


@end
