//
//  RecentViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSelectedDelegate.h"
#import "WannaHideDelegate.h"

@interface RecentViewController : UIViewController

@property(nonatomic,assign)id<LocationSelectedDelegate,WannaHideDelegate>delegate;

@end
