//
//  TumblrKit_Tests_for_Mac.h
//  TumblrKit Tests for Mac
//
//  Created by Igor Sutton on 12/14/11.
//  Copyright (c) 2011 igorsutton.com. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "TKPostsRequest.h"
#import "TKTumblelogsRequest.h"

@interface TumblrKit_Tests_for_Mac : SenTestCase <TKPostsRequestDelegate,TKTumblelogsRequestDelegate>
{
    BOOL _testIsDone;
}

@end
