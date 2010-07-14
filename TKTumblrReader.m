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
//  TKProvider.m by Igor Sutton on 7/13/10.
//

#import "TKTumblrReader.h"


@implementation TKTumblrReader

@synthesize currentElementName, currentPost;

- (id)init
{
    if ((self = [super init]) != nil) {
        posts = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc
{
    [posts release];
    [currentElementName release];
    [currentPost release];
    [super dealloc];
}

- (NSArray *)posts
{
    return posts;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.currentElementName = elementName;

    if ([elementName isEqualToString:@"post"]) {
        self.currentPost = [TKPost postWithAttributes:attributeDict];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"post"]) {
        if (currentPost != nil)
            [posts addObject:currentPost];
        self.currentPost = nil;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if ([currentElementName isEqualToString:@"photo-caption"]) {
        [currentPost appendToCaption:string];
    }
    else if ([currentElementName isEqualToString:@"conversation-text"]) {
        [currentPost appendToText:string];
    }
    else if ([currentElementName isEqualToString:@"quote-text"]) {
        [currentPost appendToText:string];
    }
    else if ([currentElementName isEqualToString:@"quote-source"]) {
        [currentPost appendToSource:string];
    }
    else if ([currentElementName isEqualToString:@"regular-title"]) {
        [currentPost appendToTitle:string];
    }
    else if ([currentElementName isEqualToString:@"regular-body"]) {
        [currentPost appendToBody:string];
    }
    else if ([currentElementName isEqualToString:@"link-text"]) {
        [currentPost appendToText:string];
    }
    else if ([currentElementName isEqualToString:@"link-url"]) {
        [currentPost setURLWithString:string];
    }
}

@end
