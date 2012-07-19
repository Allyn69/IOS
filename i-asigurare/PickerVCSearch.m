//
//  PickerVCSearch.m
//  iRCA
//
//  Created by Administrator on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerVCSearch.h"
#import "Database.h"
#import "YTOAutovehiculViewController.h"

@implementation PickerVCSearch

@synthesize tableView, delegate, titlu, listOfItems, _indexPath;
@synthesize nomenclator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //Initialize the array.
//    listOfItems = [[NSMutableArray alloc] init];
//    
//    NSArray *countriesToLiveInArray = [NSArray arrayWithObjects:@"Iceland", @"Greenland", @"Switzerland", @"Norway", @"New Zealand", @"Greece", @"Rome", @"Ireland", nil];
//    NSDictionary *countriesToLiveInDict = [NSDictionary dictionaryWithObject:countriesToLiveInArray forKey:@"Countries"];
//    
//    NSArray *countriesLivedInArray = [NSArray arrayWithObjects:@"India", @"U.S.A", nil];
//    NSDictionary *countriesLivedInDict = [NSDictionary dictionaryWithObject:countriesLivedInArray forKey:@"Countries"];
//    
//    [listOfItems addObject:countriesToLiveInDict];
//    [listOfItems addObject:countriesLivedInDict];
    
    //Initialize the copy array.
    copyListOfItems = [[NSMutableArray alloc] init];
    
    //Set the title
    self.navigationItem.title = @"Countries";
    
    //Add the search bar
    self.tableView.tableHeaderView = searchBar;
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    
    searching = NO;
    letUserSelectRow = YES;
    
    for (UIView *searchBarSubview in [searchBar subviews]) {
        
        if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
            
            @try {
                
                [(UITextField *)searchBarSubview addTarget:self action:@selector(doneSearching_Clicked:) forControlEvents:UIControlStateNormal];
            }
            @catch (NSException * e) {
                
                // ignore exception
            }
        }
    }


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark SEARCHBAR

- (void) searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar {
    
//    //Add the overlay view.
//    if(ovController == nil)
//        ovController = [[OverlayViewControllerPVCSV2 alloc] initWithNibName:@"OverlayViewControllerPVCSV2" bundle:[NSBundle mainBundle]];
//    
//    CGFloat yaxis = navBar.frame.size.height;
//    CGFloat width = self.view.frame.size.width;
//    CGFloat height = self.view.frame.size.height;
//    
//    //Parameters x = origion on x-axis, y = origon on y-axis.
//    CGRect frame = CGRectMake(0, yaxis, width, height);
//    ovController.view.frame = frame;
//    ovController.view.backgroundColor = [UIColor grayColor];
//    ovController.view.alpha = 0.5;
//    
//    ovController.rvController = self;
    
//    [self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
    
    searching = YES;
    letUserSelectRow = NO;
    self.tableView.scrollEnabled = NO;
    
    //Add the done button.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                               target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [copyListOfItems removeAllObjects];
    
    if([searchText length] > 0) {
        
 //       [ovController.view removeFromSuperview];
        searching = YES;
        letUserSelectRow = YES;
        self.tableView.scrollEnabled = YES;
        [self searchTableView];
    }
    else {
        
  //      [self.tableView insertSubview:ovController.view aboveSubview:self.parentViewController.view];
        searching = NO;
        letUserSelectRow = NO;
        self.tableView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
}

- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    
    [self searchTableView];
}

- (void) searchTableView {
    
    NSString *searchText = searchBar.text;
    NSMutableArray *searchArray = [[NSMutableArray alloc] init];
    
    for (NSString *item in listOfItems)
    {
        [searchArray addObject:item];
    }
    
    for (NSString *sTemp in searchArray)
    {
        NSString * t = sTemp;
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copyListOfItems addObject:sTemp];
    }
    
 //   [searchArray release];
    searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    
//    [ovController.view removeFromSuperview];
//    [ovController release];
//    ovController = nil;
    
    [self.tableView reloadData];
}


#pragma mark -

#pragma mark TABLEVIEW

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return indexPath;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (searching)
        return [copyListOfItems count];
    else {
        
        return [listOfItems count];
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    
//    if(searching)
//        return @"";
//    
//    if(section == 0)
//        return @"Countries to visit";
//    else
//        return @"Countries visited";
//}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    // Set up the cell...
    
    if(searching)
        cell.textLabel.text = [copyListOfItems objectAtIndex:indexPath.row];
    else 
    {
        NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
    }
    
    if (nomenclator ==  kJudete)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get the selected country
    
    NSString *selectedValue = nil;
    
    if(searching && ![searchBar.text isEqualToString:@""])
    {
        selectedValue = [copyListOfItems objectAtIndex:indexPath.row];
    }
    else {
        
        selectedValue = [listOfItems objectAtIndex:indexPath.row];
    }
    
//    if (nomenclator ==  kJudete)
//    {
//        PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
//        actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Localitati:selectedValue]];
//        actionPicker._indexPath = indexPath;
//        actionPicker.nomenclator = kLocalitati;
//        actionPicker.delegate = self;
//        actionPicker.titlu = @"Localitati";
//        [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath];
//        [self presentModalViewController:actionPicker animated:YES];         
//    }
//    else if (nomenclator == kLocalitati)
//    {
//        [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath];
//        [self dismissModalViewControllerAnimated:YES];
//    }

    if (nomenclator == kJudete)
    {
        listOfItems = [Database Localitati:selectedValue];
        [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
        [self.tableView reloadData];
        nomenclator = kLocalitati;
        
    }
    else {
        [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
        [self dismissModalViewControllerAnimated:YES];
    }
}

//-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)index
//{
//    [self.delegate chosenIndexAfterSearch:selected rowIndex:_indexPath];
//    [self dismissModalViewControllerAnimated:YES];
//}

- (IBAction) inapoi
{
    if (nomenclator == kLocalitati)
    {
        listOfItems = [Database Judete];
        nomenclator = kJudete;
        [tableView reloadData];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -

@end
