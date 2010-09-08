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
//  TKTumblelog.h by Igor Sutton on 9/8/10.
//

#import <Cocoa/Cocoa.h>

typedef enum
{
    TKTumblelogTypePublic,
    TKTumblelogTypePrivate,
} TKTumblelogType;

@interface TKTumblelog : NSObject
{
    NSString *title;
    NSString *name;
    NSURL *URL;
    NSURL *avatarURL;
    NSNumber *privateID;

    BOOL primary;

    TKTumblelogType type;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,retain) NSURL *URL;
@property (nonatomic,retain) NSURL *avatarURL;
@property (nonatomic,retain) NSNumber *privateID;
@property (nonatomic,assign) BOOL primary;
@property (nonatomic,assign) TKTumblelogType type;

+ (id)tumblelogWithAttributes:(NSDictionary *)attributeDict;
- (id)initWithAttributes:(NSDictionary *)attributeDict;

@end
