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
//  TKTumblrResponse.h by Igor Sutton on 7/13/10.
//

#import <Cocoa/Cocoa.h>
#import "TKPost.h"

typedef enum {
    TKTumblrCreated = 201,
    TKTumblrBadRequest = 400,
    TKTumblrForbidden = 403
} TKTumblrResponseReturnCode;

@interface TKTumblrResponse : NSObject 
{
    NSArray *posts;
    NSNumber *postID;
    TKTumblrResponseReturnCode returnCode;
}

@property (retain) NSArray *posts;
@property (copy) NSNumber *postID;
@property (assign) TKTumblrResponseReturnCode returnCode;

+ (id)responseWithPosts:(NSArray *)somePosts;
+ (id)responseWithPostID:(NSNumber *)postID;
+ (id)responseWithReturnCode:(TKTumblrResponseReturnCode)theReturnCode;
- (id)initWithPosts:(NSArray *)somePosts postID:(NSNumber *)thePostID returnCode:(TKTumblrResponseReturnCode)theReturnCode;
- (id)initWithPosts:(NSArray *)somePosts postID:(NSNumber *)thePostID;
- (NSString *)returnCodeAsString;

@end
