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

#if TARGET_OS_IPHONE
typedef UIImage TKImage;
#elif TARGET_OS_MAC
typedef NSImage TKImage;
#endif

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
    NSString *source;
    TKImage *image;
    NSUInteger width;
    NSUInteger height;
}

@property (assign) NSUInteger width;
@property (assign) NSUInteger height;
@property (copy) NSString *source;
@property (retain) TKImage *image;

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
