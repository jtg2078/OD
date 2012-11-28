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

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
        
        [self takePhoto];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    else if(indexPath.section == 2 && indexPath.row == 6)
    {
        // concert view is using custom cell
        
        UILabel *titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *detailLabel = (UILabel *)[cell.contentView viewWithTag:2];
        self.currentCellLabel = titleLabel;
        self.currentCellDetailLabel = detailLabel;
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

- (IBAction)submitButtonPressed:(id)sender
{
    [SVProgressHUD showWithStatus:@"上傳中"];
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [SVProgressHUD showSuccessWithStatus:@"上傳成功"];
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)viewDidUnload {
    [self setSubmitButton:nil];
    [self setPhotoView:nil];
    [super viewDidUnload];
}

#pragma mark - misc methods

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

@end
