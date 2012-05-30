//
//  TumblrKit_Tests_for_Mac.m
//  TumblrKit Tests for Mac
//
//  Created by Igor Sutton on 12/14/11.
//  Copyright (c) 2011 igorsutton.com. All rights reserved.
//

#import "TumblrKit_Tests_for_Mac.h"
#import "TKPost.h"
#import "TKPostsResponse.h"
#import "TKTumblelog.h"
#import "TKTumblelogsResponse.h"

@implementation TumblrKit_Tests_for_Mac

- (void)setUp;
{
    _testIsDone = NO;
    [super setUp];
}

- (void)tearDown;
{
    [super tearDown];
}

- (void)testPostsRequest001;
{
    NSMutableDictionary *options = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"tumblrkit-test.tumblr.com", TKPostsRequestDomainKey, nil];
    TKPostsRequest *request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    STAssertEqualObjects([[request URL] absoluteString], @"http://tumblrkit-test.tumblr.com/api/read?", @"");

    [options setObject:[NSNumber numberWithInt:10] forKey:TKPostsRequestNumberOfPostsKey];
    request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    STAssertEqualObjects([[request URL] absoluteString], @"http://tumblrkit-test.tumblr.com/api/read?num=10", nil);
    
    [options setObject:[NSNumber numberWithInt:10] forKey:TKPostsRequestStartAtIndexKey];
    request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    STAssertEqualObjects([[request URL] absoluteString], @"http://tumblrkit-test.tumblr.com/api/read?num=10&start=10", nil);
    
    [options setObject:[NSNumber numberWithInt:10] forKey:TKPostsRequestPostIDKey];
    request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    STAssertEqualObjects([[request URL] absoluteString], @"http://tumblrkit-test.tumblr.com/api/read?num=10&id=10&start=10", nil);
}

- (void)testPostsRequest002;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"tumblrkit-test.tumblr.com", TKPostsRequestDomainKey, 
                             [NSNumber numberWithInt:10], TKPostsRequestNumberOfPostsKey, 
                             nil];
    TKPostsRequest *request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    [request start];
    
    while (!_testIsDone)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];

}

- (void)testPostsRequest003;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"tumblrkit-test.tumblr.com", TKPostsRequestDomainKey,
                             [NSNumber numberWithInt:10], TKPostsRequestNumberOfPostsKey,
                             [NSNumber numberWithInt:5], TKPostsRequestStartAtIndexKey,
                             nil];

    TKPostsRequest *request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    [request start];
    
    while (!_testIsDone)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
}

- (void)testPostsRequest004;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"tumblrkit-test.tumblr.com", TKPostsRequestDomainKey,
                             [NSNumber numberWithLong:8819125974], TKPostsRequestPostIDKey,
                             nil];
    
    TKPostsRequest *request = [[TKPostsRequest alloc] initWithOptions:options delegate:self];
    [request start];
    
    while (!_testIsDone)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
}

- (void)testTumblelogsRequest001;
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             @"email", TKTumblelogsRequestEmailKey,
                             @"password", TKTumblelogsRequestPasswordKey,
                             nil];
    
    TKTumblelogsRequest *request = [[TKTumblelogsRequest alloc] initWithOptions:options delegate:self];
    [request start];
    
    while (!_testIsDone)
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
}

#pragma mark - TKPostsRequestDelegate

- (void)postsRequest:(TKPostsRequest *)request didReceiveResponse:(TKPostsResponse *)response;
{
    _testIsDone = YES;
    
    if ([request.options objectForKey:TKPostsRequestNumberOfPostsKey])
        STAssertEquals([[request.options objectForKey:TKPostsRequestNumberOfPostsKey] intValue], (int)[response.posts count], nil);
    
    if ([request.options objectForKey:TKPostsRequestPostIDKey]) {
        STAssertEquals((int)[response.posts count], 1, nil);
        TKPost *post = [response.posts objectAtIndex:0];
        NSNumber *postID = [NSNumber numberWithLong:[post.postID longLongValue]];
        STAssertEquals([request.options objectForKey:TKPostsRequestPostIDKey], postID, nil);
    }
}

- (void)postsRequest:(TKPostsRequest *)request didFailWithError:(NSError *)error;
{
    _testIsDone = YES;
    
    STFail(@"%@", error);
}

#pragma mark - TKTumblelogsRequestDelegate

- (void)tumblelogsRequest:(TKTumblelogsRequest *)request didReceiveResponse:(TKTumblelogsResponse *)response;
{
    _testIsDone = YES;
    
    NSLog(@"Tumblelogs: %lu", [response.tumblelogs count]);
}

- (void)tumblelogsRequest:(TKTumblelogsRequest *)request didFailWithError:(NSError *)error;
{
    _testIsDone = YES;
    
    STFail(@"%@", error);
}

@end
