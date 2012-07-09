//
//  AppDelegate.h
//  FooAround
//
//  Created by Francisco Sevillano on 07/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaHandler.h"

@class ViewController;

@interface AppDelegate : UIResponder 
<MediaHandlerDelegate,UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@property (strong,nonatomic) MediaHandler *mediaHandler;


@end
