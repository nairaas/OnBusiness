//
//  ATNetworkOperationManagerTests.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/27/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATNetworkOperationManagerTests.h"
#import "AtTaskConnector.h"

@implementation ATNetworkOperationManagerTests

- (void)testAutoLogin {
	__block BOOL finished = NO;
	ATNetworkOperationManager *manager = [[ATNetworkOperationManager alloc] init];
	manager.apiPath = @"/attask/api";
	manager.apiVersion = @"v3.0";
	manager.serviceHost = @"http://attask-sandbox1";
	manager.username = @"mikayel.aghasyan@user.attask";
	manager.password = @"user";
	ATOperationHandler handler = ^(ATOperation *operation) {
		finished = YES;
	};
	ATAPIGetByIDOperation *operation = [[ATAPIGetByIDOperation alloc] initWithObjectCode:@"task" ID:@"4f420c3700005b702973c43f23e2935d" completionHandler:handler failureHandler:handler];
	[manager submitNetworkOperation:operation];
	while (!finished) {
		[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
	}
//	NSLog(@"Finished!");
}

@end
