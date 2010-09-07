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
//  TKTumblr.h by Igor Sutton on 7/14/10.
//

#import "TKPost.h"
#import "TKTumblrReadRequest.h"

#define Log(format, ...) NSLog(@"%s:%@", __PRETTY_FUNCTION__, [NSString stringWithFormat:format, ## __VA_ARGS__]);

typedef enum
{
    TKTumblrCreated = 201,
    TKTumblrBadRequest = 400,
    TKTumblrForbidden = 403
} TKTumblrResponseReturnCode;

@protocol TKTumblrDelegate

@optional
- (void)tumblrDidReceivePost:(TKPost *)thePost withDomain:(NSString *)theDomain;
- (void)tumblrWillUploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain;
- (void)tumblrDidUploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain postID:(NSNumber *)thePostID;
- (void)tumblrDidFailToUploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain returnCode:(TKTumblrResponseReturnCode)theReturnCode;

@end

@interface TKTumblr : NSObject <NSXMLParserDelegate,TKTumblrDelegate>
{
    id<TKTumblrDelegate,NSObject> delegate;

    NSString *email;
    NSString *password;

    TKPost *currentPost;
    TKPost *requestedPost;
    NSString *currentElementName;
}

@property (assign) id<TKTumblrDelegate,NSObject> delegate;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *password;
@property (nonatomic,retain) TKPost *currentPost;
@property (nonatomic,retain) TKPost *requestedPost;
@property (nonatomic,copy) NSString *currentElementName;

- (id)initWithEmail:(NSString *)theEmail andPassword:(NSString *)thePassword;
- (BOOL)uploadPost:(TKPost *)thePost;
- (BOOL)uploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain;
- (void)postsWithReadRequest:(TKTumblrReadRequest *)theReadRequest;
- (TKPost *)postWithID:(NSNumber *)thePostID andDomain:(NSString *)theDomain;
- (NSDictionary *)attributesAsDictionary;

@end
