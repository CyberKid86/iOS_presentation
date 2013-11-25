//
//  VE_StartVC.m
//  ios_presentation
//
//  Created by Vasiliy Erema on 11/24/13.
//  Copyright (c) 2013 Vasil Erema. All rights reserved.
//

#warning Autolayouts ARC

#import "VE_StartVC.h"
#import "VE_DownloadManager.h"
#import "VE_AppSettings.h"

@interface VE_StartVC ()
{
    NSUInteger _currentImageIndex;
}
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIImageView *contentImageView;
@property (nonatomic, strong) NSArray *urlStrings;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, weak) IBOutlet UIButton *updateBtn;
@end

@implementation VE_StartVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = @"AsyncDownload";//NSStringFromClass(self.class);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.urlStrings = @[@"http://www.shop.hidra.com.tr/wp-content/uploads/image_5276_1.jpg",
                        @"http://www.shop.hidra.com.tr/wp-content/uploads/image_4975_1.jpg",
                        @"http://www.shop.hidra.com.tr/wp-content/uploads/image_6186_1.jpg"];
    _currentImageIndex = 0;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:scrollView atIndex:0];
    self.scrollView = scrollView;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollView.bounds];
    [scrollView addSubview:imageView];
    self.contentImageView = imageView;
    
    [self updateBGImage];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [[VE_AppSettings sharedSettings] appColor];
    [self updateScrollViewContentFrame];
}

- (NSString *)nextImageUrlString
{
    if (self.urlStrings.count)
    {
        _currentImageIndex = ++_currentImageIndex%self.urlStrings.count;
        return self.urlStrings[_currentImageIndex];
    }
    return nil;
}

- (void)updateScrollViewContentFrame
{
    self.scrollView.contentSize = CGSizeMake(MAX(self.scrollView.frame.size.width, self.contentImageView.image.size.width),
                                             MAX(self.scrollView.frame.size.height, self.contentImageView.image.size.height));
    self.contentImageView.frame = CGRectMake(roundf((self.scrollView.contentSize.width - self.contentImageView.image.size.width)/2.0),
                                             roundf((self.scrollView.contentSize.height - self.contentImageView.image.size.height)/2.0),
                                             self.contentImageView.image.size.width,
                                             self.contentImageView.image.size.height);
    self.scrollView.contentOffset = CGPointMake(-roundf((self.scrollView.bounds.size.width - self.scrollView.contentSize.width)/2.0),
                                                -roundf((self.scrollView.bounds.size.height - self.scrollView.contentSize.height)/2.0));
}

- (void)setBGImage:(UIImage *)image
{
    self.contentImageView.image = image;
    [self updateScrollViewContentFrame];
}

- (void)updateBGImage
{
    if (!self.activityIndicator)
    {
        self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        self.activityIndicator.hidesWhenStopped = YES;
        [self.view insertSubview:self.activityIndicator aboveSubview:self.updateBtn];
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                              attribute:NSLayoutAttributeCenterX
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.updateBtn
                                                              attribute:NSLayoutAttributeCenterX
                                                             multiplier:1
                                                               constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.activityIndicator
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.updateBtn
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1
                                                               constant:0]];
        self.activityIndicator.center = self.updateBtn.center;
    }
    [_activityIndicator startAnimating];
    self.updateBtn.alpha = 0.0f;
    __weak VE_StartVC *weakSelf = self;
    [[VE_DownloadManager sharedInstance] downloadDataWithURLString:[self nextImageUrlString]
                                                        usingCache:YES
                                                andComplitionBlock:^(NSData *downloadedData)
     {
         if (weakSelf)
         {
             if (downloadedData)
             {
                 UIImage *downloadedImage = [[UIImage alloc] initWithData:downloadedData scale:[UIScreen mainScreen].scale];
                 [weakSelf setBGImage:downloadedImage];
             }
             weakSelf.updateBtn.alpha = 1.0f;
             [_activityIndicator stopAnimating];
         }
     }];
}
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [UIView animateWithDuration:duration
                     animations:^
     {
         [self updateScrollViewContentFrame];
     }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (IBAction)imageUpdate:(id)sender
{
    [self updateBGImage];
}

- (IBAction)clearCache:(id)sender
{
    [[VE_DownloadManager sharedInstance] clearCache];
}

@end
