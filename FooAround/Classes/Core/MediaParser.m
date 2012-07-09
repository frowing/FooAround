//
//  MediaParser.m
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaParser.h"
#import "MediaObject.h"

#define DATA_KEY   @"data"
#define MEDIA_OBJECT_IDENT_KEY            @"id"
#define MEDIA_OBJECT_NAME_KEY             @"name"
#define MEDIA_OBJECT_LOW_RES_KEY          @"low_resolution"
#define MEDIA_OBJECT_THUMBNAIL_KEY        @"thumbnail"
#define MEDIA_OBJECT_STANDARD_RES_KEY     @"standard_resolution"

@interface MediaParser()


@end

@implementation MediaParser

- (NSArray*)mediaObjectsInData:(NSData*)data {
  NSError *error = nil;
  NSDictionary *dataDictionary = 
  [NSJSONSerialization dataWithJSONObject:data 
                                  options:NSJSONWritingPrettyPrinted 
                                    error:&error];
  
  if (error != nil) {
    return nil;
  }
  
  NSArray *dataArray = [dataDictionary objectForKey:DATA_KEY];
  
  if (nil == dataArray) {
    return nil;
  }
  
  NSMutableArray *mediaObjects = [NSMutableArray array];
  
  for (NSDictionary *mediaObjectDict in dataArray) {
    
  }
  
} 

@end
