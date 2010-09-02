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
//  TKPost.h by Igor Sutton on 7/12/10.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    TKPostTypeAll,
    TKPostTypeRegular,
    TKPostTypeLink,
    TKPostTypeQuote,
    TKPostTypePhoto,
    TKPostTypeConversation,
    TKPostTypeVideo,
    TKPostTypeAudio,
    TKPostTypeAnswer
} TKPostType;

typedef enum
{
    TKPostFormatHTML,
    TKPostFormatMarkdown
} TKPostFormat;

typedef enum
{
    TKPostFilterHTML,
    TKPostFilterText,
    TKPostFilterNone
} TKPostFilter;

@interface TKPost : NSObject
{
    NSNumber *postID;
    NSString *url;
    NSString *slug;
    NSDate *date;
    NSString *reblogKey;
    TKPostType type;
    TKPostFormat format;
    NSString *group;
}

@property (nonatomic,copy) NSNumber *postID;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *slug;
@property (nonatomic,copy) NSDate *date;
@property (nonatomic,copy) NSString *reblogKey;
@property (nonatomic,assign) TKPostType type;
@property (nonatomic,assign) TKPostFormat format;
@property (nonatomic,copy) NSString *group;

+ (id)postWithAttributes:(NSDictionary *)attributeDict;

- (id)initWithAttributes:(NSDictionary *)attributeDict;
- (NSString *)typeAsString;
- (NSDictionary *)attributesAsDictionary;

@end

@interface TKPostRegular : TKPost
{
    NSMutableString *title;
    NSMutableString *body;
}

- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;
- (NSString *)body;
- (void)setBody:(NSString *)aBody;
- (void)appendToTitle:(NSString *)string;
- (void)appendToBody:(NSString *)string;

@end

@interface TKPostLink : TKPost
{
    NSMutableString *text;
    NSURL *URL;
}

@property (nonatomic,copy) NSURL *URL;

- (NSString *)text;
- (void)setText:(NSString *)aText;
- (void)appendToText:(NSString *)string;
- (void)setURLWithString:(NSString *)URLString;

@end

@interface TKPostQuote : TKPost
{
    NSMutableString *text;
    NSMutableString *source;
}

- (NSString *)text;
- (void)setText:(NSString *)aText;
- (NSString *)source;
- (void)setSource:(NSString *)aSource;
- (void)appendToText:(NSString *)string;
- (void)appendToSource:(NSString *)string;

@end

@interface TKPostPhoto : TKPost
{
    NSMutableString *caption;
    NSUInteger width;
    NSUInteger height;
}

@property (assign) NSUInteger width;
@property (assign) NSUInteger height;

- (NSString *)caption;
- (void)setCaption:(NSString *)aCaption;
- (void)appendToCaption:(NSString *)string;

@end

@interface TKPostConversation : TKPost
{
    NSMutableString *text;
}

- (NSString *)text;
- (void)setText:(NSString *)aText;
- (void)appendToText:(NSString *)string;

@end

@interface TKPostVideo : TKPost
{
    NSMutableString *caption;
    NSMutableString *source;
    NSMutableString *player;
}

- (NSString *)caption;
- (void)setCaption:(NSString *)aCaption;
- (NSString *)source;
- (void)setSource:(NSString *)aSource;
- (NSString *)player;
- (void)setPlayer:(NSString *)aPlayer;
- (void)appendToCaption:(NSString *)string;
- (void)appendToSource:(NSString *)string;
- (void)appendToPlayer:(NSString *)string;

@end

@interface TKPostAudio : TKPost
{
    NSMutableString *caption;
    NSMutableString *player;
}

- (NSString *)caption;
- (void)setCaption:(NSString *)aCaption;
- (NSString *)player;
- (void)setPlayer:(NSString *)aPlayer;
- (void)appendToCaption:(NSString *)string;
- (void)appendToPlayer:(NSString *)string;

@end
