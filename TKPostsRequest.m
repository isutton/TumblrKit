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

#import "TKPostsRequest.h"
#import "TKPostsResponse.h"
#import "TKPost.h"

@implementation TKPostsRequest

@synthesize delegate = _delegate;

#pragma mark - NSObject

- (void)dealloc;
{
     _receivedPosts = nil;
     _options = nil;
     _parser = nil;
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict;
{
    _currentElementName = elementName;
    
    if ([elementName isEqualToString:@"post"])
        _currentPost = [TKPost postWithAttributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName;
{
    if ([elementName isEqualToString:@"post"]) {
        [_receivedPosts addObject:_currentPost];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string;
{
    static NSDictionary *elementToSelectorDict = nil;
    
    if (!elementToSelectorDict) {
        elementToSelectorDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"appendToText:", @"text",
                                 @"appendToCaption:",@"caption",
                                 @"appendToPlayer:", @"player",
                                 @"appendToBody:", @"body",
                                 @"setURLWithString:", @"url",
                                 nil];
    }
    
    NSString *key = [[_currentElementName componentsSeparatedByString:@"-"] lastObject];
    SEL selector = NSSelectorFromString([elementToSelectorDict objectForKey:key]);
    if (selector && [_currentPost respondsToSelector:selector]) {
        [_currentPost performSelector:selector withObject:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser;
{
     _currentPost = nil;
    [self.delegate postsRequest:self didReceiveResponse:[TKPostsResponse responseWithPosts:_receivedPosts]];
}

#pragma mark - TKRequest

- (NSURL *)URL;
{
    NSMutableDictionary *options = [_options mutableCopy];
    NSString *domain = [options objectForKey:TKPostsRequestDomainKey];
    [options removeObjectForKey:TKPostsRequestDomainKey];
    NSMutableString *URLString = [NSMutableString stringWithFormat:@"http://%@/api/read?", domain];

    NSMutableArray *queryStringArray = [NSMutableArray array];
    for (NSString *key in [options allKeys]) {
        NSString *value = [options objectForKey:key];
        [queryStringArray addObject:[NSString stringWithFormat:@"%@=%@", key, value]];
    }
    
    [URLString appendString:[queryStringArray componentsJoinedByString:@"&"]];
    NSURL *URL = [NSURL URLWithString:URLString];
    return URL;
}

- (void)connectionDidFinishLoadingData:(NSData *)data;
{
    _parser = [[NSXMLParser alloc] initWithData:data];
    [_parser setDelegate:self];
    [_parser parse];
}

- (void)connectionDidFailWithError:(NSError *)error;
{
    [self.delegate postsRequest:self didFailWithError:error];
}

#pragma mark - API

- (id)initWithOptions:(NSDictionary *)options delegate:(id<TKPostsRequestDelegate>)delegate;
{
    if (!(self = [self init]))
        return nil;

    if (![options objectForKey:TKPostsRequestDomainKey])
        [NSException raise:@"TKPostsRequestDomainKey is mandatory" format:@"TKPostsRequestDomainKey is mandatory"];
    
    _receivedPosts = [[NSMutableArray alloc] init];    
    _options = options;
    _delegate = delegate;
        
    return self;
}

- (NSDictionary *)options;
{
    return _options;
}

@end

NSString const *TKPostsRequestDomainKey = @"domain";
NSString const *TKPostsRequestPostIDKey = @"id";
NSString const *TKPostsRequestStartAtIndexKey = @"start";
NSString const *TKPostsRequestNumberOfPostsKey = @"num";
