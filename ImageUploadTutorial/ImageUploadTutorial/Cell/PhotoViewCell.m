//
//  PhotoViewCell.m
//  ImageUploadTutorial

#import "PhotoViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PhotoViewCell
@synthesize photoViewImage;
//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//    self = [super initWithCoder:aDecoder];
//    if (self)
//    {
//        NSLog(@"dsfcdskfmodsmcfods,f");
//        // change to our custom selected background view
//        CustomCellBackground *backgroundView = [[CustomCellBackground alloc] initWithFrame:CGRectZero];
//        self.selectedBackgroundView = backgroundView;
//    }
//    return self;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithWhite:0.85f alpha:1.0f];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 3.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
        self.layer.shadowOpacity = 0.5f;
        // make sure we rasterize nicely for retina
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        self.layer.shouldRasterize = YES;
        
        self.photoViewImage.contentMode = UIViewContentModeScaleAspectFill;
        self.photoViewImage.clipsToBounds = YES;
        
        [self.contentView addSubview:self.photoViewImage];
    }
    
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.photoViewImage.image = nil;
}

@end
