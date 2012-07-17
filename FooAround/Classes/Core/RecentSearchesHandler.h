//
//  RecentSearchesHandler.h
//  FooAround
//
//  Created by Francisco Sevillano on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface RecentSearchesHandler : NSObject

@property(nonatomic,retain) NSMutableArray *recentSearches;

- (void)addPlacemark:(CLPlacemark*)placemark;

//Implements Singleton pattern so we can easily share data between views
+ (RecentSearchesHandler*)sharedInstance;

@end
