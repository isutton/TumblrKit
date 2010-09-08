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
//  TKTumblr.m by Igor Sutton on 9/7/10.
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

- (void)dealloc
{
    self.email = nil;
    self.password = nil;
    self.currentTumblelog = nil;
    self.currentPost = nil;
    self.currentElementName = nil;
    self.requestedPost = nil;
    [super dealloc];
}

- (TKPost *)postWithID:(NSNumber *)thePostID andDomain:(NSString *)theDomain
{
    TKTumblrReadRequest *theReadRequest = [[TKTumblrReadRequest alloc] initWithPostID:thePostID andDomain:theDomain];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[theReadRequest endpoint]];
    [theReadRequest release];
    id previousDelegate = [self delegate];
    [self setDelegate:self];
    [parser setDelegate:self];
    [parser parse];
    [parser release];
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
    [parser release];
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

    NSString *postString = [postDict multipartMIMEString];
    NSMutableURLRequest *theURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.tumblr.com/api/write"]];

    [theURLRequest setHTTPMethod:@"POST"];
    [theURLRequest setValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    [theURLRequest setValue:[NSString stringWithFormat:@"%d", [postString length]] forHTTPHeaderField:@"Content-Length"];
    [theURLRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSString MIMEBoundary]] forHTTPHeaderField:@"Content-Type"];
    [theURLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSError *error = nil;
    NSHTTPURLResponse *theURLResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theURLRequest
                                                 returningResponse:&theURLResponse
                                                             error:&error];

    // Release the request before we can enter some potentially danger
    // code path.
    [theURLRequest release];

    // Bail out quickly if NSURLConnection populated error.
    if (([theURLResponse statusCode] != TKTumblrCreated)) {
        if (delegate && [delegate respondsToSelector:@selector(tumblrDidFailToUploadPost:withDomain:returnCode:)]) {
            [delegate tumblrDidFailToUploadPost:thePost
                                     withDomain:theDomain
                                     returnCode:[theURLResponse statusCode]];
        }
        return NO;
    }

    // The following code will only execute when we get a TKTumblrCreated response, so it's
    // safe to assume that responseData will have only the postID of the post we created.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *postID = [formatter numberFromString:[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]];
    [formatter release];

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
    [parser release];

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

#pragma mark TKTumblrDelegate

- (void)tumblrDidReceivePost:(TKPost *)thePost withDomain:(NSString *)theDomain
{
    [self setRequestedPost:thePost];
}

@end
