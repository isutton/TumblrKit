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

#import "TKPost.h"
#import "TKTumblrReadRequest.h"
#import "TKTumblelog.h"

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
- (void)tumblrDidReceiveTumblelog:(TKTumblelog *)theTumblelog;
- (void)tumblrDidReturnTumblelogs:(NSArray *)tumblelogs;
- (void)tumblrUserAuthenticated;
- (void)tumblrUserNotAuthenticated;
@end

@interface TKTumblr : NSObject <NSXMLParserDelegate,TKTumblrDelegate>
{
    id<TKTumblrDelegate,NSObject> delegate;

    NSString *email;
    NSString *password;

    NSMutableArray *usersTumblelogs;
    TKTumblelog *currentTumblelog;
    TKPost *currentPost;
    TKPost *requestedPost;
    NSString *currentElementName;
    
    BOOL authenticationRequestInProgress;
    BOOL userAuthenticated;
}

@property (assign) id<TKTumblrDelegate,NSObject> delegate;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *password;
@property (nonatomic, retain) NSMutableArray *usersTumblelogs;
@property (nonatomic,retain) TKTumblelog *currentTumblelog;
@property (nonatomic,retain) TKPost *currentPost;
@property (nonatomic,retain) TKPost *requestedPost;
@property (nonatomic,copy) NSString *currentElementName;
@property (assign) BOOL userAuthenticated;
@property (assign) BOOL authenticationRequestInProgress;

- (id)initWithEmail:(NSString *)theEmail andPassword:(NSString *)thePassword;
- (BOOL)uploadPost:(TKPost *)thePost;
- (BOOL)uploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain;
- (void)postsWithReadRequest:(TKTumblrReadRequest *)theReadRequest;
- (TKPost *)postWithID:(NSNumber *)thePostID andDomain:(NSString *)theDomain;
- (NSDictionary *)attributesAsDictionary;
- (void)tumblelogs;
- (void)authenticate;

@end
