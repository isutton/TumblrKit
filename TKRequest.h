//
//  Copyright (c) 2011 TumblrKit
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

@class TKRequest;

@protocol TKRequestable <NSObject>

@optional
- (void)connectionDidFinishLoadingData:(NSData *)data;
- (void)connectionDidFailWithError:(NSError *)error;

@optional
- (NSData *)HTTPBody;

@required
- (NSURL *)URL;

@end

#if TARGET_OS_MAC
@interface TKRequest : NSObject <TKRequestable,NSURLConnectionDelegate>
#elif TARGET_OS_IPHONE
@interface TKRequest : NSObject <TKRequestable,NSURLConnectionDelegate,NSURLConnectionDataDelegate>
#endif
{
    @protected
    NSURLConnection *_connection;
    NSMutableData *_receivedData;
}

#pragma mark - API

- (void)start;
- (void)cancel;

@end
