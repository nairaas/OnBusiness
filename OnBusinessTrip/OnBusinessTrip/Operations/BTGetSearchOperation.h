//
//  BTGetSearchOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTGetSearchOperation : ATAPIGetByIDOperation

- (id)initWithProfileID:(NSString *)profileID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
