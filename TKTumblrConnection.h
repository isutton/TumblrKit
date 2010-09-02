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
//  TKTumblrConnection.h by Igor Sutton on 7/13/10.
//

#import <Cocoa/Cocoa.h>
#import "TKTumblrRequest.h"
#import "TKTumblrResponse.h"

#import "NSString+MIME.h"

@interface TKTumblrConnection : NSObject
{

}

- (BOOL)sendSynchronousRequest:(TKTumblrRequest *)req returningResponse:(TKTumblrResponse **)res error:(NSError **)error;
- (BOOL)sendSynchronousWriteRequest:(TKTumblrRequest *)theRequest returningResponse:(TKTumblrResponse **)theResponse error:(NSError **)error;
- (BOOL)sendSynchronousReadRequest:(TKTumblrRequest *)aRequest returningResponse:(TKTumblrResponse **)aResponse error:(NSError **)error;

@end
