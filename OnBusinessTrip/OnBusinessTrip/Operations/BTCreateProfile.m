//
//  BTCreateProfile.m
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import "BTCreateProfile.h"
#import "OperationHelper.h"

@implementation BTCreateProfile

- (id)initWithUserID:(NSString *)uID name:(NSString *)name date:(NSString *)dateOfBirth gender:(NSInteger)gender successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
    NSNumber *userId = [[NSNumber alloc] initWithInt:[uID integerValue]];
    NSNumber *g = [[NSNumber alloc] initWithInt:gender];
    NSNumber *age = [[NSNumber alloc] initWithInt:20];
    NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:@"Armenia", @"country", @"Yerevan", @"state", @"Yerevan", @"city", nil]; //@"40", @"longitude", @"44", @"latitude", 
    NSDictionary *input = [NSDictionary dictionaryWithObjectsAndKeys:userId, @"userId", name, @"name", g, @"gender", @"2012-04-23T18:25:43", @"birthDate", age, @"age", location, @"location", nil];
	return [super initWithObjectCode:@"profile" inputData:input fields:nil completionHandler:successHandler
                      failureHandler:failureHandler];
}

@end
