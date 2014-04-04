//
//  AppDelegate.m
//  ImageUploadTutorial

//***********************************************************************************************************
// This app demonstrates the function of BuiltFile's upload/download properties.
// The demo app fetches images that are uploaded and display it in UICollectionView.
// It also demonstates how we can upload and download images using built.io SDK's BuiltFile class methods.
//***********************************************************************************************************

#import "AppDelegate.h"
#import <BuiltIO/BuiltIO.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //***********************************************************************************************************
    // Initialize Built class with your application's API-KEY and APP-UID
    //[Built initializeWithApiKey:@"your-API-key" andUid:@"your-app-UID"];
    //***********************************************************************************************************
    [Built initializeWithApiKey:@"blta6f4ec821d77f303" andUid:@"imagetutorial"];
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

+(AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

//***********************************************************************************************************
// Create a BuiltFile of the selected image
// BuiltFile's save method saves the image object and SDK sets the BuiltFile's uid internally.
// Set this uid as value and save the BuiltObject by SDK's save method.
// Now with this your image is actually uploaded to built's server.
//***********************************************************************************************************
-(void)uploadImage:(UIImage *)selectedImage onSuccess:(void (^) (void))successBlock onError:(void (^) (void))errorBlock{
    BuiltFile *file = [BuiltFile file];
    [file setImage:selectedImage forKey:@"Image"];
    
    [file saveOnSuccess:^{
        BuiltObject *object = [BuiltObject objectWithClassUID:@"userphoto"];
        [object setObject:[file uid] forKey:@"image_file"];
        [object saveOnSuccess:^{
            successBlock();
        } onError:^(NSError *error) {
            errorBlock();
        }];
    } onError:^(NSError *error) {
        errorBlock();
    }];
}

//***********************************************************************************************************
// Download a image file from BuiltFile's downloadimage method.
// The method returns UIImage on success which can be saved to disk (camera roll).
//***********************************************************************************************************
-(void)downloadImage:(NSString *)urlString onSuccess:(void (^) (void))successBlock onError:(void (^) (void))errorBlock{
    BuiltFile *file = [BuiltFile file];
    file.url = urlString;
    [file downloadImageOnCompletion:^(UIImage *image) {
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        successBlock();
    } onError:^(NSError *error) {
        errorBlock();
    }];
}

@end
