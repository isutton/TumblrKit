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
//  TKTumblrConnection.m by Igor Sutton on 7/13/10.
//

#import "TKTumblrConnection.h"
#import "TKTumblrReader.h"


@implementation TKTumblrConnection

- (BOOL)sendSynchronousRequest:(TKTumblrRequest *)req returningResponse:(TKTumblrResponse **)res error:(NSError **)error
{

    //
    // If req.post is not nil, then we're adding/editing some post, otherwise
    // we'll be consulting the read api using the parameters specified in the
    // request.
    //

    if ([req isWrite])
        return [self sendSynchronousWriteRequest:req returningResponse:res error:error];

    return [self sendSynchronousReadRequest:req returningResponse:res error:error];
}

- (BOOL)sendSynchronousReadRequest:(TKTumblrRequest *)aRequest returningResponse:(TKTumblrResponse **)aResponse error:(NSError **)error
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:[aRequest URLForRead]];
    TKTumblrReader *reader = [[TKTumblrReader alloc] init];
    [parser setDelegate:reader];
    [parser parse];
    if (aResponse) {
        *aResponse = [TKTumblrResponse responseWithPosts:reader.posts];
    }

    return YES;
}

- (BOOL)sendSynchronousWriteRequest:(TKTumblrRequest *)aRequest returningResponse:(TKTumblrResponse **)aResponse error:(NSError **)error
{
    return NO;
}

@end
