//
//  SearchViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 14/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocationSelectedDelegate.h"
#import "WannaHideDelegate.h"


@interface SearchViewController : UIViewController
<UISearchBarDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,assign)id<LocationSelectedDelegate,WannaHideDelegate>delegate;

@end
