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
//  TKTumblelog.m by Igor Sutton on 9/8/10.
//

#import "TKTumblelog.h"


@implementation TKTumblelog

@synthesize title, name, URL, avatarURL, privateID, primary, type;

+ (id)tumblelogWithAttributes:(NSDictionary *)attributeDict
{
    return [[(TKTumblelog *)[self alloc] initWithAttributes:attributeDict] autorelease];
}

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    if ((self = [super init]) != nil) {
        self.title = [attributeDict objectForKey:@"title"];
        self.name = [attributeDict objectForKey:@"name"];
        self.URL = [NSURL URLWithString:[attributeDict objectForKey:@"url"]];
        self.avatarURL = [NSURL URLWithString:[attributeDict objectForKey:@"avatar-url"]];
        self.privateID = [NSNumber numberWithInt:[[attributeDict objectForKey:@"private-id"] intValue]];
        self.primary = [[attributeDict objectForKey:@"is-primary"] isEqualToString:@"yes"];            
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"Title: %@, Name: %@, URL: %@, Avatar URL: %@, Private ID: %@, Primary: %i",
            self.title,
            self.name,
            [self.URL absoluteString],
            [self.avatarURL absoluteString],
            self.privateID,
            self.primary];
}

@end
