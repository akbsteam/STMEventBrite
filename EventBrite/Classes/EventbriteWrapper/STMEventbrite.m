// STMEventBrite.m
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

#import "STMEventbrite.h"
#import <AFNetworking/AFNetworking.h>
#import <AFOAuth2Client/AFOAuth2Client.h>
#import "NSDictionary+UrlEncoding.h"

#import "STMEBAuthViewController.h"

NSString *const EVENTBRITE_BASEURL = @"https://www.eventbrite.com";

@interface STMEventbrite()

@property (nonatomic, strong) AFOAuth2Client *oauthClient;
@property (nonatomic, strong) NSString *appKey;

@end

@implementation STMEventbrite

- (id)initWithAppKey:(NSString *)appKey secret:(NSString *)secret
{
    if (!(self = [super init]))
        return nil;
    
    NSURL *baseurl = [NSURL URLWithString:EVENTBRITE_BASEURL];
    
    _appKey = appKey;
    _oauthClient = [AFOAuth2Client clientWithBaseURL:baseurl clientID:appKey secret:secret];
    
    return self;
}

- (UIViewController *)authoriseViewController:(id <STMEBAuthDelegate>)delegate
{
    NSString *authUrl = [NSString stringWithFormat:@"%@/oauth/authorize?response_type=token&client_id=%@", EVENTBRITE_BASEURL, self.appKey];
    NSURL *url = [NSURL URLWithString:authUrl];
    
    STMEBAuthViewController *vc = [[STMEBAuthViewController alloc] initWithUrl:url ebWrapper:self delegate:delegate];
    return vc;
}

- (NSString *)accessToken
{
    return [AFOAuthCredential retrieveCredentialWithIdentifier:self.oauthClient.serviceProviderIdentifier].accessToken;
}

- (void)setAccessToken:(NSString *)accessToken
{
    AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:accessToken tokenType:@"accessToken"];
    [AFOAuthCredential storeCredential:(AFOAuthCredential *)credential withIdentifier:self.oauthClient.serviceProviderIdentifier];
}

#pragma mark - Events

- (void)eventSearchWithKeywords:(NSArray *)keywords
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    if (keywords) {
        [args setObject:[keywords componentsJoinedByString:@","] forKey:@"keywords"];
    }
    
    [self callEventbriteWithMethod:@"event_search" authentication:NO args:[args copy]];
}

- (void)eventGet:(NSUInteger)id
{
    [self callEventbriteWithMethod:@"event_get" authentication:NO args:@{ @"id": @(id) }];
}

- (void)eventNew
{
   [self notimplemented];
}

- (void)eventCopy
{
   [self notimplemented];
}

- (void)eventUpdate
{
   [self notimplemented];
}

#pragma mark - Tickets

- (void)ticketNew
{
   [self notimplemented];
}

- (void)ticketUpdate
{
   [self notimplemented];
}

#pragma mark - Venues

- (void)venueGet:(NSUInteger)id
{
    [self callEventbriteWithMethod:@"venue_get" authentication:YES args:@{ @"id": @(id) }];
}

- (void)venueNew
{
    [self notimplemented];
}

- (void)venueUpdate
{
    [self notimplemented];
}

#pragma mark - Discount Codes

- (void)eventListDiscounts
{
    [self notimplemented];
}

- (void)discountNew
{
    [self notimplemented];
}

- (void)discountUpdate
{
    [self notimplemented];
}

#pragma mark - Attendees

// doNotDisplay - [profile,answers,address]
- (void)eventListAttendees:(NSUInteger)id count:(NSUInteger)count page:(NSUInteger)page doNotDisplay:(NSArray *)doNotDisplay showFullBarcodes:(BOOL)showFullBarcodes
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:@(id) forKey:@"id"];
    [args setObject:@(showFullBarcodes) forKey:@"show_full_barcodes"];
    
    if (count > 0) {
        [args setObject:@(count) forKey:@"count"];
    }
    
    if (page > 0) {
        [args setObject:@(page) forKey:@"page"];
    }
    
    if (doNotDisplay) {
        [args setObject:[doNotDisplay componentsJoinedByString:@","] forKey:@"do_not_display"];
    }
    
    [self callEventbriteWithMethod:@"event_list_attendees" authentication:NO args:[args copy]];
}

#pragma mark - Organizer Profiles

// display - [custom_header,custom_footer,confirmation_page,confirmation_email]
- (void)organizerListEvents:(NSUInteger)id display:(NSArray *)display
{    
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:@(id) forKey:@"id"];
    
    if (display) {
        [args setObject:[display componentsJoinedByString:@","] forKey:@"display"];
    }
    
    [self callEventbriteWithMethod:@"organiser_list_events" authentication:YES args:[args copy]];
}

- (void)organizerGet:(NSUInteger)id
{
    [self callEventbriteWithMethod:@"organiser_get" authentication:NO args:@{ @"id": @(id) }];
}

- (void)organizerNewName:(NSString *)name description:(NSString *)description
{
    [self callEventbriteWithMethod:@"organiser_new" authentication:YES args:@{ @"name":name, @"description":description }];
}

- (void)organizerUpdate:(NSUInteger)id name:(NSString *)name description:(NSString *)description
{
    [self callEventbriteWithMethod:@"organiser_update" authentication:YES args:@{ @"id": @(id), @"name":name, @"description":description }];
}

#pragma mark - Users

// display - [custom_header,custom_footer,confirmation_page,confirmation_email]
// doNotDisplay - [description,venue,logo,style,organizer,tickets]
// statuses - [live,started,ended]
// asc - asc BOOL
- (void)userListEventsForUser:(NSString *)email display:(NSArray *)display doNotDisplay:(NSArray *)doNotDisplay statuses:(NSArray *)statuses asc:(BOOL)asc
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:email forKey:@"user"];
    
    if (display) {
        [args setObject:[display componentsJoinedByString:@","] forKey:@"display"];
    }
    
    if (doNotDisplay) {
        [args setObject:[doNotDisplay componentsJoinedByString:@","] forKey:@"do_not_display"];
    }
    
    if (statuses) {
        [args setObject:[statuses componentsJoinedByString:@","] forKey:@"event_statuses"];
    }
    
    NSString *asc_or_desc = (asc) ? @"asc" : @"desc";
    [args setObject:asc_or_desc forKey:@"asc_or_desc"];
    
    [self callEventbriteWithMethod:@"user_list_tickets" authentication:YES args:[args copy]];
}

- (void)userListTicketsWithType:(NSString *)type
{
    // type - Filter on ‘public’, ‘private’, or ‘all’. Default is ‘public’.
    
    [self callEventbriteWithMethod:@"user_list_tickets" authentication:YES args:@{ @"type": type }];
    
}

- (void)userListVenues
{
    [self callEventbriteWithMethod:@"user_list_venues" authentication:YES args:nil];
}

- (void)userListOrganizers
{
    [self callEventbriteWithMethod:@"user_list_organizers" authentication:YES args:nil];
}

- (void)userGetWithId:(NSUInteger)id orEmail:(NSString *)email
{
    NSDictionary *args = nil;
    
    if (id != 0) {
        args = @{ @"user_id": @(id) };
    } else if (email != nil) {
        args = @{ @"email": email };
    } else {
        NSException* myException = [NSException
                                    exceptionWithName:@"Invalid arguments"
                                    reason:@"Must supply id or email"
                                    userInfo:nil];
        
        @throw myException;
    }
    
    [self callEventbriteWithMethod:@"user_list_organizers" authentication:YES args:args];
}

- (void)userNewWithEmail:(NSString *)email password:(NSString *)password
{
    [self callEventbriteWithMethod:@"user_new" authentication:YES args: @{ @"email": email, @"passwd": password } ];
}

- (void)userUpdateWithEmail:(NSString *)email password:(NSString *)password
{
    [self callEventbriteWithMethod:@"user_new" authentication:YES args: @{ @"new_email": email, @"new_password": password } ];
}

#pragma mark - Payments
- (void)paymentUpdate
{
    [self notimplemented];
}

#pragma mark - Utility

- (void)notimplemented
{
    NSException* myException = [NSException
                                exceptionWithName:@"Not implemented"
                                reason:@"This method has not been implemented yet"
                                userInfo:nil];
    
    @throw myException;
}

#pragma mark - Private

- (void)callEventbriteWithMethod:(NSString *)method authentication:(BOOL)authentication args:(NSDictionary *)args
{
    if (args == nil) {
        args = @{};
    }
    
    NSMutableDictionary *mArgs = [args mutableCopy];
    [mArgs setObject:self.appKey forKey:@"app_key"];
    
    NSString *urlString = [mArgs addDictionaryAsQueryStringToUrlString:[NSString stringWithFormat:@"%@/json/%@", EVENTBRITE_BASEURL, method]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSMutableURLRequest *mRequest = [request mutableCopy];
    
    NSString *access_token = [AFOAuthCredential retrieveCredentialWithIdentifier:self.oauthClient.serviceProviderIdentifier].accessToken;
    if (!access_token && authentication) {
        NSException* myException = [NSException
                                    exceptionWithName:@"Auth required"
                                    reason:@"Need to log in"
                                    userInfo:nil];
        
        @throw myException;
    }

    if (authentication || access_token) {
        NSString *auth = [NSString stringWithFormat:@"Bearer %@", access_token];
        [mRequest addValue:auth forHTTPHeaderField:@"Authorization"];
    }
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[mRequest copy] success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        NSLog(@"%@", JSON);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        
    }];
    
    [operation start];
}

@end


