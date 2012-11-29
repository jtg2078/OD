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

#pragma mark - memory management

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
        
        self.descriptionLabel.text = @"日期格式為 年/月/日";
        [self.descriptionLabel sizeToFit];
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
                
                self.descriptionLabel.text = @"範例:\n\(02)2123-4567\n0936-123-456\n0936123456";
                [self.descriptionLabel sizeToFit];
            }
            else if([self.myLabel.text isEqualToString:@"Email"] == YES)
            {
                self.myTextField.keyboardType = UIKeyboardTypeEmailAddress;
            }
            else if([self.myLabel.text isEqualToString:@"抽菸品牌"] == YES)
            {
                self.descriptionLabel.text = @"以逗號作為區分, 例如:\n大衛杜夫,DUNHILL,七星";
                [self.descriptionLabel sizeToFit];
            }
            else if([self.myLabel.text isEqualToString:@"喜愛時尚品牌"] == YES)
            {
                self.descriptionLabel.text = @"以逗號作為區分, 例如:\nTIFFANY,CHANEL,Armani";
                [self.descriptionLabel sizeToFit];
            }
            else if([self.myLabel.text isEqualToString:@"喜愛音樂類型"] == YES)
            {
                self.descriptionLabel.text = @"以逗號作為區分, 例如:\nPOP,RAP,ROCK";
                [self.descriptionLabel sizeToFit];
            }
            
            shouldBringUpKeyboard = YES;
        }
        
    }
}

- (void)viewDidUnload
{
    [self setMyLabel:nil];
    [self setMyTextField:nil];
    [self setMyDatePicker:nil];
    [self setMySegement:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    self.writeBackLabel.text = self.myTextField.text;
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if(shouldBringUpKeyboard)
    {
        [self.myTextField becomeFirstResponder];
    }
}

#pragma mark - user interaction

- (IBAction)datePickerValueChanged:(id)sender
{
    
    self.myTextField.text = [self.df stringFromDate:self.myDatePicker.date];
}

- (IBAction)segControlValueChanged:(id)sender
{
    self.myTextField.text = [self.mySegement titleForSegmentAtIndex:self.mySegement.selectedSegmentIndex];
}


@end
