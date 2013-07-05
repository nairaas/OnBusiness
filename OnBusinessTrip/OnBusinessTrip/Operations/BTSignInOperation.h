//
//  BTSignInOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTSignInOperation : ATAPILoginOperation

- (id)initWithUserName:(NSString *)email password:(NSString *)pass successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
