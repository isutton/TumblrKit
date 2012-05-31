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

#import "TKPost.h"

static NSString *TKPostTypeFromTumblrAsString[] =
        {
                @"",
                @"regular",
                @"link",
                @"quote",
                @"photo",
                @"conversation",
                @"video",
                @"audio",
                @"answer"
        };

static NSString *TKPostTypeAsString[] =
        {
                @"",
                @"TKPostTypeRegular",
                @"TKPostTypeLink",
                @"TKPostTypeQuote",
                @"TKPostTypePhoto",
                @"TKPostTypeConversation",
                @"TKPostTypeVideo",
                @"TKPostTypeAudio",
                @"TKPostTypeAnswer"
        };

static NSString *TKPostFormatAsString[] =
        {
                @"TKPostFormatHTML",
                @"TKPostFormatMarkdown"
        };

@implementation TKPost

@synthesize postID, url, slug, date, reblogKey, type, format, group;

- (id)init
{
    if ((self = [super init]) != nil) {
        postID = nil;
        url = nil;
        reblogKey = nil;
        date = nil;
        url = nil;
        group = nil;
        format = TKPostFormatHTML;
    }

    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    if ((self = [self init]) != nil) {
        self.postID = [attributeDict objectForKey:@"id"];
        self.url = [attributeDict objectForKey:@"url"];
        self.date = [attributeDict objectForKey:@"date"];
        self.slug = [attributeDict objectForKey:@"slug"];
        self.reblogKey = [attributeDict objectForKey:@"reblog-key"];
        self.format = [[attributeDict objectForKey:@"format"] isEqualToString:@"html"]
                ? TKPostFormatHTML
                : TKPostFormatMarkdown;
    }

    return self;
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"Post ID: %@, Date: %@, URL: %@, Slug: %@, Type: %@, Reblog Key: %@, Format: %@", self.postID, self.date, self.url, self.slug, TKPostTypeAsString[self.type], self.reblogKey, TKPostFormatAsString[self.format]];
}

+ (id)postWithAttributes:(NSDictionary *)attributeDict
{
    /**
     Simplistic dictionary to be used statically. Used to map a Tumblr's post type
     to internal TumblrKit class names.
     */
    NSDictionary *TKPostTypeToClassNameDict = [NSDictionary dictionaryWithObjectsAndKeys:
            @"TKPostPhoto", @"photo",
            @"TKPostConversation", @"conversation",
            @"TKPostLink", @"link",
            @"TKPostQuote", @"quote",
            @"TKPostRegular", @"regular",
            @"TKPostVideo", @"video",
            @"TKPostAudio", @"audio",
            nil];

    Class postClass = nil;
    NSString *type_ = [attributeDict objectForKey:@"type"];

    postClass = NSClassFromString([TKPostTypeToClassNameDict objectForKey:type_]);

    return [(TKPost *) [postClass alloc] initWithAttributes:attributeDict];
}

- (NSString *)typeAsString
{
    return TKPostTypeFromTumblrAsString[self.type];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
            [self typeAsString], @"type",
            [self group], @"group",
            nil];
    return dict;
}

@end

@implementation TKPostRegular

- (id)init
{
    if ((self = [super init]) != nil) {
        self.title = @"";
        self.body = @"";
        self.type = TKPostTypeRegular;
    }

    return self;
}


- (NSString *)title
{
    return [title copy];
}

- (void)setTitle:(NSString *)aTitle
{
    if (aTitle != title) {
        title = [aTitle mutableCopy];
    }
}

- (NSString *)body
{
    return [body copy];
}

- (void)setBody:(NSString *)aBody
{
    if (aBody != body) {
        body = [aBody mutableCopy];
    }
}

- (void)appendToBody:(NSString *)string
{
    [body appendString:string];
}

- (void)appendToTitle:(NSString *)string
{
    [title appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Title: %@, Body: %@", [super description], self.title, self.body];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [super attributesAsDictionary];
    [dict setObject:body forKey:@"body"];
    [dict setObject:title forKey:@"title"];
    return dict;
}

@end

@implementation TKPostLink

@synthesize URL;

- (id)init
{
    if ((self = [super init]) != nil) {
        URL = nil;
        type = TKPostTypeLink;
        text = [[NSMutableString alloc] init];
    }

    return self;
}


- (NSString *)text
{
    return [text copy];
}

- (void)setText:(NSString *)aText
{
    if (aText != text) {
        text = [aText mutableCopy];
    }
}

- (void)appendToText:(NSString *)string
{
    [text appendString:string];
}

- (void)setURLWithString:(NSString *)URLString
{
    self.URL = [NSURL URLWithString:URLString];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Link Text: %@, Link URL: %@", [super description], self.text, self.URL];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [super attributesAsDictionary];
    [dict setObject:text forKey:@"name"];
    [dict setObject:[URL absoluteString] forKey:@"url"];
    return dict;
}

@end

@implementation TKPostQuote

- (id)init
{
    if ((self = [super init]) != nil) {
        type = TKPostTypeQuote;
        source = [[NSMutableString alloc] init];
        text = [[NSMutableString alloc] init];
    }

    return self;
}


- (NSString *)text
{
    return [text copy];
}

- (void)setText:(NSString *)aText
{
    if (aText != text) {
        text = [aText mutableCopy];
    }
}

- (NSString *)source
{
    return [source copy];
}

- (void)setSource:(NSString *)aSource
{
    if (aSource != source) {
        source = [aSource mutableCopy];
    }
}

- (void)appendToText:(NSString *)string
{
    [text appendString:string];
}

- (void)appendToSource:(NSString *)string
{
    [source appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Quote Text: %@, Quote Source: %@", [super description], self.text, self.source];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [super attributesAsDictionary];
    [dict setObject:text forKey:@"quote"];
    [dict setObject:source forKey:@"whatever"];
    return dict;
}

@end

@implementation TKPostConversation

- (id)init
{
    if ((self = [super init]) != nil) {
        type = TKPostTypeConversation;
        text = [[NSMutableString alloc] init];
    }

    return self;
}


- (NSString *)text
{
    return [text copy];
}

- (void)setText:(NSString *)aText
{
    if (aText != text) {
        text = [aText mutableCopy];
    }
}

- (void)appendToText:(NSString *)string
{
    [text appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Conversation Text: %@", [super description], self.text];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [super attributesAsDictionary];
    [dict setObject:text forKey:@"conversation"];
    [dict setObject:@"" forKey:@"title"];
    return dict;
}

@end

@implementation TKPostPhoto

@synthesize width, height, source, image;

- (id)init
{
    if ((self = [super init]) != nil) {
        type = TKPostTypePhoto;
        caption = [[NSMutableString alloc] init];
        image = nil;
        source = nil;
        width = 0;
        height = 0;
    }

    return self;
}

- (id)initWithAttributes:(NSDictionary *)attributeDict
{
    if ((self = [super initWithAttributes:attributeDict]) != nil) {
        width = [[attributeDict objectForKey:@"width"] intValue];
        height = [[attributeDict objectForKey:@"height"] intValue];
    }

    return self;
}


- (NSString *)caption
{
    return [caption copy];
}

- (void)setCaption:(NSString *)aCaption
{
    if (aCaption != caption) {
        caption = [aCaption mutableCopy];
    }
}

- (void)appendToCaption:(NSString *)string
{
    [caption appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Photo Caption: %@, Photo Width: %i, Photo Height: %i", [super description], self.caption, self.width, self.height];
}

- (NSDictionary *)attributesAsDictionary
{
    NSMutableDictionary *dict = (NSMutableDictionary *) [super attributesAsDictionary];
    if (source != nil)
        [dict setObject:source forKey:@"source"];
    if (image != nil && source == nil) {
#if TARGET_OS_IPHONE
        [dict setObject:UIImageJPEGRepresentation(image, 1.0) forKey:@"data"];
#elif TARGET_OS_MAC
        NSBitmapImageRep *bitmap = [[image representations] objectAtIndex:0];
        [dict setObject:[bitmap representationUsingType:NSJPEGFileType properties:nil] forKey:@"data"];
#endif
    }
    [dict setObject:caption forKey:@"caption"];

    return dict;
}

@end

@implementation TKPostVideo

- (id)init
{
    if ((self = [super init]) != nil) {
        type = TKPostTypeVideo;
        caption = [[NSMutableString alloc] init];
        source = [[NSMutableString alloc] init];
        player = [[NSMutableString alloc] init];
    }

    return self;
}


- (NSString *)caption
{
    return [caption copy];
}

- (void)setCaption:(NSString *)aCaption
{
    if (aCaption != caption) {
        caption = [aCaption mutableCopy];
    }
}

- (NSString *)source
{
    return [source copy];
}

- (void)setSource:(NSString *)aSource
{
    if (aSource != source) {
        source = [aSource mutableCopy];
    }
}

- (NSString *)player
{
    return [player copy];
}

- (void)setPlayer:(NSString *)aPlayer
{
    if (aPlayer != player) {
        player = [aPlayer mutableCopy];
    }
}

- (void)appendToCaption:(NSString *)string
{
    [caption appendString:string];
}

- (void)appendToSource:(NSString *)string
{
    [source appendString:string];
}

- (void)appendToPlayer:(NSString *)string
{
    [player appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Video Caption: %@, Video Source: %@, Video Player: %@", [super description], self.caption, self.source, self.player];
}

@end

@implementation TKPostAudio

- (id)init
{
    if ((self = [super init]) != nil) {
        type = TKPostTypeAudio;
        caption = [[NSMutableString alloc] init];
        player = [[NSMutableString alloc] init];
    }

    return self;
}


- (NSString *)caption
{
    return [caption copy];
}

- (void)setCaption:(NSString *)aCaption
{
    if (aCaption != caption) {
        caption = [aCaption mutableCopy];
    }
}

- (NSString *)player
{
    return [player copy];
}

- (void)setPlayer:(NSString *)aPlayer
{
    if (aPlayer != player) {
        player = [aPlayer mutableCopy];
    }
}

- (void)appendToCaption:(NSString *)string
{
    [caption appendString:string];
}

- (void)appendToPlayer:(NSString *)string
{
    [player appendString:string];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@, Audio Caption: %@, Audio Player: %@", [super description], self.caption, self.player];
}

@end
