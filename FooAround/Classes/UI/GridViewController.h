//
//  GridViewController.h
//  Unity-iPhone
//
//  Created by frowing on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThumbnailViewController.h"

@protocol GridViewControllerDelegate
@required
- (void)needToShowImage:(NSString*)name WithURL:(NSString*)url;
@end

@interface GridViewController : UIViewController 
<ThumbnailViewControllerDelegate>

@property(nonatomic,retain) NSArray *elements; 
@property(nonatomic,assign)id<GridViewControllerDelegate> delegate;
@property(nonatomic,retain)IBOutlet UIScrollView *scrollView;
@property(nonatomic,assign)BOOL selectable;
@property(nonatomic,retain)NSString *thumbnailSelectedID;

- (id)initWithElements:(NSArray*)elements 
           andDelegate:(id<GridViewControllerDelegate>) delegate;
@end
