//
//  LocationSelectedDelegate.h
//  FooAround
//
//  Created by Francisco Sevillano on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LocationSelectedDelegate <NSObject>

- (void)locationSelected:(NSString*)locationName 
           atCoordinates:(CLLocationCoordinate2D)coordinates;

@end
