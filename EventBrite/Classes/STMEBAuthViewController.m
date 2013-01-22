//
//  STMEventbriteAuthenticationViewController.m
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import "STMEBAuthViewController.h"
#import "XQueryComponents.h"
#import "STMEventbrite.h"

@interface STMEBAuthViewController ()

@property (nonatomic, strong) UIWebView *webview;
@property (nonatomic, weak) STMEventbrite *ebWrapper;
@property (nonatomic, weak) id <STMEBAuthDelegate> delegate;

@end

@implementation STMEBAuthViewController

- (id)initWithUrl:(NSURL *)url ebWrapper:(STMEventbrite *)ebWrapper delegate:(id <STMEBAuthDelegate>) delegate
{
    if (!(self = [super init]))
        return nil;
    
    _ebWrapper = ebWrapper;
    _delegate = delegate;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view.frame = screenRect;
    _webview = [[UIWebView alloc] initWithFrame:screenRect];
    _webview.delegate = self;
    [self.view addSubview:_webview];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [_webview loadRequest:requestObj];
    
    return self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [[request URL] absoluteString];
    NSInteger loc = [url rangeOfString:@"#"].location;
    
    if (url && loc != NSNotFound)
    {
        NSString *query = [url substringFromIndex:loc+1];
        
        NSDictionary *dict = [query dictionaryFromQueryComponents];
        NSArray *accessToken = [dict objectForKey:@"access_token"];
        NSArray *tokenType = [dict objectForKey:@"token_type"];
        
        if ([[tokenType lastObject] isEqualToString:@"Bearer"] && [accessToken count] > 0)
        {
            self.ebWrapper.accessToken = [accessToken lastObject];
            [self dismissModalViewControllerAnimated:YES];
            [self.delegate complete];
            
            return NO;
        }
    }
    
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
