//
//  YTOAsiguratViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/16/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAsiguratViewController.h"
#import "YTOAppDelegate.h"
#import "YTONomenclatorViewController.h"
#import "Database.h"
#import "YTOUtils.h"
#import "YTOCalculatorViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOSetariViewController.h"
#import "YTOCASCOViewController.h"

@interface YTOAsiguratViewController ()

@end

@implementation YTOAsiguratViewController

@synthesize asigurat, controller, proprietar, persoanaFizica;

@synthesize responseData;

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
    shouldSave = YES;
    
    [self initCells];
    
    
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
            persoanaFizica = NO;

        [self load:asigurat];
    }
    [self initLabels:persoanaFizica];
}

- (void) viewWillAppear:(BOOL)animated
{
    goingBack = YES;
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
    // Daca persoana este salvata si nu este din profilul meu
    // nu se mai schimba tipul persoanei
    if (asigurat._isDirty && !proprietar)
        return;
    
    // inchid tastatura in caz ca este deschisa
    [self doneEditing];
    
    // aflu pe ce buton a apasat PF sau PJ
    UIButton * btn = (UIButton *)sender;
    BOOL estePF = btn.tag == 1;
    
    if (proprietar)
        [self salveazaPersoana];
    
    // Daca persoana nu a fost salvata, schimb tipul de persoana
    persoanaFizica = estePF;
    if (asigurat._isDirty == NO)
    {
        asigurat.tipPersoana = estePF ? @"fizica" : @"juridica";
    }
    
    // se initializeaza labelurile si textele in functie de tip persoana PF sau PJ
    [self initLabels:persoanaFizica];
    
    // Daca sunt pe "Profilul meu", incarca ProprietarPF sau ProprietarPJ
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
    
    if (!asigurat._isDirty && !persoanaFizica)
    {
        // Daca nu a completat nimic la cod unic, ii deschidem tastatura
        // pentru a pregati apelul de GetCUIInfo
        if (asigurat.codUnic == nil || asigurat.codUnic.length == 0)
        {
            [txtCodUnic becomeFirstResponder];
        }
    }
    
    [self load:asigurat];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self doneEditing];
    
    // Daca vine de pe butonul de cancel
    if (shouldSave)
        [self save];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
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
    
    if (isSearching)
        return;
    
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
        ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        
        NSString * txt = @"Codul numeric personal";
        if (!persoanaFizica)
        {
            if (!asigurat._isDirty)
                isSearching = YES;
            
            txt = @"Codul unic de identificare - pe baza acestuia vom incerca sa obtinem automat informatii publice precum denumire si adresa firmei.";
        }
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
        {
            [self showTooltip:@"Numarul tau de telefon la care poti fi contactat."];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }
        else if (indexPath.row == 7)
        {
            [self showTooltip:@"Adresa de email pentru corespondenta (comenzi efectuate, polite de asigurare, alerte)"];
            [self showTooltip:@"Numarul tau de telefon la care poti fi contactat."];
        }
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    activeTextField.tag = indexPath.row;
    
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
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if (index == 2)
        [self setNume:textField.text];
    else if (index == 3)
        [self setcodUnic:textField.text];
    else if (index == 5)
        [self setAdresa:textField.text];
    
    if (proprietar)
    {
        if (index == 6)
            [self setTelefon:textField.text];
        else if (index == 7)
            [self setEmail:textField.text];
    }
}

- (void) save
{
    if (goingBack)
    {
        // Daca persoana a fost salvata si cnp-ul nu este corect, sau introduce
        // altceva decat CNP, las asa cum introduce utilizatorul, nu intervin la tip persoana
        if (!asigurat._isDirty)
        {
            if (asigurat.codUnic.length == 13)
                asigurat.tipPersoana = @"fizica";
            else if (asigurat.codUnic.length > 0 && asigurat.codUnic.length < 10)
                asigurat.tipPersoana = @"juridica";
        }
        [self salveazaPersoana];
    
//        if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
//        {
//            YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
//            [parent setAsigurat:asigurat];
//        }
//        else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
//        {
//            YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
//            [parent setAsigurat:asigurat];
//        }
//        else if ([self.controller isKindOfClass:[YTOListaAsiguratiViewController class]])
//        {
//            YTOListaAsiguratiViewController * parent = (YTOListaAsiguratiViewController *)self.controller;
//            [parent reloadData];
//        }
    }
}

- (void) salveazaPersoana
{
    if (!asigurat._isDirty && asigurat.nume.length == 0 && asigurat.codUnic.length == 0 && asigurat.judet.length == 0 && asigurat.localitate.length == 0 && asigurat.adresa.length == 0)
    {
        // daca nu a completat nimic, nu salvam
    }
    else if (asigurat._isDirty)
        [asigurat updatePersoana];
    else
    {
        [asigurat addPersoana];
    }
    
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        [parent setAsigurat:asigurat];
    }
    else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        [parent setAsigurat:asigurat];
    }
    else if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
    {
        YTOCASCOViewController * parent = (YTOCASCOViewController *)self.controller;
        [parent setAsigurat:asigurat];
    }
    else if ([self.controller isKindOfClass:[YTOListaAsiguratiViewController class]])
    {
        // fac reload doar daca s-a salvat persoana
        if (asigurat._isDirty)
        {
            YTOListaAsiguratiViewController * parent = (YTOListaAsiguratiViewController *)self.controller;
            [parent reloadData];
        }
    }

}

- (void) btnSave_Clicked
{
    [self doneEditing];
    
    [self save];
    
    // Am salvat o data, pe viewWillDissapear nu mai salvam
    shouldSave = NO;
    
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        // selecteaza asiguratul si ma duce direct in ecranul de calculator
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        // selecteaza asiguratul si ma duce direct in ecranul de calculator
        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
    {
        // selecteaza asiguratul si ma duce direct in ecranul de calculator
        YTOCASCOViewController * parent = (YTOCASCOViewController *)self.controller;
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOListaAsiguratiViewController class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) btnCancel_Clicked
{
    // In cazul in care a modificat ceva si a apasat pe Cancel,
    // incarcam lista cu persoane din baza de date
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate refreshPersoane];
    
    shouldSave = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) load:(YTOPersoana *)a
{
//    if ([a.tipPersoana isEqualToString:@"juridica"])
//    {
//        UIButton * btn = (UIButton *)[cellTipPersoana viewWithTag:2];
//        [self btnTipPersoana_OnClick:btn];
//    }
    
    UIImageView * imgTextHeader = (UIImageView *)[cellAsigurat viewWithTag:4];
    if (!proprietar && a._isDirty)
        imgTextHeader.image = [UIImage imageNamed:@"text-header-persoana-salvata.png"];
    else if (!proprietar)
        imgTextHeader.image = [UIImage imageNamed:@"text-header-persoana.png"];
    else
        imgTextHeader.image = [UIImage imageNamed:@"text-header-profil.png"];
    
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
    self.navigationItem.hidesBackButton = YES;
}
- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
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
        
        imgTooltip.image = [UIImage imageNamed:@"tooltip-profil.png"];
    }
    else
    {
        //UIButton * btn = (UIButton *)[cellAsigurat viewWithTag:5];
        //[btn setBackgroundImage:[UIImage imageNamed:@"icon-foto-person.png"] forState:UIControlStateNormal];
        lblDespreMine.text = @"Persoana fizica";
        lblFirmaMea.text = @"Persoana juridica";
        imgTipPersoana.image = [UIImage imageNamed:@"persoana-pf.png"];
        
        imgTooltip.image = [UIImage imageNamed:@"tooltip-calatorie.png"];
    }
    
    NSArray *topLevelObjectsNume = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellNume = [topLevelObjectsNume objectAtIndex:0];
    txtNume = (UITextField *)[cellNume viewWithTag:2];
    [YTOUtils setCellFormularStyle:cellNume];
    
    NSArray *topLevelObjectsCodUnic = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodUnic = [topLevelObjectsCodUnic objectAtIndex:0];
    [(UITextField *)[cellCodUnic viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    txtCodUnic = (UITextField *)[cellCodUnic viewWithTag:2];    
    [YTOUtils setCellFormularStyle:cellCodUnic];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    txtAdresa = (UITextField *)[cellAdresa viewWithTag:2];
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
        txtEmail = (UITextField *)[cellEmail viewWithTag:2];
        [YTOUtils setCellFormularStyle:cellEmail];
        
        NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
        cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
        [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON"];
        [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
        [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
        txtTelefon = (UITextField *)[cellTelefon viewWithTag:2];
        [YTOUtils setCellFormularStyle:cellTelefon];
    }
}

- (void) initLabels:(BOOL )pf
{
    UILabel *lblDespreMine = (UILabel *)[cellTipPersoana viewWithTag:3];
    UILabel *lblFirmaMea = (UILabel *)[cellTipPersoana viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellTipPersoana viewWithTag:5];

    if (pf)
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:@"NUME PRENUME"];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:@"CNP"];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:@"ADRESA"];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE"];
        
        lblDespreMine.textColor = [UIColor whiteColor];
        lblFirmaMea.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pf.png"] : [UIImage imageNamed:@"persoana-pf.png"];
    }
    else
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:@"DENUMIRE"];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:@"CUI"];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:@"ADRESA"];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE"];
        
        lblFirmaMea.textColor = [UIColor whiteColor];
        lblDespreMine.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pj.png"] : [UIImage imageNamed:@"persoana-pj.png"];
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
    txtNume.text = v;
    asigurat.nume = v;
}

- (void) setcodUnic:(NSString *)v
{
    
    UIImageView * imgAlert = (UIImageView *)[cellCodUnic viewWithTag:10];
    txtCodUnic.text = v;
    NSString * cui_vechi = asigurat.codUnic;
    asigurat.codUnic = v;
    
    if (v.length == 0)
    {
        isSearching = NO;
        return;
    }
    
    if ( ([asigurat.tipPersoana isEqualToString:@"fizica"] && [YTOUtils validateCNP:v]))
    {
        [imgAlert setHidden:YES];
    }
    else if ([asigurat.tipPersoana isEqualToString:@"juridica"] && [YTOUtils validateCUI:v])
    {
        [imgAlert setHidden:YES];
        
        // Daca persoana este noua, cui-ul este valid
        // Apelam serviciul GetCUIInfo
        if (!asigurat._isDirty && ![cui_vechi isEqualToString:v])
            [self callGetCUIInfo];
    }
    else
    {
        [imgAlert setHidden:NO];
        isSearching = NO;
    }
    
}
- (void) setJudet:(NSString *)v
{
    asigurat.judet = v;
}
- (NSString *) getJudet
{
    if (asigurat.judet == nil)
        return @"";
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
    if (asigurat.localitate == nil)
        return @"";
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
    txtAdresa = (UITextField *)[cellAdresa viewWithTag:2];
    txtAdresa.text = v;
    asigurat.adresa = v;
}

- (void) setTelefon:(NSString *)v
{
    UIImageView * imgAlert = (UIImageView *)[cellTelefon viewWithTag:10];
    
    txtTelefon.text = v;
    asigurat.telefon = v;
    
    if (asigurat.telefon.length < 10 && asigurat.telefon.length > 14)
        [imgAlert setHidden:NO];
    else
        [imgAlert setHidden:YES];
}

- (void) setEmail:(NSString *)v
{
    UIImageView * imgAlert = (UIImageView *)[cellEmail viewWithTag:10];
    
    v = [YTOUtils replacePossibleWrongEmailAddresses:v];
    
    txtEmail.text = v;
    asigurat.email = v;
    
    if (v.length > 0)
    {
        if ([YTOUtils validateEmail:v])
            [imgAlert setHidden:YES];
        else
            [imgAlert setHidden:NO];
    }
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


#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetCUIInfo xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<cui>%@</cui>"
                      "</GetCUIInfo>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      asigurat.codUnic];
    return xml;
}

- (void) callGetCUIInfo {

    [self showLoading];
	
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:5.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/GetCUIInfo" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
    
    //[self performSelectorOnMainThread:@selector(hideLoading) withObject:nil waitUntilDone:NO];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);

	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
	if (succes) {
        NSError * err = nil;
        NSData *data = [raspuns dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];

        NSString * nume = [json objectForKey:@"Nume"];
        NSString * caen = [json objectForKey:@"ClasaCaen"];
        NSString * judet = [json objectForKey:@"Judet"];
        NSString * localitate = [json objectForKey:@"Localitate"];
        NSString * strada = [json objectForKey:@"Strada"];
        NSString * numar = [json objectForKey:@"Numar"];
        NSString * bloc = [json objectForKey:@"Bloc"];
        NSString * scara = [json objectForKey:@"Scara"];
        NSString * apartament = [json objectForKey:@"Apartament"];
        
        NSLog(@"%@, %@", nume, caen);
        
        if (nume.length > 0)
            [self setNume:nume];
        if (caen.length > 0)
            asigurat.codCaen = caen;
        if (judet.length > 0)
            [self setJudet:judet];
        if (localitate.length > 0)
            [self setLocalitate:localitate];

        NSString * adresaFull = @"";
        if (strada.length > 0)
            adresaFull = [adresaFull stringByAppendingString:strada];
        if (numar.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", nr.%@", numar]];
        if (bloc.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", bl.%@", bloc]];
        if (scara.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", sc.%@", scara]];
        if (apartament.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", ap.%@", apartament]];
        
        [self setAdresa:adresaFull];
    }
	else {
        
	}
    
    [self hideLoading];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"GetCUIInfoResult"]) {
        raspuns = currentElementValue;
	}
    
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

#pragma POPUP
- (void) showLoading
{
    isSearching = YES;
    [btnLoadingOk setHidden:YES];
    [lblLoadingOk setHidden:YES];
    [lblLoadingDescription setHidden:YES];
    [lblLoadingTitlu setText:@"Cautam datele firmei..."];
    [loading setHidden:NO];
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    isSearching = NO;
    [vwLoading setHidden:YES];
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description
{
    [btnLoadingOk setHidden:NO];
    [lblLoadingOk setHidden:NO];
    [lblLoadingDescription setHidden:NO];
    [lblLoadingDescription setText:description];
    [lblLoadingTitlu setText:title];
    [loading setHidden:YES];
    [vwLoading setHidden:NO];
}
@end
