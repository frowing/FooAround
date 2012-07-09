//
//  MediaObject.m
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MediaObject.h"

@implementation MediaObject

@synthesize ident = ident_;
@synthesize text = text_;
@synthesize thumbnailURL = thumbnailURL_;
@synthesize lowResURL = lowResURL_;
@synthesize standardURL = standardURL_;

- (void)dealloc {
  [ident_ release];
  [text_ release];
  [thumbnailURL_ release];
  [lowResURL_ release];
  [standardURL_ release];
  
  [super dealloc];
}


@end
