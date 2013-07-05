//
//  BTGuestMatchesOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 6/8/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTGuestMatchesOperation : ATAPICreateObjectOperation

- (id)initWithSuccessSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
