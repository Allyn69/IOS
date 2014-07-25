//
//  YTOCasaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/2/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOCasaViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOAsigurareViewController.h"
#import "YTOLocuinta.h"
#import "YTOUtils.h"
#import "Database.h"
#import "KeyValueItem.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "YTOCasaMeaViewController.h"

@interface YTOCasaViewController ()

@end

@implementation YTOCasaViewController

@synthesize controller, locuinta, goingBack, fieldArray;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i364", [YTOUserDefaults getLanguage],@"Locuinta");
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
    //self.trackedViewName = @"YTOCasaViewController";
    
    keyboardFirstTimeActive = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    
    lblInfoLocuinta.text = NSLocalizedStringFromTable(@"i367", [YTOUserDefaults getLanguage],@"Info locuinta");
    lblAlerte.text = NSLocalizedStringFromTable(@"i370", [YTOUserDefaults getLanguage],@"Alerte");
    
    lblTipulLocuintei.text = NSLocalizedStringFromTable(@"i376", [YTOUserDefaults getLanguage],@"TIPUL LOCUINTEI");
    lblApartament.text = NSLocalizedStringFromTable(@"i377", [YTOUserDefaults getLanguage],@"Apartament in bloc");
    lblCasaComuna.text = NSLocalizedStringFromTable(@"i378", [YTOUserDefaults getLanguage],@"Casa - vila comuna");
    lblCasaIndividuala.text = NSLocalizedStringFromTable(@"i379", [YTOUserDefaults getLanguage],@"Casa - vila individuala");
    
    lblPentruAlerte.text = NSLocalizedStringFromTable(@"i373", [YTOUserDefaults getLanguage],@"Pentru a salva alerte, trebuie sa completezi informatiile locuintei");
    lblCumAlerte.text = NSLocalizedStringFromTable(@"i803", [YTOUserDefaults getLanguage],@"Cum editezi alerte?");
    lblCumAlerte.textColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    goingBack = YES;
    selectatInfoLocuinta = YES;
    shouldSave = YES;
    
    [self initCells];
    [self loadStructuriRezistenta];
    
    if (!locuinta) {
        locuinta = [[YTOLocuinta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        // set default values
        [self setTipLocuinta:@"apartament-in-bloc"];
        [self setStructura: NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat")];
        [self setNrCamere:2];
        [self setNrLocatari:2];
        locuinta.locuitPermanent = @"da";
        
        UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
        NSString * descr = lbl.text;
        NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i560", [YTOUserDefaults getLanguage],@"Locuit permanent"), @"| "];
        if ([locuinta.locuitPermanent isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
            descr = [descr stringByAppendingString:str];
        else if (![locuinta.locuitPermanent isEqualToString:@"da"])
            descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
        
        lbl.text = descr;
        
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        if (proprietar)
        {
            [self setLocalitate:proprietar.localitate];
            [self setJudet:proprietar.judet];
            [self setAdresa:proprietar.adresa];
        }
        percentCompletedOnLoad = [locuinta CompletedPercent];
    }
    else {
        if (([locuinta.tipLocuinta isEqualToString:@"casa-vila-individuala"])
            || ([locuinta.tipLocuinta isEqualToString:@"casa-vila-comuna"]))
            faraEtaj = YES;
        [self load:locuinta];
    }
    [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void)keyboardWillShow {
    
    keyboardFirstTimeActive = YES;
    
}

- (void) showRightTextForWrongField
{
    if (locuinta.CompletedPercent == (float)10/11)
    {
        if (!locuinta.adresa || locuinta.adresa.length == 0)
        {
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i640", [YTOUserDefaults getLanguage],@"Introdu adresa completa a imobilului.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtAdresa becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtAdresa superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (!locuinta.etaj && [locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]){
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i642", [YTOUserDefaults getLanguage],@" Introdu etajul la care se afla locuinta.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtEtaj becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtEtaj superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (!locuinta.regimInaltime){
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i641", [YTOUserDefaults getLanguage],@"Introdu numarul de etaje al cladirii.")];
            int i = 6;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 5;
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtInaltime becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtInaltime superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (locuinta.anConstructie <= 0){
            int i = 7;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 6;
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i644", [YTOUserDefaults getLanguage],@" Completeaza anul constructiei imobilului.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtAnConstructie becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtAnConstructie superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (locuinta.suprafataUtila <= 0){
            int i = 8;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 7;
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i647", [YTOUserDefaults getLanguage],@"Completeaza suprafata utila a locuintei (in metri patrati).")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtSuprafata becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtSuprafata superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (!locuinta.judet || locuinta.judet.length == 0){
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i639", [YTOUserDefaults getLanguage],@"Selecteaza judetul si localitatea imobilului.")];
        }else {
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite")];
        }
    }else if (locuinta.CompletedPercent >= (float) 1 && !locuinta.isValidForLocuinta){
        if (1949 > locuinta.anConstructie){
            int i = 7;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 6;
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i645", [YTOUserDefaults getLanguage],@" Anul constructiei cladirii trebuie sa fie cel putin 1950. Altfel, imobilul nu poate fi asigurat.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtAnConstructie becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtAnConstructie superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (locuinta.anConstructie > [YTOUtils getAnCurent]){
            int i = 7;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 6;
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i646", [YTOUserDefaults getLanguage],@" Anul constructiei imobilului asigurat nu poate fi mai mare decat anul curent.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtAnConstructie becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtAnConstructie superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else if (locuinta.regimInaltime < locuinta.etaj){
            int i = 6;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 5;
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i643", [YTOUserDefaults getLanguage],@" Introdu etajul – acesta nu poate fi mai mare decat numarul de etaje al cladirii.")];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtEtaj becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtEtaj superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }else{
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite"))];
        }
    }else if (!locuinta.isValidForGothaer && [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
        if (!locuinta.codPostal || locuinta.codPostal.length == 0)
        {
            [self showTooltipAtentie:@"Introdu codul postal necesar pentru produsul \"Casa mea\"."];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtCodPostal becomeFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtCodPostal superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
            return;
        }if (!locuinta.anConstructie || locuinta.anConstructie <= 1950)
        {
            int i = 7;
            if (![locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"]) i = 6;
            [self showTooltipAtentie:@" Anul constructiei cladirii trebuie sa fie cel putin 1950. Altfel, imobilul nu poate fi asigurat."];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [txtAnConstructie resignFirstResponder];
            UITableViewCell *currentCell = (UITableViewCell *) [[txtAnConstructie superview] superview];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
            [txtAnConstructie becomeFirstResponder];
            return;
        }
        if (!locuinta.structuraLocuinta || locuinta.structuraLocuinta.length == 0 || [locuinta.structuraLocuinta isEqualToString:@"chirpici-paiata"] || [locuinta.structuraLocuinta isEqualToString:@"lemn"] || [locuinta.structuraLocuinta isEqualToString:@"zidarie-lemn"]|| [locuinta.structuraLocuinta isEqualToString:@"caramida-nearsa"]){
            [self showTooltipAtentie:@"Structura locuintei poate avea una din valorile beton-armat,bca,beton,bca,caramida."];
               [(UILabel *)[cellStructura viewWithTag:1] setTextColor: [UIColor redColor ]];
            return;
        }
        if (![locuinta.locuitPermanent isEqualToString:@"da"] && [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        {
            [(UILabel *)[cellDescriereLocuinta viewWithTag:1] setTextColor: [UIColor redColor ]];
            [self showTooltipAtentie:@"Se preiau in asigurare doar imobilele locuinte permanent."];
            [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]
                             atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
        else{
            [self showTooltipAtentie:NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite"))];
        }
        
    }else{
        [self showTooltipAtentie:NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],NSLocalizedStringFromTable(@"i442", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite"))];
    }
    [self wasValidated];
}

- (void) wasValidated
{
    BOOL isOk = YES;
    if (!locuinta.adresa || locuinta.adresa.length == 0)
    {
        [(UILabel *)[cellAdresa viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellAdresa viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!locuinta.etaj && [locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"])
    {
         [(UILabel *)[cellEtaj viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellEtaj viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!locuinta.regimInaltime || locuinta.regimInaltime < locuinta.etaj)
    {
         [(UILabel *)[cellInaltime viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellInaltime viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (locuinta.anConstructie <= 0 || 1949> locuinta.anConstructie || locuinta.anConstructie > [YTOUtils getAnCurent])
    {
         [(UILabel *)[cellAnConstructie viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellAnConstructie viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (locuinta.suprafataUtila <= 0)
    {
         [(UILabel *)[cellSuprafata viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellSuprafata viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (!locuinta.judet || locuinta.judet.length == 0)
    {
         [(UILabel *)[cellJudetLocalitate viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellJudetLocalitate viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if ((!locuinta.codPostal || locuinta.codPostal.length == 0 )&& [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
          [(UILabel *)[cellCodPostal viewWithTag:1] setTextColor: [UIColor redColor ]];
    }
    else
    {
        [(UILabel *)[cellCodPostal viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    if (![locuinta.locuitPermanent isEqualToString:@"da"] && [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        [(UILabel *)[cellDescriereLocuinta viewWithTag:1] setTextColor: [UIColor redColor ]];
        [self showTooltipAtentie:@"Se preiau in asigurare doar imobilele locuinte permanent."];
        isOk = NO;
        
    }
    else
    {
        [(UILabel *)[cellDescriereLocuinta viewWithTag:1] setTextColor: [YTOUtils colorFromHexString:ColorTitlu]];
    }
    if ((!locuinta.structuraLocuinta || locuinta.structuraLocuinta.length == 0 || [locuinta.structuraLocuinta isEqualToString:@"chirpici-paiata"] || [locuinta.structuraLocuinta isEqualToString:@"lemn"] || [locuinta.structuraLocuinta isEqualToString:@"zidarie-lemn"] || [locuinta.structuraLocuinta isEqualToString:@"caramida-nearsa"]) && [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        [self showTooltipAtentie:@"Structura locuintei poate avea una din valorile beton-armat,bca,beton,bca,caramida."];
        [(UILabel *)[cellStructura viewWithTag:1] setTextColor: [UIColor redColor ]];
        isOk = NO;
    }
    else
    {
        [(UILabel *)[cellStructura viewWithTag:1]  setTextColor: [YTOUtils colorFromHexString:ColorTitlu ]];
    }
    
    if (isOk)
        [self hideTooltipAtentie];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (([self.controller isKindOfClass:[YTOLocuintaViewController class]] && locuinta.CompletedPercent && locuinta._isDirty) || [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        [self showRightTextForWrongField];
        
    }
    [YTOUtils rightImageVodafone:self.navigationItem];
}


- (void) viewWillAppear:(BOOL)animated
{
    goingBack = YES;
}

- (void) viewWillDisappear:(BOOL)animated {
    
    if (shouldSave)
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (selectatInfoLocuinta){
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
            return 10;
        if (faraEtaj == NO) return 15;
        else return 14;
    }else
        return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectatInfoLocuinta)
    {
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        {
            if (indexPath.row == 0)
                return 78;
            else if (indexPath.row ==1)
                return 30;
            else if (indexPath.row == 4)
                return 100;
            return 60;
        }
        if (faraEtaj == NO){
            if (indexPath.row == 0)
                return 78;
            else if (indexPath.row ==1)
                return 30;
            else if (indexPath.row == 5)
                return 100;
            else if (indexPath.row == 10 || indexPath.row == 12)
                return 67;
            return 60;
        }
        else {
            if (indexPath.row == 0)
                return 78;
            else if (indexPath.row ==1)
                return 30;
            else if (indexPath.row == 5)
                return 100;
            else if (indexPath.row == 9 || indexPath.row == 11)
                return 67;
            return 60;
        }
    }
    else
    {
        if (indexPath.row == 0)
            return 78;
        else if (indexPath.row == 1)
            return 30;
        return 60;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    if (selectatInfoLocuinta)
    {
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        {
            if (indexPath.row == 0) cell = cellHeader;
            else if (indexPath.row == 1) cell = cellInfoAlerte;
            else if (indexPath.row == 2) cell = cellAdresa;
            else if (indexPath.row == 3) cell = cellCodPostal;
            else if (indexPath.row == 4) cell = cellTipLocuinta;
            else if (indexPath.row == 5) cell = cellStructura;
            else if (indexPath.row == 6) cell = cellSuprafata;
            else if (indexPath.row == 7) cell = cellAnConstructie;
            else if (indexPath.row == 8) cell = cellDescriereLocuinta;
            else if (indexPath.row == 9) cell = cellSC;
            return cell;
        }
        if (faraEtaj == NO){
            if (indexPath.row == 0) cell = cellHeader;
            else if (indexPath.row == 1) cell = cellInfoAlerte;
            else if (indexPath.row == 2) cell = cellJudetLocalitate;
            else if (indexPath.row == 3) cell = cellAdresa;
            else if (indexPath.row == 4) cell = cellCodPostal;
            else if (indexPath.row == 5) cell = cellTipLocuinta;
            else if (indexPath.row == 6) cell = cellStructura;
            else if (indexPath.row == 7) cell = cellInaltime;
            else if (indexPath.row == 8){
                cell = cellEtaj; //int x = locuinta.etaj;
            }
            else if (indexPath.row == 9) cell = cellAnConstructie;
            else if (indexPath.row == 10) cell = cellNrCamere;
            else if (indexPath.row == 11) cell = cellSuprafata;
            else if (indexPath.row == 12) cell = cellNrLocatari;
            else if (indexPath.row == 13) cell = cellDescriereLocuinta;
            else cell = cellSC;
        }
        else
        {
            if (indexPath.row == 0) cell = cellHeader;
            else if (indexPath.row == 1) cell = cellInfoAlerte;
            else if (indexPath.row == 2) cell = cellJudetLocalitate;
            else if (indexPath.row == 3) cell = cellAdresa;
            else if (indexPath.row == 4) cell = cellCodPostal;
            else if (indexPath.row == 5) cell = cellTipLocuinta;
            else if (indexPath.row == 6) cell = cellStructura;
            else if (indexPath.row == 7) cell = cellInaltime;
            else if (indexPath.row == 8) cell = cellAnConstructie;
            else if (indexPath.row == 9) cell = cellNrCamere;
            else if (indexPath.row == 10) cell = cellSuprafata;
            else if (indexPath.row == 11) cell = cellNrLocatari;
            else if (indexPath.row == 12) cell = cellDescriereLocuinta;
            else cell = cellSC;
        }
    }
    else
    {
        if (indexPath.row == 0) cell = cellHeader;
        else if (indexPath.row == 1) cell = cellInfoAlerte;
        else if (indexPath.row == 2) cell = cellExpirareLoc;
        else cell = cellExpirareRataLoc;
    }
    
    if (indexPath.row % 2 != 0) {
        CGRect frame = CGRectMake(0, 0, 320, cell.frame.size.height);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row > 1 && !selectatInfoLocuinta) {
        if ( (indexPath.row == 2 && alertaLocuinta != nil) || (indexPath.row == 3 && alertaRataLoc != nil) )
            return YES;
    }
    return NO;
}

- (void) tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && !selectatInfoLocuinta)
    {
        if (indexPath.row == 2)
        {
            [alertaLocuinta deleteAlerta:NO];
            alertaLocuinta = nil;
            ((UITextField *)[cellExpirareLoc viewWithTag:2]).text = @"";
            ((UITextField *)[cellExpirareLoc viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
        }
        else if (indexPath.row == 3)
        {
            [alertaRataLoc deleteAlerta:NO];
            alertaRataLoc = nil;
            ((UITextField *)[cellExpirareRataLoc viewWithTag:2]).text = @"";
            ((UITextField *)[cellExpirareRataLoc viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
        }
    }
    
    [self btnEditShouldAppear];
    [tv reloadData];
}

- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //    [self doneEditing];
    //    if (indexPath.row == 3) {
    //        [self showListaJudete:indexPath];
    //    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];
    
    if (selectatInfoLocuinta)
    {
        NSLog (@"%d",indexPath.row);
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
            if (indexPath.row == 5) {
                [self showNomenclator];
            }else if (indexPath.row == 8)
            {
                [self showListaDescriereLocuinta:indexPath];
            }
        }else {
            if (indexPath.row == 2)
            {
                [self showListaJudete:indexPath];
            }
            else if (indexPath.row == 6) {
                [self showNomenclator];
            }
            else if (indexPath.row == 12)
            {
                if (faraEtaj == YES)
                    [self showListaDescriereLocuinta:indexPath];
            }
            else if (indexPath.row == 13)
            {
                if (faraEtaj == NO)
                    [self showListaDescriereLocuinta:indexPath];
            }
            else
            {
                UITableViewCell * cell = [tv cellForRowAtIndexPath:indexPath];
                UITextField * txt = (UITextField *)[cell viewWithTag:2];
                activeTextField = txt;
                [txt becomeFirstResponder];
            }
        }
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
    
    UIBarButtonItem *prevButton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"prev", [YTOUserDefaults getLanguage],@"Inapoi") style:UIBarButtonItemStyleBordered target:self action:@selector(prevEditing)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"next", [YTOUserDefaults getLanguage],@"Inainte") style:UIBarButtonItemStyleBordered target:self action:@selector(nextEditing)];
    
    
    int index = indexPath.row;
    NSArray *itemsArray = nil;
    if (index == 1 || index == 4 || index == 11 || index == 10) {
        prevButton.enabled = NO;
        nextButton.enabled = NO;
        prevButton.width = 0.01;
        nextButton.width = 0.01;
        
        itemsArray = [NSArray arrayWithObjects:prevButton, nextButton, flexButton1, doneButton, nil];
    }
    else {
        itemsArray = [NSArray arrayWithObjects:prevButton, nextButton, flexButton1, doneButton, nil];
    }
    
    [toolbar setItems:itemsArray];
    
    [activeTextField setInputAccessoryView:toolbar];
    if (selectatInfoLocuinta)
    {
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
            // In cazul in care tastatura este activa si se da back
            if (index == 2)
                [self showTooltip:@"Codul Postal necesar pentru produsul \"Casa mea\""];
            else if (index == 5)
            {
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@" mp" withString:@""];
                [self showTooltip:NSLocalizedStringFromTable(@"i398", [YTOUserDefaults getLanguage],@"Suprafata utila a locuintei in metri patrati")];
            }else if (index == 6)
            {
                [self showTooltip:NSLocalizedStringFromTable(@"i395", [YTOUserDefaults getLanguage],@"Anul constructiei imobilului")];
                ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
            }
        }else {
            
            int index = 0;
            if (indexPath != nil)
                index = indexPath.row;
            else
                index = textField.tag;
            
            if (index > 5  || index == 4)
            {
                [self addBarButton];
            }
            
            if (index == 3)     // Adresa
                [self showTooltip:NSLocalizedStringFromTable(@"i375", [YTOUserDefaults getLanguage],@"Adresa completa: strada, numar, bloc etc.")];
            if (index == 4)
                [self showTooltip:@"Codul Postal necesar pentru produsul \"Casa mea\""];
            if (faraEtaj == NO) {
                
                if (index == 7) // Nr. Etaje
                    [self showTooltip:NSLocalizedStringFromTable(@"i391", [YTOUserDefaults getLanguage],@"Numarul de etaje al imobilului / blocului")];
                else if (index == 8) // Etaj
                    [self showTooltip:NSLocalizedStringFromTable(@"i393", [YTOUserDefaults getLanguage],@"Etajul la care se afla locuinta")];
                else if (index == 9)
                {
                    [self showTooltip:NSLocalizedStringFromTable(@"i395", [YTOUserDefaults getLanguage],@"Anul constructiei imobilului")];
                    ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
                }
                else if (index == 11)
                {
                    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" mp" withString:@""];
                    [self showTooltip:NSLocalizedStringFromTable(@"i398", [YTOUserDefaults getLanguage],@"Suprafata utila a locuintei in metri patrati")];
                }
            }
            else {
                if (index == 7) // Nr. Etaje
                    [self showTooltip:NSLocalizedStringFromTable(@"i391", [YTOUserDefaults getLanguage],@"Numarul de etaje al imobilului / blocului")];
                else if (index == 8)
                {
                    [self showTooltip:NSLocalizedStringFromTable(@"i395", [YTOUserDefaults getLanguage],@"Anul constructiei imobilului")];
                    ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
                }
                else if (index == 10)
                {
                    textField.text = [textField.text stringByReplacingOccurrencesOfString:@" mp" withString:@""];
                    [self showTooltip:NSLocalizedStringFromTable(@"i398", [YTOUserDefaults getLanguage],@"Suprafata utila a locuintei in metri patrati")];
                }
            }
        }
    }
    else
    {
        // Daca nu a fost salvata locuinta, nu setam alerte
        if (!locuinta._isDirty)
            return;
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"i67", [YTOUserDefaults getLanguage],@"Salveaza") destructiveButtonTitle:nil otherButtonTitles:NSLocalizedStringFromTable(@"i66", [YTOUserDefaults getLanguage],@"Renunta"),nil];
        actionSheet.tag = indexPath.row;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
		UIDatePicker *datePicker = [[UIDatePicker alloc] init];
		datePicker.tag = 101;
		datePicker.datePickerMode = 1; // date and time view
		//datePicker.minimumDate = [NSDate date];
        datePicker.minimumDate = [[NSDate date] dateByAddingTimeInterval:86400];
        
        YTOAlerta * alerta;
        if (indexPath.row == 2)
            alerta = [YTOAlerta getAlertaLocuinta:locuinta.idIntern];
        else if (indexPath.row == 3)
            alerta = [YTOAlerta getAlertaRataLocuinta:locuinta.idIntern];
        
        if (alerta)
            [datePicker setDate:alerta.dataAlerta];
		[actionSheet addSubview:datePicker];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, 320, 215)];
     if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
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
    
    if (index == 2)
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:indexPath.section]
                         atScrollPosition:UITableViewScrollPositionTop animated:NO];
    else
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]
                         atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    // Daca nu a fost salvata masina, nu setam alerte
    if (!locuinta._isDirty && !selectatInfoLocuinta)
        return NO;
    
	activeTextField = textField;
	//tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
    
    //activeTextField.tag = indexPath.row;
    
	return YES;
}

-(void)doneEditing {
    tableView.tableFooterView = nil;
    [activeTextField resignFirstResponder];
    activeTextField = nil;
    [YTOUtils rightImageVodafone:self.navigationItem];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self deleteBarButton];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self doneEditing];
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [YTOUtils rightImageVodafone:self.navigationItem];
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideTooltip];
    [self hideTooltipAtentie];
    
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
     if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
         
    //keyboardFirstTimeActive = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    if (selectatInfoLocuinta)
    {
        // In cazul in care tastatura este activa si se da back
        if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
            int index = 0;
            if (indexPath != nil)
                index = indexPath.row;
            else
                index = textField.tag;
            if (index == 2)
            {
                if (textField!=nil)
                    [self setAdresa:textField.text];
            }
            if (index == 3)
            {
                if (textField!=nil)
                    [self setCodPostal:textField.text];
            }
            if (index == 6)
                [self setSuprafata:[textField.text intValue]];
            if (index == 7)
                [self setAnConstructie:[textField.text intValue]];

        }else {
            int index = 0;
            if (indexPath != nil)
                index = indexPath.row;
            else
                index = textField.tag;
            
            if (index == 2 || index == 3)
            {
                if (textField!=nil)
                    [self setAdresa:textField.text];
            }
            if (index == 4)
            {
                if (textField!=nil)
                    [self setCodPostal:textField.text];
            }
            else if (index == 7)
                [self setInaltime:[textField.text intValue]];
            
            if (!faraEtaj) {
                if (index == 8)
                    [self setEtaj:[textField.text intValue]];
                else if (index == 9)
                    [self setAnConstructie:[textField.text intValue]];
                else if (index == 11)
                    [self setSuprafata:[textField.text intValue]];
            }
            else {
                if (index == 8)
                    [self setAnConstructie:[textField.text intValue]];
                else if (index == 10)
                    [self setSuprafata:[textField.text intValue]];
                
            }
        }
    }
    else
    {
        
    }
    [self wasValidated];
}

-(void) nextEditing
{
    //    UITableViewCell *currentCell = (UITableViewCell *) [[activeTextField superview] superview];
    //    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    //	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index + 1 == fieldArray.count) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    
    id nextField = [fieldArray objectAtIndex:index + 1];
    
    if (![nextField isKindOfClass:[UITextField class]]) {
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self deleteBarButton];
        [activeTextField resignFirstResponder];
    }
    else
    {
        activeTextField = nextField;
        [nextField becomeFirstResponder];
    }
}

- (void) prevEditing
{
    //    UITableViewCell *currentCell = (UITableViewCell *) [[activeTextField superview] superview];
    //    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    //	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index == 0) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        return;
    }
    
    id prevField = [fieldArray objectAtIndex:index - 1];
    
    if (![prevField isKindOfClass:[UITextField class]]){
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [self deleteBarButton];
        [activeTextField resignFirstResponder];
    }
    else {
        activeTextField = prevField;
        [prevField becomeFirstResponder];
    }
    
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
	//self.navigationItem.rightBarButtonItem = nil;
    [YTOUtils rightImageVodafone:self.navigationItem];
    self.navigationItem.hidesBackButton = NO;
}

- (void) load:(YTOLocuinta *)p
{
    UIImageView * imgTextHeader = (UIImageView *)[cellHeader viewWithTag:1];
    imgTextHeader.image = [UIImage imageNamed:@"header-locuinta-salvata.png"];
    NSString * string1 = @"";
    NSString * string2 = @"";
    NSString * string;
    
    UILabel *lbl11 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel *lbl22 = (UILabel *) [cellHeader viewWithTag:22];
    
    string1 = NSLocalizedStringFromTable(@"i740", [YTOUserDefaults getLanguage],@"Informatii");
    string2 = NSLocalizedStringFromTable(@"i741", [YTOUserDefaults getLanguage],@"locuinta");
    lbl22.text = NSLocalizedStringFromTable(@"i736", [YTOUserDefaults getLanguage],@"poti modifica datele de mai jos");
    
    string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:albastruLocuinta] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:albastruLocuinta]];
    }
    
    [self setLocalitate:p.localitate];
    [self setJudet:p.judet];
    [self setAdresa:p.adresa];
    [self setCodPostal:p.codPostal];
    [self setTipLocuinta:p.tipLocuinta];
    [self setStructura:p.structuraLocuinta];
    [self setInaltime:p.regimInaltime];
    [self setEtaj:p.etaj];
    [self setAnConstructie:p.anConstructie];
    [self setNrCamere:p.nrCamere];
    [self setSuprafata:p.suprafataUtila];
    [self setNrLocatari:p.nrLocatari];
    
    [self setAlarma:p.areAlarma];
    [self setGrilajeGeam:p.areGrilajeGeam];
    [self setDetectieIncendiu:p.detectieIncendiu];
    [self setPaza:p.arePaza];
    [self setZonaIzolata:p.zonaIzolata];
    [self setLocuitPermananet:p.locuitPermanent];
    [self setClauzaFurtBunuri:p.clauzaFurtBunuri];
    [self setClauzaApaConducta:p.clauzaApaConducta];
    [self setTeren:p.areTeren];
    
    // PENTRU ALERTE
    alertaLocuinta = [YTOAlerta getAlertaLocuinta:locuinta.idIntern];
    if (alertaLocuinta)
        [self setAlerta:2 withDate:alertaLocuinta.dataAlerta savingData:NO];
    alertaRataLoc = [YTOAlerta getAlertaRataLocuinta:locuinta.idIntern];
    if (alertaRataLoc)
        [self setAlerta:3 withDate:alertaRataLoc.dataAlerta savingData:NO];
    
}

- (void) save
{
    if (goingBack)
    {
        
        if (locuinta._isDirty)
            [locuinta updateLocuinta:NO];
        else
        {
            NSLog(@"%.2f", [locuinta CompletedPercent]);
            if ([locuinta CompletedPercent] > percentCompletedOnLoad)
                [locuinta addLocuinta:NO];
        }
        
        if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
        {
            YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
            [parent setLocuinta:locuinta];
        }
        else if ([self.controller isKindOfClass:[YTOListaLocuinteViewController class]])
        {
            YTOListaLocuinteViewController * parent = (YTOListaLocuinteViewController *)self.controller;
            [parent reloadData];
        }
        else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]])
        {
            YTOAsigurareViewController * parent = (YTOAsigurareViewController *)self.controller;
            [parent setLocuinta:locuinta];
        } else if ([self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        {
            YTOCasaMeaViewController * parent = (YTOCasaMeaViewController *)self.controller;
            [parent setLocuinta:locuinta];
        }
    }
}

- (void) btnSave_Clicked
{
    [self doneEditing];
    
    [self save];
    
    // Am salvat o data, nu mai salvam pe viewWillDissapear
    shouldSave = NO;
    
    if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        //[parent setLocuinta:locuinta];
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOListaLocuinteViewController class]])
    {
        //YTOListaLocuinteViewController * parent = (YTOListaLocuinteViewController *)self.controller;
        //[parent reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOAsigurareViewController class]] || [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

- (void) btnCancel_Clicked
{
    // In cazul in care a modificat ceva si a apasat pe Cancel,
    // incarcam lista cu masini din baza de date
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate refreshLocuinte];
    
    shouldSave = NO;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showStructuraRezistenta:(NSIndexPath *)index;
{
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    //actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database MarciAuto]];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat"), NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton"),NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca"), NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida"), NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa"),NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata"), NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn"), NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn"), nil];
    actionPicker._indexPath = index;
    actionPicker.delegate = self;
    actionPicker.titlu = NSLocalizedStringFromTable(@"i380", [YTOUserDefaults getLanguage],@"STRUCTURA REZISTENTA");
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) showNomenclator
{
    [vwNomenclator setHidden:NO];
    UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = 0;
    
    [lblTitle setText:NSLocalizedStringFromTable(@"i381", [YTOUserDefaults getLanguage],@"Selecteaza structura de rezistenta")];
    _nomenclatorNrItems = structuriRezistenta.count;
    NSString *str = @"";
    NSString *p = locuinta.structuraLocuinta;
    if ([p isEqualToString:@"beton-armat"])
        str =  NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat");
    else if ([p isEqualToString:@"beton"])
        str = NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton");
    else if ([p isEqualToString:@"bca"])
        str =NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca");
    else if ([p isEqualToString:@"caramida"])
        str =NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida");
    else if ([p isEqualToString:@"caramida-nearsa"])
        str =NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa");
    else if ([p isEqualToString:@"chirpici-paiata"])
        str =NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata");
    else if ([p isEqualToString:@"lemn"])
        str =NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn");
    else if ([p isEqualToString:@"zidarie-lemn"])
        str =NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn");
    else str = p;
    
    
    
    selectedItemIndex = [YTOUtils getKeyList:structuriRezistenta forValue:str];
    
    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<structuriRezistenta.count; i++) {
        if (i != 0 && i%3==0)
        {
            rows++;
            cols = 0;
        }
        KeyValueItem * item = (KeyValueItem *)[structuriRezistenta objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"neselectat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selectat-locuinta.png"] forState:UIControlStateSelected];
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
        lbl.text = [item.value stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
        cols++;
        [button addSubview:lbl];
        if (i == selectedItemIndex)
            [button setSelected:YES];
        [scrollView addSubview:button];
        if ((!locuinta.structuraLocuinta || locuinta.structuraLocuinta.length == 0 || [locuinta.structuraLocuinta isEqualToString:@"chirpici-paiata"] || [locuinta.structuraLocuinta isEqualToString:@"lemn"] || [locuinta.structuraLocuinta isEqualToString:@"zidarie-lemn"] || [locuinta.structuraLocuinta isEqualToString:@"caramida-nearsa"]) && [self.controller isKindOfClass:[YTOCasaMeaViewController class]] && [item.value isEqualToString:@"beton-armat"]){
            [self btnNomenclator_Clicked:button];
        }
        if (!locuinta.structuraLocuinta || locuinta.structuraLocuinta.length == 0 )
        {
             [self btnNomenclator_Clicked:button];
        }
    }
    
    float height = [structuriRezistenta count]/3.0;
    [scrollView  setContentSize:CGSizeMake(279, height * 75)];
    
    self.navigationItem.hidesBackButton = YES;
}

- (IBAction) hideNomenclator
{
    [vwNomenclator setHidden:YES];
    
    self.navigationItem.hidesBackButton = NO;
}

- (IBAction) btnNomenclator_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    for (int i=100; i<=100+_nomenclatorNrItems; i++) {
        
        UIButton * _btn = (UIButton *)[scrollView viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    KeyValueItem * item = (KeyValueItem *)[structuriRezistenta objectAtIndex:btn.tag-100];
    [self setStructura:item.value];
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

- (void) showListaDescriereLocuinta:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithObjects:NSLocalizedStringFromTable(@"i555", [YTOUserDefaults getLanguage],@"Are alarma"), NSLocalizedStringFromTable(@"i556", [YTOUserDefaults getLanguage],@"Are grilaje geam"), NSLocalizedStringFromTable(@"i557", [YTOUserDefaults getLanguage],@"Are detectie incendiu"), NSLocalizedStringFromTable(@"i558", [YTOUserDefaults getLanguage],@"Are paza"), NSLocalizedStringFromTable(@"i559", [YTOUserDefaults getLanguage],@"Este intr-o zona izolata"), NSLocalizedStringFromTable(@"i560", [YTOUserDefaults getLanguage],@"Locuit permanent"), NSLocalizedStringFromTable(@"i561", [YTOUserDefaults getLanguage],@"Clauza furt bunuri"), NSLocalizedStringFromTable(@"i562", [YTOUserDefaults getLanguage],@"Clauza apa conducta"), NSLocalizedStringFromTable(@"i563", [YTOUserDefaults getLanguage],@"Are teren"), nil];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kDescriereLocuinta;
    actionPicker.delegate = self;
    actionPicker.titlu = NSLocalizedStringFromTable(@"i401", [YTOUserDefaults getLanguage],@"Descriere locuinta");
    actionPicker.listValoriMultipleIndecsi = [[NSMutableArray alloc] init];
    if ([locuinta.areAlarma isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 0]];
    if ([locuinta.areGrilajeGeam isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 1]];
    if ([locuinta.detectieIncendiu isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 2]];
    if ([locuinta.arePaza isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 3]];
    if ([locuinta.zonaIzolata isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 4]];
    if ([locuinta.locuitPermanent isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 5]];
    if ([locuinta.clauzaFurtBunuri isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 6]];
    if ([locuinta.clauzaApaConducta isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 7]];
    if ([locuinta.areTeren isEqualToString:@"da"])
        [actionPicker.listValoriMultipleIndecsi addObject:[NSString stringWithFormat:@"%d", 8]];
    
    [self presentModalViewController:actionPicker animated:YES];
}

-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch
{
    if (indexPath.row == 2) // JUDET + LOCALITATE
    {
        if (vwSearch.nomenclator == kJudete) {
            [self setJudet:selected];
        }
        else {
            [self setLocalitate:selected];
        }
    }
    else if (indexPath.row == 5) // Structura
    {
        [self setStructura:selected];
    }
    
    if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
        if (indexPath.row == 4)
            [self setStructura:selected];
    }
    
    goingBack = YES;
}

- (void) initCells
{
    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellLocuintaHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsHeader objectAtIndex:0];
    NSString * string1 = @"";
    NSString * string2 = @"";
    NSString * string;
    
    UILabel *lbl11 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel *lbl22 = (UILabel *) [cellHeader viewWithTag:22];
    
    string1 = NSLocalizedStringFromTable(@"i737", [YTOUserDefaults getLanguage],@"Locuinta");
    string2 = NSLocalizedStringFromTable(@"i738", [YTOUserDefaults getLanguage],@"noua");
    lbl22.text = NSLocalizedStringFromTable(@"i739", [YTOUserDefaults getLanguage],@"completeaza datele de mai jos");
    
    string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:albastruLocuinta] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:albastruLocuinta]];
    }
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:NSLocalizedStringFromTable(@"i61", [YTOUserDefaults getLanguage],@"JUDET,LOCALITATE LOCUINTA")];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    txtAdresa = (UITextField *)[cellAdresa viewWithTag:2];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:NSLocalizedStringFromTable(@"i62", [YTOUserDefaults getLanguage],@"ADRESA")];
    [(UITextField *)[cellAdresa viewWithTag:2] setKeyboardType:UIKeyboardTypeDefault];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    
    NSArray *topLevelObjectsCodPostal = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCodPostal = [topLevelObjectsCodPostal objectAtIndex:0];
    txtCodPostal = (UITextField *)[cellCodPostal viewWithTag:2];
    [(UILabel *)[cellCodPostal viewWithTag:1] setText:@"COD POSTAL"];
    [(UITextField *)[cellCodPostal viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellCodPostal];
    
    NSArray *topLevelObjectsStructura = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellStructura = [topLevelObjectsStructura objectAtIndex:0];
    [(UILabel *)[cellStructura viewWithTag:1] setText:NSLocalizedStringFromTable(@"i118", [YTOUserDefaults getLanguage],@"STRUCTURA REZISTENTA")];
    [YTOUtils setCellFormularStyle:cellStructura];
    
    NSArray *topLevelObjectsInaltime = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellInaltime = [topLevelObjectsInaltime objectAtIndex:0];
    txtInaltime = (UITextField *)[cellInaltime viewWithTag:2];
    [(UILabel *)[cellInaltime viewWithTag:1] setText:NSLocalizedStringFromTable(@"i390", [YTOUserDefaults getLanguage],@"INALTIMEA CLADIRII (NR. ETAJE)")];
    [(UITextField *)[cellInaltime viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellInaltime viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellInaltime];
    
    NSArray *topLevelObjectsEtaj = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellEtaj = [topLevelObjectsEtaj objectAtIndex:0];
    txtEtaj = (UITextField *)[cellEtaj viewWithTag:2];
    [(UILabel *)[cellEtaj viewWithTag:1] setText:NSLocalizedStringFromTable(@"i392", [YTOUserDefaults getLanguage],@"ETAJ")];
    [(UITextField *)[cellEtaj viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEtaj viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellEtaj];
    
    NSArray *topLevelObjectsAnConstructie = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellAnConstructie = [topLevelObjectsAnConstructie objectAtIndex:0];
    txtAnConstructie = (UITextField *)[cellAnConstructie viewWithTag:2];
    [(UILabel *)[cellAnConstructie viewWithTag:1] setText:NSLocalizedStringFromTable(@"i394", [YTOUserDefaults getLanguage],@"AN CONSTRUCTIE (> 1950)")];
    [(UITextField *)[cellAnConstructie viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellAnConstructie viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellAnConstructie];
    
    NSArray *topLevelObjectsNrCamere = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrCamere = [topLevelObjectsNrCamere objectAtIndex:0];
    [(UILabel *)[cellNrCamere viewWithTag:1] setText:NSLocalizedStringFromTable(@"i396", [YTOUserDefaults getLanguage],@"NUMAR CAMERE")];
    UIStepper * stepperNrCamere = (UIStepper *)[cellNrCamere viewWithTag:3];
    ((UIImageView *)[cellNrCamere viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    stepperNrCamere.value = 2;
    stepperNrCamere.minimumValue = 1;
    stepperNrCamere.maximumValue = 10;
    [stepperNrCamere addTarget:self action:@selector(nrCamere_Changed:) forControlEvents:UIControlEventValueChanged];
    [YTOUtils setCellFormularStyle:cellNrCamere];
    
    
    NSArray *topLevelObjectsSuprafata = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSuprafata = [topLevelObjectsSuprafata objectAtIndex:0];
    [(UILabel *)[cellSuprafata viewWithTag:1] setText:NSLocalizedStringFromTable(@"i397", [YTOUserDefaults getLanguage],@"SUPRAFATA (MP)")];
    txtSuprafata = (UITextField *)[cellSuprafata viewWithTag:2];
    [(UITextField *)[cellSuprafata viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSuprafata viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSuprafata];
    
    NSArray *topLevelObjectsNrLocatari = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrLocatari = [topLevelObjectsNrLocatari objectAtIndex:0];
    [(UILabel *)[cellNrLocatari viewWithTag:1] setText:NSLocalizedStringFromTable(@"i399", [YTOUserDefaults getLanguage],@"NUMAR LOCATARI")];
    UIStepper * stepperNrLocatari = (UIStepper *)[cellNrLocatari viewWithTag:3];
    ((UIImageView *)[cellNrLocatari viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    stepperNrLocatari.value = 2;
    stepperNrLocatari.minimumValue = 1;
    stepperNrLocatari.maximumValue = 10;
    [stepperNrLocatari addTarget:self action:@selector(nrLocatari_Changed:) forControlEvents:UIControlEventValueChanged];
    [YTOUtils setCellFormularStyle:cellNrLocatari];
    
    NSArray *topLevelObjectsDescrLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellDescriereLocuinta = [topLevelObjectsDescrLocuinta objectAtIndex:0];
    [(UILabel *)[cellDescriereLocuinta viewWithTag:1] setText:NSLocalizedStringFromTable(@"i400", [YTOUserDefaults getLanguage],@"ALTE INFORMATII")];
    [YTOUtils setCellFormularStyle:cellDescriereLocuinta];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];
    UILabel * lblSave = (UILabel *) [cellSC viewWithTag:4];
    UILabel * lblCancel = (UILabel *) [cellSC viewWithTag:3];
    lblSave.text = NSLocalizedStringFromTable(@"i67", [YTOUserDefaults getLanguage],@"Salveaza");
    lblCancel.text = NSLocalizedStringFromTable(@"i66", [YTOUserDefaults getLanguage],@"Renunta");
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    // CELLS ALERTE
    NSArray *topLevelObjectsAlertaLoc = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareLoc = [topLevelObjectsAlertaLoc objectAtIndex:0];
    [(UILabel *)[cellExpirareLoc viewWithTag:1] setText:NSLocalizedStringFromTable(@"i411", [YTOUserDefaults getLanguage],@"LOCUINTA")];
    txtAlertaLocuinta = (UITextField *)[cellExpirareLoc viewWithTag:2];
    [(UITextField *)[cellExpirareLoc viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareLoc viewWithTag:2] setPlaceholder:NSLocalizedStringFromTable(@"i413", [YTOUserDefaults getLanguage],@"selecteaza mai jos datele de expirare")];
    ((UITextField *)[cellExpirareLoc viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareLoc viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-locuinta.png"];
    [YTOUtils setCellFormularStyle:cellExpirareLoc];
    
    NSArray *topLevelObjectsAlertaRataLoc = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareRataLoc = [topLevelObjectsAlertaRataLoc objectAtIndex:0];
    [(UILabel *)[cellExpirareRataLoc viewWithTag:1] setText:NSLocalizedStringFromTable(@"i412", [YTOUserDefaults getLanguage],@"RATA SCADENTA LOCUINTA")];
    txtAlertaRataLocuinta = (UITextField *)[cellExpirareRataLoc viewWithTag:2];
    [(UITextField *)[cellExpirareRataLoc viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareRataLoc viewWithTag:2] setPlaceholder:NSLocalizedStringFromTable(@"i413", [YTOUserDefaults getLanguage],@"selecteaza mai jos datele de expirare")];
    ((UITextField *)[cellExpirareRataLoc viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareRataLoc viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-rata-locuinta.png"];
    [YTOUtils setCellFormularStyle:cellExpirareRataLoc];
    
    if ([locuinta.tipLocuinta isEqualToString:@"apartament-in-bloc"] || !locuinta.tipLocuinta)
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtAdresa,txtCodPostal,@"x",@"x", txtInaltime, txtEtaj, txtAnConstructie,@"x", txtSuprafata, nil];
    else
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtAdresa,txtCodPostal,@"x",@"x", txtInaltime, txtAnConstructie,@"x", txtSuprafata, nil];
    
      if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]]){
          fieldArray = [[NSMutableArray alloc] initWithObjects :txtCodPostal,@"x",@"x", txtSuprafata, txtAnConstructie, nil];
      }
}

- (IBAction)nrLocatari_Changed:(id)sender
{
    // inchidem tastatura
    [self doneEditing];
    
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrLocatari:stepper.value];
}

- (IBAction)nrCamere_Changed:(id)sender
{
    // inchidem tastatura
    [self doneEditing];
    
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrCamere:stepper.value];
}

- (IBAction)btnTipLocuinta_Clicked:(id)sender
{
    // inchidem tastatura
    [self doneEditing];
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[cellTipLocuinta viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (btn.tag == 1) {
        [self setTipLocuinta:@"apartament-in-bloc"];
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtAdresa,@"x",@"x", txtInaltime, txtEtaj, txtAnConstructie,@"x", txtSuprafata, nil];
        faraEtaj = NO;
        [tableView reloadData];
    }
    else if (btn.tag == 2) {
        [self setTipLocuinta:@"casa-vila-comuna"];
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtAdresa,@"x",@"x", txtInaltime, txtAnConstructie,@"x", txtSuprafata, nil];
        faraEtaj = YES;
        [tableView reloadData];
    }
    else if (btn.tag ==3) {
        [self setTipLocuinta:@"casa-vila-individuala"];
        fieldArray = [[NSMutableArray alloc] initWithObjects:txtAdresa,@"x",@"x", txtInaltime, txtAnConstructie,@"x", txtSuprafata, nil];
        faraEtaj = YES;
        [tableView reloadData];
    }
    
    //    YTOLocuinta * loc = [[YTOLocuinta alloc] init];
    //    if (isOK == YES) loc.isOK = YES;
    
}

- (void) setAdresa:(NSString *)p
{
    locuinta.adresa = p;
    UILabel * lbl = (UILabel *)[cellAdresa viewWithTag:2];
    lbl.text = p;
}

- (void) setCodPostal:(NSString *)p
{
    locuinta.codPostal = p;
    UILabel * lbl = (UILabel *)[cellCodPostal viewWithTag:2];
    lbl.text = p;
}

- (NSString *) getJudet
{
    return locuinta.judet;
}
- (void) setJudet:(NSString *)judet
{
    locuinta.judet = judet;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
}

- (NSString *) getLocalitate
{
    return locuinta.localitate;
}
- (void) setLocalitate:(NSString *)localitate
{
    locuinta.localitate = localitate;
}

- (NSString *) getLocatie
{
    if ([self getJudet].length == 0 && [self getLocalitate].length ==0)
        return @"";
    return [NSString stringWithFormat:@"%@, %@", [self getJudet], [self getLocalitate]];
}

- (void) setTipLocuinta:(NSString *)p
{
    if ([p isEqualToString:@"apartament-in-bloc"])
        ((UIButton *)[cellTipLocuinta viewWithTag:1]).selected = YES;
    else if ([p isEqualToString:@"casa-vila-comuna"])
        ((UIButton *)[cellTipLocuinta viewWithTag:2]).selected = YES;
    else if ([p isEqualToString:@"casa-vila-individuala"])
        ((UIButton *)[cellTipLocuinta viewWithTag:3]).selected = YES;
    locuinta.tipLocuinta = p;
    [self wasValidated];
}

- (void) setStructura:(NSString *)p
{
    //locuinta.structuraLocuinta = p;
    UILabel * lbl = (UILabel *)[cellStructura viewWithTag:2];
    NSString *str = @"";
    if ([p isEqualToString: NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat")])
        str = @"beton-armat";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton")])
        str =@"beton";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca")])
        str =@"bca";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida")])
        str =@"caramida";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa")])
        str =@"caramida-nearsa";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata")])
        str =@"chirpici-paiata";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn")])
        str =@"lemn";
    else if ([p isEqualToString:NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn")])
        str =@"zidarie-lemn";
    lbl.text = p;
    if ([str isEqualToString:@""]){
        if ([p isEqualToString:@"beton-armat"])
            str =  NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat");
        else if ([p isEqualToString:@"beton"])
            str = NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton");
        else if ([p isEqualToString:@"bca"])
            str =NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca");
        else if ([p isEqualToString:@"caramida"])
            str =NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida");
        else if ([p isEqualToString:@"caramida-nearsa"])
            str =NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa");
        else if ([p isEqualToString:@"chirpici-paiata"])
            str =NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata");
        else if ([p isEqualToString:@"lemn"])
            str =NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn");
        else if ([p isEqualToString:@"zidarie-lemn"])
            str =NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn");
        
        lbl.text = str;
    }
    
    
    locuinta.structuraLocuinta = str;
}

- (void) setInaltime:(int)p
{
    UITextField * txt = (UITextField *)[cellInaltime viewWithTag:2];
    //    if (p > 0) {
    locuinta.regimInaltime = p;
    txt.text = [NSString stringWithFormat:@"%d", p];
    //   }
    // else locuinta.regimInaltime = 0;
}
- (void) setEtaj:(int)p
{
    UIImageView * imgAlert = (UIImageView *)[cellEtaj viewWithTag:10];
    UITextField * txt = (UITextField *)[cellEtaj viewWithTag:2];
    if (p > 0) {
        
        locuinta.etaj = p;
        txt.text = [NSString stringWithFormat:@"%d", p];
        if (p <= locuinta.regimInaltime)
            [imgAlert setHidden:YES];
        else
            [imgAlert setHidden:NO];
        
    }
    else locuinta.etaj = 0;
    
}
- (void) setAnConstructie:(int)p
{
    UIImageView * imgAlert = (UIImageView *)[cellAnConstructie viewWithTag:10];
    UITextField * txt = (UITextField *)[cellAnConstructie viewWithTag:2];
    if (p > 0)
    {
        locuinta.anConstructie = p;
        
        txt.text = [NSString stringWithFormat:@"%d", p];
        
        if (p > 1950 && p <= [YTOUtils getAnCurent] + 1)
            [imgAlert setHidden:YES];
        else
            [imgAlert setHidden:NO];
    }
    else locuinta.anConstructie = 0;
    
}

- (void) setNrCamere:(int)p
{
    if (p > 0)
    {
        locuinta.nrCamere = p;
        UITextField * txt = (UITextField *)[cellNrCamere viewWithTag:2];
        txt.text = [NSString stringWithFormat:@"%d", p];
    }
}
- (void) setSuprafata:(int)p
{
    if (p>0)
    {
        locuinta.suprafataUtila = p;
        //UITextField * txt = (UITextField *)[cellSuprafata viewWithTag:2];
        txtSuprafata.text = [NSString stringWithFormat:@"%d mp", p];
    }
    else locuinta.suprafataUtila = 0;
}

- (void) setNrLocatari:(int)p
{
    locuinta.nrLocatari = p;
    UITextField * txt = (UITextField *)[cellNrLocatari viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];
}

- (void) setAlarma:(NSString *)v
{
    locuinta.areAlarma = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i402", [YTOUserDefaults getLanguage],@"Are alarma"), @"| "];
    if ([locuinta.areAlarma isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.areAlarma isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setGrilajeGeam:(NSString *)v
{
    locuinta.areGrilajeGeam = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i403", [YTOUserDefaults getLanguage],@"Are grilaje geam"), @"| "];
    if ([locuinta.areGrilajeGeam isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.areGrilajeGeam isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setDetectieIncendiu:(NSString *)v
{
    locuinta.detectieIncendiu = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i404", [YTOUserDefaults getLanguage],@"Are detectie incendiu"), @"| "];
    if ([locuinta.detectieIncendiu isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.detectieIncendiu isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setPaza:(NSString *)v
{
    locuinta.arePaza = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i405", [YTOUserDefaults getLanguage],@"Are paza"), @"| "];
    if ([locuinta.arePaza isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.arePaza isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setTeren:(NSString *)v
{
    locuinta.areTeren = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i410", [YTOUserDefaults getLanguage],@"Are teren"), @"| "];
    if ([locuinta.areTeren isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.areTeren isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setZonaIzolata:(NSString*)v
{
    locuinta.zonaIzolata = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i406", [YTOUserDefaults getLanguage],@"Este intr-o zona izolata"), @"| "];
    if ([locuinta.zonaIzolata isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.zonaIzolata isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}

- (void) setLocuitPermananet:(NSString *)v
{
    locuinta.locuitPermanent = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i560", [YTOUserDefaults getLanguage],@"Locuit permanent"), @"| "];
    if ([locuinta.locuitPermanent isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.locuitPermanent isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}
- (void) setClauzaFurtBunuri:(NSString *)v
{
    locuinta.clauzaFurtBunuri = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i561", [YTOUserDefaults getLanguage],@"Clauza furt bunuri"), @"| "];
    if ([locuinta.clauzaFurtBunuri isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.clauzaFurtBunuri isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
}
- (void) setClauzaApaConducta:(NSString *)v
{
    locuinta.clauzaApaConducta = v;
    
    UILabel * lbl = (UILabel *)[cellDescriereLocuinta viewWithTag:2];
    NSString * descr = lbl.text;
    NSString *str = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i562", [YTOUserDefaults getLanguage],@"Clauza apa conducta"), @"| "];
    if ([locuinta.clauzaApaConducta isEqualToString:@"da"] && [descr rangeOfString:str].location != 0)
        descr = [descr stringByAppendingString:str];
    else if (![locuinta.clauzaApaConducta isEqualToString:@"da"])
        descr = [descr stringByReplacingOccurrencesOfString:str withString:@""];
    
    lbl.text = descr;
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

- (void) loadStructuriRezistenta
{
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat");
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton");
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value =NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca");
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida");
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa");
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 5;
    c6.value = NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata");
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 6;
    c7.value = NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn");
    
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 1;
    c8.key = 7;
    c8.value = NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn");
    
    if ( [self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        structuriRezistenta = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4, nil];
    else structuriRezistenta = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7,c8, nil];
}

#pragma mark Action Sheet Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 0 = apasa Reunt
    // 1 = apasa Salveaza
    if (buttonIndex == 1)
    {
        UIDatePicker *datePickerPermis = (UIDatePicker *)[actionSheet viewWithTag:101];
        if (datePickerPermis) {
            [self setAlerta:actionSheet.tag withDate:datePickerPermis.date savingData:YES];
        }
        [activeTextField resignFirstResponder];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    [self doneEditing];
}

- (void) setAlerta:(int)index withDate:(NSDate *)data savingData:(BOOL)toSave
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MM.yyyy";
    
    NSString *timestamp = [formatter stringFromDate:data];
    YTOAlerta * alerta;
    int tipAlerta=0;
    
    UITextField * txt;
    
    if (index == 2)
    {
        tipAlerta = 6;
        txt = txtAlertaLocuinta;
    }
    else if (index == 3)
    {
        tipAlerta = 8;
        txt = txtAlertaRataLocuinta;
    }
    
    if (txt)
    {
        txt.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0];
        txt.text = timestamp;
    }
    
    alerta = [YTOAlerta getAlerta:locuinta.idIntern forType:tipAlerta];
    if (alerta == nil)
        alerta = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
    
    alerta.idObiect = locuinta.idIntern;
    alerta.tipAlerta = tipAlerta;
    alerta.esteRata = (tipAlerta == 8 ? @"da" : @"nu");
    alerta.dataAlerta = data;
    
    if (toSave)
    {
        if (alerta._isDirty)
            [alerta updateAlerta:NO];
        else
            [alerta addAlerta:NO];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setAlerteBadge];
        
        if (index == 2)
            alertaLocuinta = alerta;
        else if (index == 3)
            alertaRataLoc = alerta;
    }
    
    [self btnEditShouldAppear];
}

#pragma INFO || ALERTE
- (IBAction)btnInfoAlerte_OnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL esteInfoLocuinta = btn.tag == 1;
    
    [self doneEditing];
    
    UILabel *lblInfoLocuinta = (UILabel *)[cellInfoAlerte viewWithTag:3];
    UILabel *lblAlerte = (UILabel *)[cellInfoAlerte viewWithTag:4];
    UIImageView * imgInfoAlerte = (UIImageView *)[cellInfoAlerte viewWithTag:5];
    
    // Daca nu a fost salvata masina, nu setam alerte
    if ([locuinta CompletedPercent] <= percentCompletedOnLoad)
    {
        vwPopup.hidden = NO;
        return;
    }
    NSString * string1 = @"";
    NSString * string2 = @"";
    NSString * string;
    
    UILabel *lbl11 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel *lbl22 = (UILabel *) [cellHeader viewWithTag:22];
    if (!esteInfoLocuinta)
    {
        selectatInfoLocuinta = NO;
        lblInfoLocuinta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblAlerte.textColor = [UIColor whiteColor];
        imgInfoAlerte.image = [UIImage imageNamed:@"selectat-dreapta-locuinta.png"];
        string1 = NSLocalizedStringFromTable(@"i752", [YTOUserDefaults getLanguage],@"Alerte");
        string2 = NSLocalizedStringFromTable(@"i753", [YTOUserDefaults getLanguage],@"pentru locuinta");
        lbl22.text = NSLocalizedStringFromTable(@"i754", [YTOUserDefaults getLanguage],@"selecteaza mai jos datele de expirare");
        
        ((UIImageView *)[cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"header-locuinta-alerte.png"];
        [self save];
    }
    else
    {
        selectatInfoLocuinta = YES;
        lblInfoLocuinta.textColor = [UIColor whiteColor];
        lblAlerte.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        imgInfoAlerte.image = [UIImage imageNamed:@"selectat-stanga-locuinta.png"];
        if (locuinta._isDirty){
            ((UIImageView *)[cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"header-locuinta-salvata.png"];
            string1 = NSLocalizedStringFromTable(@"i740", [YTOUserDefaults getLanguage],@"Informatii");
            string2 = NSLocalizedStringFromTable(@"i741", [YTOUserDefaults getLanguage],@"locuinta");
            lbl22.text = NSLocalizedStringFromTable(@"i739", [YTOUserDefaults getLanguage],@"completeaza datele de mai jos");
        }
        else{
            ((UIImageView *)[cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"header-locuinta.png"];
            string1 = NSLocalizedStringFromTable(@"i737", [YTOUserDefaults getLanguage],@"Locuinta");
            string2 = NSLocalizedStringFromTable(@"i738", [YTOUserDefaults getLanguage],@"noua");            lbl22.text = NSLocalizedStringFromTable(@"i742", [YTOUserDefaults getLanguage],@"poti modifica datele de mai jos");
        }
    }
    string = [NSString stringWithFormat:@"%@ %@" , string1,string2 ];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:albastruLocuinta] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:albastruLocuinta]];
    }
    
    lbl11.adjustsFontSizeToFitWidth = YES;
    
    
    [tableView reloadData];
    
    [self btnEditShouldAppear];
}

-(IBAction)hidePopup
{
    vwPopup.hidden = YES;
}

- (void) btnEditShouldAppear
{
    if (!selectatInfoLocuinta && (alertaLocuinta != nil || alertaRataLoc != nil))
    {
        UIBarButtonItem *btnEdit;
        if (editingMode)
            btnEdit = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                       style:UIBarButtonItemStylePlain
                                                      target:self
                                                      action:@selector(callEditItems)];
        else
            btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
    }
    else
    {
        //self.navigationItem.rightBarButtonItem = nil;
        [YTOUtils rightImageVodafone:self.navigationItem];
    }
}

- (void) callEditItems
{
    if (!editingMode)
    {
        editingMode = YES;
        [tableView setEditing:YES];
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnDone;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
    }
    else
    {
        editingMode = NO;
        [tableView setEditing:NO];
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
    }
}

@end
