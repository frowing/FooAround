//
//  ViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ChoosePlaceViewController.h"
#import "ViewController.h"
#import "SingleImageView.h"

#define BUTTON_TEXT_COLOR  [UIColor colorWithRed:(49.0f / 255.0f) green:(140.0f/255.0f) blue:(191.0f/255.0f) alpha:1.0f]


//The retry button can have two functions, retry getting the location or 
//pictures from Instagram
#define RETRY_NONE          -1
#define RETRY_LOCATION_TAG  0
#define RETRY_INSTAGRAM_TAG 1

@interface ViewController ()

@property(nonatomic,retain) MediaHandler *mediaHandler;
@property(nonatomic,retain) GridViewController *gridViewController;
@property(nonatomic,retain) ChoosePlaceViewController *choosePlaceViewController;
@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) CLGeocoder *geocoder;
@property(nonatomic,retain) UIPopoverController *popover;

@property(nonatomic,assign) BOOL locationSelected;
@property(nonatomic,retain) NSString *locationSelectedName;
@property(nonatomic,assign) CLLocationCoordinate2D locationSelectedCoordinates; 

//We are getting too many location updates too quickly, we just need one
@property(nonatomic,assign) BOOL gotFirstLocation;

- (void)hideChoosePlaceViewController;
- (void)getLocation;
- (void)doReverseGeocoding;
- (void)showErrorMessage:(NSString*)message 
              showButton:(BOOL)showButton 
           withButtonTag:(NSUInteger)buttonTag;
- (void)hideErrorMessage;
- (void)showGridViewControllerWithElements:(NSArray*)elements;

@end

@implementation ViewController

@synthesize placeButton = placeButton_;
@synthesize navBarActivity = navBarActivity_;
@synthesize errorMessageLabel = errorMessageLabel_;
@synthesize retryButton = retryButton_;
@synthesize gridViewController = gridViewController_;
@synthesize choosePlaceViewController = choosePlaceViewController_;
@synthesize mediaHandler = mediaHandler_;
@synthesize locationManager = locationManager_;
@synthesize geocoder = geocoder_;
@synthesize popover = popover_;
@synthesize locationSelected = locationSelected_;
@synthesize locationSelectedName = locationSelectedName;
@synthesize locationSelectedCoordinates = locationSelectedCoordinates;
@synthesize gotFirstLocation = gotFirstLocation_;
@synthesize bodyActivity = bodyActivity_;

- (void)dealloc {
  [placeButton_ release];
  [navBarActivity_ release];
  [errorMessageLabel_ release];
  [retryButton_ release];
  [gridViewController_ release];
  [choosePlaceViewController_ release];
  [mediaHandler_ release];
  [locationManager_ release];
  [geocoder_ release];
  [popover_ release];
  [bodyActivity_ release];
  
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.choosePlaceViewController = 
  [[[ChoosePlaceViewController alloc]init]autorelease];
  
  self.choosePlaceViewController.delegate = self;
  self.mediaHandler = 
  [[[MediaHandler alloc]initWithDelegate:self]autorelease];
  
  self.geocoder = [[[CLGeocoder alloc]init] autorelease];
  
  [self.placeButton setTitleColor:BUTTON_TEXT_COLOR 
                         forState:UIControlStateNormal];
  [self.retryButton setTitleColor:BUTTON_TEXT_COLOR 
                         forState:UIControlStateNormal];
  [self.retryButton setTitle:NSLocalizedString(@"RetryButtonTitle", @"") 
                    forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return NO;
}

- (IBAction)placeButtonPressed:(id)sender {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self presentModalViewController:self.choosePlaceViewController 
                            animated:YES];
  } 
  else {
    self.choosePlaceViewController.view.frame = CGRectMake(0,0, 320, 460); 
    popover_ = 
    [[UIPopoverController alloc]initWithContentViewController:self.choosePlaceViewController];
    
    self.popover.popoverContentSize = CGSizeMake(320, 460);
    [self.popover presentPopoverFromRect:self.placeButton.frame 
                                  inView:self.view 
                permittedArrowDirections:UIPopoverArrowDirectionAny 
                                animated:YES];
  }
}

- (IBAction)retryButtonPressed:(id)sender {
  
  if (self.retryButton.tag == RETRY_INSTAGRAM_TAG) {
    if (self.locationSelected) {
      [self locationSelected:self.locationSelectedName 
               atCoordinates:self.locationSelectedCoordinates];
    }
    else {
      [self doReverseGeocoding];
    } 
  }
  else if (self.retryButton.tag == RETRY_LOCATION_TAG) {
    [self getLocation];
  }
  else {
    NSAssert(NO,
             @"The retry button should have a meaningful tag");
  }
}

- (void)start {
  if (!self.locationSelected) {
      [self getLocation];
  }
}

#pragma mark -
#pragma mark GridViewControllerDelegate methods

- (void)needToShowImage:(NSString*)name WithURL:(NSString*)url {
  
  //Name might be nil but url can't
  NSAssert(url != nil,@"url should not be nil");
  
  SingleImageView *imageView = 
  [[[SingleImageView alloc]initWithFrame:CGRectMake(0, 
                                                   0, 
                                                   self.view.frame.size.width, 
                                                   self.view.frame.size.height) 
                                   name:name
                                    url:url] 
   autorelease];
  
  imageView.alpha = 0.0f;
  [self.view addSubview:imageView];
  [UIView animateWithDuration:SINGLE_IMAGE_SHOWING_HIDING_TIME
                   animations:^{
    imageView.alpha = 1.0f;
  } completion:^(BOOL finished) {
    
  }];
}

#pragma mark -
#pragma mark MediaHandlerDelegate methods

- (void)media:(NSArray*)media withResult:(Result)result {
  self.bodyActivity.hidden = YES;
  if (result == Success) {
    if ([media count] > 0) {
      [self showGridViewControllerWithElements:media];
    }
    else {
      [self showErrorMessage:NSLocalizedString(@"InstagramEmptyMessage",@"") 
                  showButton:NO
               withButtonTag:RETRY_NONE];
    }
  }
  else { 
    
    NSUInteger tagForButton = RETRY_NONE;
    
    if (self.locationSelected) {
      tagForButton = RETRY_LOCATION_TAG;
    }
    else {
      tagForButton = RETRY_INSTAGRAM_TAG;
    } 
    
    [self showErrorMessage:NSLocalizedString(@"InstagramErrorMessage",@"") 
                showButton:YES 
             withButtonTag:tagForButton];
  }
  
}


#pragma mark -
#pragma mark CLLocationManagerDelegate methods 

- (void)locationManager:(CLLocationManager *)manager 
didUpdateToLocation:(CLLocation *)newLocation 
fromLocation:(CLLocation *)oldLocation {
  if (!self.gotFirstLocation) {
    self.gotFirstLocation = YES;
    [self.locationManager stopUpdatingLocation];
    [self doReverseGeocoding];
  }  
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  [manager stopUpdatingLocation];
  self.navBarActivity.hidden = YES;
  NSLog(@"Error: %@",[error localizedDescription]);
  switch([error code]) {
    case kCLErrorDenied:
      [self showErrorMessage:NSLocalizedString(@"LocationDisabledErrorMessage",@"") 
                  showButton:NO 
               withButtonTag:RETRY_NONE];
      
      [self.placeButton setTitle:NSLocalizedString(@"SearchTitle", @"") 
                        forState:UIControlStateNormal];
      break;
    case kCLErrorLocationUnknown:
      [self showErrorMessage:NSLocalizedString(@"LocationUnknownErrorMessage", @"") 
                  showButton:YES 
               withButtonTag:RETRY_LOCATION_TAG];
      break;
    default:
      [self showErrorMessage:NSLocalizedString(@"LocationUnknownErrorMessage", @"") 
                  showButton:YES 
               withButtonTag:RETRY_LOCATION_TAG];
      break;
  }
  
  self.locationSelected = NO;
}

#pragma mark - 
#pragma mark WannaHideDelegate methods 

- (void)wannaHide:(UIViewController*)viewController {
  [self hideChoosePlaceViewController];
}

#pragma mark -
#pragma mark LocationSelectedDelegate methods 

- (void)locationSelected:(NSString *)locationName 
           atCoordinates:(CLLocationCoordinate2D)coordinates {
  self.locationSelected = YES;
  self.locationSelectedName = locationName;
  self.locationSelectedCoordinates = coordinates;
  [self.gridViewController.view removeFromSuperview];
  self.gridViewController = nil;
  self.bodyActivity.hidden = NO;
  [self hideErrorMessage];
  [self.placeButton setTitle:locationName forState:UIControlStateNormal];
  [self.mediaHandler mediaForLocation:coordinates];
  [self hideChoosePlaceViewController];
}

- (void)currentLocationSelected {
  self.locationSelected = NO;
  [self getLocation];
  [self hideChoosePlaceViewController];
}

#pragma mark -
#pragma mark Private methods

- (void)hideChoosePlaceViewController {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self.choosePlaceViewController dismissModalViewControllerAnimated:YES];
  } else {
    [self.popover dismissPopoverAnimated:YES];
  }
}

- (void)getLocation {
  [self.gridViewController.view removeFromSuperview];
  self.gridViewController = nil;
  [self hideErrorMessage];
  if ([CLLocationManager locationServicesEnabled]) {
    locationManager_ = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.purpose = 
    NSLocalizedString(@"LocationManagerPurpose", @"");
    self.gotFirstLocation = NO;
    self.navBarActivity.hidden = NO;
    [self.locationManager startUpdatingLocation];
  } 
  else {
    
    [self showErrorMessage:NSLocalizedString(@"LocationDisabledErrorMessage",@"") 
                showButton:NO 
             withButtonTag:RETRY_NONE];
    
    [self.placeButton setTitle:NSLocalizedString(@"SearchTitle", @"") 
                      forState:UIControlStateNormal];
    self.locationSelected = NO;
    self.locationSelectedName = nil;
  }
}

- (void)doReverseGeocoding {
  self.navBarActivity.hidden = NO;
  [self hideErrorMessage];
  self.bodyActivity.hidden = NO;
  [self.mediaHandler mediaForLocation:self.locationManager.location.coordinate];
  [self.placeButton setTitle:NSLocalizedString(@"LocatingTitle", @"") 
                    forState:UIControlStateNormal];
  [self.geocoder reverseGeocodeLocation:self.locationManager.location 
                      completionHandler:^(NSArray *placemarks, NSError *error){
                        CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];                      
                        [self.placeButton setTitle:firstPlacemark.locality 
                                          forState:UIControlStateNormal];
                        
                        self.navBarActivity.hidden = YES;
                      }];
}

- (void)showErrorMessage:(NSString*)message 
              showButton:(BOOL)showButton 
           withButtonTag:(NSUInteger)buttonTag {
  NSAssert((buttonTag == RETRY_INSTAGRAM_TAG) || 
           (buttonTag == RETRY_LOCATION_TAG) || 
           (buttonTag == RETRY_NONE),
           @"unknown tag");
  
  self.errorMessageLabel.text = message;
  self.errorMessageLabel.hidden = NO;
  self.retryButton.tag = buttonTag;
  self.retryButton.hidden = !showButton;
}

- (void)hideErrorMessage {
  self.errorMessageLabel.hidden = YES;
  self.retryButton.hidden = YES;
}

- (void)showGridViewControllerWithElements:(NSArray*)elements {
  
  NSAssert(elements != nil,@"elements should not be nil");
  
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
  
  self.gridViewController.elements = elements;
  self.gridViewController.delegate = self;
  self.gridViewController.view.frame = 
  CGRectMake(0, 
             44, 
             self.view.frame.size.width, 
             self.view.frame.size.height - 44);
  [self.view addSubview:self.gridViewController.view];
}

@end
