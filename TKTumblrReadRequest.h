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

@interface TKTumblrReadRequest : NSObject
{
    NSNumber     *start;
    NSNumber     *numOfPosts;
    NSNumber     *postID;
    NSString     *search;
    NSString     *group;

    TKPostType   type;
    TKPostFilter filter;
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

- (id)initWithPostID:(NSNumber *)thePostID andDomain:(NSString *)theDomain;
- (NSURL *)endpoint;

@end
