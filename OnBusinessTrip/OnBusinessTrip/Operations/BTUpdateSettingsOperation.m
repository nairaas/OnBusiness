//
//  BTUpdateSettingsOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 7/27/13.
//
//

#import "BTUpdateSettingsOperation.h"
#import "OperationHelper.h"

@implementation BTUpdateSettingsOperation

- (id)initWithProfileID:(NSString *)profileID search:(NSDictionary *)d successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
	NSString *path = [NSString stringWithFormat:@"/settings/%@", profileID];
	return [super initWithURIPath:path inputData:d completionHandler:successHandler failureHandler:failureHandler];
}

@end
