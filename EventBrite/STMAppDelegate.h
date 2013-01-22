//
//  STMAppDelegate.h
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STMViewController;

@interface STMAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) STMViewController *viewController;

@end
