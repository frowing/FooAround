//
//  ThumbnailViewController.m
//  Unity-iPhone
//
//  Created by frowing on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "AsyncImageView.h"
#import "MediaObject.h"
#import "ThumbnailViewController.h"

NSString * const THUMBNAIL_ID_KEY     = @"THUMBNAIL_ID";
NSString * const THUMBNAIL_IMAGE_KEY  = @"THUMBNAIL_IMAGE";
NSString * const THUMBNAIL_NAME_KEY   = @"THUMBNAIL_NAME";
NSString * const THUMBNAIL_INFO_KEY   = @"THUMBNAIL_INFO";

#define SELECTED_BORDER_COLOR [UIColor colorWithRed:(254/255) green:(201/255.0f) blue:(0/255.0f) alpha:1.0f]
#define UNSELECTED_BORDER_COLOR [UIColor whiteColor]

#define SELECTED_BACKGROUND_COLOR [UIColor colorWithRed:(254/255) green:(201/255.0f) blue:(0/255.0f) alpha:1.0f]
#define UNSELECTED_BACKGROUND_COLOR [UIColor blackColor]

@interface ThumbnailViewController()

@property(nonatomic,assign) CGFloat width;
@property(nonatomic,assign) ThumbnailState state;
 
@end


@implementation ThumbnailViewController
@synthesize mediaObject = mediaObject_;
@synthesize width = width_;
@synthesize imageView = imageView_;
@synthesize backgroundView = backgroundView_;
@synthesize selectionButton = selectionButton_;
@synthesize state = state_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [mediaObject_ release];
  [imageView_ release];
  [backgroundView_ release];
  [selectionButton_ release];
  
  [super dealloc];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithMediaObject:(MediaObject*)mediaObject {
  if (nil == mediaObject) {
    return nil;
  }
  
  self = [super init];

  if(self) {  
    mediaObject_ = mediaObject;
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
  self.imageView.activityIndicatorStyle = UIActivityIndicatorViewStyleGray;
  self.imageView.imageURL = [NSURL URLWithString:self.mediaObject.thumbnailURL];
  [self.view bringSubviewToFront:self.selectionButton];
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
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark IBAction methods

- (IBAction)selectionButtonPressed:(id)sender {
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate thumbnailSelectedWithID:self.mediaObject.ident];
}

@end
