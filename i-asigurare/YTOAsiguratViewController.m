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
#import "YTOCalculatorViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOSetariViewController.h"

@interface YTOAsiguratViewController ()

@end

@implementation YTOAsiguratViewController

@synthesize asigurat, controller, proprietar, persoanaFizica;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Persoana", @"Persoana");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    goingBack = YES;
    persoanaFizica = YES;
    
    [self initCells];
    [self initLabels:persoanaFizica];
    
    // Verific daca view-ul este pentru contul meu
    if (proprietar)
    {
        asigurat = [YTOPersoana Proprietar];
    }
    // Daca exista proprietar, incarc, altfel caut si in proprietar pj
    if (proprietar && !asigurat)
    {
        asigurat = [YTOPersoana ProprietarPJ];
    }
    
    if (!asigurat) {
        asigurat = [[YTOPersoana alloc] initWithGuid:[YTOUtils GenerateUUID]];
        // set default values
        asigurat.tipPersoana = @"fizica";
        asigurat.casatorit = @"da";
        asigurat.copiiMinori = @"nu";
        asigurat.pensionar = @"nu";
        asigurat.handicapLocomotor = @"nu";
        asigurat.proprietar = (proprietar ? @"da" : @"nu");
        asigurat.nrBugetari = 0;
        // .. do to
    }
    else {
        if ([asigurat.tipPersoana isEqualToString:@"juridica"])
        {
            // Simulez click-ul pe PJ, dupa care se face load:asigurat din btnTipPersoana_OnClick
            UIButton * btn = (UIButton *)[cellTipPersoana viewWithTag:2];
            [self btnTipPersoana_OnClick:btn];
        }
        else
            [self load:asigurat];
    }    
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    [btn setSelected:checkboxSelected];
}

- (IBAction)btnTipPersoana_OnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL estePF = btn.tag == 1;
    
    UILabel *lblDespreMine = (UILabel *)[cellTipPersoana viewWithTag:3];
    UILabel *lblFirmaMea = (UILabel *)[cellTipPersoana viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellTipPersoana viewWithTag:5];
    
    if (!estePF)
    {
        persoanaFizica = NO;
        lblDespreMine.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblFirmaMea.textColor = [UIColor whiteColor];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pj.png"] : [UIImage imageNamed:@"persoana-pj.png"];
    }
    else
    {
        persoanaFizica = YES;
        lblDespreMine.textColor = [UIColor whiteColor];
        lblFirmaMea.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pf.png"] : [UIImage imageNamed:@"persoana-pf.png"];
    }
    
    
    [self initLabels:persoanaFizica];
    
    [self salveazaPersoana];
    
    // incarc
    if (proprietar)
    {
        NSString * telefon = asigurat.telefon;
        NSString * email = asigurat.email;
        if (!persoanaFizica) {
            asigurat = [YTOPersoana ProprietarPJ];
        }
        else
            asigurat = [YTOPersoana Proprietar];
        
        // Daca nu exista proprietar PF sau PJ, initializez..
        if (!asigurat)
        {
            asigurat = [[YTOPersoana alloc] initWithGuid:[YTOUtils GenerateUUID]];
            asigurat.tipPersoana = persoanaFizica ? @"fizica" : @"juridica";
            asigurat.proprietar = @"da";
        }
        
        if (asigurat.telefon.length == 0 && telefon.length > 0)
            asigurat.telefon = telefon;
        if (asigurat.email.length == 0 && email.length > 0)
            asigurat.email = email;
    }
    [self load:asigurat];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self doneEditing];
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
    if (proprietar)
        return 9;
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 78;
    else if (indexPath.row == 1)
        return 30;
    return 60;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellAsigurat;
    else if (indexPath.row == 1) cell = cellTipPersoana;
    else if (indexPath.row == 2) cell = cellNume;
    else if (indexPath.row == 3) cell = cellCodUnic;
    else if (indexPath.row == 4) cell = cellJudetLocalitate;
    else if (indexPath.row == 5) cell = cellAdresa;
    else if ((indexPath.row == 6 || indexPath.row == 7) && proprietar)
    {
        if (indexPath.row == 6) cell = cellTelefon;
        else if (indexPath.row == 7) cell = cellEmail;
        else cell = cellSC;
    }
    else cell = cellSC;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);  
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];  
        [cell addSubview:bgColor];  
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self doneEditing];
    if (indexPath.row == 3) {
       [self showListaJudete:indexPath];
    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];    
    
    if (indexPath.row == 4) {
        [self showListaJudete:indexPath];
    }
    else
    {
        UITableViewCell * cell = [tv cellForRowAtIndexPath:indexPath];
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
    
    if (indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 5 || (proprietar && (indexPath.row == 6 || indexPath.row == 7)))
    {
        [self addBarButton];
    }
    
    if (indexPath.row == 2)
    {
        NSString * txt = @"Completeaza numele si prenumele.";
        if (!persoanaFizica)
            txt = @"Completeaza denumirea firmei.";
        [self showTooltip:txt];
    }
    else if (indexPath.row == 3)
    {
        NSString * txt = @"Codul numeric personal";
        if (!persoanaFizica)
            txt = @"Codul unic de identificare";
        [self showTooltip:txt];
    }
    else if (indexPath.row == 5)
    {
        NSString * txt = @"Adresa completa din buletin";
        if (!persoanaFizica)
            txt = @"Sediul social al firmei";
        [self showTooltip:txt];
    }
 
    if (proprietar)
    {
        if (indexPath.row == 6)
            [self showTooltip:@"Numarul tau de telefon la care poti fi contactat."];
        else if (indexPath.row == 7)
            [self showTooltip:@"Adresa de email pentru corespondenta (comenzi efectuate, polite de asigurare, alerte)"];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
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
    [self hideTooltip];

    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row == 2)
        [self setNume:textField.text];
    else if (indexPath.row == 3)
        [self setcodUnic:textField.text];
    else if (indexPath.row == 5)
        [self setAdresa:textField.text];
    
    if (proprietar)
    {
        if (indexPath.row == 6)
            [self setTelefon:textField.text];
        else if (indexPath.row == 7)
            [self setEmail:textField.text];
    }
}

- (void) save
{
    if (goingBack)
    {
        
        if (asigurat.codUnic.length == 13)
            asigurat.tipPersoana = @"fizica";
        else if (asigurat.codUnic.length > 0 && asigurat.codUnic.length < 10)
            asigurat.tipPersoana = @"juridica";
        
        [self salveazaPersoana];
    
    }
}

- (void) salveazaPersoana
{
    if (asigurat.nume.length == 0 && asigurat.codUnic.length == 0 && asigurat.judet.length == 0 && asigurat.localitate.length == 0 && asigurat.adresa.length == 0)
    {
        // daca nu a completat nimic, nu salvam
    }
    else if (asigurat._isDirty)
        [asigurat updatePersoana];
    else
    {
        [asigurat addPersoana];
    }
}

- (void) btnSave_Clicked
{
    [self doneEditing];
    [self save];
    
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        [parent setAsigurat:asigurat];
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOListaAsiguratiViewController class]])
    {
        YTOListaAsiguratiViewController * parent = (YTOListaAsiguratiViewController *)self.controller;
        [parent reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) btnCancel_Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) load:(YTOPersoana *)a
{
//    if ([a.tipPersoana isEqualToString:@"juridica"])
//    {
//        UIButton * btn = (UIButton *)[cellTipPersoana viewWithTag:2];
//        [self btnTipPersoana_OnClick:btn];
//    }
    
    [self setNume:a.nume];
    [self setcodUnic:a.codUnic];
    [self setJudet:a.judet];
    [self setLocalitate:a.localitate];
    [self setAdresa:a.adresa];
    
    if ([a.proprietar isEqualToString:@"da"])
    {
        [self setEmail:a.email];
        [self setTelefon:a.telefon];
    }
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
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {

    NSLog(@"%d", indexPath.row);
    if (indexPath.row == 4) // JUDET + LOCALITATE
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

- (void) initCells
{
    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellPersoanaHeader" owner:self options:nil];
    cellAsigurat = [topLevelObjectsHeader objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellAsigurat];
    UILabel *lblDespreMine = (UILabel *)[cellTipPersoana viewWithTag:3];
    UILabel *lblFirmaMea = (UILabel *)[cellTipPersoana viewWithTag:4];
    UIImageView * imgTipPersoana = (UIImageView *)[cellTipPersoana viewWithTag:5];
    lblDespreMine.textColor = [UIColor whiteColor];
    lblFirmaMea.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (proprietar)
    {
        UIImageView * imgTextHeader = (UIImageView *)[cellAsigurat viewWithTag:4];
        imgTextHeader.image = [UIImage imageNamed:@"text-header-profil.png"];
        //UIButton * btn = (UIButton *)[cellAsigurat viewWithTag:5];
        //[btn setBackgroundImage:[UIImage imageNamed:@"icon-foto-person-profil.png"] forState:UIControlStateNormal];
        lblDespreMine.text = @"Despre mine";
        lblFirmaMea.text = @"Firma mea";
        imgTipPersoana.image = [UIImage imageNamed:@"profil-pf.png"];
    }
    else
    {
        //UIButton * btn = (UIButton *)[cellAsigurat viewWithTag:5];
        //[btn setBackgroundImage:[UIImage imageNamed:@"icon-foto-person.png"] forState:UIControlStateNormal];
        lblDespreMine.text = @"Persoana fizica";
        lblFirmaMea.text = @"Persoana juridica";
        imgTipPersoana.image = [UIImage imageNamed:@"persoana-pf.png"];
    }
    
    NSArray *topLevelObjectsNume = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellNume = [topLevelObjectsNume objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellNume];
    
    NSArray *topLevelObjectsCodUnic = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodUnic = [topLevelObjectsCodUnic objectAtIndex:0];
    [(UITextField *)[cellCodUnic viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellCodUnic];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];    
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];        
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];   
    
    if (proprietar)
    {
        NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
        cellEmail = [topLevelObjectsEmail objectAtIndex:0];
        [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL"];
        [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
        [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
        [(UITextField *)[cellEmail viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [YTOUtils setCellFormularStyle:cellEmail];
        
        NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
        cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
        [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON"];
        [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
        [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
        [YTOUtils setCellFormularStyle:cellTelefon];
    }
}

- (void) initLabels:(BOOL )pf
{
    if (pf)
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:@"NUME PRENUME"];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:@"CNP"];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:@"ADRESA"];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE"];
    }
    else
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:@"DENUMIRE"];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:@"CUI"];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:@"ADRESA"];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE"];
    }
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

#pragma Proprietati
- (void) setNume:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellNume viewWithTag:2];
    txt.text = v;
    asigurat.nume = v;
}
- (void) setcodUnic:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellCodUnic viewWithTag:2];
    txt.text = v;    
    asigurat.codUnic = v;
}
- (void) setJudet:(NSString *)v
{
    asigurat.judet = v;
}
- (NSString *) getJudet
{
    return asigurat.judet;
}
- (void) setLocalitate:(NSString *)v
{
    asigurat.localitate = v;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
}
- (NSString *) getLocalitate
{
    return asigurat.localitate;    
}
- (NSString *) getLocatie
{
    if ([self getJudet].length == 0 && [self getLocalitate].length ==0)
        return @"";
    return [NSString stringWithFormat:@"%@, %@", [self getJudet], [self getLocalitate]];
}

- (void) setAdresa:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellAdresa viewWithTag:2];
    txt.text = v;
    asigurat.adresa = v;
}

- (void) setTelefon:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellTelefon viewWithTag:2];
    txt.text = v;
    asigurat.telefon = v;
}

- (void) setEmail:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellEmail viewWithTag:2];
    txt.text = v;
    asigurat.email = v;
}

- (void) showTooltip:(NSString *)tooltip
{
    [vwTooltip setHidden:NO];
    lblTootlip.text = tooltip;
}
- (void) hideTooltip
{
    [vwTooltip setHidden:YES];
    lblTootlip.text = @"";    
}

@end
