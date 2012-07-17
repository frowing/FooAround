//
//  ViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewController.h"
#import "LocationSelectedDelegate.h"
#import "MediaHandler.h"
#import "WannaHideDelegate.h"

@interface ViewController : UIViewController
<CLLocationManagerDelegate, 
GridViewControllerDelegate,
LocationSelectedDelegate,
MediaHandlerDelegate,
WannaHideDelegate, 
UIAlertViewDelegate>

@property(nonatomic,retain)IBOutlet UILabel *errorMessageLabel;
@property(nonatomic,retain)IBOutlet UIButton *retryButton;
@property(nonatomic,retain)IBOutlet UIButton *placeButton;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *navActivity;

- (IBAction)placeButtonPressed:(id)sender;
- (IBAction)retryButtonPressed:(id)sender;

- (void)start;

@end
