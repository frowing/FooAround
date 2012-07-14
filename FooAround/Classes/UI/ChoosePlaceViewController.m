//
//  ChoosePlaceViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePlaceViewController.h"

#define TOOLBAR_TINT_COLOR            [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]

@interface ChoosePlaceViewController ()

@property(nonatomic,retain)UIToolbar *toolbar;
@property(nonatomic,retain)UISegmentedControl *segmentedControl;
@property(nonatomic,retain)UIBarButtonItem *currentLocationButton;

- (void)setUpToolbar;
- (void)currentLocationButtonPressed;


@end

@implementation ChoosePlaceViewController

@synthesize toolbar = toolBar_;
@synthesize segmentedControl = segmentedControl_;
@synthesize currentLocationButton = currentLocationButton_;

- (void)dealloc {
  [toolBar_ release];
  [segmentedControl_ release];
  [currentLocationButton_ release];
  
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

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.view.autoresizingMask = 
  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewWillAppear:(BOOL)animated {
  [self setUpToolbar];
}

#pragma mark -
#pragma mark Private methods

- (void)setUpToolbar {
  NSArray *items = 
  [NSArray arrayWithObjects:NSLocalizedString(@"SearchTitle", @""),NSLocalizedString(@"RecentTitle", @""), nil];
  segmentedControl_ = [[UISegmentedControl alloc]initWithItems:items];
  self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  
  self.currentLocationButton = 
  [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"AroundTitle", @"")  
                                  style:UIBarButtonItemStyleBordered 
                                 target:self 
                                 action:@selector(currentLocationButtonPressed)];
  
  toolBar_ = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 
                                                        0, 
                                                        self.view.frame.size.width,
                                                        44)];
  self.toolbar.center = 
  CGPointMake(self.view.frame.size.width / 2, 
  self.view.frame.size.height - (self.toolbar.frame.size.height / 2));
  
  self.toolbar.tintColor = TOOLBAR_TINT_COLOR;
  
  UIBarButtonItem *segmentedItem = 
  [[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl];
  
  UIBarButtonItem *flexibleSpace = 
  [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace 
                                                 target:nil 
                                                 action:nil] 
   autorelease];
  
  NSArray *toolbarItems = 
  [NSArray arrayWithObjects:segmentedItem,flexibleSpace,self.currentLocationButton, nil];
  
  self.toolbar.items = toolbarItems; 
  [self.view addSubview:self.toolbar];
}

- (void)currentLocationButtonPressed {
  NSLog(@"currentLocationButtonPressed");
}

@end
