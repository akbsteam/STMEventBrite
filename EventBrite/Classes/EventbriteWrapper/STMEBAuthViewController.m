// STMEventbriteAuthenticationViewController.m
//
// Copyright (c) 2013 Andy Bennett (http://steamshift.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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
