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
//  TKTumblrRequest.h by Igor Sutton on 7/13/10.
//

#import <Foundation/Foundation.h>
#import "TKPost.h"

@interface TKTumblrRequest : NSObject
{
    NSURL *URL;
    NSString *email;
    NSString *password;
    NSUInteger startIndex;
    NSUInteger numberOfPosts;
    NSUInteger postID;
    TKPostFilter postFilter;
    TKPostType postType;
    TKPost *post;
    NSString *tag;
}

@property (copy) NSURL *URL;
@property (copy) NSString *email;
@property (copy) NSString *password;
@property (assign) NSUInteger startIndex;
@property (assign) NSUInteger numberOfPosts;
@property (assign) NSUInteger postID;
@property (assign) TKPostFilter postFilter;
@property (assign) TKPostType postType;
@property (assign) TKPost *post;
@property (copy) NSString *tag;

+ (id)requestWithURL:(NSURL *)theURL;

- (id)initWithURL:(NSURL *)theURL;
- (id)initWithDomain:(NSString *)theDomain;
- (BOOL)isWrite;
- (NSURL *)URLForRead;
- (NSURL *)URLForWrite;
- (NSDictionary *)attributesAsDictionary;

@end
