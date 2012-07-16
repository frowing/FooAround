//
//  SingleImageView.m
//  FooAround
//
//  Created by Francisco Sevillano on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//
#import "AsyncImageView.h"
#import "SingleImageView.h"

#define NAVBAR_TINT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]

@interface SingleImageView ()

@property(nonatomic,retain) UINavigationBar *navBar;
@property(nonatomic,retain) AsyncImageView *imageView;

- (void)setUpNavBarWithName:(NSString*)name;
- (void)setUpImageViewWithURL:(NSString*)url;
- (void)doneButtonPressed;

@end

@implementation SingleImageView

@synthesize navBar = navBar_;
@synthesize imageView = imageView_;

- (void)dealloc {
  [navBar_ release];
  [imageView_ release];
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame name:(NSString*)name url:(NSString*)url
{  
  //Name can be nil, url can't
  if ((name == nil) || ([name isEqualToString:@""])){
    name = NSLocalizedString(@"EmptyName", @"");
  }
  
  if (url == nil) {
    return nil;
  }
  
    self = [super initWithFrame:frame];
    if (self) {
      self.backgroundColor = [UIColor blackColor];
      [self setUpNavBarWithName:name];
      [self setUpImageViewWithURL:url];
    }
    return self;
}

#pragma mark -
#pragma mark Private methods

- (void)doneButtonPressed {
  [UIView animateWithDuration:SINGLE_IMAGE_SHOWING_HIDING_TIME animations:^{
    self.alpha = 0.0f;
  } completion:^(BOOL finished) {
      [self removeFromSuperview];
  }];
}

- (void)setUpNavBarWithName:(NSString*)name {
  self.navBar = 
  [[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 
                                                    0, 
                                                    self.frame.size.width, 
                                                    44)] 
   autorelease];
  
  self.navBar.tintColor = NAVBAR_TINT_COLOR;
  
  UINavigationItem *navItem =
  [[[UINavigationItem alloc]initWithTitle:name] 
   autorelease];
  
  UIBarButtonItem *doneButton = 
  [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"DoneButtonTitle", @"")
                                   style:UIBarButtonItemStyleBordered 
                                  target:self 
                                  action:@selector(doneButtonPressed)]
   autorelease];
  navItem.rightBarButtonItem = doneButton;
  self.navBar.items = [NSArray arrayWithObject:navItem];
  [self addSubview:self.navBar];
}

- (void)setUpImageViewWithURL:(NSString *)url {
  self.imageView = 
  [[[AsyncImageView alloc]initWithFrame:CGRectMake(0, 
                                                  0, 
                                                  self.frame.size.width,
                                                  self.frame.size.width)] autorelease];
  self.imageView.center = 
  CGPointMake(self.frame.size.width / 2, 
              self.frame.size.height / 2);
  
  NSAssert([self.backgroundColor isEqual:[UIColor blackColor]],
           @"if color changes, we might not need this");
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    self.imageView.activityIndicatorStyle = UIActivityIndicatorViewStyleWhite;
  } 
  else {
    self.imageView.activityIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
  }
  [self addSubview:self.imageView];
  self.imageView.imageURL = [NSURL URLWithString:url];
}

@end
