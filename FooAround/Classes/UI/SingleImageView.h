//
//  SingleImageView.h
//  FooAround
//
//  Created by Francisco Sevillano on 15/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SINGLE_IMAGE_SHOWING_HIDING_TIME  0.2f

@interface SingleImageView : UIView

- (id)initWithFrame:(CGRect)frame name:(NSString*)name url:(NSString*)url;

@end
