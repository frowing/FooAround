//
//  ThumbnailViewController.h
//  Unity-iPhone
//
//  Created by frowing on 4/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#define WIDTH_TO_HEIGHT_RATIO 1.0f

@class AsyncImageView;
@class MediaObject;

typedef enum {
  eInitial,
  eSelected,
  eNotSelected
}ThumbnailState;

@protocol ThumbnailViewControllerDelegate

- (void)thumbnailSelectedWithID:(NSString*)thumbnailID;

@end

@interface ThumbnailViewController : UIViewController

@property(nonatomic,retain)IBOutlet AsyncImageView *imageView;
@property(nonatomic,retain)IBOutlet UIView *backgroundView;
@property(nonatomic,retain)IBOutlet UIButton *selectionButton;
@property(nonatomic,assign) id<ThumbnailViewControllerDelegate> delegate;
@property(nonatomic,retain) MediaObject *mediaObject;

- (IBAction)selectionButtonPressed:(id)sender;

- (id)initWithMediaObject:(MediaObject*)mediaObject;

@end
