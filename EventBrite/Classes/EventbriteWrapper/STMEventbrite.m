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

- (BOOL)hasAccessToken
{
    return ([self accessToken] != nil);
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
    AFOAuthCredential *credential = [AFOAuthCredential retrieveCredentialWithIdentifier:self.oauthClient.serviceProviderIdentifier];
    return credential.accessToken;
}

- (void)setAccessToken:(NSString *)accessToken
{
    AFOAuthCredential *credential = [AFOAuthCredential credentialWithOAuthToken:accessToken tokenType:@"accessToken"];
    [AFOAuthCredential storeCredential:(AFOAuthCredential *)credential withIdentifier:self.oauthClient.serviceProviderIdentifier];
}

#pragma mark - Events

- (void)eventSearchWithKeywords:(NSArray *)keywords success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    if (keywords) {
        [args setObject:[keywords componentsJoinedByString:@","] forKey:@"keywords"];
    }
    
    [self callEventbriteWithMethod:@"event_search" authentication:NO args:[args copy] success:success failure:failure];
}

- (void)eventGet:(NSString *)eventId success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"event_get" authentication:NO args:@{ @"id": eventId } success:success failure:failure];
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

- (void)venueGet:(NSString *)venueId success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"venue_get" authentication:YES args:@{ @"id": venueId } success:success failure:failure];
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
- (void)eventListAttendees:(NSString *)eventId
                     count:(NSUInteger)count
                      page:(NSUInteger)page
              doNotDisplay:(NSArray *)doNotDisplay
          showFullBarcodes:(BOOL)showFullBarcodes
                   success:(STMBESuccess)success
                   failure:(STMBEFailure)failure
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:eventId forKey:@"id"];
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
    
    [self callEventbriteWithMethod:@"event_list_attendees" authentication:NO args:[args copy] success:success failure:failure];
}

#pragma mark - Organizer Profiles

// display - [custom_header,custom_footer,confirmation_page,confirmation_email]
- (void)organizerListEvents:(NSString *)organiserId display:(NSArray *)display success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    NSMutableDictionary *args = [NSMutableDictionary dictionary];
    
    [args setObject:organiserId forKey:@"id"];
    
    if (display) {
        [args setObject:[display componentsJoinedByString:@","] forKey:@"display"];
    }
    
    [self callEventbriteWithMethod:@"organiser_list_events" authentication:YES args:[args copy] success:success failure:failure];
}

- (void)organizerGet:(NSString *)organiserId success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"organiser_get" authentication:NO args:@{ @"id": organiserId } success:success failure:failure];
}

- (void)organizerNewName:(NSString *)name description:(NSString *)description success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"organiser_new" authentication:YES args:@{ @"name":name, @"description":description } success:success failure:failure];
}

- (void)organizerUpdate:(NSString *)organiserId
                   name:(NSString *)name
            description:(NSString *)description
                success:(STMBESuccess)success
                failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"organiser_update" authentication:YES args:@{ @"id": organiserId, @"name":name, @"description":description } success:success failure:failure];
}

#pragma mark - Users

// display - [custom_header,custom_footer,confirmation_page,confirmation_email]
// doNotDisplay - [description,venue,logo,style,organizer,tickets]
// statuses - [live,started,ended]
// asc - asc BOOL
- (void)userListEventsForUser:(NSString *)email
                      display:(NSArray *)display
                 doNotDisplay:(NSArray *)doNotDisplay
                     statuses:(NSArray *)statuses
                          asc:(BOOL)asc
                      success:(STMBESuccess)success
                      failure:(STMBEFailure)failure
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
    
    [self callEventbriteWithMethod:@"user_list_tickets" authentication:YES args:[args copy] success:success failure:failure];
}

- (void)userListTicketsWithType:(NSString *)type success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    // type - Filter on ‘public’, ‘private’, or ‘all’. Default is ‘public’.
    
    [self callEventbriteWithMethod:@"user_list_tickets" authentication:YES args:@{ @"type": type } success:success failure:failure];
    
}

- (void)userListVenuesWithSuccess:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"user_list_venues" authentication:YES args:nil success:success failure:failure];
}

- (void)userListOrganizersWithSuccess:(STMBESuccess)success failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"user_list_organizers" authentication:YES args:nil success:success failure:failure];
}

- (void)userGetWithId:(NSString *)userId orEmail:(NSString *)email success:(STMBESuccess)success failure:(STMBEFailure)failure
{
    NSDictionary *args = nil;
    
    if (userId != 0) {
        args = @{ @"user_id": userId };
    } else if (email != nil) {
        args = @{ @"email": email };
    }
    
    [self callEventbriteWithMethod:@"user_get" authentication:YES args:args success:success failure:failure];
}

- (void)userNewWithEmail:(NSString *)email
                password:(NSString *)password
                 success:(STMBESuccess)success
                 failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"user_new" authentication:YES args: @{ @"email": email, @"passwd": password } success:success failure:failure];
}

- (void)userUpdateWithEmail:(NSString *)email
                   password:(NSString *)password
                    success:(STMBESuccess)success
                    failure:(STMBEFailure)failure
{
    [self callEventbriteWithMethod:@"user_update" authentication:YES args: @{ @"new_email": email, @"new_password": password } success:success failure:failure];
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

- (void)callEventbriteWithMethod:(NSString *)method
                  authentication:(BOOL)authentication
                            args:(NSDictionary *)args
                         success:(STMBESuccess)success
                         failure:(STMBEFailure)failure;
{
    if (args == nil) {
        args = @{};
    }
    
    NSMutableDictionary *mArgs = [args mutableCopy];
    [mArgs setObject:self.appKey forKey:@"app_key"];
    
    NSString *urlString = [mArgs addDictionaryAsQueryStringToUrlString:[NSString stringWithFormat:@"%@/json/%@", EVENTBRITE_BASEURL, method]];
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    NSLog(@"%@", urlString);
    
    NSMutableURLRequest *mRequest = [request mutableCopy];
    
    NSString *access_token = [self accessToken];
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
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:[mRequest copy] success:success failure:failure];
    
    [operation start];
}

@end


