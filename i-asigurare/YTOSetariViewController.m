//
//  YTOSetariViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOSetariViewController.h"

@interface YTOSetariViewController ()

@end

@implementation YTOSetariViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Setari", @"Setari");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellProfilulMeu = [topLevelObjects1 objectAtIndex:0];
    
    NSArray *topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellMasinileMele = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellLocuinteleMele = [topLevelObjects3 objectAtIndex:0];
    
    NSArray *topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAltePersoane = [topLevelObjects4 objectAtIndex:0];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.section == 0)
    {
        cell = cellProfilulMeu;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-profilul-meu.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"PROFILUL MEU";
        ((UILabel *)[cell viewWithTag:3]).text = @"Andreea Carp";
    }
    else if (indexPath.section == 1)
    {
        cell = cellMasinileMele;        
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-masinile-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"MASINILE MELE";
    }
    else if (indexPath.section == 2)
    {
        cell = cellLocuinteleMele;        
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-locuintele-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"LOCUINTELE MELE";        
    }
    else
    {
        cell = cellAltePersoane;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-alte-persoane.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"ALTE PERSOANE";        
    }    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
@end