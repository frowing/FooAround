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

- (void)hideChoosePlaceViewController;

@end

@implementation ViewController

@synthesize placeButton = placeButton_;
@synthesize errorMessageLabel = errorMessageLabel_;
@synthesize retryButton = retryButton_;
@synthesize gridViewController = gridViewController_;
@synthesize choosePlaceViewController = choosePlaceViewController_;
@synthesize mediaHandler = mediaHandler_;
@synthesize locationManager = locationManager_;
@synthesize geocoder = geocoder_;
@synthesize popover = popover_;

- (void)dealloc {
  [placeButton_ release];
  [errorMessageLabel_ release];
  [retryButton_ release];
  [gridViewController_ release];
  [choosePlaceViewController_ release];
  [mediaHandler_ release];
  [locationManager_ release];
  [geocoder_ release];
  [popover_ release];
  
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
  
  self.geocoder = [[CLGeocoder alloc]init];
  
  [self.placeButton setTitleColor:BUTTON_TEXT_COLOR 
                         forState:UIControlStateNormal];
  [self.retryButton setTitleColor:BUTTON_TEXT_COLOR 
                         forState:UIControlStateNormal];
  [self.retryButton setTitle:NSLocalizedString(@"RetryButtonTitle", @"") 
                    forState:UIControlStateNormal];
  
  if ([CLLocationManager locationServicesEnabled]) {
    locationManager_ = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    self.locationManager.purpose = NSLocalizedString(@"LocationManagerPurpose", @"");
    [self.locationManager startUpdatingLocation];
  } 
  else {
    self.errorMessageLabel.text = NSLocalizedString(@"LocationDisabledErrorMessage",@"");
    //TODO: enlazar a las settings de la aplicación con el retry button
    self.retryButton.hidden = YES;
    self.retryButton.tag = RETRY_LOCATION_TAG;
    self.errorMessageLabel.hidden = NO;
  }
}

- (void)viewWillAppear:(BOOL)animated {
  
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
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    [self presentModalViewController:self.choosePlaceViewController animated:YES];
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
  NSAssert(self.retryButton.tag != RETRY_NONE,
           @"The retry button should have a meaningful tag");
  
  self.retryButton.hidden = YES;
  self.errorMessageLabel.hidden = YES;
  [self.mediaHandler mediaForLocation:self.locationManager.location.coordinate];
  [self.geocoder reverseGeocodeLocation:self.locationManager.location 
                      completionHandler:^(NSArray *placemarks, NSError *error){
    //TODO: control error
    CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];                      
    [self.placeButton setTitle:firstPlacemark.locality 
                      forState:UIControlStateNormal];
  }];
}

#pragma mark -
#pragma mark GridViewControllerDelegate methods

- (void)needToShowImage:(NSString*)name WithURL:(NSString*)url {
  
  //Name might be nil but url can't
  NSAssert(url != nil,@"url should not be nil");
  
  SingleImageView *imageView = 
  [[SingleImageView alloc]initWithFrame:CGRectMake(0, 
                                                   0, 
                                                   self.view.frame.size.width, 
                                                   self.view.frame.size.height) 
                                   name:name
                                    url:url];
  
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
  //TODO: controlar que si hay error se muestre un mensaje
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
    self.errorMessageLabel.text = NSLocalizedString(@"InstagramErrorMessage",@"");
    self.retryButton.tag = RETRY_INSTAGRAM_TAG;    
    self.retryButton.hidden = NO;
    self.errorMessageLabel.hidden = NO;
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

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
  [manager stopUpdatingLocation];
  NSLog(@"Error: %@",[error localizedDescription]);
  switch([error code]) {
    case kCLErrorDenied:
      self.errorMessageLabel.text = NSLocalizedString(@"LocationDisabledErrorMessage",@"");
      break;
    case kCLErrorLocationUnknown:
      self.errorMessageLabel.text = NSLocalizedString(@"LocationUnknownErrorMessage", @"");
      self.retryButton.tag = RETRY_LOCATION_TAG;
      break;
    default:
      self.errorMessageLabel.text = NSLocalizedString(@"LocationUnknownErrorMessage", @"");
      self.retryButton.tag = RETRY_LOCATION_TAG;
      break;
  }
  
  self.errorMessageLabel.hidden = NO;

}

#pragma mark - 
#pragma mark WannaHideDelegate methods 

- (void)wannaHide:(UIViewController*)viewController {
  [self hideChoosePlaceViewController];
}

#pragma mark -
#pragma LocationSelectedDelegate methods 

- (void)locationSelected:(NSString *)locationName 
           atCoordinates:(CLLocationCoordinate2D)coordinates {
  [self.gridViewController.view removeFromSuperview];
  self.gridViewController = nil;
  self.errorMessageLabel.hidden = YES;
  self.retryButton.hidden = YES;
  [self.placeButton setTitle:locationName forState:UIControlStateNormal];
  [self.mediaHandler mediaForLocation:coordinates];
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

@end
