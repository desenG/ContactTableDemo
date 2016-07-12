#import "ContactTableViewController.h"
#import "UITableView+indexPathForCellContainingView.h"

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

@interface ContactTableViewController ()

@end

@implementation ContactTableViewController
{
    NSMutableArray *mutablecontacts;
    NSArray *partitionedData;
    Contact* inputContact;
    NSIndexPath *inputContactIndexPath;
}

-(void)loadData
{
    mutablecontacts=[NSMutableArray arrayWithArray:self.contacts];
    [self sortContacts];
    partitionedData = [self partitionObjects:mutablecontacts collationStringSelector:@selector(lastname)];
    inputContactIndexPath=[self getInputContactIndexPath];
    //    NSArray *arrSelector = [[NSArray alloc]initWithObjects:@"lastname",@"firstname", nil];
    //    NSArray *tableData2 = [self partitionObjects:mutablecontacts collationStringArray:arrSelector];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self loadData];
    // Create a mutable array to contain products for the search results table.
    self.searchResults = [NSMutableArray arrayWithCapacity:[mutablecontacts count]];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    [self.tableView setSectionIndexColor:[UIColor blueColor]];
    self.definesPresentationContext = YES;
}


#pragma mark -- UIScrollViewdelegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    @try{
        if ([self.delegate respondsToSelector: @selector(contactTableView:scrollViewWillEndDragging:withVelocity:targetContentOffset:inViewController:)])
        {
            [self.delegate contactTableView:self.tableView scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset inViewController:self];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}


#pragma mark - StaticTableViewControllerProtocol methods
-(void)updateTable
{
    NSLog(@"updateTable");
    [self loadData];
    
    @try {
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:inputContactIndexPath
                             atScrollPosition:UITableViewScrollPositionTop
                                     animated:YES];
    }
    @catch (NSException *exception)
    {
        NSLog(@"EXCEPTION:: %@",exception);
    }
    // EXCEPTION:: -[UITableView _contentOffsetForScrollingToRowAtIndexPath:atScrollPosition:]: row (0) beyond bounds (0) for section (0).
    // This appears when there is a single contact or no contacts in the address book - don't know why..
}

-(void)sortContacts
{
    mutablecontacts=[NSMutableArray arrayWithArray:[mutablecontacts sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *qId1;
        if ([[(Contact*)a lastname] length]>0) {
            qId1 = [(Contact*)a lastname];
        }else
        {
            qId1 = @"";
        }
        
        NSString *qId2;
        if ([[(Contact*)b lastname] length]>0) {
            qId2 = [(Contact*)b lastname];
        }
        else
        {
            qId2 = @"";
        }
        
        return [qId1 compare:qId2];
    }]];
}

#pragma mark - IBAction methods
-(IBAction)btnCheckBoxClicked:(id)sender
{
    NSLog(@"btnCheckBoxClicked");
    UIButton *senderButton = (UIButton *)sender;
    UIView *viewBlue;
    NSArray *subviews = [senderButton.self.superview subviews];
    for (UIView *subview in subviews) {
        if (subview.tag == 345) viewBlue = subview;
    }
    viewBlue.alpha = 1.0;
    
    NSIndexPath *buttonIndexPath = [self.tableView indexPathForCellContainingView: sender];
    
    
    // Take the selected contact from the contact list or the search results list
    Contact* contact;
    if (self.searchController.active) {
        contact = [self.searchResults objectAtIndex:buttonIndexPath.row];
    } else {
        contact=[[partitionedData objectAtIndex:buttonIndexPath.section] objectAtIndex:buttonIndexPath.row];
    }
    
    if ([contact.ischeckd isEqualToString:@"no"])
    {
        contact.ischeckd =@"yes";
        
        [senderButton setBackgroundImage:[UIImage imageNamed:@"img_tick_white.png"] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage imageNamed:@"img_tick_white.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [UIView animateWithDuration:0.3 animations:^{
            viewBlue.transform = CGAffineTransformMakeScale(1.0,1.0);
        } completion:nil];
        [self delegate ];
        
        if ([self.delegate respondsToSelector: @selector(selectContact:)])
        {
            [self.delegate selectContact:contact];
        }
    }
    else
    {
        contact.ischeckd =@"no";
        
        [senderButton setBackgroundImage:[UIImage imageNamed:@"img_tick_gray.png"] forState:UIControlStateNormal];
        [senderButton setBackgroundImage:[UIImage imageNamed:@"img_tick_gray.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        [UIView animateWithDuration:0.3 animations:^{
            viewBlue.transform = CGAffineTransformMakeScale(0.01,0.01);
        } completion:nil];
        if ([self.delegate respondsToSelector: @selector(unselectContact:)])
        {
            [self.delegate unselectContact:contact];
        }
    }

    if ([self.delegate respondsToSelector: @selector(tableView:didSelect:cellAtIndexPath:inViewController:)])
    {
        [self.delegate tableView: self.tableView
                clickedCheckBoxButton: sender
                     atIndexPath: buttonIndexPath
                inViewController: self];
    }
    NSLog(@"contact.checkd=%@,%@",contact.ischeckd,contact.firstname);
}

-(NSArray *)partitionObjects:(NSArray *)array collationStringSelector:(SEL)selector

{
    NSLog(@"partitionObjects");
    @try {
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

        NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
        NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];

        //create an array to hold the data for each section
        for(int i = 0; i < sectionCount; i++)
        {
            [unsortedSections addObject:[NSMutableArray array]];
        }

        //put each object into a section
        for (id object in array)
        {
            NSInteger index = [collation sectionForObject:object collationStringSelector:selector];
            [[unsortedSections objectAtIndex:index] addObject:object];
        }

        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];

        //sort each section
        for (NSMutableArray *section in unsortedSections)
        {
            [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:selector]];
        }

        return sections;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

-(NSIndexPath*)getInputContactIndexPath
{
    NSLog(@"getInputContactIndexPath");
    int index_Section = 0;
    for (NSMutableArray *section in partitionedData)
    {
        int index_row = 0;
        for (Contact* contact in section)
        {
            if(inputContact == contact)
            {
                return [NSIndexPath indexPathForRow:index_row inSection:index_Section];
            }
            index_row++;
        }
        index_Section++;
    }
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

-(NSArray *)partitionObjects:(NSArray *)array collationStringArray:(NSArray *)selectorArray
{
    @try{
        UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];

        NSInteger sectionCount = [[collation sectionTitles] count]; //section count is take from sectionTitles and not sectionIndexTitles
        NSMutableArray *unsortedSections = [NSMutableArray arrayWithCapacity:sectionCount];

        //create an array to hold the data for each section
        for(int i = 0; i < sectionCount; i++)
        {
            [unsortedSections addObject:[NSMutableArray array]];
        }

        //put each object into a section
        for (id object in array)
        {
            NSInteger index = [collation sectionForObject:object collationStringSelector:NSSelectorFromString([selectorArray objectAtIndex:0])];
            if (index > 25) {
                index = [collation sectionForObject:object collationStringSelector:NSSelectorFromString([selectorArray objectAtIndex:1])];
            }
            [[unsortedSections objectAtIndex:index] addObject:object];
        }

        NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];

        //sort each section
        for (NSMutableArray *section in unsortedSections)
        {
            [sections addObject:[collation sortedArrayFromArray:section collationStringSelector:NSSelectorFromString([selectorArray objectAtIndex:0])]];
        }

        return sections;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

#pragma mark - UITableViewDataSource

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSLog(@"titleForHeaderInSection");
    @try {
        if (self.searchController.active) {
            return @"Search Result";
        } else {
            return [[partitionedData objectAtIndex:section] count] ? [[[UILocalizedIndexedCollation currentCollation] sectionTitles] objectAtIndex:section] : nil;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView %lu",(unsigned long)[partitionedData count]);
    @try {
        // Return the number of sections.
        if (self.searchController.active) {
            return 1;
        } else {
            return [partitionedData count];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //NSLog(@"numberOfRowsInSection");
    @try {
        if (self.searchController.active) {
            return [self.searchResults count];
        } else {
            return [[partitionedData objectAtIndex:section] count];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSLog(@"sectionIndexTitlesForTableView");
    
    @try {
        if (([mutablecontacts count]>0))
        {
            return [[UILocalizedIndexedCollation currentCollation] sectionTitles];
        } else {
            return nil;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"cellForRowAtIndexPath");
    @try {
        static NSString *kCellID = @"ContactsCell";
        MGSwipeTableCell *cell = (MGSwipeTableCell *)[tableView dequeueReusableCellWithIdentifier:kCellID];
        if (cell == nil)
        {
            cell = [[MGSwipeTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
        }
        
        Contact *contact;
        if (self.searchController.active) {
            contact = [self.searchResults objectAtIndex:indexPath.row];
        } else {
            contact=[[partitionedData objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = nil;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundView  = Nil;
        
        UIButton *btnSelected  = (UIButton *)[cell viewWithTag:1000];
        UILabel *labelName = (UILabel *)[cell viewWithTag:1001];
        UILabel *labelLastName = (UILabel *)[cell viewWithTag:1002];
        UILabel *labelemail = (UILabel *)[cell viewWithTag:1003];
        UIImageView *imgprofile = (UIImageView *)[cell viewWithTag:4000];
        UIView *viewBlue = (UIView *)[cell viewWithTag:345];
        UIView *viewWhite = (UIView *)[cell viewWithTag:33];
        viewBlue.alpha = 0.0;
        viewWhite.layer.masksToBounds = YES;
        viewWhite.layer.borderWidth = 3;
        viewWhite.layer.borderColor = [[UIColor colorWithRed:214.0/255.0 green:214.0/255.0 blue:247.0/215.0 alpha:1.0] CGColor];
        viewWhite.alpha = 1.0;
        
        
        labelName.text =  (contact.firstname && contact.firstname.trim.length>0 )?contact.firstname: (
            (contact.lastname && contact.lastname.trim.length>0 )?contact.lastname: (
                    (contact.email && contact.email.trim.length>0 )?contact.email: ((contact.smsNumber && contact.smsNumber.trim.length>0 )?contact.smsNumber:@"")
                                                                                     )
         );
        labelLastName.text = (![labelName.text isEqualToString:contact.lastname])?contact.lastname:@"";
        if (![contact.email  isEqual: @""])
            labelemail.text = contact.email;
        else if (![contact.smsNumber  isEqual: @""])
            labelemail.text = contact.smsNumber;
        
        if ([labelLastName.text isEqualToString:@""]) {
            // There is no last name so extend the first name, in case it holds a long email or something like that...
            labelName.frame = CGRectMake(labelName.frame.origin.x,labelName.frame.origin.y,(IS_IPAD?560:224),labelName.frame.size.height);
        }
        
        //labelemail.text = (![labelName.text isEqualToString:contact.email])?contact.email:@"";
        
        [btnSelected setFrame:CGRectMake(btnSelected.frame.origin.x, btnSelected.frame.origin.y, btnSelected.frame.size.width, btnSelected.frame.size.height)];
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *tempPath =[NSString stringWithFormat:@"%@/%@/%@.png",documentsDirectory,contact.userID,contact.userID];
        
        NSFileManager *fileManager= [NSFileManager defaultManager];
        //NSError *error = nil;
        
        if ([fileManager fileExistsAtPath: tempPath])
        {
            imgprofile.image = [UIImage imageWithContentsOfFile:tempPath];
            //NSLog(@"--Show Profile Image");
        }
        else
        {
            if (contact.fbID != NULL) {
                imgprofile.image = [UIImage imageNamed:@"img_setting_profile_facebook.png"];
                //NSLog(@"--Show Facebook Image");
            } else {
                imgprofile.image = [UIImage imageNamed:@"img_setting_profile.png"];
                //NSLog(@"--Show Default Image");
            }
        }
        
        [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_gray.png"] forState:UIControlStateNormal];
        [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_white.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        btnSelected.tag = 20000;
        [btnSelected addTarget:self action:@selector(btnCheckBoxClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if([contact.ischeckd isEqualToString:@"no"])
        {
            //NSLog(@"-----Unchecking----- %@",contact.firstname);
            viewBlue.alpha = 0.0;
            [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_gray.png"] forState:UIControlStateNormal];
            [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_gray.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        else
        {
            //NSLog(@"-----Checking-----");
            [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_white.png"] forState:UIControlStateNormal];
            [btnSelected setBackgroundImage:[UIImage imageNamed:@"img_tick_white.png"] forState:UIControlStateSelected | UIControlStateHighlighted];
            viewBlue.alpha = 1.0;
        }
        [cell.contentView addSubview:imgprofile];
        [cell.contentView addSubview:btnSelected];
        [cell.contentView addSubview:labelName];
        [cell.contentView addSubview:labelLastName];
        
        //configure right buttons
        MGSwipeButton* rightDelete=[MGSwipeButton buttonWithTitle:@"Delete   " backgroundColor:[UIColor redColor]callback:^BOOL(MGSwipeTableCell *sender) {

            return YES;
        }];
//        if ([self.delegate respondsToSelector: @selector(isContactTableForDive)])
//        {
//            if([self.delegate isContactTableForDive])
//                {
//                    cell.rightButtons = @[rightDelete];
//                    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
//                    return cell;
//                }
//        }
        cell.rightButtons = @[rightDelete];
        cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
        return cell;
        
        cell.rightButtons=nil;
        return cell;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}


#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    [self filterContentForSearchText:searchString scope:nil];
    
    [self.tableView reloadData];
}

#pragma mark - UISearchBarDelegate

// Workaround for bug: -updateSearchResultsForSearchController: is not called when scope buttons change
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
    [self updateSearchResultsForSearchController:self.searchController];
}


#pragma mark - Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    @try{
        if ((searchText == nil) || [searchText.trim length] == 0)
        {
            self.searchResults = [mutablecontacts mutableCopy];
            return;
        }
        [self.searchResults removeAllObjects]; // First clear the filtered array.

        for (Contact *Contact in mutablecontacts)
        {
            NSComparisonResult result = NSOrderedAscending;
            NSComparisonResult result1 = NSOrderedAscending;
            NSComparisonResult result2 = NSOrderedAscending;
            //if ([scope isEqualToString:@"All"] || [Contact.lastname isEqualToString:scope])
            {
                if ([Contact.lastname length] >0) {
                    result = [Contact.lastname compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
                }
                if ([Contact.firstname length] >0) {
                    result1 = [Contact.firstname compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
                }
                if ([Contact.email length] >0) {
                    
                    result2 = [Contact.email compare:searchText options:(NSCaseInsensitiveSearch|NSDiacriticInsensitiveSearch) range:NSMakeRange(0, [searchText length])];
                }
                
                if (result == NSOrderedSame || result1 == NSOrderedSame || result2 == NSOrderedSame)
                {
                    [self.searchResults addObject:Contact];
                }
            }
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception);
    }
}

@end
