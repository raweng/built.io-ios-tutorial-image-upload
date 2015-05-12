//
//  AppDelegate.h
//  ImageUploadTutorial

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) BuiltApplication *builtApplication;
@property (strong, nonatomic) UIWindow *window;

+(AppDelegate *)sharedAppDelegate;

-(void)uploadImage:(UIImage *)selectedImage onSuccess:(void (^) (void))successBlock onError:(void (^) (void))errorBlock;
-(void)downloadImage:(BuiltObject *)object onSuccess:(void (^) (void))successBlock onError:(void (^) (void))errorBlock;

@end
