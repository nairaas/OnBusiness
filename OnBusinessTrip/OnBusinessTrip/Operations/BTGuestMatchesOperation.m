//
//  BTGuestMatchesOperation.m
//  OnBusinessTrip
//
//  Created by Naira on 6/8/13.
//
//

#import "BTGuestMatchesOperation.h"
#import "OperationHelper.h"
#import "BTSearch.h"

@implementation BTGuestMatchesOperation

- (id)initWithTrip:(NSDictionary *)trip successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target {
    ATOperationHandler successHandler = ^(ATOperation *operation) {
		id result = [(ATAPIOperation *)operation output];
		[OperationHelper invokeSelector:successSel onTarget:target withObject:result forID:nil];
	};
	ATOperationHandler failureHandler = ^(ATOperation *operation) {
		[OperationHelper invokeSelector:failureSel onTarget:target withObject:operation.error forID:nil];
	};
    
    NSDictionary *search = [NSDictionary dictionaryWithObjectsAndKeys:@"18", @"ageFrom", @"65", @"ageTo", @"1", @"dating", @"1", @"gender", @"1", @"social", nil];
//    NSDictionary *trip = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-06-20T00:00:00", @"startDate", @"2013-06-25T00:00:00", @"endDate", @"83", @"locationId", nil];
	return [super initWithURIPath:@"/match/guest/search" inputData:[NSDictionary dictionaryWithObjectsAndKeys:search, @"search", trip, @"trip", nil]
				completionHandler:successHandler
				   failureHandler:failureHandler];
}

@end
