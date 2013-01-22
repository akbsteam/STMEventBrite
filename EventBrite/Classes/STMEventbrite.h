//
//  STMEventBrite.h
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "STMEBAuthDelegate.h"

@interface STMEventbrite : NSObject

- (id)initWithAppKey:(NSString *)appKey secret:(NSString *)secret;
- (UIViewController *)authoriseViewController:(id <STMEBAuthDelegate>)delegate;
- (void)setAccessToken:(NSString *)accessToken;

#pragma mark - Events

- (void)eventSearchWithKeywords:(NSArray *)keywords;
- (void)eventGet:(NSUInteger)id;
//- (void)eventNew;
//- (void)eventCopy;
//- (void)eventUpdate;

#pragma mark - Tickets

//- (void)ticketNew;
//- (void)ticketUpdate;

#pragma mark - Venues

- (void)venueGet:(NSUInteger)id;
//- (void)venueNew;
//- (void)venueUpdate;

#pragma mark - Discount Codes

//- (void)eventListDiscounts;
//- (void)discountNew;
//- (void)discountUpdate;

#pragma mark - Attendees

- (void)eventListAttendees:(NSUInteger)id count:(NSUInteger)count page:(NSUInteger)page doNotDisplay:(NSArray *)doNotDisplay showFullBarcodes:(BOOL)showFullBarcodes;

#pragma mark - Organizer Profiles

- (void)organizerListEvents:(NSUInteger)id display:(NSArray *)display;
- (void)organizerGet:(NSUInteger)id;
- (void)organizerNewName:(NSString *)name description:(NSString *)description;
- (void)organizerUpdate:(NSUInteger)id name:(NSString *)name description:(NSString *)description;

#pragma mark - Users

- (void)userListEventsForUser:(NSString *)email display:(NSArray *)display doNotDisplay:(NSArray *)doNotDisplay statuses:(NSArray *)statuses asc:(BOOL)asc;
- (void)userListTicketsWithType:(NSString *)type;
- (void)userListVenues;
- (void)userListOrganizers;
- (void)userGetWithId:(NSUInteger)id orEmail:(NSString *)email;
- (void)userNewWithEmail:(NSString *)email password:(NSString *)password;
- (void)userUpdateWithEmail:(NSString *)email password:(NSString *)password;

#pragma mark - Payments

//- (void)paymentUpdate;

@end
