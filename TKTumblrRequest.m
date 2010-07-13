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
//  TKTumblrRequest.m by Igor Sutton on 7/13/10.
//

#import "TKTumblrRequest.h"


static NSString *TKPostTypeAsQueryString[] = {
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

static NSString *TKPostFilterAsQueryString[] = {
    @"html",
    @"text",
    @"none"
};

@implementation TKTumblrRequest

@synthesize URL, startIndex, numberOfPosts, postId, postFilter, postType;

+ (id)requestWithURL:(NSURL *)theURL
{
    return [[[TKTumblrRequest alloc] initWithURL:theURL] autorelease];
}

- (id)initWithURL:(NSURL *)theURL
{
    if ((self = [super init]) != nil) {
        self.URL = theURL;
        self.startIndex = 0;
        self.numberOfPosts = 20;
        self.postId = 0;
        self.postFilter = TKPostFilterNone;
        self.postType = TKPostTypeAll;
    }
    
    return self;
}

- (void)dealloc
{
    [URL release];
    [super dealloc];
}

- (NSURL *)myURL
{
    NSMutableString *URLString = [[URL description] mutableCopy];
    
    //
    // We can have either postId or combination of startIndex, numberOfPosts and
    // postType. If postId has precedence if present.
    //
    if (postId > 0) {
        [URLString appendFormat:@"?id=%i&", self.postId];
    }
    else {
        [URLString appendFormat:@"?start=%i&num=%i&", self.startIndex, self.numberOfPosts];

        //
        // Currently Tumblr doesn't support "answer" for the type filter, so
        // we disconsider both TKPostTypeAnswer and TKPostTypeAll.
        //
        if (postType != TKPostTypeAll && postType != TKPostTypeAnswer) {
            [URLString appendFormat:@"type=%@&", TKPostTypeAsQueryString[postType]];
        }
    }
    
    [URLString appendFormat:@"filter=%@", TKPostFilterAsQueryString[postFilter]];
    
    return [[[NSURL alloc] initWithString:URLString] autorelease];
}

@end
