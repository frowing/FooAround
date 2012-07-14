//
//  ViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridViewController.h"
#import "MediaHandler.h"

@interface ViewController : UIViewController
<CLLocationManagerDelegate, 
GridViewControllerDelegate,
MediaHandlerDelegate>

@property(nonatomic,retain)IBOutlet UIButton *placeButton;

- (IBAction)placeButtonPressed:(id)sender;

@end
