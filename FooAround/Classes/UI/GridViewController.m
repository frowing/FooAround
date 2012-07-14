//
//  GridViewController.m
//  Unity-iPhone
//
//  Created by frowing on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridViewController.h"

#define VERTICAL_NUM_COLUMNS          3 
#define HORIZONTAL_NUM_COLUMNS        4
#define START_X_COORDINATE            20.0f
#define START_Y_COORDINATE            20.0f
#define X_GAP                         10.0f
#define Y_GAP                         10.0f
#define THUMBNAIL_POPOVER_VIEW_SIZE         CGSizeMake(210,127)

@interface GridViewController()
@property(nonatomic,retain) NSArray *thumbnailViewControllers;
@property(nonatomic,assign) UIDeviceOrientation orientation;

- (NSArray*)viewControllersFromElements:(NSArray*)elements;
- (CGSize)sizeForThumbnail;
- (UIDeviceOrientation)deviceOrientation;
- (BOOL)isValidOrientation:(UIDeviceOrientation)deviceOrientation;
- (void)adaptViews;
- (void)orientationChanged:(NSNotification *)notification;
- (NSUInteger)numberOfColumns;
-(UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight;
-(UIImage *) takeThumbnail:(NSURL *) url;



@end

@implementation GridViewController
@synthesize elements = elements_;

@synthesize scrollView = scrollView_;
@synthesize thumbnailViewControllers = thumbnailViewControllers_;
@synthesize orientation = orientation_;
@synthesize selectable = selectable_;
@synthesize thumbnailSelectedID = thumbnailSelectedID_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [scrollView_ release];
  [elements_ release];
  [thumbnailViewControllers_ release];
  [thumbnailSelectedID_ release];
  
  [[NSNotificationCenter defaultCenter] 
   removeObserver:self 
   name:@"UIDeviceOrientationDidChangeNotification" 
   object:nil];
  
  [super dealloc];
}

- (id)initWithElements:(NSMutableArray*)elements andDelegate:(id<GridViewControllerDelegate>)delegate{
  if (delegate == nil)
      return nil;
    
  if (elements == nil) 
    return nil;
  
  if ([elements count] < 1)
    return nil;
    
  self = [super init];
    
  if (self) {
    elements_ = [elements retain];
    delegate_ = delegate;
  }
  
  return self;  
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)setSelectable:(BOOL)selectable {
  
  selectable_ = selectable;
  
  ThumbnailState newState = eInitial;
  
  if (selectable) {
    newState = eNotSelected;
  }
  
  for (ThumbnailViewController *vc in self.thumbnailViewControllers) {
    [vc setState:newState];
  }
  
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.thumbnailViewControllers = [self viewControllersFromElements:elements_];
  self.orientation = self.deviceOrientation;
  [self performSelector:@selector(adaptViews) withObject:nil afterDelay:0.5f];
  for (ThumbnailViewController *vc in self.thumbnailViewControllers) {
    [self.scrollView addSubview:vc.view];
  }
  
  [[NSNotificationCenter defaultCenter] 
   addObserver:self                                             
   selector:@selector(orientationChanged:)                                                 
   name:@"UIDeviceOrientationDidChangeNotification"                                                
   object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Private methods

- (NSArray*)viewControllersFromElements:(NSArray*)elements {
  
  NSAssert(elements != nil,@"elements is nil");
  NSAssert([elements count] > 0,@"elements is empty");
  
  NSMutableArray *viewControllers = [NSMutableArray array];

  for (NSDictionary *element in elements) {
    
    ThumbnailViewController *thumbnailViewController = nil;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      thumbnailViewController = 
      [[[ThumbnailViewController alloc] initWithNibName:@"ThumbnailViewController_iPhone" 
                                                 bundle:nil] 
       autorelease];
    } else {
      thumbnailViewController = 
      [[[ThumbnailViewController alloc] initWithNibName:@"ThumbnailViewController_iPad" 
                                                 bundle:nil] 
       autorelease];
    }
    
    thumbnailViewController.mediaObject = (MediaObject*)element;
    thumbnailViewController.delegate = self;    
    
    [viewControllers addObject:thumbnailViewController];
  }
  
  return viewControllers;
}

-(UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight
{
    UIGraphicsBeginImageContext(CGSizeMake(resizedWidth ,resizedHeight));
    [image drawInRect:CGRectMake(0, 0, resizedWidth, resizedHeight)];
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return result;
}

- (void)adaptViews {
  
  CGFloat xOffset = START_X_COORDINATE;
  CGFloat yOffset = START_Y_COORDINATE;
  
  CGSize thumbnailSize = [self sizeForThumbnail];
  
  for (ThumbnailViewController *vc in self.thumbnailViewControllers) {
    CGRect viewFrame =
    CGRectMake(xOffset, yOffset,thumbnailSize.width,thumbnailSize.height);
    
    vc.view.frame = viewFrame;
    
    xOffset += thumbnailSize.width + X_GAP;
    
    if ((xOffset + thumbnailSize.width) >= self.view.frame.size.width) {
      xOffset = START_X_COORDINATE;
      yOffset += thumbnailSize.height + Y_GAP;
    }
  }
  
  //Adjust Scroll view size
  BOOL perfectlyAdjusted =
  ([self.thumbnailViewControllers count] % [self numberOfColumns]) == 0; 
  
  if (perfectlyAdjusted) {
    self.scrollView.contentSize =
    CGSizeMake(self.view.frame.size.width, 
               yOffset + START_Y_COORDINATE);
  }
  else {
    self.scrollView.contentSize =
    CGSizeMake(self.view.frame.size.width, 
               yOffset + thumbnailSize.height + START_Y_COORDINATE);
    NSLog(@"%@",NSStringFromCGSize(self.scrollView.frame.size));
  }
}

- (UIDeviceOrientation)deviceOrientation {
  return [[UIDevice currentDevice]orientation];
}

- (BOOL)isValidOrientation:(UIDeviceOrientation)deviceOrientation {
  
  return  UIDeviceOrientationIsLandscape(deviceOrientation) || 
  UIDeviceOrientationIsPortrait(deviceOrientation);
}

- (CGSize)sizeForThumbnail {
  
  NSUInteger numOfColumns = [self numberOfColumns];
  
  CGFloat spaceForGaps = (numOfColumns - 1) * X_GAP;
  CGFloat sideGapSpace = 2 * START_X_COORDINATE;
  CGFloat thumbnailWidth =
  (self.view.frame.size.width - spaceForGaps  - sideGapSpace) / numOfColumns ;
  
  //Square thumbnail
  return CGSizeMake(thumbnailWidth, thumbnailWidth);
}

- (void)orientationChanged:(NSNotification *)notification {
  
  if ((self.orientation != self.deviceOrientation) && 
      ([self isValidOrientation:self.deviceOrientation])) {
    
    [self performSelector:@selector(adaptViews) 
               withObject:nil 
               afterDelay:0.1f];
    
    self.orientation = self.deviceOrientation;
  }    
}

- (NSUInteger)numberOfColumns {
  if (UIDeviceOrientationIsPortrait(self.deviceOrientation)) {
    return VERTICAL_NUM_COLUMNS;
  }
  else {
    return HORIZONTAL_NUM_COLUMNS;
  }
}

#pragma mark -
#pragma mark ThumbnailViewControllerDelegate

- (void)thumbnailSelectedWithID:(NSString*)thumbnailID {

}


@end
