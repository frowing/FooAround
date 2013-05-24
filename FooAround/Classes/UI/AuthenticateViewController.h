//
//  AuthenticateViewController.h
//  FooAround
//
//  Created by Francisco Sevillano on 13/01/13.
//
//

#import <UIKit/UIKit.h>

@protocol AuthenticateDelegate

@required
- (void)authenticated:(BOOL)success
      withAccessToken:(NSString*)accessToken;

@end

@interface AuthenticateViewController : UIViewController<UIWebViewDelegate>

- (id)initWithDelegate:(id<AuthenticateDelegate>)delegate
              clientId:(NSString*)clientId
        andAccessToken:(NSString*)accessToken;

@end
