//
//  ATAPIDeleteObjectOperation.h
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIObjectOperation.h"

@interface ATAPIDeleteObjectOperation : ATAPIObjectOperation

@property (nonatomic, copy) NSString *ID;
@property (nonatomic) BOOL force;

- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode ID:(NSString *)ID force:(BOOL) force
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
