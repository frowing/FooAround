//
//  MediaObject.h
//  FooAround
//
//  Created by Francisco Sevillano on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
* Media Object Container
*/
@interface MediaObject : NSObject 

@property(nonatomic,retain) NSString *ident;
@property(nonatomic,retain) NSString *name;
@property(nonatomic,retain) NSString *thumbnailURL;
@property(nonatomic,retain) NSString *lowResURL;
@property(nonatomic,retain) NSString *standardURL;


@end
