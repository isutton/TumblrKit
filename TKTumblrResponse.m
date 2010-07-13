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
//  TKTumblrResponse.m by Igor Sutton on 7/13/10.
//

#import "TKTumblrResponse.h"


@implementation TKTumblrResponse

@synthesize posts;

+ (id)responseWithPosts:(NSArray *)somePosts
{
    return [[[self alloc] initWithPosts:somePosts] autorelease];
}

- (id)initWithPosts:(NSArray *)somePosts
{
    if ((self = [super init]) != nil) {
        self.posts = somePosts;
    }
    
    return self;    
}

- (void)dealloc
{
    [posts release];
    [super dealloc];
}

@end
