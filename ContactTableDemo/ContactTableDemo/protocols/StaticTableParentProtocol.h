

/*
 This is a very simple protocol that lets a UITableViewController notify it's parent view controller when
 
    •The user seelcts a cell
 
    •The user taps a button on a cell.
 
 To use it, simply add the string "<StaticTableParentProtocol>" to the interface 
 for your parent view controller, and then implement one or both of the methods defined below.
 (both are optinal)
 
 Then, in your child subclass of UITableViewController, set up a delegate property of type 
 UIViewController <StaticTableParentProtocol>
 
 You can then add code in your table view controller that notifies the parent view controller when the 
 user selects a cell or taps a button on a cell.
 
 The protocol could easily be extended to handle mulitple buttons, sliders, switches, etc, or notify
 the parent when the user finishes editing a UITextField or UITextView
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "StaticTableViewControllerProtocol.h"

@protocol StaticTableParentProtocol <NSObject>

@optional

-(BOOL)isContactTableForDive;

-(void)selectContact:(Contact*)contact;

-(void)unselectContact:(Contact*)contact;

- (void) tableView: (UITableView *) tableView
         didSelect: (BOOL) select
   cellAtIndexPath: (NSIndexPath *)indexPath
 inViewController : (UIViewController <StaticTableViewControllerProtocol> *) viewController;

- (void) tableView: (UITableView *) tableView
clickedCheckBoxButton: (UIButton *) button
       atIndexPath: (NSIndexPath *) buttonIndexPath
  inViewController: (UITableViewController <StaticTableViewControllerProtocol>*) viewController;

- (void) contactTableView: (UITableView *) tableView
scrollViewWillEndDragging: (UIScrollView *)scrollView
             withVelocity:(CGPoint)velocity
      targetContentOffset:(inout CGPoint *)targetContentOffset
        inViewController : (UIViewController <StaticTableViewControllerProtocol> *) viewController;
@end
