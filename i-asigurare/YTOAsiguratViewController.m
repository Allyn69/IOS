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
#import "YTOUserDefaults.h"
#import "YTOCalculatorViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOSetariViewController.h"
#import "YTOCASCOViewController.h"
#import "YTOCasaMeaViewController.h"
#import "YTOMyTravelsViewController.h"
#import "YTOCalatorieViewController.h"

@interface YTOAsiguratViewController ()

@end

@implementation YTOAsiguratViewController

@synthesize asigurat, controller, proprietar, persoanaFizica, fieldArray, txtAdresa;
//@synthesize indexAsigurat;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i443", [YTOUserDefaults getLanguage],@"Persoana");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    
   // //self.trackedViewName = @"YTOAsiguratViewController";
    
    goingBack = YES;
    persoanaFizica = YES;
    shouldSave = YES;
    
    keyboardFirstTimeActive = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    
    [self initCells];
    
    // Verific daca view-ul este pentru contul meu
    if (proprietar)
    {
        asigurat = [YTOPersoana Proprietar];
        asigurat._isDirty = YES;
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
        asigurat.casatorit = @"nu";
        asigurat.copiiMinori = @"nu";
        asigurat.pensionar = @"nu";
        asigurat.handicapLocomotor = @"nu";
        asigurat.proprietar = (proprietar ? @"da" : @"nu");
        asigurat.nrBugetari = 0;
        asigurat.email = [YTOUserDefaults getUserName];
        [self setEmail:isLogat ? [YTOUserDefaults getUserName] : asigurat.email];
        // .. do to
    }
    else {
        if ([asigurat.tipPersoana isEqualToString:@"juridica"])
            persoanaFizica = NO;
        
        [self load:asigurat];
    }
    [self initLabels:persoanaFizica];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    
    
}

- (void) showRightTextForWrongField
{
    if ((![asigurat.mesajOneFieldWrong isEqualToString:@""] && self.produsAsigurare != Calatorie && self.produsAsigurare != MyTravels) || ( self.produsAsigurare == Calatorie && ![asigurat.mesajOneFieldWrongCalatorie isEqualToString:@""]) || (self.produsAsigurare == MyTravels && ![asigurat.mesajOneFieldWrongMyTravels isEqualToString:@""]))
    {
        if (asigurat.getWrongLabel == 0)
        {
            if (self.produsAsigurare == Calatorie)  [self showTooltipAtentie:asigurat.mesajOneFieldWrongCalatorie];
            else [self showTooltipAtentie:asigurat.mesajOneFieldWrong];
        }else{
            if (self.produsAsigurare == Calatorie)  [self showTooltipAtentie:asigurat.mesajOneFieldWrongCalatorie];
            else [self showTooltipAtentie:asigurat.mesajOneFieldWrong];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:asigurat.getWrongLabel inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            UITextField * txt;
            if (asigurat.getWrongLabel == 2) txt = txtNume;
            if (asigurat.getWrongLabel == 3) txt = txtCodUnic;
            if (asigurat.getWrongLabel == 4) txt = txtAdresa;
            if (self.produsAsigurare == Calatorie && asigurat.getWrongLabel == 5) txt = txtSerieAct;
            if (self.produsAsigurare == MyTravels && (asigurat.getWrongLabel == 6 || asigurat.getWrongLabel == 5)) txt = txtCodPostal;
            [txt becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txt superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }
    }else{
        [self showTooltipAtentie:NSLocalizedStringFromTable(@"i125", [YTOUserDefaults getLanguage],NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite"))];
    }
    [self wasValidated];
}

- (void) wasValidated
{
    if (!asigurat.nume || asigurat.nume.length == 0)
    {
       [(UILabel *)[cellNume viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellNume viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!asigurat.codUnic || asigurat.codUnic.length == 0)
    {
        [(UILabel *)[cellCodUnic viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else if (asigurat.codUnic.length != 13 && [asigurat.tipPersoana isEqualToString:@"fizica"])
    {
        [(UILabel *)[cellCodUnic viewWithTag:1] setTextColor: [UIColor redColor ]];
    }else
    {
        [(UILabel *)[cellCodUnic viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!asigurat.adresa || asigurat.adresa.length == 0)
    {
       [(UILabel *)[cellAdresa viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellAdresa viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!asigurat.judet || asigurat.judet.length == 0)
    {
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if ((!asigurat.serieAct || asigurat.serieAct.length == 0 )&& [self.controller isKindOfClass:[YTOCalatorieViewController class]])
    {
        [(UILabel *)[cellSerieAct viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellSerieAct viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if ((!asigurat.codPostal || asigurat.codPostal.length == 0) && [self.controller isKindOfClass:[YTOMyTravelsViewController class]])
    {
        [(UILabel *)[cellCodPostal viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellCodPostal viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }

}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (([self.controller isKindOfClass:[YTOMyTravelsViewController class]] || [self.controller isKindOfClass:[YTOCalculatorViewController class]] || [self.controller isKindOfClass:[YTOCASCOViewController class]] || [self.controller isKindOfClass:[YTOLocuintaViewController class]] || [self.controller isKindOfClass:[YTOCalatorieViewController class] ] || [self.controller isKindOfClass:[YTOCasaMeaViewController class] ]) && asigurat._isDirty)
    {
        [self showRightTextForWrongField];
    }
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        isLogat = YES;
        txtEmail.enabled = NO;
        txtEmail.textColor = [YTOUtils colorFromHexString:menuLighGray];
    }else {
        isLogat = NO;
        txtEmail.enabled = YES;
        txtEmail.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    }
    
    [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void)keyboardWillShow {
    
    keyboardFirstTimeActive = YES;
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
    txtCodUnic.text = @"";
    [self load:asigurat];
    [tableView reloadData];
   
    if (!asigurat._isDirty && !persoanaFizica)
    {
        // Daca nu a completat nimic la cod unic, ii deschidem tastatura
        // pentru a pregati apelul de GetCUIInfo
        if (asigurat.codUnic == nil || asigurat.codUnic.length == 0)
        {
            if (IS_OS_7_OR_LATER){
                keyboardFirstTimeActive = NO;
                NSString *txt = NSLocalizedStringFromTable(@"i256", [YTOUserDefaults getLanguage],@"Codul unic de identificare - pe baza acestuia vom incerca sa obtinem automat informatii publice precum denumirea si adresa firmei");
                [self showTooltip:txt];
            }
            [txtCodUnic becomeFirstResponder];
        }
    }
    
    
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
        if ([asigurat.tipPersoana isEqualToString:@"fizica"]) {
            return 12;
        }else return 10;
    else if ([asigurat.tipPersoana isEqualToString:@"fizica"])
            return 9;
    else return 7;
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
    else if ((indexPath.row == 6 || indexPath.row == 7 || indexPath.row==8 || indexPath.row == 9 || indexPath.row == 10) && proprietar)
    {
        if (indexPath.row == 6) cell = cellTelefon;
        else if (indexPath.row == 7) cell = cellEmail;
        else if (indexPath.row == 8) cell = cellOperator;
        else if (indexPath.row == 9 && [asigurat.tipPersoana isEqualToString:@"fizica"]) cell = cellSerieAct;
        else if (indexPath.row == 10 && [asigurat.tipPersoana isEqualToString:@"fizica"]) cell = cellCodPostal;
        else cell = cellSC;
    }
    else if (indexPath.row == 6 && [asigurat.tipPersoana isEqualToString:@"fizica"]) cell = cellSerieAct;
    else if (indexPath.row == 7 && [asigurat.tipPersoana isEqualToString:@"fizica"]) cell = cellCodPostal;
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
    if (indexPath.row == 8) {
        [self showPopupOperator];
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
    else if (indexPath.row == 8 && proprietar){
        [self showPopupOperator];
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
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
       else currentCell =  (UITableViewCell *) [[textField superview] superview];
    
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    UIBarButtonItem *flexButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *prevButton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"prev", [YTOUserDefaults getLanguage],@"Inapoi")style:UIBarButtonItemStyleBordered target:self action:@selector(prevEditing)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"next", [YTOUserDefaults getLanguage],@"Inainte") style:UIBarButtonItemStyleBordered  target:self action:@selector(nextEditing)];
    
    
    NSArray *itemsArray = [NSArray arrayWithObjects: prevButton, nextButton, flexButton1, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [activeTextField setInputAccessoryView:toolbar];
    
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    
    if (index == 2 || index == 3 || index == 5  || index == 6 || (proprietar && (index == 7 || index == 8 || index == 9 || index == 10)))
    {
        [self addBarButton];
    }
    
    if (index == 2)
    {
        NSString * txt = NSLocalizedStringFromTable(@"i238", [YTOUserDefaults getLanguage],@"Completeaza numele si prenumele");
        if (!persoanaFizica)
            txt = NSLocalizedStringFromTable(@"i254", [YTOUserDefaults getLanguage],@"Completeaza denumirea firmei");
        [self showTooltip:txt];
    }
    else if (index == 3)
    {
        ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        
        NSString * txt = NSLocalizedStringFromTable(@"i240", [YTOUserDefaults getLanguage],@"Codul numeric personal");
        if (!persoanaFizica)
        {
            if (!asigurat._isDirty)
                isSearching = YES;
            
            txt = NSLocalizedStringFromTable(@"i256", [YTOUserDefaults getLanguage],@"Codul unic de identificare - pe baza acestuia vom incerca sa obtinem automat informatii publice precum denumirea si adresa firmei");
        }
        [self showTooltip:txt];
    }
    else if (index == 5)
    {
        NSString * txt = NSLocalizedStringFromTable(@"i243", [YTOUserDefaults getLanguage],@"Adresa completa din buletin");
        if (!persoanaFizica)
            txt = NSLocalizedStringFromTable(@"i258", [YTOUserDefaults getLanguage],@"Sediul social al firmei");
        [self showTooltip:txt];
    }else if (index == 6 && [asigurat.tipPersoana isEqualToString:@"fizica"])
    {
         NSString * txt = NSLocalizedStringFromTable(@"i251", [YTOUserDefaults getLanguage],@"Seria cartii de identitate (pentru UE) sau a pasaportului (UE + alte tari): este necesara pentru calcularea tarifelor asigurarii de calatorie");
        [self showTooltip:txt];
    }else if (index == 7  && [asigurat.tipPersoana isEqualToString:@"fizica"])
    {
        [self showTooltip:@"Codul postal necesar pentru produsul \"My travels\""];
    }
    
    if (proprietar)
    {
        if (index == 6)
        {
            [self showTooltip:NSLocalizedStringFromTable(@"i245", [YTOUserDefaults getLanguage],@"Numarul de telefon la care poti fi contactat")];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }
        else if (index == 7)
        {
            [self showTooltip:NSLocalizedStringFromTable(@"i247", [YTOUserDefaults getLanguage],@"Adresa de email pentru corespondenta (comenzi efectuate, polite de asigurare, alerte)")];
            //[self showTooltip:@"Numarul tau de telefon la care poti fi contactat."];
        }else if (index == 9 && [asigurat.tipPersoana isEqualToString:@"fizica"])
        {
            NSString * txt = NSLocalizedStringFromTable(@"i251", [YTOUserDefaults getLanguage],@"Seria cartii de identitate (pentru UE) sau a pasaportului (UE + alte tari): este necesara pentru calcularea tarifelor asigurarii de calatorie");
            [self showTooltip:txt];
        }else if (index == 10 && [asigurat.tipPersoana isEqualToString:@"fizica"])
        {
            NSString * txt = @"Codul postal necesar pentru produsul \"My travels\"";
            [self showTooltip:txt];
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, 320, 215)];
    tableView.tableFooterView = keyboardView;
    
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    int index = 0;;
    
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if (keyboardFirstTimeActive)
        tableView.contentInset = UIEdgeInsetsMake(65, 0, 10, 0);
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]
                     atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	activeTextField = textField;
	//tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
    
    activeTextField.tag = indexPath.row;
    
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
    [self hideTooltipAtentie];
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
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
    else if (index == 5) {
        [self setAdresa:textField.text];
        [self deleteBarButton];
    }else if (index == 6 && [asigurat.tipPersoana isEqualToString:@"fizica"] && ([asigurat.proprietar isEqualToString:@"nu"] || [self.controller isKindOfClass:[YTOCalatorieViewController class]]))
    {
        [self setSerieAct:textField.text];
    }else if (index == 7 && [asigurat.tipPersoana isEqualToString:@"fizica"] && ([asigurat.proprietar isEqualToString:@"nu"] || [self.controller isKindOfClass:[YTOMyTravelsViewController class]]))
    {
        [self setCodPostal:textField.text];
    }
    
    if (proprietar)
    {
        if (index == 6)
            [self setTelefon:textField.text];
        else if (index == 7) {
            [self setEmail:textField.text];
            [self deleteBarButton];
            }
        else if (index == 9 && [asigurat.tipPersoana isEqualToString:@"fizica"])
        {
            [self setSerieAct:textField.text];
        }else if (index == 10 && [asigurat.tipPersoana isEqualToString:@"fizica"])
        {
            [self setCodPostal:textField.text];
        }
    }
    [self wasValidated];
}

-(void) nextEditing
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index + 1 == fieldArray.count) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    id nextField = [fieldArray objectAtIndex:index + 1];
    if (nextField == (id) txtAdresa) {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self deleteBarButton];
        tableView.tableFooterView = nil;
        [activeTextField resignFirstResponder];
    }else{
        activeTextField = nextField;
        [nextField becomeFirstResponder];
    }
}

- (void) prevEditing
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index == 0) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    
    id prevField = [fieldArray objectAtIndex:index - 1];
    activeTextField = prevField;
    [prevField becomeFirstResponder];
    
}

- (void) save
{
    
    
    if (goingBack)
    {
        // Daca persoana a fost salvata si cnp-ul nu este corect, sau introduce
        // altceva decat CNP, las asa cum introduce utilizatorul, nu intervin la tip persoana
        if (!asigurat._isDirty)
        {
            //            if (asigurat.codUnic.length == 13)
            //                asigurat.tipPersoana = @"fizica";
            //            else if (asigurat.codUnic.length > 0 && asigurat.codUnic.length < 10)
            //                asigurat.tipPersoana = @"juridica";
        }
        [self salveazaPersoana];
        
        
        // daca vine din calatorie, si persoana modificata este valida pentru calculatie, trasmit indexul persoanei
//        if (self.produsAsigurare == Calatorie && [asigurat isValidForComputeCalatorie])
//        {
//            YTOListaAsiguratiViewController * parent = (YTOListaAsiguratiViewController *)self.controller;
//            parent.indexAsigurat = indexAsigurat;
//            [parent reloadData];
//        }
        
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
    if (!asigurat._isDirty && asigurat.nume.length == 0 && asigurat.codUnic.length == 0 && asigurat.judet.length == 0 && asigurat.localitate.length == 0 && asigurat.adresa.length == 0 && asigurat.serieAct.length == 0)
    {
        // daca nu a completat nimic, nu salvam
    }
    else if (asigurat._isDirty)
        [asigurat updatePersoana:NO];
    else
    {
        [asigurat addPersoana:NO];
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
    else if ([self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        YTOCasaMeaViewController * parent = (YTOCasaMeaViewController *)self.controller;
        parent.asigurat = asigurat;
    }
    else if ([self.controller isKindOfClass:[YTOMyTravelsViewController class]])
    {
        YTOMyTravelsViewController * parent = (YTOMyTravelsViewController *)self.controller;
        parent.asigurat = asigurat;
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
            parent.tagViewControllerFrom = 2;
            [parent reloadData];
        }
    }
}

- (void) btnSave_Clicked
{
    
    //    if (asigurat.adresa.length == 0) {
    //
    //        txtAdresa = (UITextField *)[cellAdresa viewWithTag:2];
    //        [txtAdresa becomeFirstResponder];
    //        return;
    //    }
    
    [self doneEditing];
    
    [self save];
    
    // Am salvat o data, pe viewWillDissapear nu mai salvam
    shouldSave = NO;
    
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]] || [self.controller isKindOfClass:[YTOCasaMeaViewController class]]|| [self.controller isKindOfClass:[YTOMyTravelsViewController class]])
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
    UILabel * lbl11 = (UILabel *)[cellAsigurat viewWithTag:11];
    UILabel * lbl22 = (UILabel *)[cellAsigurat viewWithTag:22];
    NSString *string1 = @"";
    NSString *string2 = @"";
    NSString *string  = @"";
    if (!proprietar && a._isDirty){
        imgTextHeader.image = [UIImage imageNamed:@"header-persoana-salvata.png"];
        string1 = NSLocalizedStringFromTable(@"i746", [YTOUserDefaults getLanguage],@"Informatii");
        string2 = NSLocalizedStringFromTable(@"i747", [YTOUserDefaults getLanguage],@"persoana");
        lbl22.text = NSLocalizedStringFromTable(@"i748", [YTOUserDefaults getLanguage],@"poti modifica datele de mai jos");
        string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString beginEditing];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:portocaliuCalatorie] range:NSMakeRange(0, string1.length+1)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
            [attributedString beginEditing];
            
            [lbl11 setAttributedText:attributedString];
        }else{
            [lbl11 setText:string];
            [lbl11 setTextColor:[YTOUtils colorFromHexString:portocaliuCalatorie]];
        }
    }
    else if (!proprietar){
        imgTextHeader.image = [UIImage imageNamed:@"header-persoana-noua.png"];
        string1 = NSLocalizedStringFromTable(@"i743", [YTOUserDefaults getLanguage],@"Persoana");
        string2 = NSLocalizedStringFromTable(@"i744", [YTOUserDefaults getLanguage],@"noua");
        lbl22.text = NSLocalizedStringFromTable(@"i745", [YTOUserDefaults getLanguage],@"completeaza datele de mai jos");
        if (!proprietar && a._isDirty){
            imgTextHeader.image = [UIImage imageNamed:@"header-persoana-salvata.png"];
            string1 = NSLocalizedStringFromTable(@"i746", [YTOUserDefaults getLanguage],@"Informatii");
            string2 = NSLocalizedStringFromTable(@"i747", [YTOUserDefaults getLanguage],@"persoana");
            lbl22.text = NSLocalizedStringFromTable(@"i748", [YTOUserDefaults getLanguage],@"poti modifica datele de mai jos");
            string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
                NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                [attributedString beginEditing];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:portocaliuCalatorie] range:NSMakeRange(0, string1.length+1)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
                [attributedString beginEditing];
                
                [lbl11 setAttributedText:attributedString];
            }else{
                [lbl11 setText:string];
                [lbl11 setTextColor:[YTOUtils colorFromHexString:portocaliuCalatorie]];
            }
    }
    else{
        imgTextHeader.image = [UIImage imageNamed:@"header-persoana-noua.png"];
        string1 = NSLocalizedStringFromTable(@"i743", [YTOUserDefaults getLanguage],@"Persoana");
        string2 = NSLocalizedStringFromTable(@"i744", [YTOUserDefaults getLanguage],@"noua");
        lbl22.text = NSLocalizedStringFromTable(@"i745", [YTOUserDefaults getLanguage],@"completeaza datele de mai jos");
        string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString beginEditing];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:portocaliuCalatorie] range:NSMakeRange(0, string1.length+1)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
            [attributedString beginEditing];
            
            [lbl11 setAttributedText:attributedString];
        }else{
            [lbl11 setText:string];
            [lbl11 setTextColor:[YTOUtils colorFromHexString:portocaliuCalatorie]];
        }
        if (!proprietar && a._isDirty){
            imgTextHeader.image = [UIImage imageNamed:@"header-persoana-salvata.png"];
            string1 = NSLocalizedStringFromTable(@"i746", [YTOUserDefaults getLanguage],@"Informatii");
            string2 = NSLocalizedStringFromTable(@"i747", [YTOUserDefaults getLanguage],@"persoana");
            lbl22.text = NSLocalizedStringFromTable(@"i748", [YTOUserDefaults getLanguage],@"poti modifica datele de mai jos");
            string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
                NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
                [attributedString beginEditing];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:rosuProfil] range:NSMakeRange(0, string1.length+1)];
                [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
                [attributedString beginEditing];
                
                [lbl11 setAttributedText:attributedString];
            }else{
                [lbl11 setText:string];
                [lbl11 setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
            }
        }
    }
    }
    
    
    

    [self setNume:a.nume];
    [self setcodUnic:a.codUnic];
    [self setLocalitate:a.localitate];
    [self setJudet:a.judet];
    [self setAdresa:a.adresa];
    [self setSerieAct:a.serieAct];
    [self setCodPostal:a.codPostal];
    
    if ([a.proprietar isEqualToString:@"da"])
    {
        [self setEmail:isLogat ? [YTOUserDefaults getUserName] :a.email];
        [self setTelefon:a.telefon];
        [self setOperator:[YTOUserDefaults getOperator] != nil ? [YTOUserDefaults getOperator] : @""];
    }
}


-(IBAction) doneEditing
{
    tableView.tableFooterView = nil;
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
    [YTOUtils rightImageVodafone:self.navigationItem];
    //self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    
 //   NSLog(@"%d", indexPath.row);
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
    UILabel * lbl11 = (UILabel *)[cellAsigurat viewWithTag:11];
    UILabel * lbl22 = (UILabel *)[cellAsigurat viewWithTag:22];
    NSString *string1 = @"";
    NSString *string2 = @"";
    NSString *string  = @"";

    
    if (proprietar)
    {
        UIImageView * imgTextHeader = (UIImageView *)[cellAsigurat viewWithTag:4];
        imgTextHeader.image = [UIImage imageNamed:@"header-profil.png"];
        string1 = NSLocalizedStringFromTable(@"i728", [YTOUserDefaults getLanguage],@"Profilul");
        string2 = NSLocalizedStringFromTable(@"i729", [YTOUserDefaults getLanguage],@"meu");
        //UIButton * btn = (UIButton *)[cellAsigurat viewWithTag:5];
        //[btn setBackgroundImage:[UIImage imageNamed:@"icon-foto-person-profil.png"] forState:UIControlStateNormal];
        lblDespreMine.text = NSLocalizedStringFromTable(@"i235", [YTOUserDefaults getLanguage], @"Despre mine");
        lblFirmaMea.text = NSLocalizedStringFromTable(@"i252", [YTOUserDefaults getLanguage],@"Firma mea");
        imgTipPersoana.image = [UIImage imageNamed:@"profil-pf.png"];
        imgTooltip.image = [UIImage imageNamed:@"tooltip-profil.png"];
        lbl22.text = NSLocalizedStringFromTable(@"i730", [YTOUserDefaults getLanguage],@"acestea sunt informatiile tale");
        string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString beginEditing];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:rosuProfil] range:NSMakeRange(0, string1.length+1)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
            [attributedString beginEditing];
            
            [lbl11 setAttributedText:attributedString];
        }else{
            [lbl11 setText:string];
            [lbl11 setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
        }

    }
    else
    {
        UIImageView * imgTextHeader = (UIImageView *)[cellAsigurat viewWithTag:4];
        imgTextHeader.image = [UIImage imageNamed:@"header-persoana-noua.png"];
        string1 = NSLocalizedStringFromTable(@"i743", [YTOUserDefaults getLanguage],@"Persoana");
        string2 = NSLocalizedStringFromTable(@"i744", [YTOUserDefaults getLanguage],@"noua");
        lbl22.text = NSLocalizedStringFromTable(@"i745", [YTOUserDefaults getLanguage],@"completeaza datele de mai jos");
        //UIButton * btn = (UIButton *)[cellAsigurat viewWithTag:5];
        //[btn setBackgroundImage:[UIImage imageNamed:@"icon-foto-person.png"] forState:UIControlStateNormal];
        lblDespreMine.text = NSLocalizedStringFromTable(@"i422", [YTOUserDefaults getLanguage],@"Persoana fizica");
        lblFirmaMea.text = NSLocalizedStringFromTable(@"i423", [YTOUserDefaults getLanguage],@"Persoana juridica");
        imgTipPersoana.image = [UIImage imageNamed:@"persoana-pf.png"];
        imgTooltip.image = [UIImage imageNamed:@"tooltip-calatorie.png"];
        string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
        
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
            [attributedString beginEditing];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:portocaliuCalatorie] range:NSMakeRange(0, string1.length+1)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
            [attributedString beginEditing];
            
            [lbl11 setAttributedText:attributedString];
        }else{
            [lbl11 setText:string];
            [lbl11 setTextColor:[YTOUtils colorFromHexString:portocaliuCalatorie]];
        }

    }
    
        
    NSArray *topLevelObjectsNume = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellNume = [topLevelObjectsNume objectAtIndex:0];
    txtNume = (UITextField *)[cellNume viewWithTag:2];
    txtNume.tag = 2;
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
    
    NSArray *topLevelObjectsSerieAct = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellSerieAct = [topLevelObjectsSerieAct objectAtIndex:0];
    txtSerieAct = (UITextField *)[cellSerieAct viewWithTag:2];
    txtSerieAct.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    [YTOUtils setCellFormularStyle:cellSerieAct];
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsCodPostal = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodPostal = [topLevelObjectsCodPostal objectAtIndex:0];
    txtCodPostal = (UITextField *)[cellCodPostal viewWithTag:2];
    [(UILabel *)[cellCodPostal viewWithTag:1] setText:@"COD POSTAL"];
    [(UITextField *)[cellCodPostal viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellCodPostal];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];
    UILabel *lblSave = (UILabel *) [cellSC viewWithTag:4];
    UILabel *lblCancel = (UILabel *) [cellSC viewWithTag:3];
    lblSave.text = NSLocalizedStringFromTable(@"i67", [YTOUserDefaults getLanguage],@"Salveaza");
    lblCancel.text = NSLocalizedStringFromTable(@"i66", [YTOUserDefaults getLanguage],@"Renunta");
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    if (proprietar)
    {
        NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
        cellEmail = [topLevelObjectsEmail objectAtIndex:0];
        [(UILabel *)[cellEmail viewWithTag:1] setText:NSLocalizedStringFromTable(@"i246", [YTOUserDefaults getLanguage],@"EMAIL")];
        [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
        [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
        [(UITextField *)[cellEmail viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        txtEmail = (UITextField *)[cellEmail viewWithTag:2];
        [YTOUtils setCellFormularStyle:cellEmail];
        
        NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
        cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
        [(UILabel *)[cellTelefon viewWithTag:1] setText:NSLocalizedStringFromTable(@"i244", [YTOUserDefaults getLanguage],@"TELEFON")];
        [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
        [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
        txtTelefon = (UITextField *)[cellTelefon viewWithTag:2];
        [YTOUtils setCellFormularStyle:cellTelefon];
        
        NSArray *topLevelObjectsOperator = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
        cellOperator = [topLevelObjectsOperator objectAtIndex:0];
        [YTOUtils setCellFormularStyle:cellOperator];
        
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtNume, txtCodUnic, txtAdresa, txtTelefon, txtEmail,txtSerieAct,txtCodPostal,  nil];
    }
    else
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtNume, txtCodUnic, txtAdresa,txtSerieAct,txtCodPostal, nil];
}

- (void) initLabels:(BOOL )pf
{
    
    UILabel *lblDespreMine = (UILabel *)[cellTipPersoana viewWithTag:3];
    UILabel *lblFirmaMea = (UILabel *)[cellTipPersoana viewWithTag:4];
    UILabel *lblGeneric = (UILabel *)[cellTipPersoana viewWithTag:6];
    UIImageView * img = (UIImageView *)[cellTipPersoana viewWithTag:5];
    
    
    if (pf)
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:NSLocalizedStringFromTable(@"i237", [YTOUserDefaults getLanguage],@"NUME SI PRENUME")];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:NSLocalizedStringFromTable(@"i239", [YTOUserDefaults getLanguage],@"CNP")];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:NSLocalizedStringFromTable(@"i242", [YTOUserDefaults getLanguage],@"ADRESA")];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:NSLocalizedStringFromTable(@"i241", [YTOUserDefaults getLanguage],@"JUDET,LOCALITATE")];
        [(UILabel *)[cellOperator viewWithTag:1] setText:NSLocalizedStringFromTable(@"i248", [YTOUserDefaults getLanguage],@"ALEGE OPERATOR")];
        [(UILabel *)[cellSerieAct viewWithTag:1] setText:NSLocalizedStringFromTable(@"i250", [YTOUserDefaults getLanguage],@"SERIE CI/PASAPORT")];
        
        lblDespreMine.textColor = [UIColor whiteColor];
        lblFirmaMea.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pf.png"] : [UIImage imageNamed:@"persoana-pf.png"];
    }
    else
    {
        [(UITextField *)[cellNume viewWithTag:1] setText:NSLocalizedStringFromTable(@"i253", [YTOUserDefaults getLanguage],@"DENUMIRE")];
        [(UILabel *)[cellCodUnic viewWithTag:1] setText:NSLocalizedStringFromTable(@"i255", [YTOUserDefaults getLanguage],@"CUI")];
        [(UILabel *)[cellAdresa viewWithTag:1] setText:NSLocalizedStringFromTable(@"i257", [YTOUserDefaults getLanguage],@"ADRESA")];
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:NSLocalizedStringFromTable(@"i241", [YTOUserDefaults getLanguage],@"JUDET,LOCALITATE")];
        [(UILabel *)[cellOperator viewWithTag:1] setText:NSLocalizedStringFromTable(@"i248", [YTOUserDefaults getLanguage],@"ALEGE OPERATOR")];
        
        lblFirmaMea.textColor = [UIColor whiteColor];
        lblDespreMine.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        img.image = proprietar ? [UIImage imageNamed:@"profil-pj.png"] : [UIImage imageNamed:@"persoana-pj.png"];
    }
    
    if (asigurat._isDirty && !proprietar)
    {
        if (asigurat.tipPersoana){
            NSString *tipPersoana;
            tipPersoana = [NSString stringWithFormat:@"%@", ([asigurat.tipPersoana isEqualToString:@"fizica" ] ? NSLocalizedStringFromTable(@"i422", [YTOUserDefaults getLanguage],@"Persoana fizica"): NSLocalizedStringFromTable(@"i423", [YTOUserDefaults getLanguage],@"Persoana juridica"))];
            lblGeneric.text = tipPersoana;
        }
        lblGeneric.textColor = [UIColor whiteColor];
        img.image = [UIImage imageNamed:@"persoana-salvata.png"];
        lblDespreMine.hidden = YES;
        lblFirmaMea.hidden = YES;
    }
    if ([YTOUserDefaults getOperator]!=nil)
        [self setOperator:[YTOUserDefaults getOperator]];
}

- (void) showListaJudete:(NSIndexPath *)index;
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = NSLocalizedStringFromTable(@"i304", [YTOUserDefaults getLanguage],@"Judete");
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
    if (v != (id)[NSNull null] && v.length >0)
        txtCodUnic.text = v;
    else v = @"";
    NSString * cui_vechi = asigurat.codUnic;
    asigurat.codUnic = v;
    
    if (asigurat.codUnic && asigurat.codUnic.length > 2){
        if ((asigurat.dataPermis && asigurat.dataPermis < [YTOUtils getAnMinimPermis:asigurat.codUnic]) || !asigurat.dataPermis)
            asigurat.dataPermis = [YTOUtils getAnMinimPermis:asigurat.codUnic];
    }else
        asigurat.dataPermis = [NSString stringWithFormat:@"01-01-%d",[YTOUtils getAnCurent]];

    
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
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
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
    UIImageView * imgAlert = (UIImageView *)[cellAdresa viewWithTag:10];
    
    txtAdresa = (UITextField *)[cellAdresa viewWithTag:2];
    txtAdresa.text = v;
    asigurat.adresa = v;
    
    if (asigurat.adresa.length == 0)
        [imgAlert setHidden:NO];
    else
        [imgAlert setHidden:YES];
}

- (void) setSerieAct : (NSString *) v
{
    txtSerieAct.text = v;
    asigurat.serieAct = v;
}

- (void) setCodPostal:(NSString *)p
{
    txtCodPostal.text = p;
    asigurat.codPostal = p;
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

- (void) setOperator:(NSString *)v
{
    UILabel * lbl = (UILabel *)[cellOperator viewWithTag:2];
    lbl.text = [self getOperator];
}

- (NSString *) getOperator
{
    if ([YTOUserDefaults getOperator] != nil)
        return [YTOUserDefaults getOperator];
    return @"";
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


- (void) showTooltipAtentie:(NSString *)tooltipAtentie
{
    [vwTooltipAtentie setHidden:NO];
    lblTooltipAtentie.text = tooltipAtentie;
}

- (void) hideTooltipAtentie
{
    [vwTooltipAtentie setHidden:YES];
    lblTooltipAtentie.text = @"";
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
														timeoutInterval:10.0];
    
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
        
        if (data == nil) {
            [self hideLoading];
            return;
        }
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
        if (strada && strada.length > 0)
            adresaFull = [adresaFull stringByAppendingString:strada];
        if (numar && numar.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", nr.%@", numar]];
        if (bloc && bloc.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", bl.%@", bloc]];
        if (scara && scara.length > 0)
            adresaFull = [adresaFull stringByAppendingString:[NSString stringWithFormat:@", sc.%@", scara]];
        if (apartament && apartament.length > 0)
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
  //  [lblLoadingDescription setHidden:YES];
    [lblLoadingTitlu setText:NSLocalizedStringFromTable(@"i424", [YTOUserDefaults getLanguage],@"cautam datele firmei...")];
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

- (void) showPopupOperator
{
    vwOperator.hidden = NO;
    lblPopupOperator.text = NSLocalizedStringFromTable(@"i249", [YTOUserDefaults getLanguage],@"Te rugam sa selectezi operatorul de telefonie mobila");
    lblPopupOperator.hidden = NO;
    if ([YTOUserDefaults getOperator]!=nil)
    {
        if ([[YTOUserDefaults getOperator] isEqualToString:@"Vodafone"])
        {
            UIButton * _btn = (UIButton *)[vwOperator viewWithTag:1];
            _btn.selected = YES;
        }else if ([[YTOUserDefaults getOperator] isEqualToString:@"Orange"])
        {
            UIButton * _btn = (UIButton *)[vwOperator viewWithTag:2];
            _btn.selected = YES;
        }else if ([[YTOUserDefaults getOperator] isEqualToString:@"Cosmote"])
        {
            UIButton * _btn = (UIButton *)[vwOperator viewWithTag:3];
            _btn.selected = YES;
        }
    }
}

- (IBAction)choseOperator:(id)sender
{
    //NSLog(@"Operator %@", [YTOUserDefaults getOperator]);
    NSString *operator;
    UIButton *btn = (UIButton *) sender;
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[vwOperator viewWithTag:i];
        [_btn setSelected:NO];
    }
    
    if (btn.tag == 1){
        operator = @"Vodafone";
        btn.selected = YES;
    }
    else if (btn.tag == 2){
        operator = @"Orange";
        btn.selected = YES;
    }
    else if (btn.tag == 3){
        operator = @"Cosmote";
        btn.selected = YES;
    }
    [YTOUserDefaults setOperatorMobil:operator];
    [self setOperator:operator];
}

- (IBAction)hidePopupOperator:(id)sender
{
    lblPopupOperator.hidden = YES;
    vwOperator.hidden = YES;
}
@end
