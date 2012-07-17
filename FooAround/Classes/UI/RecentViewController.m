//
//  RecentViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentViewController.h"
#import "RecentSearchesHandler.h"

#define NAVBAR_TINT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]

#define TABLE_VIEW_FRAME CGRectMake(0, self.navBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navBar.frame.size.height)

@interface RecentViewController ()

@property(nonatomic,retain)UINavigationBar *navBar;
@property(nonatomic,assign)RecentSearchesHandler *recentSearchesHandler;

- (void)adjustNavbar;
- (void)setupNavbar;
- (void)cancelButtonPressed;
- (void)setupTableView;

@end

@implementation RecentViewController

@synthesize navBar = navBar_;
@synthesize tableView = tableView_;
@synthesize recentSearchesHandler = recentSearchesHandler_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [navBar_ release];
  [recentSearchesHandler_ release];
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
  self.recentSearchesHandler = [RecentSearchesHandler sharedInstance];
  [self setupTableView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
  self.tableView.frame = TABLE_VIEW_FRAME;
  [self.tableView reloadData];
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
  item.rightBarButtonItem = cancelButton;
  item.title = NSLocalizedString(@"RecentTitle", @"");
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

- (void)setupTableView {
  tableView_ = [[UITableView alloc]initWithFrame:TABLE_VIEW_FRAME style:UITableViewStylePlain];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.hidden = NO;
  [self.view addSubview:self.tableView];
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
		cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle 
                                  reuseIdentifier:identifier] autorelease];
	}
  
  CLPlacemark *placemark = 
  [self.recentSearchesHandler.recentSearches objectAtIndex:indexPath.row];
  cell.textLabel.text = placemark.locality;
  cell.detailTextLabel.text = 
  [NSString stringWithFormat:@"%@, %@",placemark.administrativeArea,placemark.country];
  
  return cell;
}

#pragma mark - 
#pragma mark UITableViewDelegate methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.recentSearchesHandler.recentSearches count];
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  CLPlacemark *placemark = 
  [self.recentSearchesHandler.recentSearches objectAtIndex:indexPath.row];
  
  NSAssert(self.delegate != nil,@"delegate should not be nil");
  [self.delegate locationSelected:placemark.locality 
                    atCoordinates:placemark.location.coordinate];
}

@end
