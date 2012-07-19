//
//  YTOListaAutoViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOListaAutoViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOAutovehiculViewController.h"
#import "Database.h"
#import "YTOUtils.h"

@interface YTOListaAutoViewController ()

@end

@implementation YTOListaAutoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Lista masini", @"Lista masini");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    listaMasini = [YTOAutovehicul Masini];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return listaMasini.count;
}

//- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:@"CellView_String"];
//    if (cell == nil) {
//        // Create a temporary UIViewController to instantiate the custom cell.
//        UIViewController *temporaryController = [[UIViewController alloc] initWithNibName:@"CellView_String" bundle:nil];
//        // Grab a pointer to the custom cell.
//        cell = (YTOCellView_String *)temporaryController.view;
//        // Release the temporary UIViewController.
//    }
//    
//    return cell;
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.imageView.image = [UIImage imageNamed:@"person.png"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [((YTOAutovehicul *)[listaMasini objectAtIndex:indexPath.row]).marcaAuto uppercaseString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", ((YTOAutovehicul *)[listaMasini objectAtIndex:indexPath.row]).modelAuto, ((YTOAutovehicul *)[listaMasini objectAtIndex:indexPath.row]).nrInmatriculare];
    
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
    
    YTOAutovehicul * masina = [listaMasini objectAtIndex:indexPath.row];
    //YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
    //aView.asigurat = persoana;
    
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
    [parent setAutovehicul:masina];
    [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
}

- (IBAction)adaugaPersoana:(id)sender
{
    YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
