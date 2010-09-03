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
    [reader release];
    [parser release];

    return YES;
}

- (BOOL)sendSynchronousWriteRequest:(TKTumblrRequest *)theRequest returningResponse:(TKTumblrResponse **)theResponse error:(NSError **)error
{
    NSMutableDictionary *postDict = (NSMutableDictionary *)[theRequest attributesAsDictionary];

    [postDict addEntriesFromDictionary:[theRequest.post attributesAsDictionary]];

    NSString *postString = [NSString multipartMIMEStringWithDictionary:postDict];

    NSMutableURLRequest *theURLRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.tumblr.com/api/write"]];

    [theURLRequest setHTTPMethod:@"POST"];

    [theURLRequest setValue:@"8bit"
         forHTTPHeaderField:@"Content-Transfer-Encoding"];

    [theURLRequest setValue:[NSString stringWithFormat:@"%d", [postString length]]
         forHTTPHeaderField:@"Content-Length"];

    [theURLRequest setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", [NSString MIMEBoundary]]
         forHTTPHeaderField:@"Content-Type"];

    [theURLRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];

    NSHTTPURLResponse *theURLResponse = nil;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theURLRequest returningResponse:&theURLResponse error:error];

    // Release the request before we can enter some potentially danger
    // code path.
    [theURLRequest release];

    // Bail out quickly if NSURLConnection populated error.
    if (([theURLResponse statusCode] != TKTumblrCreated)) {
        if (theResponse)
            *theResponse = [TKTumblrResponse responseWithReturnCode:[theURLResponse statusCode]];
        return NO;
    }
    
    // If we don't have a response to fill in, just leave.
    if (!theResponse)
        return YES;
    
    // The following code will only execute when we get a TKTumblrCreated response, so it's
    // safe to assume that responseData will have only the postID of the post we created.
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    *theResponse = [TKTumblrResponse responseWithPostID:[formatter numberFromString:[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease]]];
    [formatter release];

    return YES;
}

@end
