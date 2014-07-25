//
//  YTOCalculatorViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
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
#import "YTOReduceriViewController.h"
#import "YTOCustomPopup.h"
#import "YTOUserDefaults.h"

@interface YTOCalculatorViewController ()

@end

@implementation YTOCalculatorViewController

@synthesize DataInceput = _DataInceput;
@synthesize Durata = _Durata;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;
@synthesize listaCompanii;
@synthesize asigurat;
@synthesize isWrongAuto;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i446", [YTOUserDefaults getLanguage],@"Calculator");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // //self.trackedViewName = @"YTOCalculatorViewController";
    [self initCells];
    [self initCustomValues];
    [YTOUtils rightImageVodafone:self.navigationItem];
    lblAlegeCasco.text = NSLocalizedStringFromTable(@"i152", [YTOUserDefaults getLanguage],@"Daca masina are CASCO selecteaza compania");
    lblInfoReduceri.text = NSLocalizedStringFromTable(@"i156", [YTOUserDefaults getLanguage],@"Informatii pentru REDUCERI");
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];

}

-(void) viewDidAppear:(BOOL)animated
{
    isWrongAuto = NO;
    if ([asigurat.tipPersoana isEqualToString:@"fizica"]){
    UILabel *lbl = (UILabel *)[cellPF viewWithTag:1];
    lbl.text = [self setTextInLabel];
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
            return 67;
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
        if ([asigurat.tipPersoana isEqualToString:@"fizica"]){
            cell = cellPF;
            UILabel *lbl = (UILabel *)[cellPF viewWithTag:1];
            lbl.text = [self setTextInLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if ([asigurat.tipPersoana isEqualToString:@"juridica"])
            cell = cellPJ;
        else cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    else if (indexPath.row == 4) cell = cellAsiguratCasco;
    else if (indexPath.row == 5) cell = cellDataInceput;
    else if (indexPath.row == 6) cell = cellCalculeaza;
    
    return cell;
}

- (NSString *) setTextInLabel
{
    NSString *txt = [[NSString alloc] init];
    if (asigurat.nrBugetari.intValue > 0 )
        {
            
            NSString *str;
            if ([asigurat.nrBugetari isEqualToString:@"1"])
                 str = @" bugetar";
            else str = NSLocalizedStringFromTable(@"i578", [YTOUserDefaults getLanguage],@" bugetari");
            txt = [NSString stringWithFormat:@"%@%@%@%@",txt,asigurat.nrBugetari,str,@" | "];
        }
   if ([asigurat.casatorit isEqualToString:@"da"])
        {
            NSString *str = NSLocalizedStringFromTable(@"i576", [YTOUserDefaults getLanguage],@"Casatorit");
            txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
        }
    if ([asigurat.pensionar isEqualToString:@"da"])
        {
            NSString *str = NSLocalizedStringFromTable(@"i577", [YTOUserDefaults getLanguage],@"Pensionar");
            txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
        }
    if ([asigurat.copiiMinori isEqualToString:@"da"])
        {
            NSString *str = NSLocalizedStringFromTable(@"i574", [YTOUserDefaults getLanguage],@"Copii\nminori");
            txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
        }
    if ([asigurat.handicapLocomotor isEqualToString:@"da"])
        {
            NSString *str = NSLocalizedStringFromTable(@"i575", [YTOUserDefaults getLanguage],@"Handicap\nlocomotor");
            txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
        }
    if ([txt isEqualToString:@""]) txt = NSLocalizedStringFromTable(@"i157", [YTOUserDefaults getLanguage],@"alege din lista");
    return txt;
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
        if ((isWrongAuto && masina==nil) || !isWrongAuto){
            if ([appDelegate Masini].count > 0)
            {
                YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
                aView.controller = self;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
            else {
                YTOAutovehiculViewController * aView;
                if (IS_IPHONE_5)
                    aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
                else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
                aView.controller = self;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
        }else if (isWrongAuto && masina !=nil){
            YTOAutovehiculViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
            else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
            aView.controller = self;
            aView.autovehicul = masina;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        // Daca exista persoane salvate, afisam lista
        if ([appDelegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
            else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
            aView.controller = self;
            aView.produsAsigurare = RCA;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.controller = self;
            aView.proprietar = YES;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 3 && ([asigurat.tipPersoana isEqualToString:@"juridica"]))
    {
        [self showCoduriCaen:indexPath];
    }
    else if (indexPath.row == 3 && ([asigurat.tipPersoana isEqualToString:@"fizica"]))
    {
        YTOReduceriViewController *aView ;
        if (IS_IPHONE_5)
            aView = [[YTOReduceriViewController alloc] initWithNibName:@"YTOReduceriViewController_R4" bundle:nil];
        else aView = [[YTOReduceriViewController alloc] initWithNibName:@"YTOReduceriViewController" bundle:nil];
        aView.asigurat = self.asigurat;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
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
            isWrongAuto = YES;
            
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
        if (!asigurat || ![asigurat isValidForCompute])
        {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [UIColor redColor];        
            if (isOK == NO) return;
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
        
        [masina updateAutovehicul:NO];
        [asigurat updatePersoana:NO];
        
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
	
	UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
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
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    img.image = nil;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-rca-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-rca-en.png"];
    else img.image = [UIImage imageNamed:@"asig-rca"];

    
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:verde];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:verde];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:verde];
    
    lbl1.text = NSLocalizedStringFromTable(@"i758", [YTOUserDefaults getLanguage],@"Asigurare RCA");
    lbl2.text = NSLocalizedStringFromTable(@"i759", [YTOUserDefaults getLanguage],@"● Tarife direct de la companii");
    lbl3.text = NSLocalizedStringFromTable(@"i760", [YTOUserDefaults getLanguage],@"● Livrare gratuita prin curier rapid");
        lbl1.adjustsFontSizeToFitWidth = YES;
        lbl2.adjustsFontSizeToFitWidth = YES;
        lbl3.adjustsFontSizeToFitWidth = YES;
    cellHeader.userInteractionEnabled = NO;
    
//    if ([YTOUserDefaults isRedus])
//        lbl3.hidden = YES;
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellMasina = [topLevelObjectsMarca objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = NSLocalizedStringFromTable(@"i147", [YTOUserDefaults getLanguage],@"Alege autovehicul");
    UILabel * lblCell1 = (UILabel *)[cellMasina viewWithTag:6];
    lblCell1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell1.text = NSLocalizedStringFromTable(@"i158", [YTOUserDefaults getLanguage],@"AUTOVEHICUL ASIGURAT");
    
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = NSLocalizedStringFromTable(@"i148", [YTOUserDefaults getLanguage],@"Alege Persoana");
    UILabel * lblCell2 = (UILabel *)[cellProprietar viewWithTag:6];
    lblCell2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell2.text = NSLocalizedStringFromTable(@"i149", [YTOUserDefaults getLanguage],@"PROPRIETAR AUTOVEHICUL (VEZI TALON)");;
    
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i128", [YTOUserDefaults getLanguage],@"Calculeaza");;

    NSArray *topLevelObjectsCodUnic = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodUnic = [topLevelObjectsCodUnic objectAtIndex:0];
    UILabel * lblCellCodUnic = (UILabel *)[cellCodUnic viewWithTag:1];
    lblCellCodUnic.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellCodUnic.text = NSLocalizedStringFromTable(@"i240", [YTOUserDefaults getLanguage],@"Codul numeric personal");;
    
    NSArray *topLevelObjectsCodCaen = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellPJ = [topLevelObjectsCodCaen objectAtIndex:0];
    [(UILabel *)[cellPJ viewWithTag:1] setText:NSLocalizedStringFromTable(@"i259", [YTOUserDefaults getLanguage],@"Cod Caen")];
    [YTOUtils setCellFormularStyle:cellPJ];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = NSLocalizedStringFromTable(@"i127", [YTOUserDefaults getLanguage],@"Data inceput");;
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged]; 
    [YTOUtils setCellFormularStyle:cellDataInceput];
}

- (void) initCustomValues
{
    cautLegaturaDintreMasinaSiAsigurat = YES;
    
    // Incarc proprietarul PF
    YTOPersoana * prop = [YTOPersoana Proprietar];
    // Daca nu exista proprietar PF, incerc sa incarc propriertar PJ
    if (!prop)
        prop  = [YTOPersoana ProprietarPJ];
    
    if (prop)
    {
        [self setAsigurat:prop];
    }
    
    _DataInceput = [YTOUtils getDataMinimaInceperePolita];
    
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
    YTOListaAsiguratiViewController * aView;
    if (IS_IPHONE_5)
        aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
    else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
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
    
    if ([asigurat.tipPersoana isEqualToString:@"fizica"])
    {
        // ?? nu cred ca mai trebuie
        //asigurat.tipPersoana = @"fizica";
        
    }
    else if (asigurat.codUnic.length > 0 && [asigurat.tipPersoana isEqualToString:@"juridica"]) {
        // nu cred ca mai trebuie ??
        //asigurat.tipPersoana = @"juridica";
        if (!asigurat.codCaen || [asigurat.codCaen isKindOfClass:[NSNull class]]) asigurat.codCaen = nil;
        
        if (asigurat.codCaen || asigurat.codCaen.length == 0)
            asigurat.codCaen = @"01";
        
        [self setCodCaen:asigurat.codCaen];
    }
    
    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:masina.idProprietar])
    {
        YTOAutovehicul * _auto = [YTOAutovehicul getAutovehiculByProprietar:a.idIntern];

        if (_auto && _auto.idIntern && [_auto isValidForRCA] && cautLegaturaDintreMasinaSiAsigurat)
        {
            [self setAutovehicul:_auto];
            cautLegaturaDintreMasinaSiAsigurat = NO;
        }
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
    if (masina.idProprietar.length > 0 && ![masina.idProprietar isEqualToString:asigurat.idIntern] && cautLegaturaDintreMasinaSiAsigurat)
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:masina.idProprietar];
        if (prop)
            [self setAsigurat:prop];
        
        cautLegaturaDintreMasinaSiAsigurat = NO;
    }
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
    if (trecutDeOra)
        [comps setDay:stepper.value + 1];
    else
        [comps setDay:stepper.value];
    NSDate *date = [calendar dateByAddingComponents:comps 
                                             toDate:currentDate  
                                            options:0];
    _DataInceput = date;
    [self setDataInceput:date];
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
        
        YTOWebServiceRCAViewController * aView;
        
        if (IS_IPHONE_5)
            aView = [[YTOWebServiceRCAViewController alloc] initWithNibName:@"YTOWebServiceRCAViewController_R4" bundle:nil];
        else
            aView = [[YTOWebServiceRCAViewController alloc] initWithNibName:@"YTOWebServiceRCAViewController" bundle:nil];
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
//        UILabel *lbl = (UILabel *)[cellPF viewWithTag:1];
//        lbl.text = [self setTextInLabel];
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
    self.navigationItem.hidesBackButton = YES;
    
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
        [lblTitle setText:NSLocalizedStringFromTable(@"i530", [YTOUserDefaults getLanguage],@"Alege compania unde ai CASCO")];
        listOfItems = listaCompanii;
        _nomenclatorNrItems = listaCompanii.count;
        if (masina.cascoLa.length > 0)
            selectedItemIndex = [YTOUtils getKeyList:listaCompanii forValue: masina.cascoLa];
        else selectedItemIndex = 9;
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
        [lbl setTextAlignment:NSTextAlignmentCenter];
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
    self.navigationItem.hidesBackButton = NO;
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
            if ([item.value isEqualToString:@"Neasigurat"])
                [self setCompanieCasco:@""];
            else [self setCompanieCasco:item.value];
        }
    }
}

@end
