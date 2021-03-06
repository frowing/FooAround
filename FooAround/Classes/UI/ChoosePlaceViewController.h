//
//  ChoosePlaceViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSelectedDelegate.h"
#import "WannaHideDelegate.h"

@interface ChoosePlaceViewController : UIViewController
<LocationSelectedDelegate,
WannaHideDelegate>

@property(nonatomic,assign)id<LocationSelectedDelegate,WannaHideDelegate>delegate;

@end
