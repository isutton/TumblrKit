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
    NSString *format = @"--%@\nContent-Disposition: form-data; name=\"%@\"\n\n%@\n";
    NSMutableString *result = [NSMutableString string];
    NSMutableDictionary *dict_ = [dict mutableCopy];
    
    // Hack: it seems the order we send the data in the HTTP post body matter
    // in the Tumblr API. We'll remove the "type" object from the dictionary
    // we copied and append its value as first thing, then we'll iterate the
    // remaining keys. The impressive part is it worked directly when TumblrKit
    // was compiled in 32 bit mode (where "type" was the first item to be encoded)
    // but didn't work in 64 bit mode. It seems the architecture affects the
    // sort of the keys, but we should not rely on that anyway (nor should the
    // Tumblr API engineers :-)
    
    id value = [dict_ objectForKey:@"type"];
    [dict_ removeObjectForKey:@"type"];
    [result appendFormat:format, [NSString MIMEBoundary], @"type", value];
    
    for (NSString *key in dict_) {
        [result appendFormat:format, [NSString MIMEBoundary], key, [dict_ objectForKey:key]];
    }
    
    [result appendFormat:@"\n--%@--\n", [NSString MIMEBoundary]];
    return result;
}

@end
