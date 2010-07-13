//
//  Test.m
//  TumblrKit
//
//  Created by Igor Sutton on 7/12/10.
//  Copyright 2010 StrayDev.com. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TKTumblrConnection.h"
#import "TKTumblrRequest.h"
#import "TKTumblrResponse.h"


int main(int argc, char **argv) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

    TKTumblrRequest *req = [[TKTumblrRequest alloc] initWithURL:[NSURL URLWithString:@"http://igorsutton.com/api/read"]];
    req.postFilter = TKPostFilterText;
    req.startIndex = 2;
    req.numberOfPosts = 1;
    req.postType = TKPostTypeLink;

    TKTumblrConnection *conn = [[TKTumblrConnection alloc] init];

    TKTumblrResponse *res = nil;
    NSError *error = nil;

    [conn sendSynchronousRequest:req returningResponse:&res error:&error];

    NSLog(@"%@", res.posts);    
    
    [pool drain];
}