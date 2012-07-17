//
//  ChoosePlaceViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePlaceViewController.h"
#import "SearchViewController.h"
#import "RecentViewController.h"


#define TOOLBAR_TINT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]

@interface ChoosePlaceViewController ()

@property(nonatomic,retain)UIToolbar *toolbar;
@property(nonatomic,retain)UISegmentedControl *segmentedControl;
@property(nonatomic,retain)UIBarButtonItem *currentLocationButton;


@property(nonatomic,retain)SearchViewController *searchViewController;
@property(nonatomic,retain)RecentViewController *recentViewController;

- (void)adjustToolBar;
- (void)adjustViewControllers;
- (void)setupToolBar;
- (void)setupViewControllers;
- (void)currentLocationButtonPressed;
- (void)segmentedValueChanged;

@end

@implementation ChoosePlaceViewController

@synthesize toolbar = toolBar_;
@synthesize segmentedControl = segmentedControl_;
@synthesize currentLocationButton = currentLocationButton_;
@synthesize searchViewController = searchViewController_;
@synthesize recentViewController = recentViewController_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [toolBar_ release];
  [segmentedControl_ release];
  [currentLocationButton_ release];
  [searchViewController_ release];
  [recentViewController_ release];
  
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
  
  [self setupToolBar];
  [self setupViewControllers];
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
  [self adjustToolBar];
  [self adjustViewControllers];
}

#pragma mark -
#pragma mark Private methods

- (void)adjustToolBar {
  self.toolbar.frame = CGRectMake(0, 
                                  0, 
                                  self.view.frame.size.width,
                                  44);
  self.toolbar.center = 
  CGPointMake(self.view.frame.size.width / 2, 
              self.view.frame.size.height - (self.toolbar.frame.size.height / 2));
  NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (void)adjustViewControllers {
  CGRect viewControllersFrame = 
  CGRectMake(0, 
             0, 
             self.view.frame.size.width, 
             self.view.frame.size.height - self.toolbar.frame.size.height);
  
  self.searchViewController.view.frame = viewControllersFrame;  
  self.recentViewController.view.frame = viewControllersFrame;
}

- (void)setupToolBar {
  NSArray *items = 
  [NSArray arrayWithObjects:NSLocalizedString(@"SearchTitle", @""),
                            NSLocalizedString(@"RecentTitle", @""), 
                            nil];
  
  segmentedControl_ = [[UISegmentedControl alloc]initWithItems:items];
  self.segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
  [self.segmentedControl addTarget:self
                            action:@selector(segmentedValueChanged) 
                  forControlEvents:UIControlEventValueChanged];
  
  self.currentLocationButton = 
  [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"AroundTitle", @"")  
                                  style:UIBarButtonItemStyleBordered 
                                 target:self 
                                 action:@selector(currentLocationButtonPressed)] 
   autorelease];
  
  toolBar_ = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 
                                                        0, 
                                                        self.view.frame.size.width,
                                                        44)];
  
  self.toolbar.tintColor = TOOLBAR_TINT_COLOR;
  
  UIBarButtonItem *segmentedItem = 
  [[[UIBarButtonItem alloc]initWithCustomView:self.segmentedControl] autorelease];
  
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

- (void)setupViewControllers {
  
  searchViewController_ = [[SearchViewController alloc]init];
  self.searchViewController.delegate = self;
  [self.view addSubview:self.searchViewController.view];
  
  recentViewController_ = [[RecentViewController alloc]init];
  self.recentViewController.delegate = self;  
  [self.view addSubview:self.recentViewController.view];
  
  self.searchViewController.view.hidden = NO;
  self.recentViewController.view.hidden = YES;
  self.segmentedControl.selectedSegmentIndex = 0;
}

- (void)currentLocationButtonPressed {
  [self.delegate currentLocationSelected];
}

- (void)segmentedValueChanged {
  if (self.segmentedControl.selectedSegmentIndex == 0) {
    self.searchViewController.view.hidden = NO;
    self.recentViewController.view.hidden = YES;
  }
  else if (self.segmentedControl.selectedSegmentIndex == 1) {
    self.searchViewController.view.hidden = YES;
    self.recentViewController.view.hidden = NO;
    [self.recentViewController viewWillAppear:NO];
  }
  else {
    NSAssert(NO,@"unknown selectedSegmentIndex");
  }
}

#pragma mark -
#pragma mark WannaHideDelegate methods

- (void)wannaHide:(UIViewController*)viewController {
  
  NSAssert(viewController == self.searchViewController || 
           viewController == self.recentViewController,@"unknown view controller");
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate wannaHide:self];
  
}

#pragma mark -
#pragma LocationSelectedDelegate methods 

- (void)locationSelected:(NSString *)locationName 
           atCoordinates:(CLLocationCoordinate2D)coordinates {
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate locationSelected:locationName atCoordinates:coordinates];
}

- (void)currentLocationSelected {
  NSAssert(NO,@"we don't need this right now");
}

@end
