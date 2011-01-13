//
//  Copyright (c) 2010, 2011 TumblrKit
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSDictionary+TumblrKit.h"
#import "NSString+TumblrKit.h"

@implementation NSDictionary (TumblrKit)

- (NSString *)multipartMIMEString
{
    NSString *format = @"--%@\nContent-Disposition: form-data; name=\"%@\"\n\n%@\n";
    NSMutableString *result = [NSMutableString string];
    NSMutableDictionary *dict_ = [self mutableCopy];

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
