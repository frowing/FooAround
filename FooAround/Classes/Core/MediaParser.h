//
//  MediaParser.h
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Parses data into Media objects
 */
@interface MediaParser : NSObject

- (NSArray*)mediaObjectsInData:(NSData*)data;

@end
