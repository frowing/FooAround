//
//  ViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePlaceViewController.h"
#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,retain)MediaHandler *mediaHandler;
@property(nonatomic,retain)GridViewController *gridViewController;
@property(nonatomic,retain)CLLocationManager *locationManager;
@property(nonatomic,retain)CLGeocoder *geocoder;
@property(nonatomic,retain)UIPopoverController *popover;

@end

@implementation ViewController

@synthesize placeButton = placeButton_;
@synthesize gridViewController = gridViewController_;
@synthesize mediaHandler = mediaHandler_;
@synthesize locationManager = locationManager_;
@synthesize geocoder = geocoder_;
@synthesize popover = popover_;
- (void)dealloc {
  [placeButton_ release];
  [gridViewController_ release];
  [mediaHandler_ release];
  [locationManager_ release];
  [geocoder_ release];
  [popover_ release];
  
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.mediaHandler = [[[MediaHandler alloc]initWithDelegate:self]autorelease];
  self.geocoder = [[CLGeocoder alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
  if ([CLLocationManager locationServicesEnabled]) {
    locationManager_ = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.purpose = NSLocalizedString(@"LocationManagerPurpose", @"");
    [self.locationManager startUpdatingLocation];
  } 
  else {
    //TODO: What to do when location is not enabled
  }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)placeButtonPressed:(id)sender {
  ChoosePlaceViewController *cpvc = [[ChoosePlaceViewController alloc]init];
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self presentModalViewController:cpvc animated:YES];
  } 
  else {
    cpvc.view.frame = CGRectMake(0,0, 320, 460); 
    popover_ = [[UIPopoverController alloc]initWithContentViewController:cpvc];
    self.popover.popoverContentSize = CGSizeMake(320, 460);
    [self.popover presentPopoverFromRect:self.placeButton.frame 
                                  inView:self.view 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
  }
}

#pragma mark -
#pragma mark GridViewControllerDelegate methods

-(void)elementSelected:(NSString *)elementID {
  
}

#pragma mark -
#pragma mark MediaHandlerDelegate methods

- (void)media:(NSArray*)media withResult:(Result)result {
  
  if (result == Success) {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      self.gridViewController = 
      [[[GridViewController alloc] initWithNibName:@"GridViewController_iPhone" 
                                            bundle:nil] 
       autorelease];
    } else {
      self.gridViewController = 
      [[[GridViewController alloc] initWithNibName:@"GridViewController_iPad"
                                            bundle:nil] 
       autorelease];
    }
    
    self.gridViewController.elements = media;
    self.gridViewController.delegate = self;
    self.gridViewController.view.frame = 
    CGRectMake(0, 
               44, 
               self.view.frame.size.width, 
               self.view.frame.size.height - 44);
    [self.view addSubview:self.gridViewController.view];
  }
  else {
      //TODO: control errors
  }
  
}


#pragma mark -
#pragma mark CLLocationManagerDelegate methods 

- (void)locationManager:(CLLocationManager *)manager 
didUpdateToLocation:(CLLocation *)newLocation 
fromLocation:(CLLocation *)oldLocation {
  [self.mediaHandler mediaForLocation:newLocation.coordinate];
  [self.locationManager stopUpdatingLocation];
  [self.geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error){
    //TODO: control error
    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
    [self.placeButton setTitle:firstPlacemark.locality forState:UIControlStateNormal];
  } ];
}
@end
