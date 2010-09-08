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
//  TKTumblrReadRequest.h by Igor Sutton on 9/7/10.
//

#import <Foundation/Foundation.h>
#import "TKPost.h"

/**
 The TKTumblrReadRequest class is responsible to encapsulate the parameters
 used to retrieve one or a set of posts from Tumblr, represented in
 TumblrKit as TKPost objects.
 */
@interface TKTumblrReadRequest : NSObject
{
    /** This represents the offset we want to use to fetch a series of posts. */
    NSNumber     *start;

    /** This represents the limit we want to use to fetch a series of posts. */
    NSNumber     *numOfPosts;

    /** The ID of the post we want to fetch. */
    NSNumber     *postID;

    /** The search string to look for posts. */
    NSString     *search;

    /** The origin group (or domain) we want to fetch posts. */
    NSString     *group;

    /** The type of posts we want to fetch. */
    TKPostType   type;

    /** The filter we want to use when fetching posts. */
    TKPostFilter filter;

    /** The state of posts we want to fetch (requires authentication). */
    TKPostState  state;
}

@property (copy) NSNumber *start;
@property (copy) NSNumber *numOfPosts;
@property (copy) NSNumber *postID;
@property (copy) NSString *search;
@property (copy) NSString *group;

@property (assign) TKPostType   type;
@property (assign) TKPostFilter filter;
@property (assign) TKPostState  state;

/**
 Initialize a TKTumblrReadRequest with a postID and a domain.
 */
- (id)initWithPostID:(NSNumber *)thePostID andDomain:(NSString *)theDomain;

/**
 The resulting endpoint (with query parameters) used to fetch the posts.
 */
- (NSURL *)endpoint;

@end
