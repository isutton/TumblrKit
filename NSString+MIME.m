//
//  NSString+MIME.m
//  TumblrKit
//
//  Created by Igor Sutton on 9/2/10.
//  Copyright 2010 StrayDev.com. All rights reserved.
//

#import "NSString+MIME.h"


@implementation NSString (MIME)

+ (NSString *)MIMEBoundary
{
    static NSString *MIMEBoundary = nil;
    
    if (!MIMEBoundary) {
        MIMEBoundary = [[NSString alloc] initWithFormat:
                        @"----_=_MIMEBoundary_%@_=_----", 
                        [[NSProcessInfo processInfo] globallyUniqueString]];
    }
    
    return MIMEBoundary;
}

+ (NSString *)multipartMIMEStringWithDictionary:(NSDictionary *)dict
{
    NSMutableString *result = [NSMutableString string];
    for (NSString *key in dict) {
        [result appendFormat:
         @"--%@\nContent-Disposition: form-data; name=\"%@\"\n\n%@\n",
         [NSString MIMEBoundary],
         key,
         [dict objectForKey:key]];
    }
    [result appendFormat:@"\n--%@--\n", [NSString MIMEBoundary]];
    return result;
}

@end
