//
//  BTSignUpOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 5/30/13.
//
//

#import "BTSignUpOperation.h"
#import "OperationHelper.h"

@implementation BTSignUpOperation

- (id)initWithUserName:(NSString *)email password:(NSString *)pass date:(NSString *)dateOfBirth gender:(NSInteger)gender successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:email, @"email", pass, @"password", nil];
	return [super initWithURIPath:@"/user" inputData:input completionHandler:successHandler failureHandler:failureHandler];
}

@end
