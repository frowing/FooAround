//
//  MediaHandler.h
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "HttpConnection.h"
#import "Result.h"

/**
 * Will inform about the retrieving results
 */
@protocol MediaHandlerDelegate

- (void)media:(NSArray*)media withResult:(Result)result;

@end

/**
 * Performs necessary operations to retrieve media objects
 */
@interface MediaHandler : NSObject<HttpConnectionDelegate> 

- (id)initWithDelegate:(id<MediaHandlerDelegate>)delegate;
- (void)mediaForLocation:(CLLocationCoordinate2D)location;

@end
