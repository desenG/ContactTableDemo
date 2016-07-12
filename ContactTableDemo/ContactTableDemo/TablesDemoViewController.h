//
//  TablesDemoViewController.h
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-04-05.
//  Copyright © 2016 divecommunications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuntimeDataStorage.h"
#import "ContactTableViewController.h"

@interface TablesDemoViewController : UIViewController<StaticTableParentProtocol>
@property (nonatomic, weak) ContactTableViewController *contactTableViewController;

@end
