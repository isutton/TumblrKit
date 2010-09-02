//
//  NSString+MIME.h
//  TumblrKit
//
//  Created by Igor Sutton on 9/2/10.
//  Copyright 2010 StrayDev.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//
// The following code (and its implementation) was found in:
// 
// http://stackoverflow.com/questions/2326071/sending-a-post-request-from-cocoa-to-tumblr
//

@interface NSString (MIME)

+ (NSString *)MIMEBoundary;
+ (NSString *)multipartMIMEStringWithDictionary:(NSDictionary *)dict;

@end
