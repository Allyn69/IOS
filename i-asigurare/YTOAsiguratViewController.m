//
//  YTOAsiguratViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAsiguratViewController.h"
#import "YTOAppDelegate.h"
#import "YTONomenclatorViewController.h"
#import "Database.h"
#import "YTOUtils.h"

@interface YTOAsiguratViewController ()

@end

@implementation YTOAsiguratViewController

@synthesize asigurat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Asigurat", @"Asigurat");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    goingBack = YES;
    
    NSArray *topLevelObjectsNume = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellNume = [topLevelObjectsNume objectAtIndex:0];
    [(UITextField *)[cellNume viewWithTag:1] setText:@"NUME PRENUME"];
    [(UITextField *)[cellNume viewWithTag:2] setPlaceholder:@"Nume si prenume"];
    [YTOUtils setCellFormularStyle:cellNume];
    
    NSArray *topLevelObjectsCodUnic = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric2" owner:self options:nil];
    cellCodUnic = [topLevelObjectsCodUnic objectAtIndex:0];
    [(UILabel *)[cellCodUnic viewWithTag:1] setText:@"COD UNIC"];
    [(UITextField *)[cellCodUnic viewWithTag:2] setPlaceholder:@"Codul numeric personal"];
    [YTOUtils setCellFormularStyle:cellCodUnic];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:@"ADRESA"];
    [(UITextField *)[cellAdresa viewWithTag:2] setPlaceholder:@"Adresa din buletin"];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator2" owner:self options:nil];
    cellJudet = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudet viewWithTag:1] setText:@"JUDET"];
    [YTOUtils setCellFormularStyle:cellJudet];
    
    NSArray *topLevelObjectsLocalitate = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator2" owner:self options:nil];
    cellLocalitate = [topLevelObjectsLocalitate objectAtIndex:0];
    [(UILabel *)[cellLocalitate viewWithTag:1] setText:@"LOCALITATE"];
    [YTOUtils setCellFormularStyle:cellLocalitate];
    
    
    if (!asigurat) {
        asigurat = [[YTOPersoana alloc] initWithGuid:[YTOUtils GenerateUUID]];
    }
    else {
        [self load:asigurat];
    }
    
    [btnCasatorit setBackgroundImage:[UIImage imageNamed:@"neselectat.png"] forState:UIControlStateNormal];
    [btnCasatorit setBackgroundImage:[UIImage imageNamed:@"selectat.png"] forState:UIControlStateSelected];
    [btnCasatorit setBackgroundImage:[UIImage imageNamed:@"selectat.png"] forState:UIControlStateHighlighted];
    btnCasatorit.adjustsImageWhenHighlighted = YES;
    
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    [btn setSelected:checkboxSelected];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self save];
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
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
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
    return 45;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.section == 0) return  cellNume;
    else if (indexPath.section == 1) return cellCodUnic;
    else if (indexPath.section == 2) return cellJudet;
    else if (indexPath.section == 3) return cellLocalitate;
    else if (indexPath.section == 4) return cellAdresa;
    else 
    { 
        cellReduceri.backgroundColor = [UIColor clearColor]; 
        cellReduceri.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        return cellReduceri; 
    }
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
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self doneEditing];
    if (indexPath.section == 2) {
        goingBack = NO;
        PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
        actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
        actionPicker._indexPath = indexPath;
        actionPicker.delegate = self;
        actionPicker.titlu = @"Judete";
        [self presentModalViewController:actionPicker animated:YES];
    }
    else if (indexPath.section == 3) {
        goingBack = NO;        
        PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
        actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Localitati:@"Bucuresti"]];
        actionPicker._indexPath = indexPath;
        actionPicker.delegate = self;
        actionPicker.titlu = @"Localitati";
        [self presentModalViewController:actionPicker animated:YES];        
    }
}

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

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.section == 0 || indexPath.section == 1 || indexPath.section == 4)
    {
        [self addBarButton];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}
	btnDone.enabled = YES;
	activeTextField = textField;
	int loc = textField.tag;
	NSString * locat = [NSString stringWithFormat:@"%d", loc]; 
	
//	for(int k=0; k<[visibleIndices count]; k++)
//	{
//		for(int l=0; l<[(NSMutableArray*)[visibleIndices objectAtIndex:k] count]; l++)
//		{
//			NSString * value = (NSString*)[(NSMutableArray*)[visibleIndices objectAtIndex:k] objectAtIndex:l];
//			if([value isEqualToString:locat])
//			{
//				ip = [NSIndexPath indexPathForRow:l inSection:k];
//			}
//		}
//	}
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(0, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{
    
	if(activeTextField == textField)
	{
		int loc = activeTextField.tag;
		int i = loc/100;
		int j = loc%100;
		//NSDictionary * object = (NSDictionary*)[(NSArray*)[(NSDictionary*)[(NSArray*)[root objectForKey:@"Categories"] objectAtIndex:i] objectForKey:@"Properties"] objectAtIndex:j];
		//if(activeTextField.text!=nil)
            //[values setObject:activeTextField.text forKey:[object objectForKey:@"Name"]];
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	btnDone.enabled = NO;
    //[self emptyCellCache];
	//[self cacheCells];
	//[tableView reloadData];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {

}

- (void) save
{
    if (goingBack)
    {
        asigurat.nume = ((UITextField *)[cellNume viewWithTag:2]).text;
        asigurat.codUnic = ((UITextField *)[cellCodUnic viewWithTag:2]).text;
        asigurat.judet = ((UILabel *)[cellJudet viewWithTag:2]).text;
        asigurat.localitate = ((UILabel *)[cellLocalitate viewWithTag:2]).text;        
        asigurat.adresa = ((UITextField *)[cellAdresa viewWithTag:2]).text;
        
        if (asigurat.nume.length > 0 && asigurat.codUnic.length > 0 && asigurat.judet.length > 0
            && asigurat.localitate.length > 0 && asigurat.adresa.length > 0)
        {
            if (asigurat._isDirty)
                [asigurat updatePersoana:asigurat];
            else
                [asigurat addPersoana:asigurat];
        }
    }
}

- (void) load:(YTOPersoana *)a
{
    ((UITextField *)[cellNume viewWithTag:2]).text = a.nume;
    ((UITextField *)[cellCodUnic viewWithTag:2]).text = a.codUnic;
    ((UILabel *)[cellJudet viewWithTag:2]).text = a.judet;
    ((UILabel *)[cellLocalitate viewWithTag:2]).text = a.localitate;
    ((UITextField *)[cellAdresa viewWithTag:2]).text = a.adresa;
}


-(IBAction) doneEditing
{
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}

- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
}
- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.section == 2) // JUDET
    {
        UILabel * lbl = (UILabel *)[cell viewWithTag:2];
        lbl.text = selected;
        asigurat.judet = selected;
         NSLog(@"SELECTED: %@, index=%d", selected, indexPath.row);   
    }
    else if (indexPath.section == 3) // LOCALITATE
    {
        UILabel * lbl = (UILabel *)[cell viewWithTag:2];
        lbl.text = selected;
        asigurat.localitate = selected;
        NSLog(@"SELECTED: %@, index=%d", selected, indexPath.section); 
    }
    goingBack = YES;
}
@end
