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

#import "TKRequest.h"

#pragma GCC diagnostic ignored "-Wprotocol"

@implementation TKRequest

#pragma mark - NSObject

- (id)init;
{
    if (!(self = [super init]))
        return nil;
    
    _receivedData = [[NSMutableData alloc] init];
    
    return self;
}

- (void)dealloc;
{
    [self cancel];
    [_receivedData release]; _receivedData = nil;
    [super dealloc];
}

#pragma mark - NSURLConnectionDelegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
{
    [self connectionDidFailWithError:error];
}

#pragma mark - NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
{
    NSLog(@"%@", response);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
{
    [_receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    [self connectionDidFinishLoadingData:_receivedData];    
}

#pragma mark - API

- (void)start;
{
    NSAssert(!_connection, @"start can't be called twice without being cancelled.");
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:[self URL]];
    
    if ([self respondsToSelector:@selector(HTTPBody)]) {
        theRequest.HTTPMethod = @"POST";
        theRequest.HTTPBody = self.HTTPBody;
    } 
    else {
        theRequest.HTTPMethod = @"GET";
    }
    
    _connection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
}

- (void)cancel;
{
    [_connection cancel];
    [_connection release]; _connection = nil;
}

@end
