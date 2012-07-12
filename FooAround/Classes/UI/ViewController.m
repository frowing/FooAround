//
//  ViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize placeButton = placeButton_;
@synthesize gridViewController = gridViewController_;
@synthesize mediaHandler = mediaHandler_;

- (void)dealloc {
  [placeButton_ release];
  [gridViewController_ release];
  [mediaHandler_ release];
  
  [super dealloc];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  self.mediaHandler = [[[MediaHandler alloc]initWithDelegate:self]autorelease];
  [self.mediaHandler mediaForLocation:CLLocationCoordinate2DMake(40.62725620, -4.00858680)];
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
  
}

#pragma mark -
#pragma mark GridViewControllerDelegate methods

-(void)elementSelected:(NSString *)elementID {
  
}

#pragma mark -
#pragma mark MediaHandlerDelegate methods

- (void)media:(NSArray*)media withResult:(Result)result {
  
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    self.gridViewController = [[[GridViewController alloc] initWithNibName:@"GridViewController_iPhone" bundle:nil] autorelease];
  } else {
    self.gridViewController = [[[GridViewController alloc] initWithNibName:@"GridViewController_iPad" bundle:nil] autorelease];
  }
  
  self.gridViewController.elements = media;
  self.gridViewController.delegate = self;
  self.gridViewController.view.frame = 
  CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
  [self.view addSubview:self.gridViewController.view];
}
@end
