//
//  STMEventbriteAuthenticationViewController.h
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STMEBAuthDelegate.h"

@class STMEventbrite;

@interface STMEBAuthViewController : UIViewController <UIWebViewDelegate>

- (id)initWithUrl:(NSURL *)url ebWrapper:(STMEventbrite *)ebWrapper delegate:(id <STMEBAuthDelegate>) delegate;

@end
