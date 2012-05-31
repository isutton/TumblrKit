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
    return endpoint;
}

@end
