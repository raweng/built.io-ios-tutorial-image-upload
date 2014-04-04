//
//  PhotosViewController.m
//  ImageUploadTutorial

//***********************************************************************************************************
// This ViewController queries your class containing your image objects and displays them in UICollectionView
// NETWORK_ELSE_CACHE CachePolicy is set for BuiltQuery.
// The objects from class are retreived by BuiltQuery.
//***********************************************************************************************************


#import "PhotosViewController.h"
#import "PhotoViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MBProgressHUD.h"
#import "MHFacebookImageViewer.h"
#import "AppDelegate.h"

NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

static NSString * const PhotoCellIdentifier = @"PhotoCell";

@interface PhotosViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate,MHFacebookImageViewerDatasource>

@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) MBProgressHUD *progressHUD;

@end

@implementation PhotosViewController

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.photos = [NSMutableArray array];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self loadPhotos];
}

-(void)loadPhotos{
    if (!self.progressHUD) {
        self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.progressHUD.dimBackground = YES;
    }else{
        [self.progressHUD show:YES];
    }
    
    
    [self.photos removeAllObjects];
    
    //***********************************************************************************************************
    // Query to fetch objects from class.
    // CachePolicy is set to NETWORK_ELSE_CACHE.i.e, if network is available it gets data through n/w call else it fetches from cache.
    //***********************************************************************************************************
    
    BuiltQuery *query = [BuiltQuery queryWithClassUID:@"userphoto"];
    [query orderByDescending:@"created_at"];
    [query setCachePolicy:NETWORK_ELSE_CACHE];
    [query exec:^(QueryResult *result, ResponseType type) {
        NSArray *photo = [result getResult];
        
        [photo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self.photos addObject:[[obj objectForKey:@"image_file"] objectForKey:@"url"]];
        }];
        
        [self.collectionView reloadData];
        [self.progressHUD hide:YES afterDelay:2.0];
    } onError:^(NSError *error, ResponseType type) {
        [self.progressHUD hide:YES afterDelay:2.0];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotoViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor blackColor];
    
    // load the image for this cell
    [cell.photoViewImage setImageWithURL:[NSURL URLWithString:[self.photos objectAtIndex:indexPath.row]]];
    [cell.photoViewImage setupImageViewerWithDatasource:self initialIndex:indexPath.row onOpen:nil onClose:nil];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.photos.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIImagePickerController *controller = [segue destinationViewController];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

- (IBAction)openImagePicker:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    
    [self.navigationController presentViewController:picker animated:YES completion:nil];
    
}

- (IBAction)refresh:(id)sender {
    [self.photos removeAllObjects];
    [self.collectionView reloadData];
    
    [self loadPhotos];
}

#pragma mark UIImagePickerControllerDelegate, UINavigationControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHUD.dimBackground = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [[AppDelegate sharedAppDelegate]uploadImage:selectedImage onSuccess:^{
        [self loadPhotos];
    } onError:^{
        [self.progressHUD hide:YES afterDelay:2.0];
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MHFacebookImageViewerDatasource
-(NSInteger)numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer{
    return self.photos.count;
}

-(NSURL *)imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return [NSURL URLWithString:[self.photos objectAtIndex:index]];
}

-(UIImage *)imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer{
    return nil;
}

@end
