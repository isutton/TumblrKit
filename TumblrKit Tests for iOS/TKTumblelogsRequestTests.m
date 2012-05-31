//
//  TKTumblelogsRequestTests.m
//  TumblrKit
//
//  Created by Igor Sutton on 05/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TKTumblelogsRequestTests.h"
#import "TKTumblelogsResponse.h"
#import "TKTumblelog.h"

@implementation TKTumblelogsRequestTests
{
    NSArray *tumblelogs;
    BOOL requestHasFinished;
    void (^didReceiveResponseBlock)(TKTumblelogsResponse *response);
    void (^didFailWithErrorBlock)(NSError *error);
}

- (void)setUp
{
    requestHasFinished = NO;
}

- (void)tearDown
{

}

- (void)testSuccessfulRequest
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"", TKTumblelogsRequestEmailKey, @"", TKTumblelogsRequestPasswordKey, nil];
    TKTumblelogsRequest *request = [[TKTumblelogsRequest alloc] initWithOptions:options delegate:self];
    [request start];

    didFailWithErrorBlock = ^(NSError *error) {
        requestHasFinished = YES;
        STFail(@"An error occurred: %@", error);
    };

    didReceiveResponseBlock = ^(TKTumblelogsResponse *response) {
        requestHasFinished = YES;
        tumblelogs = response.tumblelogs;
    };

    // Keep running the mainRunLoop until the request has finished.
    while (!requestHasFinished) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }

    STAssertNotNil(tumblelogs, nil);
    STAssertTrue([tumblelogs count] == 6, nil);

    TKTumblelog *tumblelog = [tumblelogs lastObject];
    STAssertEqualObjects(tumblelog.title, @"TumblrKit test", nil);
    STAssertEqualObjects(tumblelog.name, @"tumblrkit-test", nil);
    STAssertEqualObjects(tumblelog.URL, [NSURL URLWithString:@"http://tumblrkit-test.tumblr.com/"], nil);
}

- (void)testForbiddenRequest
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@"foo@bar", TKTumblelogsRequestEmailKey, @"baz", TKTumblelogsRequestPasswordKey, nil];
    TKTumblelogsRequest *request = [[TKTumblelogsRequest alloc] initWithOptions:options delegate:self];
    [request start];

    didFailWithErrorBlock = ^(NSError *error) {
        requestHasFinished = YES;
        STAssertTrue(403 == [error code], nil);
    };

    didReceiveResponseBlock = ^(TKTumblelogsResponse *response) {
        requestHasFinished = YES;
        STFail(@"Request should fail");
    };

    // Keep running the mainRunLoop until the request has finished.
    while (!requestHasFinished) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    }
}

- (void)tumblelogsRequest:(TKTumblelogsRequest *)request didReceiveResponse:(TKTumblelogsResponse *)response
{
    didReceiveResponseBlock(response);
}

- (void)tumblelogsRequest:(TKTumblelogsRequest *)request didFailWithError:(NSError *)error
{
    didFailWithErrorBlock(error);
}

@end
