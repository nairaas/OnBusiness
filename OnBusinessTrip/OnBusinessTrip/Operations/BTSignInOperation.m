//
//  BTSignInOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import "BTSignInOperation.h"
#import "OperationHelper.h"

@implementation BTSignInOperation

- (id)initWithUserName:(NSString *)email password:(NSString *)pass successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:successSel onTarget:target withObject:nil forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
    return [super initWithUsername:email password:pass completionHandler:successHandler failureHandler:failureHandler];
}

@end
