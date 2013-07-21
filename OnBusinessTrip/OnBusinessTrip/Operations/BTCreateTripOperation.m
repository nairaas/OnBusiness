//
//  BTCreateTripOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import "BTCreateTripOperation.h"
#import "OperationHelper.h"

@implementation BTCreateTripOperation

- (id)initWithProfileID:(NSString *)uID location:(NSString *)lID startDate:(NSDate *)startDate endDate:(NSDate *)endDate successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
    NSNumber *userId = [[NSNumber alloc] initWithInt:[uID integerValue]];
    NSNumber *locationId = [[NSNumber alloc] initWithInt:[lID integerValue]];
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", locationId, @"locationId", startDate, @"startDate", endDate, @"endDate", nil];
	return [super initWithURIPath:@"/trip" inputData:input completionHandler:successHandler failureHandler:failureHandler];
}

@end
