//
//  AppDelegate.h
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXPORT NSString * const INSTAGRAM_CLIENT_ID;

@class ViewController;

@interface AppDelegate : UIResponder 
<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property(nonatomic,retain)NSString *accessToken;

- (void)authenticate;


@end
