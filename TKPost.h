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

#import <Foundation/Foundation.h>

typedef enum
{
    TKPostStateAll,
    TKPostStateDraft,
    TKPostStateQueue,
    TKPostStateSubmission
} TKPostState;

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

/**
 Base class for all TumblrKit post representation.
 */
@interface TKPost : NSObject
{
    /** This post's ID. */
    NSNumber *postID;

    /** This post's URL. */
    NSString *url;

    /** This post's slug. */
    NSString *slug;

    /** This post's publish date. */
    NSDate *date;

    /** This post's reblog key. */
    NSString *reblogKey;

    /** This post's type. */
    TKPostType type;

    /** This post's format. */
    TKPostFormat format;

    /** This post's group (or domain). */
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

/**
 Creates a new TKPost subclass based on the attributeDict parameter.
 */
+ (id)postWithAttributes:(NSDictionary *)attributeDict;

/**
 Initializes the base TKPost object with attributeDict contents.
 */
- (id)initWithAttributes:(NSDictionary *)attributeDict;

/**
 Returns this post's type as string.
 */
- (NSString *)typeAsString;

/**
 Returns a dictionary containing all the attributes of the current post.
 */
- (NSDictionary *)attributesAsDictionary;

@end

/**
 Represents Tumblr's "regular" kind of post.
 */
@interface TKPostRegular : TKPost
{
    /** This post's title. */
    NSMutableString *title;

    /** This post's body. */
    NSMutableString *body;
}

/**
 Returns a copy of this post's title.
 */
- (NSString *)title;

/**
 Sets this post's title.
 */
- (void)setTitle:(NSString *)aTitle;

/**
 Returns a copy of this post's body.
 */
- (NSString *)body;

/**
 Sets this post's body.
 */
- (void)setBody:(NSString *)aBody;

/**
 Appends the given string to this post's title.
 */
- (void)appendToTitle:(NSString *)string;

/**
 Appends the given string to this post's body.
 */
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
