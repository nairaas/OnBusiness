//
//  BTSignUpOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 5/30/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTSignUpOperation : ATAPIPostOperation

- (id)initWithUserName:(NSString *)email password:(NSString *)pass date:(NSString *)dateOfBirth gender:(NSInteger)gender successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
