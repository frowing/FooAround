//
//  RecentViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentViewController.h"

#define NAVBAR_TINT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]

@interface RecentViewController ()

@property(nonatomic,retain)UINavigationBar *navBar;

- (void)adjustNavbar;
- (void)setupNavbar;
- (void)cancelButtonPressed;

@end

@implementation RecentViewController

@synthesize navBar = navBar_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [navBar_ release];
  
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
  [self setupNavbar];

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

#pragma mark -
#pragma mark Private methods 

- (void)setupNavbar {
  navBar_ = 
  [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 
                                                   0, 
                                                   self.view.frame.size.width,
                                                   44)];
  self.navBar.tintColor = NAVBAR_TINT_COLOR;
  UINavigationItem *item = [[[UINavigationItem alloc]init] autorelease];
  UIBarButtonItem *cancelButton = 
  [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"CancelButtonTitle", @"")
                                   style:UIBarButtonItemStyleBordered 
                                  target:self 
                                  action:@selector(cancelButtonPressed)]
   autorelease];
  cancelButton.title = NSLocalizedString(@"CancelButtonTitle", @"");
  item.rightBarButtonItem = cancelButton;
  self.navBar.items = [NSArray arrayWithObject:item];  
  [self.view addSubview:self.navBar];
}

- (void)cancelButtonPressed {
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate wannaHide:self];
}

- (void)adjustNavbar{
  self.navBar.frame = CGRectMake(0, 
                                 0, 
                                 self.view.frame.size.width,
                                 44);
} 



@end
