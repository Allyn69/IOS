//
//  YTOCalculatorViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOCalculatorViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTONomenclatorViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOListaAutoViewController.h"
#import "YTOUtils.h"
#import "YTOWebServiceRCAViewController.h"
#import "Database.h"
#import "YTOCustomPopup.h"

@interface YTOCalculatorViewController ()

@end

@implementation YTOCalculatorViewController

@synthesize DataInceput = _DataInceput;
@synthesize Durata = _Durata;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;
@synthesize listaCompanii;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calculator", @"Calculator");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCells];
    [self initCustomValues];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return  75;
    else if (indexPath.row == 3)
    {
        if ([asigurat.tipPersoana isEqualToString:@"fizica"])
            return 230;
        else if ([asigurat.tipPersoana isEqualToString:@"juridica"])
            return 67;
        else return 0;
    }
    else if (indexPath.row == 4)
        return 100;
    else if (indexPath.row == 5)
        return 67;
    return 66;
//    else if (indexPath.row == 1 || indexPath.row == 4)
//        return 40;
//    else if (indexPath.row == 2)
//        return 100;
//    return  67;
}
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
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellMasina;
    else if (indexPath.row == 2) cell = cellProprietar;
    else if (indexPath.row == 3) 
    {
        if ([asigurat.tipPersoana isEqualToString:@"fizica"])
            cell = cellPF;
        else if ([asigurat.tipPersoana isEqualToString:@"juridica"])
            cell = cellPJ;
        else cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    else if (indexPath.row == 4) cell = cellAsiguratCasco;
    else if (indexPath.row == 5) cell = cellDataInceput;
    else if (indexPath.row == 6) cell = cellCalculeaza;
    
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

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 1)
    {        
        // Daca exista masini salvate, afisam lista
        if ([YTOAutovehicul Masini].count > 0)
        {
            YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        // Daca exista persoane salvate, afisam lista
        if ([appDelegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView = [[YTOListaAsiguratiViewController alloc] init];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            aView.controller = self;
            aView.proprietar = YES;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 3 && ([asigurat.tipPersoana isEqualToString:@"juridica"]))
    {
        [self showCoduriCaen:indexPath];
    }
    else if (indexPath.row == 6)
    {
        BOOL isOK = YES;
        
        // Daca nu a fost selectata masina sau datele masinii nu sunt complete
        if (!masina || ![masina isValidForRCA])
        {
            UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
        }
        else {
            UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        // Daca nu a fost selectata persoana sau datele persoanei nu sunt complete
        if (!asigurat || asigurat.idIntern.length == 0)
        {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [UIColor redColor];        
            isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        }
        else {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        if (!isOK)
            return;
        
        masina.idProprietar  = asigurat.idIntern;
        [masina updateAutovehicul];
        [asigurat updatePersoana];
        
        [self calculeaza];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
   // UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
   // NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    [self addBarButton];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}
	//btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	//btnDone.enabled = NO;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    //UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    //NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    //[self hideTooltip];
    
    [self deleteBarButton];
}

#pragma Methods
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

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"calculator-rca.png"];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellMasina = [topLevelObjectsMarca objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = @"Alege masina";
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = @"Alege proprietar";
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = @"Calculeaza";

    NSArray *topLevelObjectsCodUnic = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodUnic = [topLevelObjectsCodUnic objectAtIndex:0];
    UILabel * lblCellCodUnic = (UILabel *)[cellCodUnic viewWithTag:1];
    lblCellCodUnic.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellCodUnic.text = @"Cod numeric personal";
    
    NSArray *topLevelObjectsCodCaen = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellPJ = [topLevelObjectsCodCaen objectAtIndex:0];
    [(UILabel *)[cellPJ viewWithTag:1] setText:@"COD CAEN"];
    [YTOUtils setCellFormularStyle:cellPJ];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged]; 
    [YTOUtils setCellFormularStyle:cellDataInceput];
}

- (void) initCustomValues
{
    // Incarc proprietarul PF
    YTOPersoana * prop = [YTOPersoana Proprietar];
    // Daca nu exista proprietar PF, incerc sa incarc propriertar PJ
    if (!prop)
        prop  = [YTOPersoana ProprietarPJ];
    
    if (prop)
    {
        [self setAsigurat:prop];
    }
    
    _DataInceput = [[NSDate date] dateByAddingTimeInterval:86400];
    [self setDataInceput:_DataInceput];
    _Durata = @"6";
}

- (void) showCoduriCaen:(NSIndexPath *)index
{
    //goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database CoduriCaen]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kCoduriCaen;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Coduri Caen";
    [self presentModalViewController:actionPicker animated:YES];
}

-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    [self setCodCaen:selected];
}

- (IBAction)selectPersoana:(id)sender 
{
    YTOListaAsiguratiViewController * aView = [[YTOListaAsiguratiViewController alloc] init];
    aView.controller = self;
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    //    YTONomenclatorViewController * view = [[YTONomenclatorViewController alloc] init];
    //    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    //    [appDelegate.rcaNavigationController pushViewController:view animated:YES];
}

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellProprietar viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];    

    if (a.nume)
        lblCellP.text = a.nume;
    if (a.codUnic && a.judet)
        ((UILabel *)[cellProprietar viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    asigurat = a;
    
    if (asigurat.codUnic.length == 13 && [asigurat.tipPersoana isEqualToString:@"fizica"])
    {
        // ?? nu cred ca mai trebuie
        //asigurat.tipPersoana = @"fizica";
        
        stepperAnMinimPermis.minimumValue = [[YTOUtils getAnMinimPermis:asigurat.codUnic] intValue];
        stepperAnMinimPermis.maximumValue = [YTOUtils getAnCurent];
        
        if (asigurat.dataPermis.length == 0)
        {
            stepperAnMinimPermis.value = [[YTOUtils getAnMinimPermis:asigurat.codUnic] intValue];
            [self setAnPermis:stepperAnMinimPermis.value];
        }
        else
        {
            if (asigurat.dataPermis.length == 4)
                [self setAnPermis:[asigurat.dataPermis intValue]];
            else
                [self setAnPermis:[YTOUtils getAnFromDate:[YTOUtils getDateFromString:asigurat.dataPermis withFormat:@"yyyy-MM-dd"]]];
        }
        
        if (asigurat.nrBugetari.length == 0)
            [self setNrBugetari:0];
        else 
            [self setNrBugetari:[asigurat.nrBugetari intValue]];
        

        if (asigurat.casatorit.length == 0)
            [self setCasatorit:YES];
        else 
            [self setCasatorit:[asigurat.casatorit isEqualToString:@"da"]];
        
        if (asigurat.copiiMinori.length == 0)
            [self setCopiiMinori:NO];
        else 
            [self setCopiiMinori:[asigurat.copiiMinori isEqualToString:@"da"]];
        
        if (asigurat.pensionar.length == 0)
            [self setPensionar:NO];
        else 
            [self setPensionar:[asigurat.pensionar isEqualToString:@"da"]];
        
        if (asigurat.handicapLocomotor.length == 0)
            [self setHandicap:NO];
        else 
            [self setHandicap:[asigurat.handicapLocomotor isEqualToString:@"da"]];
        
    }
    else if (asigurat.codUnic.length > 0 && [asigurat.tipPersoana isEqualToString:@"juridica"]) {
        // nu cred ca mai trebuie ??
        //asigurat.tipPersoana = @"juridica";
        
        if (asigurat.codCaen.length == 0)
            asigurat.codCaen = @"01";
        
        [self setCodCaen:asigurat.codCaen];
    }
    
    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:masina.idProprietar])
    {
        YTOAutovehicul * _auto = [YTOAutovehicul getAutovehiculByProprietar:a.idIntern];

        if (_auto && _auto.idIntern && [_auto isValidForRCA])
            [self setAutovehicul:_auto];
    }
    
    [tableView reloadData];
}
- (void)setAutovehicul:(YTOAutovehicul *)a
{
    //[btnMasina.titleLabel setText:a.marcaAuto];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (a.marcaAuto.length > 0)
    {
        lblCell.text = a.marcaAuto;
        ((UILabel *)[cellMasina viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.modelAuto, a.nrInmatriculare];

        if (a.cascoLa && ![a.cascoLa isEqualToString:@""])
            [self setCompanieCasco:a.cascoLa];
    }
    masina = a;
    [self setCompanieCasco:masina.cascoLa];
    if (masina.idProprietar.length > 0 && ![masina.idProprietar isEqualToString:asigurat.idIntern])
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:masina.idProprietar];
        if (prop)
            [self setAsigurat:prop];
    }
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
   // [btn setSelected:checkboxSelected];
    if (btn.tag  == 1)
        [self setCasatorit:checkboxSelected];
    else if (btn.tag == 2)
        [self setCopiiMinori:checkboxSelected];
    else if (btn.tag == 3)
        [self setPensionar:checkboxSelected];
    else [self setHandicap:checkboxSelected];
}

/*
- (IBAction)chkTipPersoana_Selected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    if (btn.tag == 1)
        [self setPersoanaFizica:YES];
    else
        [self setPersoanaFizica:NO];
}*/

- (IBAction)dateStepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];    
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    // set tomorrow (0: today, -1: yesterday)
    [comps setDay:stepper.value];
    NSDate *date = [calendar dateByAddingComponents:comps 
                                             toDate:currentDate  
                                            options:0];
    _DataInceput = date;
    [self setDataInceput:date];
}

- (IBAction)nrBugetariSepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrBugetari:stepper.value];
}

- (IBAction)anPermisSepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setAnPermis:stepper.value];    
}

- (IBAction)calculeaza
{
    if (asigurat && masina)
    {
        oferta = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        oferta.tipAsigurare = 1;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:masina.idIntern, nil];
        oferta.idAsigurat = asigurat.idIntern;
        oferta.dataInceput = _DataInceput;
        oferta.durataAsigurare = [_Durata intValue];
        
        YTOWebServiceRCAViewController * aView = [[YTOWebServiceRCAViewController alloc] init];
        aView.asigurat = asigurat;
        aView.masina = masina;
        aView.oferta = oferta;
        
        YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma Properties
- (void) setPersoanaFizica:(BOOL)k
{
    UILabel * lblPF = (UILabel *)[cellTipPersoana viewWithTag:2];
    UILabel * lblPJ = (UILabel *)[cellTipPersoana viewWithTag:4];   
    UIImageView * img = (UIImageView *)[cellTipPersoana viewWithTag:5];
    
    if (k)
    {
        img.image = [UIImage imageNamed:@"pf.png"];
        lblPF.textColor = [UIColor whiteColor];
        lblPJ.textColor = [YTOUtils colorFromHexString:@"#758ca1"];
        asigurat.tipPersoana = @"fizica";
    }
    else {
        img.image = [UIImage imageNamed:@"pj.png"];
        lblPJ.textColor = [UIColor whiteColor];
        lblPF.textColor = [YTOUtils colorFromHexString:@"#758ca1"];        
        asigurat.tipPersoana = @"juridica";
    }
}

- (void) setCodCaen:(NSString *)k
{
    asigurat.codCaen = k;
    UILabel * lbl = (UILabel *)[cellPJ viewWithTag:2];
    lbl.text = k;
}

- (void) setDataInceput:(NSDate *)DataInceput
{
    UILabel * lbl = (UILabel *)[cellDataInceput viewWithTag:2];
    lbl.text = [YTOUtils formatDate:DataInceput withFormat:@"dd.MM.yyyy"];
    oferta.dataInceput = DataInceput;
}

- (void) setCasatorit:(BOOL)k
{
    asigurat.casatorit = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellPF viewWithTag:1];
    btn.selected = k;
}
- (BOOL) getCasatorit
{
    return  asigurat.casatorit == @"da";
}

- (void) setCopiiMinori:(BOOL)k
{
    asigurat.copiiMinori = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellPF viewWithTag:2];
    //btn.selected = k;
    //[self checkboxSelected:btn];
    [btn setSelected:k];
}
- (BOOL) getCopiiMinori 
{
    return asigurat.copiiMinori == @"da" ? YES : NO;
}

- (void) setPensionar:(BOOL)k 
{
    asigurat.pensionar = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellPF viewWithTag:3];
    btn.selected = k;   
}
- (BOOL) getPensionar
{
    return asigurat.pensionar == @"da";
}
- (void) setHandicap:(BOOL)k
{
    asigurat.handicapLocomotor = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellPF viewWithTag:4];
    btn.selected = k;    
}
- (BOOL) getHandicap
{
    return asigurat.handicapLocomotor == @"da";
}

- (void) setNrBugetari:(int)k
{
    asigurat.nrBugetari = [NSString stringWithFormat:@"%d", k];
    UILabel * lbl = (UILabel *)[cellPF viewWithTag:5];
    lbl.text = asigurat.nrBugetari;
}

- (void) setAnPermis:(int)k
{
    UILabel * lbl = (UILabel *)[cellPF viewWithTag:6];
    lbl.text = [NSString stringWithFormat:@"%d", k];
    
    NSDate * azi = [NSDate date];
    int anCurent = [YTOUtils getAnFromDate:azi];
    
    // Daca anul in care si-a luat permisul este anul curent, pun luna si ziua de ieri
    // Altfel pun default 1 noiembrie + an
    if (anCurent == k)
    {
        asigurat.dataPermis = [YTOUtils formatDate:[azi dateByAddingTimeInterval: -86400.0] withFormat:@"yyyy-MM-dd"];
    }
    else
    {
        asigurat.dataPermis = [NSString stringWithFormat:@"%d-11-01", k];
    }
}

- (void) setCompanieCasco:(NSString*)v
{
    ((UIButton *)[cellAsiguratCasco   viewWithTag:1]).selected = ((UIButton *)[cellAsiguratCasco viewWithTag:2]).selected =
    ((UIButton *)[cellAsiguratCasco viewWithTag:3]).selected = ((UIButton *)[cellAsiguratCasco viewWithTag:4]).selected = NO;
    
    // Daca compania nu este deja selectata, o selectam
    // altfel o deselectam
    if (![v isEqualToString:@""])
    {
        // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
        if ([v isEqualToString:@"Allianz"])
            ((UIButton *)[cellAsiguratCasco viewWithTag:1]).selected = YES;
        else if ([v isEqualToString:@"Omniasig"])
            ((UIButton *)[cellAsiguratCasco viewWithTag:2]).selected = YES;
        else if ([v isEqualToString:@"Generali"]) {
            ((UILabel *)[cellAsiguratCasco viewWithTag:33]).text = v;
            ((UIButton *)[cellAsiguratCasco viewWithTag:3]).selected = YES;
        }
        else if (v.length > 0) {
            ((UILabel *)[cellAsiguratCasco viewWithTag:33]).text = v;
            ((UIButton *)[cellAsiguratCasco viewWithTag:3]).selected = YES;
        }
        masina.cascoLa = v;
    }
    else
        masina.cascoLa = @"";
}

#pragma vwNomenclator

- (IBAction)checkboxCompanieCascoSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (checkboxSelected == NO)
    {
        [self setCompanieCasco:@""];
        btn.selected = checkboxSelected;
    }
    else if (btn.tag  == 1) {
        [self setCompanieCasco:@"Allianz"];
    }
    else if (btn.tag == 2)
    {
        [self setCompanieCasco:@"Omniasig"];
    }
    else if (btn.tag == 3) {
        if ([((UILabel *)[cellAsiguratCasco viewWithTag:33]).text isEqualToString:@"Generali"])
            [self setCompanieCasco:@"Generali"];
        else
            [self setCompanieCasco:((UILabel *)[cellAsiguratCasco viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kCompaniiAsigurare;
        [self showNomenclator];
    }
}

- (void) showNomenclator
{
    [vwNomenclator setHidden:NO];
    UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    NSMutableArray * listOfItems;
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = -1;
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        listaCompanii = [YTOUtils GETCompaniiAsigurare];
        [lblTitle setText:@"Alege compania unde ai CASCO"];
        listOfItems = listaCompanii;
        _nomenclatorNrItems = listaCompanii.count;
        if (masina.cascoLa.length > 0)
            selectedItemIndex = [YTOUtils getKeyList:listaCompanii forValue: masina.cascoLa];
    }
    
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<listOfItems.count; i++) {
        if (i != 0 && i%3==0)
        {
            rows++;
            cols = 0;
        }
        KeyValueItem * item = (KeyValueItem *)[listOfItems objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"neselectat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selectat-rca.png"] forState:UIControlStateSelected];
        [button addTarget:self
                   action:@selector(btnNomenclator_Clicked:)
         forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        button.clipsToBounds = YES;
        UILabel * lbl = [[UILabel alloc] init];
        if (cols == 0)
        {
            button.frame = CGRectMake(20, rows * 70, 67, 65);
        }
        else if (cols == 1)
        {
            button.frame = CGRectMake(cols*105, rows * 70, 67, 65);
        }
        else
        {
            button.frame = CGRectMake(cols*95, rows * 70, 67, 65);
        }
        lbl.frame = CGRectMake(1, 5, 67, 34);
        lbl.backgroundColor = [UIColor clearColor];
        lbl.numberOfLines = 0;
        [lbl setTextAlignment:UITextAlignmentCenter];
        lbl.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl.font = [UIFont fontWithName:@"Arial" size:12];
        lbl.text = [[item.value stringByReplacingOccurrencesOfString:@"/" withString:@"/ "] stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
        cols++;
        [button addSubview:lbl];
        if (i == selectedItemIndex)
            [button setSelected:YES];
        [scrollView addSubview:button];
    }
    
    float height = [listOfItems count]/3.0;
    [scrollView  setContentSize:CGSizeMake(279, height * 75)];
}

- (IBAction) hideNomenclator
{
    [vwNomenclator setHidden:YES];
}

- (IBAction) btnNomenclator_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    
    [btn setSelected:checkboxSelected];
    
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    for (int i=100; i<=100+_nomenclatorNrItems; i++) {
        
        UIButton * _btn = (UIButton *)[scrollView viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        if (checkboxSelected == NO)
            [self setCompanieCasco:@""];
        else
        {
            KeyValueItem * item = (KeyValueItem *)[listaCompanii objectAtIndex:btn.tag-100];
            [self setCompanieCasco:item.value];
        }
    }
}

@end
