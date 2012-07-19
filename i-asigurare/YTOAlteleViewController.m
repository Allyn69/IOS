//
//  YTOAlteleViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAlteleViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"

@interface YTOAlteleViewController ()

@end

@implementation YTOAlteleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Altele", @"Altele");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row == 0) {
        cell.textLabel.text = @"PROMOTII";
        cell.detailTextLabel.text = @"ofertele i-Asigurare";
        cell.imageView.image = [UIImage imageNamed:@"promotii.png"];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"VREI SA NE SPUI CEVA?";
        cell.detailTextLabel.text = @"trimite-ne un mesaj";        
        cell.imageView.image = [UIImage imageNamed:@"trimite-mesaj.png"];
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"INTREBARI FRECVENTE";
        cell.detailTextLabel.text = @"totul despre asigurari";    
        cell.imageView.image = [UIImage imageNamed:@"faq.png"];
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = @"COMPANII ASIGURARE";
        cell.detailTextLabel.text = @"date de contact";        
        cell.imageView.image = [UIImage imageNamed:@"contact-companii.png"];        
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = @"VALABILITATE RCA";
        cell.detailTextLabel.text = @"verifica polita ta RCA";        
        cell.imageView.image = [UIImage imageNamed:@"valabilitate-rca.png"];
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = @"TERMENI & CONDITII";
        cell.detailTextLabel.text = @"citeste regulile";        
        cell.imageView.image = [UIImage imageNamed:@"termeni.png"];
    }    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
