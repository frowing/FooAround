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
#define IDENT_KEY                         @"id"
#define IMAGES_KEY                        @"images"
#define LOW_RES_KEY                       @"low_resolution"
#define THUMBNAIL_KEY                     @"thumbnail"
#define STANDARD_RES_KEY                  @"standard_resolution"
#define URL_KEY                           @"url"
#define CAPTION_KEY                       @"caption"
#define TEXT_KEY                          @"text"

@interface MediaParser()


@end

@implementation MediaParser

- (NSArray*)mediaObjectsInData:(NSData*)data {
  NSError *error = nil;
  NSDictionary *dataDictionary = 
  [NSJSONSerialization JSONObjectWithData:data 
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
    MediaObject *mediaObject = [[[MediaObject alloc]init] autorelease];
    
    NSDictionary *imagesDict = [mediaObjectDict objectForKey:IMAGES_KEY];
    
    NSDictionary *lowResImageDict = [imagesDict objectForKey:LOW_RES_KEY];
    mediaObject.lowResURL = [lowResImageDict objectForKey:URL_KEY];
    
    NSDictionary *standardResImageDict = [imagesDict objectForKey:STANDARD_RES_KEY];
    mediaObject.standardURL = [standardResImageDict objectForKey:URL_KEY];
    
    NSDictionary *thumbnailImageDict = [imagesDict objectForKey:THUMBNAIL_KEY];
    mediaObject.thumbnailURL = [thumbnailImageDict objectForKey:URL_KEY];
    
    NSDictionary *captionDict = [mediaObjectDict objectForKey:CAPTION_KEY];
    if (![captionDict isKindOfClass:[NSNull class]]) {
      mediaObject.text = [captionDict objectForKey:TEXT_KEY];
    }
    
    mediaObject.ident = [mediaObjectDict objectForKey:IDENT_KEY];
    
    [mediaObjects addObject:mediaObject];
  }
  
  return mediaObjects;
  
} 

@end
