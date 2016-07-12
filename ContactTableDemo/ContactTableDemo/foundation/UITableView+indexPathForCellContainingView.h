//
//  UITableView+indexPathForCellContainingView.h
//

#import <UIKit/UIKit.h>

@interface UITableView (indexPathForCellContainingView)

- (NSIndexPath *) indexPathForCellContainingView: (UIView *) view;

@end
