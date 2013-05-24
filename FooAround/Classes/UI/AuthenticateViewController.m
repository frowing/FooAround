//
//  AuthenticateViewController.m
//  FooAround
//
//  Created by Francisco Sevillano on 13/01/13.
//
//

#import "AuthenticateViewController.h"


#define REDIRECT_URL @"motherfuckingboss://yeah"

@interface AuthenticateViewController ()

@property(nonatomic,assign)id<AuthenticateDelegate>delegate;
@property(nonatomic,retain)NSString *clientId;
@property(nonatomic,retain)NSString *accessToken;
@property(nonatomic,retain)UIWebView *webView;


@end

@implementation AuthenticateViewController

- (void)dealloc
{
    [_clientId release];
    [_webView release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithDelegate:(id<AuthenticateDelegate>)delegate
              clientId:(NSString*)clientId
        andAccessToken:(NSString*)accessToken
{
    self = [super init];
    if (self)
    {
      _delegate = delegate;
      _accessToken = accessToken;
      _clientId = clientId;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    if (self.accessToken != nil)
    {
      [self.delegate authenticated:YES withAccessToken:self.accessToken];
    }
    else
    {
      NSString *url =
        [NSString stringWithFormat:@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token",self.clientId,REDIRECT_URL];
      NSLog(@"authorization url %@",url);
      [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
    }
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate methods 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
  NSLog(@"redirect url %@",request.URL.absoluteString);
  if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound)
  {
    NSString* params =
      [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
      
    NSString *accessToken =
        [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
      
    [self.delegate authenticated:YES withAccessToken:accessToken];
    [self dismissModalViewControllerAnimated:YES];
    return NO;
  }
  else if ([request.URL.absoluteString rangeOfString:@"error"].location != NSNotFound)
  {
    [self.delegate authenticated:NO withAccessToken:nil];
    return NO;
  }
  else
  {
    return YES;
  }
}

@end
