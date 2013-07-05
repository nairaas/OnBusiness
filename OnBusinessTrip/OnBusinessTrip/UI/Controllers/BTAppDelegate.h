//
//  BTAppDelegate.h
//  OnBusinessTrip
//
//  Created by Naira on 4/18/13.
//
//

#import <UIKit/UIKit.h>
#import <AtTaskConnector/AtTaskConnector.h>

@interface BTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (readonly, strong, nonatomic) ATNetworkOperationManager *networkOperationManager;

@end
