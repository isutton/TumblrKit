TumblrKit
=========

TumblrKit is a light-weight wrapper around Tumblr's API in Objective-C.

Currently you can:

* Fetch posts from Tumblr (regular, conversation, quote and link)
* Upload posts to Tumblr (regular, conversation, quote and link)

Usage
-----

You can fetch a post with a specific POST_ID using the following:

    TKTumblr *tumblr = [[TKTumblr alloc] initWithEmail:EMAIL andPassword:PASSWORD];
    TKPost *thePost = [tumblr postWithID:[NSNumber numberWithInt:POST_ID] andDomain:@"example.tumblr.com"];
    NSLog(@"thePost: %@", thePost);

If you want to fetch more than one post:

    // Instantiate a new TKTumblr object.
    TKTumblr *tumblr = [[TKTumblr alloc] initWithEmail:EMAIL andPassword:PASSWORD];

    // Configure a delegate implementing the TKTumblrDelegate protocol.
    tumblr.delegate = aDelegate;

    // Configure the read request object.
    TKTumblrReadRequest *theReadRequest = [[TKTumblrReadRequest alloc] init];

    // Return the post in raw text (if you wrote using Markdown).
    theReadRequest.filter = TKPostFilterNone;

    // Execute the read request. For each post, TKTumblr will send the
    // tumblrDidReceivePost:withDomain: message to the delegate object.
    [tumblr postsWithReadRequest:theReadRequest];

To upload a TKPost:

    // Create a new TKPost
    TKPostRegular *thePost = [[TKPostRegular alloc] init];
    thePost.title = @"The title";
    thePost.body = @"The body";

    // Upload it to Tumblr. The delegate will receive either
    // tumblrDidUploadPost:withDomain:postId: or
    // tumblrDidFailToUploadPost:withDomain:returnCode:
    [tumblr uploadPost:thePost withDomain:@"another-example.tumblr.com"];

    // If you're lazy, you can dismiss the withDomain to upload to your main
    // Tumblelog.
    [tumblr uploadPost:thePost];

