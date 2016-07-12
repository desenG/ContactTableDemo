#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Contact.h"

//Forward declaration of StaticTableParentProtocol,
//since the delegate in StaticTableViewControllerProtocol.h conforms to the StaticTableParentProtocol
@protocol StaticTableParentProtocol;

@protocol StaticTableViewControllerProtocol <NSObject>

@property (nonatomic, weak) UIViewController <StaticTableParentProtocol> *delegate;

@optional
-(void)updateTable;
-(void)addContact:(Contact*)contact;
@end
