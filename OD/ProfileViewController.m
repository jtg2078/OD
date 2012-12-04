//
//  ProfileViewController.m
//  OD
//
//  Created by jason on 11/27/12.
//  Copyright (c) 2012 jason. All rights reserved.
//

#import "ProfileViewController.h"
#import "InputViewController.h"
#import "UIImage+Resize.h"
#import "AppDelegate.h"
#import "ODMananger.h"

@interface ProfileViewController ()
@property (nonatomic, weak) ODMananger *manager;
@end

@implementation ProfileViewController

#pragma mark - memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - view lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.otherIndustryTextField.inputAccessoryView = self.keyboardToolbar;
    self.manager = [ODMananger sharedInstance];
    
    self.job = @"時尚/精品";
    self.gender = 0;
    
    self.photoActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:@"拍攝照片", @"選擇照片", nil];
}

- (void)viewDidUnload
{
    [self setSubmitButton:nil];
    [self setPhotoView:nil];
    [self setMyTableView:nil];
    [self setOtherIndustryTextField:nil];
    [self setKeyboardToolbar:nil];
    [self setNameLabel:nil];
    [self setBirthdayLabel:nil];
    [self setCellLabel:nil];
    [self setEmailLabel:nil];
    [super viewDidUnload];
}

#pragma mark - segue related

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"pushEditViewController"] == YES)
    {
        InputViewController *ivc = segue.destinationViewController;
        ivc.titleText = self.currentCellLabel.text;
        ivc.detailText = self.currentCellDetailLabel.text;
        ivc.writeBackLabel = self.currentCellDetailLabel;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.section == 0 && indexPath.row == 0)
    {
        // image view, do something else
        self.currentCellLabel = nil;
        self.currentCellDetailLabel = nil;
        
        AppDelegate *delegate = [UIApplication sharedApplication].delegate;
        [self.photoActionSheet showInView:delegate.window.rootViewController.view];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(indexPath.section == 2)
    {
        self.currentCellLabel = nil;
        self.currentCellDetailLabel = nil;
        
        for(int i = 0; i < [tableView numberOfRowsInSection:indexPath.section]; i++)
        {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:idx];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.gender = indexPath.row;
    }
    else if(indexPath.section == 4)
    {
        self.currentCellLabel = nil;
        self.currentCellDetailLabel = nil;
        
        int rowCount = [tableView numberOfRowsInSection:indexPath.section];
        for(int i = 0; i < rowCount; i++)
        {
            NSIndexPath *idx = [NSIndexPath indexPathForRow:i inSection:indexPath.section];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:idx];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        if(indexPath.row == rowCount - 1)
            self.job = self.otherIndustryTextField.text;
        else
            self.job = cell.detailTextLabel.text;
    }
    else
    {
        self.currentCellLabel = cell.textLabel;
        self.currentCellDetailLabel = cell.detailTextLabel;
    }
    
    if(self.currentCellLabel && self.currentCellDetailLabel)
    {
        NSLog(@"%@", self.currentCellLabel.text);
        NSLog(@"%@", self.currentCellDetailLabel.text);
        [self performSegueWithIdentifier:@"pushEditViewController" sender:self];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    /*
    // Resize the image from the camera
	UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit
                                                       bounds:CGSizeMake(self.photoView.frame.size.width,
                                                                         self.photoView.frame.size.height)
                                         interpolationQuality:kCGInterpolationHigh];
    
    // Crop the image to a square
    
    UIImage *croppedImage = [scaledImage croppedImage:CGRectMake((scaledImage.size.width - self.photoView.frame.size.width) / 2, (scaledImage.size.height - self.photoView.frame.size.height) / 2, self.photoView.frame.size.width, self.photoView.frame.size.height)];
     */
    
    // Show the photo on the screen
    self.photoView.image = image;
    [picker dismissModalViewControllerAnimated:NO];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:NO];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        [self takePhoto];
    }
    else if(buttonIndex == 1)
    {
        [self pickPhoto];
    }
}

#pragma mark - user interaction

- (IBAction)submitButtonPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"上傳中"];
    
    // gathering profile info
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    
    [p setObject:self.nameLabel.text                        forKey:@"name"];
    [p setObject:[NSNumber numberWithInt:self.gender]       forKey:@"gender"];
    [p setObject:self.cellLabel.text                        forKey:@"phone"];
    [p setObject:self.emailLabel.text                       forKey:@"email"];
    [p setObject:self.job                                   forKey:@"job"];
    
    NSArray *birthday = [self.birthdayLabel.text componentsSeparatedByString:@"/"];
    [p setObject:[birthday objectAtIndex:0]                 forKey:@"birth_y"];
    [p setObject:[birthday objectAtIndex:1]                 forKey:@"birth_m"];
    [p setObject:[birthday objectAtIndex:2]                 forKey:@"birth_d"];
    
    NSLog(@"profile Dictionary: %@", p);
    
    UIImage *photo = [self.manager captureView:self.photoView];
    
    [self.manager submitProfile:p photo:photo callback:^(ProfileResult result) {
        
        if(result == ProfileResultOK)
        {
            [SVProgressHUD showSuccessWithStatus:@"上傳成功"];
            
            int64_t delayInSeconds = 1.0;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self.navigationController popToRootViewControllerAnimated:NO];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                UITabBarController *tbc = (UITabBarController *)delegate.window.rootViewController;
                tbc.selectedIndex = 0;
            });
        }
        else if(result == ProfileResultEXISTED)
        {
            [SVProgressHUD showErrorWithStatus:@"重覆註冊"];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"上傳失敗"];
        }
    }];
}

- (IBAction)closeKeyboardPressed:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)screenshotButtonPressed:(id)sender
{
    UIImage* image = nil;
    
    UIGraphicsBeginImageContext(self.myTableView.contentSize);
    {
        CGPoint savedContentOffset = self.myTableView.contentOffset;
        CGRect savedFrame = self.myTableView.frame;
        
        self.myTableView.contentOffset = CGPointZero;
        self.myTableView.frame = CGRectMake(0, 0, self.myTableView.contentSize.width, self.myTableView.contentSize.height);
        
        [self.myTableView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        self.myTableView.contentOffset = savedContentOffset;
        self.myTableView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil)
    {
        [self.manager sendEmailWithImage:image];
    }
}

- (void)takePhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
#if TARGET_IPHONE_SIMULATOR
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
#endif
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

- (void)pickPhoto
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.editing = YES;
    imagePickerController.delegate = (id)self;
    
    [self presentModalViewController:imagePickerController animated:YES];
}

@end
