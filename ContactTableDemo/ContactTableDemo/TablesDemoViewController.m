//
//  TablesDemoViewController.m
//  ObjectiveC_Demo
//
//  Created by DesenGuo on 2016-04-05.
//  Copyright © 2016 divecommunications. All rights reserved.
//

#import "TablesDemoViewController.h"

@implementation TablesDemoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [ResourceHelper updateRuntimeAddressBook];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self showContactFriends];
}

-(void)showContactFriends
{
    [self updateContactTable];
}

-(void)updateContactTable
{
    NSLog(@"updateContactTable");
    NSMutableArray* getAddressFriends=[RuntimeDataStorage contactsFromAddressBook];
    
    NSMutableSet *set = [NSMutableSet setWithArray:getAddressFriends];
    
    self.contactTableViewController.contacts = [set allObjects];
    
    [self.contactTableViewController updateTable];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    @try{
        NSLog(@"segue.identifier  ::%@",segue.identifier);
        
        if ([segue.identifier isEqualToString: @"contactTable"])
        {
            self.contactTableViewController = segue.destinationViewController;
            self.contactTableViewController.delegate =self;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
    
}
@end
