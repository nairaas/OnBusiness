//
//  BTSignUpViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 5/27/13.
//
//

#import "BTSignUpViewController.h"
#import "BTApplicationContext.h"

#import "BTSignUpOperation.h"
#import "BTCreateProfile.h"
#import "BTCreateTripOperation.h"
#import "BTGetSearchOperation.h"
#import "BTSignInOperation.h"
//#import "BTAppDelegate.h"
#import "BTUploadImage.h"
#import "BTGetUserProfileOperation.h"
#import "BTUpdateUserSearchOperation.h"
#import "Profile.h"
#import "OperationHelper.h"

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTSignUpViewController ()

@property (nonatomic, strong) Profile *profile;

@end

@implementation BTSignUpViewController

@synthesize signUp = _signUp;
@synthesize profile = _profile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
	[self signInAsGuest];
 
}

- (void)signInAsGuest {
	BTSignInOperation *op = [[BTSignInOperation alloc] initWithUserName:[[BTApplicationContext sharedInstance] guestUsername]
                                                               password:[[BTApplicationContext sharedInstance] guestPassword]
                                                             successSel:@selector(guestSignInSucceeded)
                                                             failureSel:@selector(guestSignInFailedWithError:) target:self];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)guestSignInSucceeded {
	BTSignUpOperation *op = [[BTSignUpOperation alloc] initWithUserName:self.emailTextField.text
															   password:self.passwordTextField.text
																   date:self.dateTextField.text gender:0
															 successSel:@selector(successfulSignUpHandler:)
															 failureSel:@selector(failedSignUpHandler:) target:self];
	//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	//    [del.networkOperationManager submitNetworkOperation:op];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)guestSignInFailedWithError:(NSError *)error {
	NSLog(@"Fail: %@", error);
}

- (void)successfulSignUpHandler:(NSDictionary *)userInfo {
    NSLog(@"USER: %@", userInfo);
	BTCreateProfile *op = [[BTCreateProfile alloc] initWithUserID:[userInfo objectForKey:@"id"] name:@"Hello" date:nil gender:1 successSel:@selector(profileCreated:) failureSel:@selector(profileCreationFailed:) target:self];
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.networkOperationManager submitNetworkOperation:op];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)failedSignUpHandler:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)profileCreated:(id)profileID {
    NSLog(@"Profile: %@", profileID);
	self.profile = (Profile *)[OperationHelper objectWithID:profileID];
/*    BTCreateTripOperation *op = [[BTCreateTripOperation alloc] initWithProfileID:[profile objectForKey:@"id"] location:<#(NSString *)#> startDate:<#(NSDate *)#> endDate:<#(NSDate *)#> successSel:<#(SEL)#> failureSel:<#(SEL)#> target:<#(id)#>];
    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.networkOperationManager submitNetworkOperation:op];
 */
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	BTSignInOperation *op = [[BTSignInOperation alloc] initWithUserName:self.emailTextField.text
                                                               password:self.passwordTextField.text
                                                             successSel:@selector(guestSignInSucceeded1)
                                                             failureSel:@selector(guestSignInFailedWithError1:) target:self];

	//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	//    [del.networkOperationManager submitNetworkOperation:op];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];

	
}

- (void)profileCreationFailed:(NSError *)error {
    NSLog(@"Profile failure: %@", error);
}

- (void)guestSignInSucceeded1 {
	NSLog(@"sss: %@ - %@", self.profile, self.profile.profileID);
	
//	BTGetUserProfileOperation *opp = [[BTGetUserProfileOperation alloc] initWithProfileID:[self.profile profileID] successSel:@selector(profileRetrieved:) failureSel:@selector(profileRetrievalFailed:) target:self];
//	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:opp];
//	
//	BTGetSearchOperation *op = [[BTGetSearchOperation alloc] initWithProfileID:[self.profile profileID] successSel:@selector(searchSucceeded:) failureSel:@selector(searchFailedWithError:) target:self];
//	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];

    BTUploadImageOperation *upload = [[BTUploadImageOperation alloc] initWithProfileID:self.profile.profileID successSel:@selector(imageUploaded:) failureSel:@selector(imageUploadingFailed:) target:self];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:upload];
	
}

- (void)profileRetrieved:(Profile *)profile {
    NSLog(@"xxx: %@", profile);
}

- (void)profileRetrievalFailed:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)searchSucceeded:(NSDictionary *)dictionary {
    NSLog(@"Search: %@", dictionary);
	NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:dictionary];
	[d setValue:@"0" forKey:@"social"];
//	[d removeObjectForKey:@"userId"];
	BTUpdateUserSearchOperation *op = [[BTUpdateUserSearchOperation alloc] initWithProfileID:[self.profile profileID] search:d successSel:@selector(searchUpdateSucceeded:) failureSel:@selector(searchUpdateFailedWithError) target:self];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)searchFailedWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)searchUpdateSucceeded:(NSDictionary *)dictionary {
	NSLog(@"rrr: %@", dictionary);
}

- (void)searchUpdateFailedWithError:(NSError *)error {
}

- (void)imageUploaded:(NSDictionary *)dictionary {
    NSLog(@"Image: %@", dictionary);
}

- (void)imageUploadingFailed:(NSError *)error {
    NSLog(@"Image Error: %@", error);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.emailTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
    } else if (self.dateTextField == textField) {
        [self.dateTextField resignFirstResponder];
    }
    return YES;
}

@end
