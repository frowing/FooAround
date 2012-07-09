//
//  MediaHandler.m
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaHandler.h"
#import "MediaParser.h"

#define INSTAGRAM_CLIENT_ID         @"425e20d41ebe4ec0a2e54bc54b7591c4"
#define INSTAGRAM_CLIENT_ID_KEY     @"client_id"
#define INSTAGRAM_LAT_KEY           @"lat"
#define INSTAGRAM_LONG_KEY          @"lng"
#define INSTAGRAM_MEDIA_SEARCH_URL  @"https://api.instagram.com/v1/media/search"

@interface MediaHandler()

@property(nonatomic,retain) HttpConnection *connection;
@property(nonatomic,assign) id<MediaHandlerDelegate>delegate;

@end

@implementation MediaHandler
@synthesize connection = connection_;
@synthesize delegate = delegate_;

- (void)dealloc {
  [connection_ release];
  
  [super dealloc];
}

- (id)initWithDelegate:(id<MediaHandlerDelegate>)delegate {
  self = [super init];
  
  if (self) {
    delegate_ = delegate;
    connection_ = [[HttpConnection alloc]initWithDelegate:self];
  }
  
  return self;
} 

- (void)mediaForLocation:(CLLocationCoordinate2D)location {
  
  NSAssert(CLLocationCoordinate2DIsValid(location),@"invalid location");
  
  NSString *latString = [NSString stringWithFormat:@"%f",location.latitude];
  NSString *lngString = [NSString stringWithFormat:@"%f",location.longitude];
  
  
  NSMutableDictionary *parameters = 
  [NSMutableDictionary dictionaryWithObject:INSTAGRAM_CLIENT_ID 
                              forKey:INSTAGRAM_CLIENT_ID_KEY];
  [parameters setObject:latString forKey:INSTAGRAM_LAT_KEY];
  [parameters setObject:lngString forKey:INSTAGRAM_LONG_KEY];
  
  [self.connection requestUrl:INSTAGRAM_MEDIA_SEARCH_URL 
                       params:parameters
                       method:Get
                      content:nil
                      headers:nil];
}

#pragma mark -
#pragma mark HttpConnectionDelegate methods

- (void)connection:(HttpConnection*)connection 
   requestFinished:(NSData *) result 
      withEncoding:(NSStringEncoding) encoding {
#if DEBUG
	NSString *dataReceived = 
  [[NSString alloc] initWithData:result 
                        encoding:NSUTF8StringEncoding];
  
	NSLog(@"%@", dataReceived);
	[dataReceived release];
#endif 
  
  MediaParser *parser = [[[MediaParser alloc]init] autorelease];
  NSArray *media = [parser mediaObjectsInData:result];
  
  [self.delegate media:media withResult:Success];
}

- (void)connection:(HttpConnection*)connection
     requestFailed:(Result) error {
  [self.delegate media:nil withResult:error];
}

@end
