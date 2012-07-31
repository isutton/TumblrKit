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

#include "TKTumblr.h"
#include "NSString+TumblrKit.h"
#include "NSDictionary+TumblrKit.h"
#include "TKTumblelog.h"

@implementation TKTumblr

@synthesize delegate, email, password, currentPost, currentElementName, requestedPost, currentTumblelog;

- (id)initWithEmail:(NSString *)theEmail andPassword:(NSString *)thePassword
{
    if ((self = [super init]) != nil) {
        self.email = theEmail;
        self.password = thePassword;
        self.currentTumblelog = nil;
        self.currentPost = nil;
        self.currentElementName = nil;
        self.requestedPost = nil;
    }
    return self;
}


- (TKPost *)postWithID:(NSNumber *)thePostID andDomain:(NSString *)theDomain
{
    TKTumblrReadRequest *theReadRequest = [[TKTumblrReadRequest alloc] initWithPostID:thePostID andDomain:theDomain];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[theReadRequest endpoint]];
    id previousDelegate = [self delegate];
    [self setDelegate:self];
    [parser setDelegate:self];
    [parser parse];
    [self setDelegate:previousDelegate];

    TKPost *thePost = nil;

    if (requestedPost) {
        thePost = [self requestedPost];
        [self setRequestedPost:nil];
    }

    return thePost;
}

- (void)postsWithReadRequest:(TKTumblrReadRequest *)theReadRequest
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[theReadRequest endpoint]];
    [parser setDelegate:self];
    [parser parse];
}

- (BOOL)uploadPost:(TKPost *)thePost
{
    return [self uploadPost:thePost withDomain:nil];
}

- (BOOL)uploadPost:(TKPost *)thePost withDomain:(NSString *)theDomain
{
    NSMutableDictionary *postDict = (NSMutableDictionary *)[self attributesAsDictionary];

    if (theDomain)
        [postDict setObject:theDomain forKey:@"group"];

    [postDict addEntriesFromDictionary:[thePost attributesAsDictionary]];

    NSData *postBody = [postDict multipartMIMEData];
    NSMutableURLRequest *theURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.tumblr.com/api/write"]];

    [theURLRequest setHTTPMethod:@"POST"];
    [theURLRequest setValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [theURLRequest setValue:[NSString stringWithFormat:@"%d", [postBody length]] forHTTPHeaderField:@"Content-Length"];
    [theURLRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSString MIMEBoundary]] forHTTPHeaderField:@"Content-Type"];
    [theURLRequest setHTTPBody:postBody];


    if (delegate && [delegate respondsToSelector:@selector(tumblrWillUploadPost:withDomain:)]) {
        [delegate tumblrWillUploadPost:thePost withDomain:theDomain];
    }

    NSError *error = nil;
    NSHTTPURLResponse *theURLResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theURLRequest
                                                 returningResponse:&theURLResponse
                                                             error:&error];

    // Release the request before we can enter some potentially dangerous
    // code path.

    // Bail out quickly if NSURLConnection populated error.
    if (([theURLResponse statusCode] != TKTumblrCreated)) {
        if (delegate && [delegate respondsToSelector:@selector(tumblrDidFailToUploadPost:withDomain:returnCode:)]) {
            [delegate tumblrDidFailToUploadPost:thePost
                                     withDomain:theDomain
                                     returnCode:(TKTumblrResponseReturnCode)[theURLResponse statusCode]];
        }
        return NO;
    }

    // The following code will only execute when we get a TKTumblrCreated response, so it's
    // safe to assume that responseData will have only the postID of the post we created.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *postID = [formatter numberFromString:[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]];

    if (delegate && [delegate respondsToSelector:@selector(tumblrDidUploadPost:withDomain:postID:)]) {
        [delegate tumblrDidUploadPost:thePost withDomain:theDomain postID:postID];
    }

    return YES;
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 email, @"email",
                                 password, @"password",
                                 nil];
    return dict;
}

- (NSArray *)tumblelogs
{
    NSString *theURLString = [NSString stringWithFormat:@"https://www.tumblr.com/api/authenticate?email=%@&password=%@",
                              [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
                              [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL *theURL = [NSURL URLWithString:theURLString];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:theURL];
    [parser setDelegate:self];
    [parser parse];

    return nil;
}

#pragma mark NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElementName = elementName;

    if ([elementName isEqualToString:@"post"]) {
        self.currentPost = [TKPost postWithAttributes:attributeDict];
    }
    else if ([elementName isEqualToString:@"tumblelog"]) {
        self.currentTumblelog = [TKTumblelog tumblelogWithAttributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"post"]) {
        if (currentPost != nil) {
            if (delegate && [delegate respondsToSelector:@selector(tumblrDidReceivePost:withDomain:)]) {
                [delegate tumblrDidReceivePost:currentPost withDomain:@""];
            }
        }
        self.currentPost = nil;
    }
    else if ([elementName isEqualToString:@"tumblelog"]) {
        if (currentTumblelog != nil) {
            if (delegate && [delegate respondsToSelector:@selector(tumblrDidReceiveTumblelog:)]) {
                [delegate tumblrDidReceiveTumblelog:currentTumblelog];
            }
        }
        self.currentTumblelog = nil;
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    static NSDictionary *elementToSelectorDict = nil;

    if (!elementToSelectorDict) {
        elementToSelectorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                 @"appendToText:", @"text",
                                 @"appendToCaption:",@"caption",
                                 @"appendToPlayer:", @"player",
                                 @"appendToBody:", @"body",
                                 @"setURLWithString:", @"url",
                                 nil];
    }

    NSString *key = [[currentElementName componentsSeparatedByString:@"-"] lastObject];
    SEL selector = NSSelectorFromString([elementToSelectorDict objectForKey:key]);
    if (selector) {
        [currentPost performSelector:selector withObject:string];
    }
}

#pragma clang diagnostic pop

#pragma mark TKTumblrDelegate

- (void)tumblrDidReceivePost:(TKPost *)thePost withDomain:(NSString *)theDomain
{
    [self setRequestedPost:thePost];
}

@end
