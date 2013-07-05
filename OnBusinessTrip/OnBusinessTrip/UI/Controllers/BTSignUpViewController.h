//
//  BTSignUpViewController.h
//  OnBusinessTrip
//
//  Created by Naira on 5/27/13.
//
//

#import <UIKit/UIKit.h>

typedef enum {
	BTFemale,
	BTMale
} BTGender;


@interface BTSignUpViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
//@property (nonatomic, weak) IBOutlet UISwitchControl *gender;
@property (nonatomic, weak) IBOutlet UITextField *dateTextField;
@property (nonatomic, weak) IBOutlet UIButton *signUp;

- (IBAction)signUp:(id)sender;

@end
