//
//  BTMatchesViewController.h
//  OnBusinessTrip
//
//  Created by Naira on 4/27/13.
//
//

#import <UIKit/UIKit.h>

@interface BTMatchesViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *changeViewButton;

- (IBAction)switchView:(id)sender;

@end
