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
