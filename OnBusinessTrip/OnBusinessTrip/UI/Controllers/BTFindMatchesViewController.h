//
//  BTFindMatchesViewController.h
//  OnBusinessTrip
//
//  Created by Naira on 4/18/13.
//
//

#import <UIKit/UIKit.h>

@interface BTFindMatchesViewController : UIViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UITextField *locationTextField;
@property (nonatomic, weak) IBOutlet UITextField *durationTextField;
@property (nonatomic, weak) IBOutlet UIButton *findButton;

- (IBAction)signInPressed:(id)sender;

@end
