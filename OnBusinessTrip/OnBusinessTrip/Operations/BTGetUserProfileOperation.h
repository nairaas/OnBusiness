//
//  BTGetUserProfileOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 6/30/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTGetUserProfileOperation : ATAPIGetByIDOperation

- (id)initWithProfileID:(NSString *)profileID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
