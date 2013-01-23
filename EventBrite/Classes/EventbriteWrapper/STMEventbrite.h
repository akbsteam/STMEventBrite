// STMEventBrite.h
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
#import <Foundation/Foundation.h>

#import "STMEBAuthDelegate.h"

typedef void (^STMBESuccess)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef void (^STMBEFailure)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON);

@interface STMEventbrite : NSObject

- (id)initWithAppKey:(NSString *)appKey secret:(NSString *)secret;
- (BOOL)hasAccessToken;
- (UIViewController *)authoriseViewController:(id <STMEBAuthDelegate>)delegate;
- (void)setAccessToken:(NSString *)accessToken;

#pragma mark - Events

- (void)eventSearchWithArgs:(NSDictionary *)args success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)eventGet:(NSString *)eventId success:(STMBESuccess)success failure:(STMBEFailure)failure;

//- (void)eventNew;
//- (void)eventCopy;
//- (void)eventUpdate;

#pragma mark - Tickets

//- (void)ticketNew;
//- (void)ticketUpdate;

#pragma mark - Venues

- (void)venueGet:(NSString *)venueId success:(STMBESuccess)success failure:(STMBEFailure)failure;
//- (void)venueNew;
//- (void)venueUpdate;

#pragma mark - Discount Codes

//- (void)eventListDiscounts;
//- (void)discountNew;
//- (void)discountUpdate;

#pragma mark - Attendees

- (void)eventListAttendees:(NSString *)eventId
                     count:(NSUInteger)count
                      page:(NSUInteger)page
              doNotDisplay:(NSArray *)doNotDisplay
          showFullBarcodes:(BOOL)showFullBarcodes
                   success:(STMBESuccess)success
                   failure:(STMBEFailure)failure;

#pragma mark - Organizer Profiles

- (void)organizerListEvents:(NSString *)organizerId display:(NSArray *)display success:(STMBESuccess)success failure:(STMBEFailure)failure;

- (void)organizerGet:(NSString *)organizerId success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)organizerNewName:(NSString *)name description:(NSString *)description success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)organizerUpdate:(NSString *)organizerId name:(NSString *)name description:(NSString *)description success:(STMBESuccess)success failure:(STMBEFailure)failure;

#pragma mark - Users

- (void)userListEventsForUser:(NSString *)email
                      display:(NSArray *)display
                 doNotDisplay:(NSArray *)doNotDisplay
                     statuses:(NSArray *)statuses
                          asc:(BOOL)asc
                      success:(STMBESuccess)success
                      failure:(STMBEFailure)failure;

- (void)userListTicketsWithType:(NSString *)type success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)userListVenuesWithSuccess:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)userListOrganizersWithSuccess:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)userGetWithId:(NSString *)userId orEmail:(NSString *)email success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)userNewWithEmail:(NSString *)email password:(NSString *)password success:(STMBESuccess)success failure:(STMBEFailure)failure;
- (void)userUpdateWithEmail:(NSString *)email password:(NSString *)password success:(STMBESuccess)success failure:(STMBEFailure)failure;

#pragma mark - Payments

//- (void)paymentUpdate;

@end
