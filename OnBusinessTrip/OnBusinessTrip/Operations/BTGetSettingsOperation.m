//
//  BTGetSettingsOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 7/27/13.
//
//

#import "BTGetSettingsOperation.h"
#import "OperationHelper.h"

@implementation BTGetSettingsOperation

- (id)initWithProfileID:(NSString *)profileID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
	return [super initWithURIPath:[NSString stringWithFormat:@"/settings/%@", profileID] completionHandler:successHandler failureHandler:failureHandler];
}

@end
