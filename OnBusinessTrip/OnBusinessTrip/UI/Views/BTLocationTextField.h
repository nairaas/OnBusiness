//
//  BTLocationTextField.h
//  OnBusinessTrip
//
//  Created by Naira on 6/6/13.
//
//

#import <UIKit/UIKit.h>

@class  BTLocationTextField;

@protocol BTLocationTextFieldDataSource <NSObject>

- (NSString*)textField:(BTLocationTextField *)textField
   completionForPrefix:(NSString *)prefix
            ignoreCase:(BOOL)ignoreCase;

@end

@interface BTLocationTextField : UITextField

/*
 * Designated programmatic initializer (also compatible with Interface Builder)
 */
- (id)initWithFrame:(CGRect)frame;

/*
 * Autocomplete behavior
 */
@property (nonatomic, assign) NSUInteger autocompleteType; // Can be used by the dataSource to provide different types of autocomplete behavior
@property (nonatomic, assign) BOOL autocompleteDisabled;
@property (nonatomic, assign) BOOL ignoreCase;
@property (nonatomic, assign) BOOL needsClearButtonSpace;
@property (nonatomic, assign) BOOL showAutocompleteButton;

/*
 * Configure text field appearance
 */
@property (nonatomic, strong) UILabel *autocompleteLabel;
- (void)setFont:(UIFont *)font;
@property (nonatomic, assign) CGPoint autocompleteTextOffset;

/*
 * Specify a data source responsible for determining autocomplete text.
 */
@property (nonatomic, assign) id<BTLocationTextFieldDataSource> autocompleteDataSource;
+ (void)setDefaultAutocompleteDataSource:(id<BTLocationTextFieldDataSource>)dataSource;

/*
 * Subclassing:
 */
- (CGRect)autocompleteRectForBounds:(CGRect)bounds; // Override to alter the position of the autocomplete text
- (void)setupAutocompleteTextField; // Override to perform setup tasks.  Don't forget to call super.

/*
 * Refresh the autocomplete text manually (useful if you want the text to change while the user isn't editing the text)
 */
- (void)forceRefreshAutocompleteText;

@end