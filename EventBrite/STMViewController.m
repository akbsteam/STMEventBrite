//
//  STMViewController.m
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import "STMViewController.h"
#import "STMEventBrite.h"

@interface STMViewController ()

@property (nonatomic, strong) STMEventbrite *eb;

@end

@implementation STMViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (!self.eb) {
#warning add appkey, appsecret
        self.eb = [[STMEventbrite alloc] initWithAppKey:@"APPKEY" secret:@"APPSECRET"];
        UIViewController *vc = [self.eb authoriseViewController:self];
        [self presentModalViewController:vc animated:YES];
    }
}

- (void)complete
{
    [self.eb eventSearchWithKeywords:@[@"Southampton"]];
}

@end
