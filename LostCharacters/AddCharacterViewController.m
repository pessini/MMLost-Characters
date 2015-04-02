//
//  AddCharacterViewController.m
//  LostCharacters
//
//  Created by Leandro Pessini on 4/1/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "AddCharacterViewController.h"
#import "AppDelegate.h"

@interface AddCharacterViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UITextField *characterNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *actorTextField;
@property (weak, nonatomic) IBOutlet UITextField *planeSeatTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;
@end

@implementation AddCharacterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width/2;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectPic:)];
    [singleTap setNumberOfTapsRequired:1];
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;

    [self.characterNameTextField becomeFirstResponder];
}

#pragma mark -ImagePickerControllerDelegate

- (void)promptForCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.photoImageView setImage:image];
    self.selectedImage = image;
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width/2;
    [self.view layoutSubviews];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -Action

- (IBAction)onDoneButtonTapped:(UIBarButtonItem *)sender
{
    if ([self.characterNameTextField.text isEqualToString:@""] ||
        [self.actorTextField.text isEqualToString:@""] ||
        [self.ageTextField.text isEqualToString:@""] ||
        [self.planeSeatTextField.text isEqualToString:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Something is missing"
                                                        message:@"Please make sure to enter all information"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.managedObjectContext];

        [character setValue:self.characterNameTextField.text forKey:@"name"];
        [character setValue:self.actorTextField.text forKey:@"actor"];

        NSString *ageString = self.ageTextField.text;
        NSNumber *age = [NSNumber numberWithInteger:[ageString integerValue]];
        [character setValue:age forKey:@"age"];

        [character setValue:self.planeSeatTextField.text forKey:@"plane_seat"];

        NSData *imageData = UIImagePNGRepresentation(self.selectedImage);
        [character setValue:imageData forKey:@"photo"];

        [self.managedObjectContext save:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

}

- (IBAction)onCancelButtonTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)selectPic:(UITapGestureRecognizer *)sender
{
    UIActionSheet *actionSheet = nil;
    actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                             delegate:self cancelButtonTitle:nil
                               destructiveButtonTitle:nil
                                    otherButtonTitles:nil];

    // only add avaliable source to actionsheet
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        [actionSheet addButtonWithTitle:@"Photo Library"];
    }
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [actionSheet addButtonWithTitle:@"Camera Roll"];
    }

    [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setCancelButtonIndex:actionSheet.numberOfButtons-1];
    [actionSheet showInView:self.navigationController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        if (buttonIndex != actionSheet.firstOtherButtonIndex)
        {
            [self promptForPhotoRoll];
        }
        else
        {
            [self promptForCamera];
        }
    }
}
@end
