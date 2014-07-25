//
//  PickerVCSearch.m
//  iRCA
//
//  Created by Andi Aparaschivei on 11/16/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "PickerVCSearch.h"
#import "Database.h"
#import "YTOAutovehiculViewController.h"
#import "YTOCasaViewController.h"
#import "KeyValueItem.h"

@implementation PickerVCSearch

@synthesize tableView, delegate, titlu, listOfItems, _indexPath;
@synthesize copListOfItems;
@synthesize nomenclator;
@synthesize listValoriMultipleIndecsi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = titlu;
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
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
    
    navBar.title = titlu;
    
    //Initialize the copy array.
    copListOfItems = [[NSMutableArray alloc] init];

    //Add the search bar
    if (nomenclator == kJudete || nomenclator == kLocalitati || nomenclator == kMarci)
    {
        self.tableView.tableHeaderView = searchBar;
        searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    
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
    searching = YES;
    letUserSelectRow = NO;
    //self.tableView.scrollEnabled = NO;
    
//    CGRect frame = [tableView frame];
//    frame.size.height -= 250.f;
//    [tableView setFrame:frame];
    
    //Add the done button.
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                               initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                               target:self action:@selector(doneSearching_Clicked:)];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneSearching_Clicked:)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText {
    
    //Remove all objects first.
    [copListOfItems removeAllObjects];
    
    if([searchText length] > 0) {        
        searching = YES;
        letUserSelectRow = YES;
        ok = YES;
        [self searchTableView];
    }
    else {
        searching = NO;
        ok = NO;
        letUserSelectRow = NO;
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
        NSRange titleResultsRange = [sTemp rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
            [copListOfItems addObject:sTemp];
    }
    searchArray = nil;
}

- (void) doneSearching_Clicked:(id)sender {
    
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    letUserSelectRow = YES;
    searching = NO;
    self.navigationItem.rightBarButtonItem = nil;
    self.tableView.scrollEnabled = YES;
    [self.tableView reloadData];
}


#pragma mark -

#pragma mark TABLEVIEW

- (NSIndexPath *)tableView :(UITableView *)theTableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return indexPath;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (searching)
        return [copListOfItems count];
    else {
        
        return [listOfItems count];
    }
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    
    // Set up the cell...
    
    if(searching) {
        UIView *searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, 320, 215)];
        self.tableView.tableFooterView = searchView;
    
        if (ok)
            cell.textLabel.text = [copListOfItems objectAtIndex:indexPath.row];
        else
            cell.textLabel.text = [listOfItems objectAtIndex:indexPath.row];
    }
    else if (nomenclator == kCoduriCaen)
    {
        
        KeyValueItem * item = (KeyValueItem *)[listOfItems objectAtIndex:indexPath.row];
        
        cell.textLabel.text = item.value;
        cell.detailTextLabel.text = item.value2;
    }
    else 
    {
        NSString *cellValue = [listOfItems objectAtIndex:indexPath.row];
        cell.textLabel.text = cellValue;
    }
    
    if (nomenclator ==  kJudete)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else if (nomenclator == kMarci)
    {
        cell.imageView.image = [YTOUtils getImageForValue:[NSString stringWithFormat:@"%@.png", cell.textLabel.text]];
    }
    
    if (nomenclator == kDescriereLocuinta)
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        for (int i = 0; i < listValoriMultipleIndecsi.count; i++) {
            
            NSUInteger num = [[listValoriMultipleIndecsi objectAtIndex:i] intValue];
            
            if (num == indexPath.row) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                // Once we find a match there is no point continuing the loop
                break;
            }
        }
    }
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    return cell;
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get the selected country
    
    if (nomenclator == kDescriereLocuinta)
    {
        NSString * esteBifat = @"";
        
        UITableViewCell *thisCell = [tv cellForRowAtIndexPath:indexPath];
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
            
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            //add object in an array
            [listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", indexPath.row]];
            esteBifat = @"da";
        }
        else{
            
            thisCell.accessoryType = UITableViewCellAccessoryNone;
            //remove the object at the index from array
            [listValoriMultipleIndecsi removeObject:[NSString stringWithFormat:@"%d", indexPath.row]];
            esteBifat = @"nu";
        }
        
        YTOCasaViewController * view = (YTOCasaViewController *)self.delegate;
        
        switch (indexPath.row) {
            case 0:
                [view setAlarma:esteBifat];
                break;
            case 1:
                [view setGrilajeGeam:esteBifat];
                break;
            case 2:
                [view setDetectieIncendiu:esteBifat];
                break;
            case 3:
                [view setPaza:esteBifat];
                break;
            case 4:
                [view setZonaIzolata:esteBifat];
                break;
            case 5:
                [view setLocuitPermananet:esteBifat];
                break;
            case 6:
                [view setClauzaFurtBunuri:esteBifat];
                break;
            case 7:
                [view setClauzaApaConducta:esteBifat];
                break;
            case 8:
                [view setTeren:esteBifat];
                break;
            default:
                break;
        }
    }
    else 
    {
        NSString *selectedValue = nil;
        
        if(searching && ![searchBar.text isEqualToString:@""])
        {
            selectedValue = [copListOfItems objectAtIndex:indexPath.row];
        }
        else {
            
            selectedValue = [listOfItems objectAtIndex:indexPath.row];
        }
        
        if (nomenclator == kJudete)
        {
            listOfItems = [Database Localitati:selectedValue];
            navBar.title = [NSString stringWithFormat:@"Localitati %@", selectedValue];
            [searchBar resignFirstResponder];
            judet = selectedValue;
            //[self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
            nomenclator = kLocalitati;
            [self doneSearching_Clicked:nil];
            [tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
            
        }
        else {
            if (nomenclator == kCoduriCaen)
                [self.delegate chosenIndexAfterSearch:((KeyValueItem *)selectedValue).value rowIndex:_indexPath forView:self];
            else if (nomenclator == kLocalitati)
            {
                [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
                nomenclator = kJudete;
                [self.delegate chosenIndexAfterSearch:judet rowIndex:_indexPath forView:self];
            }
            else
                [self.delegate chosenIndexAfterSearch:selectedValue rowIndex:_indexPath forView:self];
            [self dismissModalViewControllerAnimated:YES];
        }
    }
}

- (IBAction) inapoi
{
    if (nomenclator == kLocalitati)
    {
        listOfItems = [Database Judete];
        nomenclator = kJudete;
        navBar.title = @"Judete";
        [tableView reloadData];
    }
    else if (nomenclator == kDescriereLocuinta)
    {
        YTOCasaViewController * parentView = (YTOCasaViewController *)self.delegate;
        parentView.goingBack = YES;
        [self dismissModalViewControllerAnimated:YES];
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark -

@end
