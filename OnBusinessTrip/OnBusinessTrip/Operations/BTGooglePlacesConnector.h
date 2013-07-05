//
//  BTGooglePlacesConnector.h
//  OnBusinessTrip
//
//  Created by Naira on 6/7/13.
//
//

#import <Foundation/Foundation.h>

@class BTGooglePlacesConnector;

@protocol BTGooglePlacesConnectorDelegate <NSObject>

- (void)connector:(BTGooglePlacesConnector *)connector didRecieveData:(NSArray *)data;

@end

@interface BTGooglePlacesConnector : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic, weak)id<BTGooglePlacesConnectorDelegate> delegate;

- (void)loadPlacesWithName:(NSString *)str;

@end
