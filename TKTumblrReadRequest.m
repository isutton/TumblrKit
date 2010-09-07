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
//  TKTumblrReadRequest.m by Igor Sutton on 9/7/10.
//

#import "TKTumblrReadRequest.h"

static NSString *TKPostTypeAsQueryString[] =
{
    @"all",
    @"text",
    @"link",
    @"quote",
    @"photo",
    @"chat",
    @"video",
    @"audio",
    @"answer"
};

static NSString *TKPostFilterAsQueryString[] =
{
    @"html",
    @"text",
    @"none"
};

@implementation TKTumblrReadRequest

@synthesize start, numOfPosts, postID, search, type, filter, state, group;

- (id)init
{
    if ((self = [super init]) != nil) {
        self.start = [NSNumber numberWithInt:0];
        self.numOfPosts = [NSNumber numberWithInt:20];
        self.postID = nil;
        self.search = nil;
        self.group = nil;
        self.type = TKPostTypeAll;
        self.state = TKPostStateAll;
        self.filter = TKPostFilterNone;
    }

    return self;
}

- (id)initWithPostID:(NSNumber *)thePostID andDomain:(NSString *)theDomain
{
    if ((self = [self init]) != nil) {
        self.postID = thePostID;
        self.group = theDomain;
    }

    return self;
}

- (void)dealloc
{
    self.start = nil;
    self.numOfPosts = nil;
    self.postID = nil;
    self.search = nil;
    self.group = nil;
    [super dealloc];
}

- (NSURL *)endpoint
{
    NSMutableString *endpointString = [[NSMutableString alloc] initWithFormat:@"http://%@/api/read", group];
    NSURL *endpoint = nil;

    if (postID) {
        [endpointString appendFormat:@"?id=%@&", postID];
    }
    else {
        [endpointString appendFormat:@"?start=%@&num=%@&", start, numOfPosts];

        if (type != TKPostTypeAll && type != TKPostTypeAnswer) {
            [endpointString appendFormat:@"type=%@&", TKPostTypeAsQueryString[type]];
        }
    }

    [endpointString appendFormat:@"filter=%@", TKPostFilterAsQueryString[filter]];
    endpoint = [NSURL URLWithString:endpointString];
    [endpointString release];
    return endpoint;
}

@end
