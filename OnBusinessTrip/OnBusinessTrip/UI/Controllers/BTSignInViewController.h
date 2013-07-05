//
//  BTSignInViewController.h
//  OnBusinessTrip
//
//  Created by Naira on 5/27/13.
//
//

#import <UIKit/UIKit.h>

@interface BTSignInViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;

@property (nonatomic, weak) IBOutlet UIButton *signInButton;

- (IBAction)signIn:(id)sender;

@end
