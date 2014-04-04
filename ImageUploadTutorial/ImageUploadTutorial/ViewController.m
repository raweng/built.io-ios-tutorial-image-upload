//
//  ViewController.m
//  ImageUploadTutorial
//
//  Created by Sameer on 25/02/14.
//  Copyright (c) 2014 Sameer. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
- (IBAction)openCameraRoll:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
//    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"userphoto"];
//    [query exec:^(QueryResult *result, ResponseType type) {
//        NSLog(@"--------userphotoØ query-------- %@",result);
//    } onError:^(NSError *error, ResponseType type) {
//        NSLog(@"--------userphoto query-------- %@",error);
//    }];
    
    BuiltFile *file = [BuiltFile file];
    [file setImage:[UIImage imageNamed:@"sample_0.jpg"] forKey:@"image_file"];
    
    [file saveOnSuccess:^{
        BuiltObject *object = [BuiltObject objectWithClassUID:@"userphoto"];
        [object setObject:[file uid] forKey:@"image_file"];
        [object saveOnSuccess:^{
            NSLog(@"image saved!!!!!");
        } onError:^(NSError *error) {
            NSLog(@"image save error!!!!!");
        }];
        NSLog(@"file saveOnSuccess");
    } onError:^(NSError *error) {
        NSLog(@"file error");
    }];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ImagePickerViewController *imagePicker = segue.destinationViewController;
    NSLog(@"segue.destinationViewController %@",segue.destinationViewController);
    
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

#pragma mark - UIImagePickerControllerDelegate, UINavigationControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"selected image info %@",info);
    
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)openCameraRoll:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    [self.navigationController presentViewController:picker animated:YES completion:nil];
}
@end
