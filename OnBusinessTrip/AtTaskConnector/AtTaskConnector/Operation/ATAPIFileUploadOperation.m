//
//  ATAPIFileUploadOperation.m
//  AtTaskConnector
//
//  Created by Naira on 8/18/13.
//
//

#import "ATAPIFileUploadOperation.h"

@implementation ATAPIFileUploadOperation

- (NSString *)HTTPHeaderForKey:(NSString *)key {
	if ([key isEqualToString:@"Content-Type"]) {
		return @"multipart/form-data; boundary=-------------V2ymHFg03ehbqgZCaKO6jy";
	} else if ([key isEqualToString:@"Content-Length"]) {
		return [NSString stringWithFormat:@"%d", [[self HTTPBody] length]];
	}
	return nil;
}

- (id)HTTPBody {
	NSMutableData *body = [NSMutableData data];
    NSString *const CRLF = @"\r\n";
    NSString *b = [NSString stringWithFormat:@"--%@%@", @"-------------V2ymHFg03ehbqgZCaKO6jy", CRLF];
    [body appendData:[b dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", @"image"];
    [body appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *name = [NSString stringWithFormat:@"; filename=\"%@\"%@%@", @"maria.png", CRLF, CRLF];
    [body appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@%@", @"image/png", CRLF];
    [body appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[CRLF dataUsingEncoding:NSUTF8StringEncoding]];
	[body appendData:self.inputData];
    [body appendData:[CRLF dataUsingEncoding:NSUTF8StringEncoding]];
    b = [NSString stringWithFormat:@"%@--%@--%@", CRLF, @"-------------V2ymHFg03ehbqgZCaKO6jy", CRLF];
	[body appendData:[b dataUsingEncoding:NSUTF8StringEncoding]];
	return body;
}

@end
