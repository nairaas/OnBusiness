//
//  BTGetSearchOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import "BTGetSearchOperation.h"
#import "OperationHelper.h"

@implementation BTGetSearchOperation

- (id)initWithProfileID:(NSNumber *)profileID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
	return [super initWithURIPath:[NSString stringWithFormat:@"/mysearch/%@", profileID] completionHandler:successHandler failureHandler:failureHandler];
}

@end
