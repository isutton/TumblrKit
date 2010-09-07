//
//
//  This file is part of TumblrKit
//
//  TumblrKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  Foobar is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TumblrKit.  If not, see <http://www.gnu.org/licenses/>.
//
//  NSDictionary+TumblrKit.m by Igor Sutton on 9/7/10.
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
