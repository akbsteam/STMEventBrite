//
//  NSDictionary+UrlEncoding.h
//  EventBrite
//
//  Created by Andy Bennett on 22/01/2013.
//  Copyright (c) 2013 Steamshift Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (UrlEncoding)

+(NSString*)urlEscapeString:(NSString *)unencodedString;
+(NSString*)addQueryStringToUrlString:(NSString *)urlString withDictionary:(NSDictionary *)dictionary;
- (NSString*)addDictionaryAsQueryStringToUrlString:(NSString *)urlString;

@end
