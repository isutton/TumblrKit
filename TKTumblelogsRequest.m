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

#import "TKTumblelogsRequest.h"
#import "TKTumblelogsResponse.h"
#import "TKTumblelog.h"

@implementation TKTumblelogsRequest

@synthesize delegate = _delegate;

#pragma mark - NSObject

- (void)dealloc;
{
    [_options release]; _options = nil;
    [_receivedTumblelogs release]; _receivedTumblelogs = nil;
    [super dealloc];
}

#pragma mark - NSXMLParserDelegate

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    _currentElementName = elementName;
    
    if ([elementName isEqualToString:@"tumblelog"])
        _currentTumblelog = [[TKTumblelog alloc] initWithAttributes:attributeDict];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"tumblelog"]) {
        [_receivedTumblelogs addObject:_currentTumblelog];
        [_currentTumblelog release];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [parser release];
    [_delegate tumblelogsRequest:self didReceiveResponse:[TKTumblelogsResponse responseWithTumblelogs:_receivedTumblelogs]];
}

#pragma mark - TKRequest

- (NSURL *)URL; 
{
    return [NSURL URLWithString:@"http://www.tumblr.com/api/authenticate"];
}

- (NSData *)HTTPBody;
{
    NSString *HTTPBodyString = [NSString stringWithFormat:@"email=%@&password=%@",
                                [_options objectForKey:TKTumblelogsRequestEmailKey],
                                [_options objectForKey:TKTumblelogsRequestPasswordKey],
                                nil];
    return [HTTPBodyString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)connectionDidFinishLoadingData:(NSData *)data;
{
    _receivedTumblelogs = [[NSMutableArray alloc] init];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];    
}

#pragma mark - API

- (id)initWithOptions:(NSDictionary *)options delegate:(id<TKTumblelogsRequestDelegate>)delegate;
{
    if (!(self = [self init]))
        return nil;
    
    if (![options objectForKey:TKTumblelogsRequestEmailKey])
        [NSException raise:@"TKTumblelogsRequestEmailKey is mandatory" format:@"TKTumblelogsRequestEmailKey is mandatory"];
    
    if (![options objectForKey:TKTumblelogsRequestPasswordKey])
        [NSException raise:@"TKTumblelogsRequestPasswordKey is mandatory" format:@"TKTumblelogsRequestPasswordKey is mandatory"];    
    
    _options = [options retain];
    _delegate = delegate;
    
    return self;
}

@end

NSString const * TKTumblelogsRequestEmailKey = @"email";
NSString const * TKTumblelogsRequestPasswordKey = @"password";
