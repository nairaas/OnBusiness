//
//  BTSearchViewController.h
//  OnBusinessTrip
//
//  Created by Naira on 6/9/13.
//
//

#import <UIKit/UIKit.h>

@interface BTSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;


@end
