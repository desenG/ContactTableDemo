
#import <UIKit/UIKit.h>
#import "StaticTableParentProtocol.h"
#import "StaticTableViewControllerProtocol.h"
#import "MGSwipeTableCell.h"
#import "MGSwipeButton.h"

@interface ContactTableViewController : UITableViewController <StaticTableViewControllerProtocol,UISearchResultsUpdating, UISearchBarDelegate>

{
}

@property (nonatomic, strong) NSArray *contacts;
@property (nonatomic, weak) UIViewController <StaticTableParentProtocol> *delegate;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults; // Filtered search results

-(void)updateTable;

@end
