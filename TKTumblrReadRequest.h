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
