//
//  MessageComposerViewController_iPad.m
//  eXo Platform
//
//  Created by Tran Hoai Son on 7/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MessageComposerViewController_iPad.h"
#import "ActivityStreamBrowseViewController.h"
#import "AppDelegate_iPad.h"
#import "RootViewController.h"
#import "LanguageHelper.h"

@implementation MessageComposerViewController_iPad


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

- (void)setHudPosition {
    _hudMessageComposer.center = CGPointMake(self.view.center.x, self.view.center.y-70);
}

-(void)dealloc 
{
    [_photoActionViewController release];
    [super dealloc];
}

- (void)showActionSheetForPhotoAttachment
{
    if (_photoActionViewController == nil) 
    {
        _photoActionViewController = [[PhotoActionViewController alloc] initWithNibName:@"PhotoActionViewController" bundle:nil];
        _photoActionViewController._delegate = self;
    }
    
    if (_popoverPhotoLibraryController == nil) 
    {
        _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:_photoActionViewController];
    }
    else
    {
        [_popoverPhotoLibraryController setContentViewController:_photoActionViewController];
    }
    [_popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 132) animated:YES];
    [_popoverPhotoLibraryController presentPopoverFromRect:[_btnAttach frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
}

- (void)showPhotoLibrary
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    thePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    thePicker.allowsEditing = YES;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    thePicker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    thePicker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    if (_popoverPhotoLibraryController == nil) 
    {
        _popoverPhotoLibraryController = [[UIPopoverController alloc] initWithContentViewController:thePicker];
    }
    else
    {
        [_popoverPhotoLibraryController setContentViewController:thePicker];   
    }
    [_popoverPhotoLibraryController setPopoverContentSize:CGSizeMake(320, 320) animated:YES];
    [_popoverPhotoLibraryController presentPopoverFromRect:[_btnAttach frame] inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [thePicker release];
}

- (void)onBtnTakePhoto
{
    UIImagePickerController *thePicker = [[UIImagePickerController alloc] init];
    thePicker.delegate = self;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {  
        thePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        thePicker.allowsEditing = YES;
        [self presentModalViewController:thePicker animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Localize(@"TakeAPicture")  message:Localize(@"CameraNotAvailable") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [thePicker release];
}

- (void)onBtnPhotoLibrary
{
    [self showPhotoLibrary];
}

- (void)onBtnCancel
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
}

- (void)addPhotoToView:(UIImage *)image
{
    [_popoverPhotoLibraryController dismissPopoverAnimated:YES];
    
    [[self.view viewWithTag:1] removeFromSuperview];
    [[self.view viewWithTag:2] removeFromSuperview];
    
    CGSize size = [image size];
    BOOL bCheck = NO;
    if (size.width > size.height) 
    {
        bCheck = YES;
    }
    
    CGRect rect;
    if (bCheck) 
    {
        rect = CGRectMake(10, self.view.frame.size.height - (50 + 10), 50*size.width/size.height, 50);
    }
    else
    {
        rect = CGRectMake(10, self.view.frame.size.height - (50*size.height/size.width + 10), 50, 50*size.height/size.width);
    }
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:rect];
    imgView.tag = 1;
    imgView.image = image;
    [self.view addSubview:imgView];
    
    UIButton *btnPhotoActivity = [[UIButton alloc] initWithFrame:rect];
    btnPhotoActivity.tag = 2;
    [btnPhotoActivity addTarget:self action:@selector(showPhotoActivity:) forControlEvents:UIControlEventTouchUpInside];
    [btnPhotoActivity setBackgroundImage:image forState:UIControlStateNormal];
    
    [self.view addSubview:btnPhotoActivity];
    
}

- (void)showPhotoActivity:(UIButton *)sender
{
    self.navigationItem.title = Localize(@"AttachedPhoto");
    [self._btnSend setTitle:Localize(@"Delete") forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    [self.view sendSubviewToBack:sender];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    
    CGSize size = imgView.frame.size;
    
    CGRect screenRect = self.navigationController.view.superview.superview.frame;
    CGRect selfRect = self.navigationController.view.superview.frame;
    
    CGRect rect;
    
    float tmpHeight = screenRect.size.height - selfRect.origin.y;
    if (540*size.height/size.width > tmpHeight) 
    {
        rect = CGRectMake((540 - size.width*tmpHeight/size.height)/2, 0, size.width*tmpHeight/size.height, tmpHeight);
        imgView.frame = CGRectMake(0, 0, 540, tmpHeight);
    }
    else
    {
        rect = CGRectMake(0, 0, 540, 540*size.height/size.width );
        imgView.frame = rect;
    }
    
    //imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height + 400);
    //imgView.frame = rect;
    self.navigationController.view.frame = imgView.frame;
    self.view.frame = imgView.frame;
    
    [UIView commitAnimations];
    
    [self.view bringSubviewToFront:imgView];
    [_txtvMessageComposer resignFirstResponder];
    [_txtvMessageComposer setUserInteractionEnabled:NO];    
}


- (void)deleteAttachedPhoto
{
    [self._btnSend setTitle:Localize(@"Send")  forState:UIControlStateNormal];
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    
    CGRect frame = imgView.frame;
    frame.size.height = 265;
    
    CGRect rect = [(UIButton *)[self.view viewWithTag:2] frame];
    [[self.view viewWithTag:2] removeFromSuperview];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, 0, 0);
    self.navigationController.view.frame = frame;
    self.view.frame = frame;
    
    [UIView commitAnimations];
    [_txtvMessageComposer setUserInteractionEnabled:YES];
}

- (void)cancelDisplayAttachedPhoto
{
    [self._btnSend setTitle:Localize(@"Send") forState:UIControlStateNormal];
    CGRect frame = self.navigationController.view.frame;
    frame.size.height = 265;
    
    
    UIImageView *imgView = (UIImageView *)[self.view viewWithTag:1];
    UIButton* btnPhotoActivity = (UIButton *)[self.view viewWithTag:2];
    CGRect rect = [btnPhotoActivity frame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    imgView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
    self.navigationController.view.frame = frame;
    self.view.frame = frame;
    [UIView commitAnimations];
    
    [self.view bringSubviewToFront:btnPhotoActivity];
    [_txtvMessageComposer setUserInteractionEnabled:YES];    
}

@end
