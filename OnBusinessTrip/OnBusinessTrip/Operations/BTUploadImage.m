//
//  BTUploadImage.m
//  OnBusinessTrip
//
//  Created by Naira on 6/23/13.
//
//

#import "BTUploadImage.h"
#import "OperationHelper.h"

@implementation BTUploadImageOperation

- (id)initWithProfileID:(NSString *)pID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
        ATOperationHandler successHandler = ^(ATOperation *operation) {
            id result = [(ATAPIOperation *)operation output];
            [OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
        };
        ATOperationHandler failureHandler = ^(ATOperation *operation) {
            [OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
        };
        NSData *dd = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"maria" ofType:@"png"]];
//	NSLog(@"row data: %@", dd);

    NSMutableData *result = [NSMutableData data];
    NSString *const CRLF = @"\r\n";
    NSString *b = [NSString stringWithFormat:@"--%@%@", @"-------------V2ymHFg03ehbqgZCaKO6jy", CRLF];
    [result appendData:[b dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *disposition = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"", @"image"];
    [result appendData:[disposition dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *name = [NSString stringWithFormat:@"; filename=\"%@\"%@%@", @"maria.png", CRLF, CRLF];
    [result appendData:[name dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *contentType = [NSString stringWithFormat:@"Content-Type: %@%@", @"image/png", CRLF];
    [result appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[CRLF dataUsingEncoding:NSUTF8StringEncoding]];
	[result appendData:dd];
 //   [result appendData:[contentType dataUsingEncoding:NSUTF8StringEncoding]];
    [result appendData:[CRLF dataUsingEncoding:NSUTF8StringEncoding]];
    b = [NSString stringWithFormat:@"%@--%@--%@", CRLF, @"-------------V2ymHFg03ehbqgZCaKO6jy", CRLF];
	[result appendData:[b dataUsingEncoding:NSUTF8StringEncoding]];
//    NSLog(@"Ress: %@", result);
	NSString *path = [NSString stringWithFormat:@"/photo/profile/%@", pID];
	return [super initWithURIPath:path inputData:result completionHandler:successHandler failureHandler:failureHandler];
}

@end
