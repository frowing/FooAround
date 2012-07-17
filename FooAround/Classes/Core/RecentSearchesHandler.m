//
//  RecentSearchesHandler.m
//  FooAround
//
//  Created by Francisco Sevillano on 17/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentSearchesHandler.h"

#define MAX_RECENT_SEARCHES         10
#define FILENAME                    @"Busquedas_recientes"

@interface RecentSearchesHandler()

-(NSString*)filePath;

@end

static RecentSearchesHandler* sharedInstance = nil;

@implementation RecentSearchesHandler

@synthesize recentSearches = recentSearches_;

- (void)dealloc {
  [recentSearches_ release];
  
  [super dealloc];
}

- (void)addPlacemark:(CLPlacemark*)placemark {
  NSAssert(placemark != nil,@"placemark should not be nil");
  
  if ([self.recentSearches count] == MAX_RECENT_SEARCHES) {
    [self.recentSearches removeLastObject];
  }
  
  NSMutableArray *newRecentSearches = 
  [NSMutableArray arrayWithArray:self.recentSearches];
  
  [newRecentSearches insertObject:placemark atIndex:0];
  
  self.recentSearches = newRecentSearches;
  
  BOOL archivingSuccess = 
  [NSKeyedArchiver archiveRootObject:newRecentSearches
                              toFile:[self filePath]];  
  
  NSAssert(archivingSuccess,@"archiving failed");  
}

#pragma mark - 
#pragma mark Private methods 

-(NSString*)filePath {
  NSArray *paths = 
  NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,NSUserDomainMask,YES);
  
	NSString *libraryDirectory = [paths objectAtIndex:0];
  
	NSString *filePath = 
  [libraryDirectory stringByAppendingPathComponent:FILENAME];
  
  NSAssert(filePath != nil,@"filepath should not be nil");
  return filePath;
}

#pragma mark -
#pragma mark Singleton methods

+ (RecentSearchesHandler *) sharedInstance
{
	@synchronized(self)
  {
		if (sharedInstance == nil)
    {
			sharedInstance = [[super allocWithZone:NULL]init];
      sharedInstance.recentSearches = 
      [NSKeyedUnarchiver unarchiveObjectWithFile:[sharedInstance filePath]];
      
      if (sharedInstance.recentSearches == nil) {
        sharedInstance.recentSearches = [[[NSMutableArray alloc]init] autorelease];
      }
		}
	}
	return sharedInstance;
}

+ (id)allocWithZone:(NSZone *) zone
{
  @synchronized(self)
  {
    if (sharedInstance == nil)
    {
      sharedInstance = [super allocWithZone:zone];
      return sharedInstance;  // assignment and return on first allocation
    }
  }
  return nil; // on subsequent allocation attempts return nil
}


- (id)copyWithZone:(NSZone *)zone
{
  return self;
}


- (id)retain
{
  return self;
}


- (unsigned)retainCount
{
  return UINT_MAX;  // denotes an object that cannot be released
}


- (oneway void)release
{
  //do nothing
}


- (id)autorelease
{
  return self;
}


@end
