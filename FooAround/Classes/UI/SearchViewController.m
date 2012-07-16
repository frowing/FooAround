//
//  SearchViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "SearchViewController.h"

#define NAVBAR_TINT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]
#define NAVBAR_FRAME CGRectMake(0,0,self.view.frame.size.width,44)
#define TABLE_VIEW_FRAME CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height)

@interface SearchViewController ()

@property(nonatomic,retain)UINavigationBar *navBar;
@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)UIButton *cancelButton;
@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)NSArray *placemarks;

- (void)setupNavbar;
- (void)setupTableView;
- (void)cancelButtonPressed;

@end

@implementation SearchViewController

@synthesize navBar = navBar_;
@synthesize searchBar = searchBar_;
@synthesize cancelButton = cancelButton_;
@synthesize delegate = delegate_;
@synthesize tableView = tableView_;
@synthesize placemarks = placemarks_;

- (void)dealloc {
  [navBar_ release];
  [searchBar_ release];
  [cancelButton_ release];
  [tableView_ release];
  [placemarks_ release];
  
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
  [self setupTableView];
}

- (void)viewWillAppear:(BOOL)animated {
  self.navBar.frame = NAVBAR_FRAME;
  self.tableView.frame = TABLE_VIEW_FRAME;
}

- (void)viewWillDisappear:(BOOL)animated {
  self.searchBar.text = @"";
  self.tableView.hidden = YES;
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
  [[UINavigationBar alloc]initWithFrame:NAVBAR_FRAME];
  self.navBar.tintColor = NAVBAR_TINT_COLOR;
  
  searchBar_ = 
  [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
  self.searchBar.tintColor = NAVBAR_TINT_COLOR;
  self.searchBar.delegate = self;
  
  UINavigationItem *item = [[UINavigationItem alloc]init];
  item.titleView = self.searchBar;
  UIBarButtonItem *cancelButton = 
  [[[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"CancelButtonTitle", @"")
                                   style:UIBarButtonItemStyleBordered 
                                  target:self 
                                  action:@selector(cancelButtonPressed)]
   autorelease];
  item.rightBarButtonItem = cancelButton;
  
  self.navBar.items = [NSArray arrayWithObject:item];  
  [self.view addSubview:self.navBar];
}

- (void)setupTableView {
  tableView_ = [[UITableView alloc]initWithFrame:TABLE_VIEW_FRAME style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.hidden = YES;
  [self.view addSubview:self.tableView];
}

- (void)cancelButtonPressed {
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate wannaHide:self];
}

#pragma mark -
#pragma mark UISearchbarDelegate methods 

//TODO: hidekeyboard button

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
  
  //TODO: show loading dialog
  [geoCoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
    if (error != nil) {
      //TODO: show alert error
    }
    else {
      [self.searchBar resignFirstResponder];
      self.placemarks = placemarks;
      self.tableView.hidden = NO;
      
      //Since will be in the background, we need to get back to the main thread
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
      });
    }    
  }];
}

#pragma mark - 
#pragma mark UITableViewDataSource methods 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *identifier = @"UITableViewCell";	
	
	// Dequeue or create a cell of the appropriate type.
	UITableViewCell *cell = 
  (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
  
	if (cell == nil) {
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle 
                                 reuseIdentifier:identifier];
	}
  
  CLPlacemark *placemark = [self.placemarks objectAtIndex:indexPath.row];
  cell.textLabel.text = placemark.locality;
  cell.detailTextLabel.text = 
  [NSString stringWithFormat:@"%@, %@",placemark.administrativeArea,placemark.country];
  
  return cell;
}

#pragma mark - 
#pragma mark UITableViewDelegate methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.placemarks count];
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CLPlacemark *placemark = [self.placemarks objectAtIndex:indexPath.row];
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate locationSelected:placemark.locality 
                    atCoordinates:placemark.location.coordinate];
}

@end
