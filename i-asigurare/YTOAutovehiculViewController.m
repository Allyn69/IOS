//
//  YTOAutovehiculViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAutovehiculViewController.h"
#import "YTOAppDelegate.h"
#import "Database.h"
#import "YTOUtils.h"
#import "KeyValueItem.h"

@interface YTOAutovehiculViewController ()

@end

@implementation YTOAutovehiculViewController

@synthesize autovehicul;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Masina", @"Masina");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    goingBack = YES;
    [self initCells];
    [self loadCategorii];
    [self loadTipCombustibil];
    [self loadDestinatieAuto];
       
    if (!autovehicul) {
        autovehicul = [[YTOAutovehicul alloc] initWithGuid:[YTOUtils GenerateUUID]];
    }
    else {
        [self load:autovehicul];
    }

}

- (void) viewWillDisappear:(BOOL)animated
{
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 10;
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
    return 67;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (indexPath.row == 0) cell = cellMarca;
    else if (indexPath.row == 1) cell = cellModelNrInmatriculare;
    else if (indexPath.row == 2) cell =  cellJudetLocalitate;
    else if (indexPath.row == 3) cell = cellSubcategorieAuto;
    else if (indexPath.row == 4) cell = cellSerieSasiuCiv;
    else if (indexPath.row == 5) cell = cellCm3Putere;
    else if (indexPath.row == 6) cell = cellNrLocuriMasaMaxima;
    else if (indexPath.row == 7) cell = cellAnFabricatie;
    else if (indexPath.row == 8) cell = cellDestinatieAuto;
    else  cell = cellCombustibil;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 66);  
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];  
        [cell addSubview:bgColor];  
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#e6e6e6"];
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
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self doneEditing];
    if (indexPath.row == 0) {
        [self showListaMarciAuto:indexPath];
    }    
    else if (indexPath.row == 2) {
        [self showListaJudete:indexPath];
    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.row == 0) {
        [self doneEditing];
        [self showListaMarciAuto:indexPath];
    }    
    else if (indexPath.row == 2) {
        [self doneEditing];
        [self showListaJudete:indexPath];
    }
    else if (indexPath.row == 3)
    {
        [self doneEditing];
        [self showListaCategoriiAuto];
    }
    else if (indexPath.row == 8)
    {
        [self doneEditing];
        [self showListaDestinatieAuto:indexPath];        
    }
    else if (indexPath.row == 9)
    {
        [self doneEditing];
        [self showListaTipCombustibil:indexPath];
    }
    else
    {
        UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        UITextField * txt = (UITextField *)[cell viewWithTag:2];
        activeTextField = txt;
        [txt becomeFirstResponder];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row != 0 || indexPath.row != 2)
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
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	btnDone.enabled = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
}

- (void) save
{
    if (goingBack)
    {
//        asigurat.nume = ((UITextField *)[cellNume viewWithTag:2]).text;
//        asigurat.codUnic = ((UITextField *)[cellCodUnic viewWithTag:2]).text;
//        asigurat.judet = ((UILabel *)[cellJudet viewWithTag:2]).text;
//        asigurat.localitate = ((UILabel *)[cellLocalitate viewWithTag:2]).text;        
//        asigurat.adresa = ((UITextField *)[cellAdresa viewWithTag:2]).text;
//        
//        if (asigurat.nume.length > 0 && asigurat.codUnic.length > 0 && asigurat.judet.length > 0
//            && asigurat.localitate.length > 0 && asigurat.adresa.length > 0)
//        {
//            if (asigurat._isDirty)
//                [asigurat updatePersoana:asigurat];
//            else
//                [asigurat addPersoana:asigurat];
//        }
    }
}

- (void) load:(YTOAutovehicul *)a
{
//    ((UITextField *)[cellNume viewWithTag:2]).text = a.nume;
//    ((UITextField *)[cellCodUnic viewWithTag:2]).text = a.codUnic;
//    ((UILabel *)[cellJudet viewWithTag:2]).text = a.judet;
//    ((UILabel *)[cellLocalitate viewWithTag:2]).text = a.localitate;
//    ((UITextField *)[cellAdresa viewWithTag:2]).text = a.adresa;
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

#pragma YTO Nomenclator
-(void)nomenclatorChosen:(KeyValueItem *)item rowIndex:(NSIndexPath *)index forView:(YTONomenclatorViewController *)view
{
    if (view.nomenclator == kCategoriiAuto)
    {
        [self setCategorieAuto:item.parentKey];
        [self setSubcategorieAuto:item.value];
    }
    else if (view.nomenclator == kTipCombustibil)
    {
        [self setTipCombustibil:item.value];
    }
    else if (view.nomenclator == kDestinatieAuto)
    {
        [self setDestinatieAuto:item.value];
    }
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    
    if (indexPath.row == 0) // MARCA
    {
        [self setMarca:selected];
    }
    if (indexPath.row == 2) // JUDET + LOCALITATE
    {
        if (vwSearch.nomenclator == kJudete) {
            [self setJudet:selected];
        }
        else { 
            [self setLocalitate:selected];
        }
    }
    goingBack = YES;
}

- (void) initCells {
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE AUTOVEHICUL"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];

    NSArray *topLevelObjectsSubcategorie = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellSubcategorieAuto = [topLevelObjectsSubcategorie objectAtIndex:0];
    [(UILabel *)[cellSubcategorieAuto viewWithTag:1] setText:@"CATEGORIE AUTOVEHICUL"];
    [YTOUtils setCellFormularStyle:cellSubcategorieAuto];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellMarca = [topLevelObjectsMarca objectAtIndex:0];
    [(UILabel *)[cellMarca viewWithTag:1] setText:@"MARCA AUTO"];
    [YTOUtils setCellFormularStyle:cellMarca];
    
    NSArray *topLevelObjectsModel = [[NSBundle mainBundle] loadNibNamed:@"CellView_StringDouble" owner:self options:nil];
    cellModelNrInmatriculare = [topLevelObjectsModel objectAtIndex:0];
    [(UILabel *)[cellModelNrInmatriculare viewWithTag:1] setText:@"MODEL AUTO"];
    [(UITextField *)[cellModelNrInmatriculare viewWithTag:2] setPlaceholder:@"ex. Logan/Clio, etc."];
    [(UILabel *)[cellModelNrInmatriculare viewWithTag:3] setText:@"NUMAR INMATRICULARE"];
    [(UITextField *)[cellModelNrInmatriculare viewWithTag:4] setPlaceholder:@"ex. B01ABC"];
    [YTOUtils setCellFormularStyle:cellModelNrInmatriculare];
    
    NSArray *topLevelObjectsSasiu = [[NSBundle mainBundle] loadNibNamed:@"CellView_StringDouble" owner:self options:nil];
    cellSerieSasiuCiv = [topLevelObjectsSasiu objectAtIndex:0];
    [(UILabel *)[cellSerieSasiuCiv viewWithTag:1] setText:@"SERIE SASIU"];
    [(UITextField *)[cellSerieSasiuCiv viewWithTag:2] setPlaceholder:@"poz. Y"];
    [(UILabel *)[cellSerieSasiuCiv viewWithTag:3] setText:@"SERIE TALON"];
    [(UITextField *)[cellSerieSasiuCiv viewWithTag:4] setPlaceholder:@"poz. X"];    
    [YTOUtils setCellFormularStyle:cellSerieSasiuCiv]; 
    
    NSArray *topLevelObjectsCm3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_StringDouble" owner:self options:nil];
    cellCm3Putere = [topLevelObjectsCm3 objectAtIndex:0];
    [(UILabel *)[cellCm3Putere viewWithTag:1] setText:@"CM3"];
    [(UITextField *)[cellCm3Putere viewWithTag:2] setPlaceholder:@"ex.1590"];
    [(UILabel *)[cellCm3Putere viewWithTag:3] setText:@"PUTERE(kW)"];
    [(UITextField *)[cellCm3Putere viewWithTag:4] setPlaceholder:@"ex.67"];    
    [YTOUtils setCellFormularStyle:cellCm3Putere];
    
    NSArray *topLevelObjectsNrLocuri = [[NSBundle mainBundle] loadNibNamed:@"CellView_StringDouble" owner:self options:nil];
    cellNrLocuriMasaMaxima = [topLevelObjectsNrLocuri objectAtIndex:0];
    [(UILabel *)[cellNrLocuriMasaMaxima viewWithTag:1] setText:@"NUMAR LOCURI"];
    [(UITextField *)[cellNrLocuriMasaMaxima viewWithTag:2] setPlaceholder:@"ex. 5"];
    [(UILabel *)[cellNrLocuriMasaMaxima viewWithTag:3] setText:@"MASA MAXIMA"];
    [(UITextField *)[cellNrLocuriMasaMaxima viewWithTag:4] setPlaceholder:@"ex. 1670"];
    [YTOUtils setCellFormularStyle:cellNrLocuriMasaMaxima];
    
    NSArray *topLevelObjectsAnFabr = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellAnFabricatie = [topLevelObjectsAnFabr objectAtIndex:0];
    [(UILabel *)[cellAnFabricatie viewWithTag:1] setText:@"AN FABRICATIE"];
    [(UITextField *)[cellAnFabricatie viewWithTag:2] setPlaceholder:@""];
    [YTOUtils setCellFormularStyle:cellAnFabricatie];     
    
    NSArray *topLevelObjectsDestinatie = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellDestinatieAuto = [topLevelObjectsDestinatie objectAtIndex:0];
    [(UILabel *)[cellDestinatieAuto viewWithTag:1] setText:@"DESTINATIE AUTO"];
    [YTOUtils setCellFormularStyle:cellDestinatieAuto];    
    
    NSArray *topLevelObjectsCombustibil = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellCombustibil = [topLevelObjectsCombustibil objectAtIndex:0];
    [(UILabel *)[cellCombustibil viewWithTag:1] setText:@"COMBUSTIBIL"];
    [YTOUtils setCellFormularStyle:cellCombustibil];
}

- (void) showListaMarciAuto:(NSIndexPath *)index;
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database MarciAuto]];
    actionPicker._indexPath = index;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Marci Auto";
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) showListaJudete:(NSIndexPath *)index;
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) showListaCategoriiAuto
{
    goingBack = NO;
    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
    actionPicker.listOfItems = categoriiAuto;
    //actionPicker._indexPath = index;
    actionPicker.nomenclator = kCategoriiAuto;
    actionPicker.delegate = self;
    //actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];    
}

- (void) showListaDestinatieAuto:(NSIndexPath *)index
{
    goingBack = NO;
    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
    actionPicker.listOfItems = destinatiiAuto;
    //actionPicker._indexPath = index;
    actionPicker.nomenclator = kDestinatieAuto;
    actionPicker.delegate = self;
    //actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES]; 
}

- (void) showListaTipCombustibil:(NSIndexPath *)index
{
    goingBack = NO;
    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
    actionPicker.listOfItems = tipCombustibil;
    //actionPicker._indexPath = index;
    actionPicker.nomenclator = kTipCombustibil;
    actionPicker.delegate = self;
    //actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) loadCategorii {
    //---ATENTIE---
    // Daca modifici aici vreun id, trebuie sa modifici si in AppDelegate
    // in application didFinishLaunchingWithOptions
    
    // 1 => Autoturism/Automobil-mixt
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"Autoturism";
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"Automobil-mixt";
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"Autoturism-de-teren";
    
    // 7 => Motocicleta
    KeyValueItem * c14 = [[KeyValueItem alloc] init];
    c14.parentKey = 7;
    c14.key = 3;
    c14.value = @"Motocicleta";
    KeyValueItem * c15 = [[KeyValueItem alloc] init];
    c15.parentKey = 7;
    c15.key = 4;
    c15.value = @"Moped";    
    KeyValueItem * c16 = [[KeyValueItem alloc] init];
    c16.parentKey = 7;
    c16.key = 5;
    c16.value = @"Atas";        
    KeyValueItem * c18 = [[KeyValueItem alloc] init];
    c18.parentKey = 7;
    c18.key = 7;
    c18.value = @"Scuter";        
    KeyValueItem * c19 = [[KeyValueItem alloc] init];
    c19.parentKey = 7;
    c19.key = 8;
    c19.value = @"ATV"; 
    
    // 2 => Autosanitara/Autorulota
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 2;
    c4.key = 9;
    c4.value = @"Autosanitara";
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 2;
    c5.key = 10;
    c5.value = @"Autorulota";
    
    // 3 => Autovehicul transport persoane
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 3;
    c6.key = 11;
    c6.value = @"Microbuz";
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 3;
    c7.key = 12;
    c7.value = @"Autobuz";
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 3;
    c8.key = 13;
    c8.value = @"Autocar";
    
    // 4 => Autovehicul transport marfa
    KeyValueItem * c9 = [[KeyValueItem alloc] init];
    c9.parentKey = 4;
    c9.key = 14;
    c9.value = @"Autoutilitara";
    KeyValueItem * c10 = [[KeyValueItem alloc] init];
    c10.parentKey = 4;
    c10.key = 15;
    c10.value = @"Autofurgon";
    KeyValueItem * c11 = [[KeyValueItem alloc] init];
    c11.parentKey = 4;
    c11.key = 16;
    c11.value = @"Autocamion";
    KeyValueItem * c20 = [[KeyValueItem alloc] init];
    c20.parentKey = 4;
    c20.key = 19;
    c20.value = @"Camion";
    
    // 5 => Autotractor
    KeyValueItem * c12 = [[KeyValueItem alloc] init];
    c12.parentKey = 5;
    c12.key = 17;
    c12.value = @"Autotractor";
    
    // 6 => Tractor-rutier
    KeyValueItem * c13 = [[KeyValueItem alloc] init];
    c13.parentKey = 6;
    c13.key = 18;
    c13.value = @"Tractor-rutier";
    
    // 8 => Remorca
    KeyValueItem * c21 = [[KeyValueItem alloc] init];
    c21.parentKey = 8;
    c21.key = 20;
    c21.value = @"Remorca";
    KeyValueItem * c22 = [[KeyValueItem alloc] init];
    c22.parentKey = 8;
    c22.key = 21;
    c22.value = @"Semiremorca";
    
    categoriiAuto = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c14,c15,c16,c18,c19,c4,c5,c6,c7,c8,c9,c10,c11,c20,c12,c13,c21,c22, nil];
}

- (void) loadTipCombustibil
{
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"benzina";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"motorina";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"gpl";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"electric/hibrid";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"fara";
    
    tipCombustibil = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5, nil];
}

- (void) loadDestinatieAuto
{
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"interes-personal";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"distributie-marfa";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"transport-persoane";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"transport-international";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"paza-protectie-interventie";
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 5;
    c6.value = @"taxi";
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 6;
    c7.value = @"maxi-taxi";
    
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 1;
    c8.key = 7;
    c8.value = @"scoala-soferi";
    
    KeyValueItem * c9 = [[KeyValueItem alloc] init];
    c9.parentKey = 1;
    c9.key = 8;
    c9.value = @"inchiriere";
    
    KeyValueItem * c10 = [[KeyValueItem alloc] init];
    c10.parentKey = 1;
    c10.key = 9;
    c10.value = @"curierat";
    
    KeyValueItem * c11 = [[KeyValueItem alloc] init];
    c11.parentKey = 1;
    c11.key = 10;
    c11.value = @"alte-activitati";
 
    destinatiiAuto = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11, nil];
}

#pragma Proprietati

- (NSString *) getJudet
{
    return autovehicul.judet;
}
- (void) setJudet:(NSString *)judet
{
    autovehicul.judet = judet;
}

- (NSString *) getLocalitate
{
    return autovehicul.localitate;    
}
- (void) setLocalitate:(NSString *)localitate
{
    autovehicul.localitate = localitate;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
}

- (NSString *) getLocatie
{
    return [NSString stringWithFormat:@"%@, %@", [self getJudet], [self getLocalitate]];
}

- (NSString *) getMarca
{
    return autovehicul.marcaAuto;
}
- (void) setMarca:(NSString *)marca
{
    UILabel * lbl = (UILabel *)[cellMarca viewWithTag:2];
    lbl.text = marca;
    autovehicul.marcaAuto = marca;
}

- (NSString *) getModel
{
    return autovehicul.modelAuto;
}
- (void) setModel:(NSString *)model
{
    UITextField * txt = (UITextField *)[cellModelNrInmatriculare viewWithTag:2];
    txt.text = model;
    autovehicul.modelAuto = model;    
}

- (NSString *) getNrInmatriculare
{
    return autovehicul.nrInmatriculare;
}
- (void) setNrInmatriculare:(NSString *)numar
{
    UITextField * txt = (UITextField *)[cellModelNrInmatriculare viewWithTag:4];
    txt.text = numar;
    autovehicul.nrInmatriculare = numar;
}

- (NSString *) getSerieSasiu
{
    return autovehicul.serieSasiu;
}
- (void) setSerieSasiu:(NSString *)serie
{
    UITextField * txt = (UITextField *)[cellSerieSasiuCiv viewWithTag:2];
    txt.text = serie;
    autovehicul.serieSasiu = serie;    
}

- (NSString *) getSerieCIV
{
    return autovehicul.serieCiv;
}
- (void) setSerieCIV:(NSString *)serie
{
    UITextField * txt = (UITextField *)[cellSerieSasiuCiv viewWithTag:4];
    txt.text = serie;
    autovehicul.serieSasiu = serie;    
}

- (int) getNrLocuri
{
    return autovehicul.nrLocuri;
}
- (void) setNrLocuri:(int)numar
{
    UITextField * txt = (UITextField *)[cellNrLocuriMasaMaxima viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", numar];
    autovehicul.nrLocuri = numar;        
}

- (int) getMasaMaxima
{
    return autovehicul.masaMaxima;
}
- (void) setMasaMaxima:(int)masa
{
    UITextField * txt = (UITextField *)[cellSerieSasiuCiv viewWithTag:4];
    txt.text = [NSString stringWithFormat:@"%d", masa];
    autovehicul.masaMaxima = masa;            
}
     
- (int) getCategorieAuto
{
    return autovehicul.categorieAuto;
}
- (void) setCategorieAuto:(int)categorie
{
    autovehicul.categorieAuto = categorie;
}

- (NSString *) getSubcategorieAuto
{
    return autovehicul.subcategorieAuto;
}
- (void) setSubcategorieAuto:(NSString *)subcategorie
{
    UILabel * lbl = (UILabel *)[cellSubcategorieAuto viewWithTag:2];
    lbl.text = subcategorie;
    autovehicul.subcategorieAuto = subcategorie;
}
         
- (NSString *) getTipCombustibil
{
    return autovehicul.combustibil;
}
- (void) setTipCombustibil:(NSString *)s
{
    UILabel * txt = (UILabel *)[cellCombustibil viewWithTag:2];
    txt.text = s;
    autovehicul.combustibil = s; 
}

- (NSString *) getDestinatieAuto
{
    return autovehicul.destinatieAuto;
}
- (void) setDestinatieAuto:(NSString *)s
{
    UILabel * txt = (UILabel *)[cellDestinatieAuto viewWithTag:2];
    txt.text = s;
    autovehicul.destinatieAuto = s;     
}
@end
