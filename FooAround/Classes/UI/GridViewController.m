//
//  GridViewController.m
//  Unity-iPhone
//
//  Created by frowing on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridViewController.h"
#import "MediaObject.h"

#define IPHONE_NUM_COLUMNS            3 
#define IPAD_NUM_COLUMNS              4
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
- (void)adaptViews;
- (NSUInteger)numberOfColumns;
- (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight;

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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.thumbnailViewControllers = [self viewControllersFromElements:elements_];
  for (ThumbnailViewController *vc in self.thumbnailViewControllers) {
    [self.scrollView addSubview:vc.view];
  }
}

- (void)viewWillAppear:(BOOL)animated {
  [self adaptViews];
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
  
  //Nothing wrong with not having Instagrams, just display error message
  //NSAssert([elements count] > 0,@"elements is empty");
  
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

- (UIImage *)resizeImage:(UIImage *)image width:(CGFloat)resizedWidth height:(CGFloat)resizedHeight
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
  }
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

- (NSUInteger)numberOfColumns {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    return IPHONE_NUM_COLUMNS;
  }
  else {
    return IPAD_NUM_COLUMNS;
  }
}

#pragma mark -
#pragma mark ThumbnailViewControllerDelegate

- (void)thumbnailSelectedWithID:(NSString*)thumbnailID {
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  for (MediaObject *mediaObject in self.elements) {
    if ([mediaObject.ident isEqualToString:thumbnailID]) {
      if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self.delegate needToShowImage:mediaObject.text WithURL:mediaObject.lowResURL];
      }
      else {
        [self.delegate needToShowImage:mediaObject.text WithURL:mediaObject.standardURL];
      }
      
      return;
    }
  }
  
  NSAssert(NO,@"that image should exist");
}

@end
