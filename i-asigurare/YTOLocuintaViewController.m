//
//  YTOLocuintaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/1/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOLocuintaViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOCasaViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOWebServiceLocuintaViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"

@interface YTOLocuintaViewController ()

@end

@implementation YTOLocuintaViewController

@synthesize DataInceput = _DataInceput;
@synthesize asigurat, locuinta;
@synthesize isWrongLoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i446", [YTOUserDefaults getLanguage],@"Calculator");
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
    }
    //self.trackedViewName = @"YTOLocuintaViewController";
    
    lblModEvaluare.text = NSLocalizedStringFromTable(@"i88", [YTOUserDefaults getLanguage],@"Modul de evaluare");
    lblEvalBanca.text = NSLocalizedStringFromTable(@"i52", [YTOUserDefaults getLanguage],@"Evaluare\nbanca");
    lblValInloc.text = NSLocalizedStringFromTable(@"i49", [YTOUserDefaults getLanguage],@"Valoare\ninlocuire");
    lblValPiata.text = NSLocalizedStringFromTable(@"i51", [YTOUserDefaults getLanguage],@"Valoare\npiata");
    lblValReala.text = NSLocalizedStringFromTable(@"i195", [YTOUserDefaults getLanguage],@"Valoare\nreala");
    
    [self setCesiune:@"nu"];
    [self initCells];
    [self initCustomValues];
    
     [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    isWrongLoc = NO;
    
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) initCustomValues
{
    cautLegaturaDintreAsiguratSiLocuinta = YES;
    
    oferta = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
    oferta.moneda = @"eur";
    [self setModEvaluare:@"valoare-reala"];
    
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
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 75;
    else if (indexPath.row == 3)
        return 100;
    else if (indexPath.row == 6)
        return 47;
    return 67;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellLocuinta;
    else if (indexPath.row == 2) cell = cellProprietar;
    else if (indexPath.row == 3) cell = cellModEvaluare;
    else if (indexPath.row == 4) cell = cellSumaAsigurata;
    else if (indexPath.row == 5) cell = cellSumaAsigurataRC;
    else if (indexPath.row == 6) cell = cellCesionareBanca;
    else if (indexPath.row == 7) cell = cellDataInceput;
    else if (indexPath.row == 8) cell = cellCalculeaza;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];    
    if (indexPath.row == 1)
    {
        [self doneEditing];
        // Daca exista locuinte salvate, afisam lista
        if ((isWrongLoc && locuinta==nil) || !isWrongLoc)
        {
            if ([delegate Locuinte].count > 0)
            {
                YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
                aView.controller = self;
                [delegate.rcaNavigationController pushViewController:aView animated:YES];
            }
            else {
                YTOCasaViewController * aView;
                if (IS_IPHONE_5)
                    aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
                else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
                aView.controller = self;
                [delegate.rcaNavigationController pushViewController:aView animated:YES];
            }
        }else if (isWrongLoc && locuinta!=nil )
        {
            YTOCasaViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController_R4" bundle:nil];
            else aView = [[YTOCasaViewController alloc] initWithNibName:@"YTOCasaViewController" bundle:nil];
            aView.controller = self;
            aView.locuinta = locuinta;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        [self doneEditing];
        // Daca exista persoane salvate, afisam lista
        if ([delegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
            else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
            aView.controller = self;
            aView.produsAsigurare  = Locuinta;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.controller = self;
            aView.proprietar = YES;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 8)
    {
        //if (locuinta.idIntern.length == 0 || asigurat.idIntern.length == 0)
           // return;
        
        //BOOL isOK = YES;
        
        if (![locuinta isValidForLocuinta])
        {
            UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            //isOK = NO;
            isWrongLoc = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        
        if (![asigurat isValidForCompute])
        {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            //isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        if (locuinta.sumaAsigurata < 10000) {
            [(UITextField *)[cellSumaAsigurata viewWithTag:2] becomeFirstResponder];
            return;
        }
        //if (!isOK)
            //return;
        
        oferta.tipAsigurare = 3;
        oferta.idAsigurat = asigurat.idIntern;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:locuinta.idIntern, nil];
        oferta.numeAsigurare = [NSString stringWithFormat:@"Locuinta, %d mp", locuinta.suprafataUtila];
        
        locuinta.idProprietar = asigurat.idIntern;
        if (locuinta.CompletedPercent < 1)
            [locuinta updateLocuinta:NO];
        
        YTOWebServiceLocuintaViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOWebServiceLocuintaViewController alloc] initWithNibName:@"YTOWebServiceLocuintaViewController_R4" bundle:nil];
        else aView = [[YTOWebServiceLocuintaViewController alloc] initWithNibName:@"YTOWebServiceLocuintaViewController" bundle:nil];
        aView.oferta = oferta;
        aView.locuinta = locuinta;
        aView.asigurat = asigurat;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row == 4 || indexPath.row == 5)
    {
        [self addBarButton];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@".00 EUR" withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" LEI" withString:@""];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
    //	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row == 4)
        [self setSumaAsigurata:textField.text];
    else if (indexPath.row == 5)
        [self setSumaAsigurataRC:textField.text];
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
	//self.navigationItem.rightBarButtonItem = nil;
     [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    NSLog(@"Language %@",[YTOUserDefaults getLanguage]);
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-locuinte-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en:"])
        img.image = [UIImage imageNamed:@"asig-locuinte-en.png"];
    else img.image = [UIImage imageNamed:@"asig-locuinte"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    lbl1.text = NSLocalizedStringFromTable(@"i785", [YTOUserDefaults getLanguage],@"Asigurare locuinta");
    lbl2.text = NSLocalizedStringFromTable(@"i771", [YTOUserDefaults getLanguage],@"● Tarife direct de la companii");
    lbl3.text = NSLocalizedStringFromTable(@"i775", [YTOUserDefaults getLanguage],@"● Livrare electronica in 5 minute");
    cellHeader.userInteractionEnabled = NO;
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl3.adjustsFontSizeToFitWidth = YES;
    
    NSArray *topLevelObjectsLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellLocuinta = [topLevelObjectsLocuinta objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = NSLocalizedStringFromTable(@"i70", [YTOUserDefaults getLanguage],@"Alege locuinta");
    UIImageView * img2 = (UIImageView *)[cellLocuinta viewWithTag:4];
    img2.image = [UIImage imageNamed:@"icon-foto-casa.png"];
    UIImageView * bg = (UIImageView *)[cellLocuinta viewWithTag:5];
    bg.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    UILabel * lblCell1 = (UILabel *)[cellLocuinta viewWithTag:6];
    lblCell1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell1.text = NSLocalizedStringFromTable(@"i77", [YTOUserDefaults getLanguage],@"LOCUINTA ASIGURATA");

    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = NSLocalizedStringFromTable(@"i148", [YTOUserDefaults getLanguage],@"Alege Persoana");
    UIImageView * bg2 = (UIImageView *)[cellProprietar viewWithTag:5];
    bg2.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    UILabel * lblCell2 = (UILabel *)[cellProprietar viewWithTag:6];
    lblCell2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell2.text = NSLocalizedStringFromTable(@"i86", [YTOUserDefaults getLanguage],@"PROPRIETAR LOCUINTA");

    
    NSArray *topLevelObjectsSA = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSumaAsigurata = [topLevelObjectsSA objectAtIndex:0];
    [(UILabel *)[cellSumaAsigurata viewWithTag:1] setText:NSLocalizedStringFromTable(@"i47", [YTOUserDefaults getLanguage],@"Suma asigurata (minim 10000 EUR)")];
//    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSumaAsigurata];
    
    NSArray *topLevelObjectsSARC = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSumaAsigurataRC = [topLevelObjectsSARC objectAtIndex:0];
    [(UILabel *)[cellSumaAsigurataRC viewWithTag:1] setText:NSLocalizedStringFromTable(@"i48", [YTOUserDefaults getLanguage],@"Suma asigurata raspundere civila (EUR)")];
    //    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSumaAsigurataRC];
    
    NSArray *topLevelObjectsCesiune = [[NSBundle mainBundle] loadNibNamed:@"CellView_DaNuCesiune" owner:self options:nil];
    cellCesionareBanca = [topLevelObjectsCesiune objectAtIndex:0];
    [(UILabel *)[cellCesionareBanca viewWithTag:6] setText:NSLocalizedStringFromTable(@"i814", [YTOUserDefaults getLanguage],@"olita este cesionata\nin favoarea bancii")];
    UIButton * btnCesiuneDa = (UIButton *)[cellCesionareBanca viewWithTag:1];
    UILabel *lblCesiuneDa = (UILabel *) [cellCesionareBanca viewWithTag:3];
    lblCesiuneDa.text = NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA");
    [btnCesiuneDa addTarget:self action:@selector(btnCesiune_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnCesiuneNu = (UIButton *)[cellCesionareBanca viewWithTag:2];
    UILabel *lblCesiuneNu = (UILabel *) [cellCesionareBanca viewWithTag:4];
    lblCesiuneNu.text = NSLocalizedStringFromTable(@"i344", [YTOUserDefaults getLanguage],@"NU");
    [btnCesiuneNu addTarget:self action:@selector(btnCesiune_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = NSLocalizedStringFromTable(@"i127", [YTOUserDefaults getLanguage],@"Data inceput");
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    ((UIImageView *)[cellDataInceput viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged];
    [YTOUtils setCellFormularStyle:cellDataInceput];

    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * img3 = (UIImageView *)[cellCalculeaza viewWithTag:1];
    img3.image = [UIImage imageNamed:@"calculeaza-locuinta.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i128", [YTOUserDefaults getLanguage],@"Calculeaza");
}

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

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellProprietar viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];    

    if (a.nume)
        lblCellP.text = a.nume;
    if (a.codUnic && a.judet)
        ((UILabel *)[cellProprietar viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    asigurat = a;

    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:locuinta.idProprietar])
    {
        YTOLocuinta * _loc = [YTOLocuinta getLocuintaByProprietar:a.idIntern];
        if (_loc && _loc.idIntern && cautLegaturaDintreAsiguratSiLocuinta)
        {
            [self setLocuinta:_loc];
            cautLegaturaDintreAsiguratSiLocuinta = NO;
        }
    }
}

- (void) setLocuinta:(YTOLocuinta *) a
{
    UILabel * lblCellP = ((UILabel *)[cellLocuinta viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if ([a.tipLocuinta isEqualToString:@"apartament-in-bloc"])
        lblCellP.text = NSLocalizedStringFromTable(@"i377", [YTOUserDefaults getLanguage],@"Apartament in bloc");
    else if ([a.tipLocuinta isEqualToString:@"casa-vila-comuna"])
        lblCellP.text = NSLocalizedStringFromTable(@"i378", [YTOUserDefaults getLanguage],@"Casa - vila comuna");
    else if ([a.tipLocuinta isEqualToString:@"casa-vila-individuala"])
        lblCellP.text = NSLocalizedStringFromTable(@"i379", [YTOUserDefaults getLanguage],@"Casa - vila individuala");
    //lblCellP.text = a.tipLocuinta;
    ((UILabel *)[cellLocuinta viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@, %d mp", a.judet, a.localitate, a.suprafataUtila];
    locuinta = a;
    
    if (locuinta.modEvaluare && ![locuinta.modEvaluare isEqualToString:@""])
        [self setModEvaluare:locuinta.modEvaluare];
    else [self setModEvaluare:@"valoare-reala"];
    
    if (locuinta.sumaAsigurata >= 10000)
        [self setSumaAsigurata:[NSString stringWithFormat:@"%d",locuinta.sumaAsigurata]];
    else
        [self setSumaAsigurata:0];
    //else [activeTextField becomeFirstResponder];
    if (locuinta.sumaAsigurataRC > 0)
        [self setSumaAsigurataRC:[NSString stringWithFormat:@"%d",locuinta.sumaAsigurataRC]];
    else
        [self setSumaAsigurataRC:0];
    
    if (locuinta.idProprietar.length > 0 && ![locuinta.idProprietar isEqualToString:asigurat.idIntern] && cautLegaturaDintreAsiguratSiLocuinta)
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:locuinta.idProprietar];
        if (prop)
            [self setAsigurat:prop];
        
        cautLegaturaDintreAsiguratSiLocuinta = NO;
    }
}

- (void) setDataInceput:(NSDate *)DataInceput
{
    UILabel * lbl = (UILabel *)[cellDataInceput viewWithTag:2];
    lbl.text = [YTOUtils formatDate:DataInceput withFormat:@"dd.MM.yyyy"];
    oferta.dataInceput = DataInceput;
}

- (void) setSumaAsigurata:(NSString *)p
{
    if (p > 0) {
    locuinta.sumaAsigurata = [p intValue];
    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setText:[NSString stringWithFormat:@"%.2f %@", [p floatValue], [oferta.moneda uppercaseString]]];
    }
    else
        [(UITextField *)[cellSumaAsigurata viewWithTag:2] setText:@""];
}
- (void) setSumaAsigurataRC:(NSString *)p
{
    if (p > 0) {
    locuinta.sumaAsigurataRC = [p intValue];
    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setText:[NSString stringWithFormat:@"%.2f %@", [p floatValue], [oferta.moneda uppercaseString]]];
    }
    else
        [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setText:@""];
}

#pragma CELL LEASING
- (void) btnCesiune_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL cesiune = btn.tag == 1;
    
    [self setCesiune:cesiune ? @"da" : @"nu"];
    
    [tableView reloadData];
}

- (void) setCesiune:(NSString *)v
{
    UILabel *lblDA = (UILabel *)[cellCesionareBanca viewWithTag:3];
    UILabel *lblNU = (UILabel *)[cellCesionareBanca viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellCesionareBanca viewWithTag:5];
    
    if ([v isEqualToString:@"nu"])
    {
        img.image = [UIImage imageNamed:@"da-nu-nu-locuinta.png"];
        lblDA.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblNU.textColor = [UIColor whiteColor];
        locuinta.cesiune = NO;
    }
    else if ([v isEqualToString:@"da"])
    {
        img.image = [UIImage imageNamed:@"da-nu-da-locuinta.png"];
        lblNU.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDA.textColor = [UIColor whiteColor];
        locuinta.cesiune = YES;
    }
}

- (IBAction)btnModeEvaluare_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    for (int i=1; i<=4; i++) {
        UIButton * _btn = (UIButton *)[cellModEvaluare viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    if (btn.tag == 1)
        [self setModEvaluare:@"valoare-reala"];
    else if (btn.tag == 2)
        [self setModEvaluare:@"valoare-piata"];
    else if (btn.tag == 3)
        [self setModEvaluare:@"evaluare-banca"];
    else if (btn.tag == 4)
        [self setModEvaluare:@"valoare-inlocuire"];
}

- (void) setModEvaluare:(NSString *)p
{
    ((UIButton *)[cellModEvaluare viewWithTag:1]).selected = ((UIButton *)[cellModEvaluare viewWithTag:2]).selected =
    ((UIButton *)[cellModEvaluare viewWithTag:3]).selected = ((UIButton *)[cellModEvaluare viewWithTag:4]).selected = NO;
    
    if ([p isEqualToString:@"valoare-reala"])
        ((UIButton *)[cellModEvaluare viewWithTag:1]).selected = YES;
    else if ([p isEqualToString:@"valoare-piata"])
        ((UIButton *)[cellModEvaluare viewWithTag:2]).selected = YES;
    else if ([p isEqualToString:@"evaluare-banca"])
        ((UIButton *)[cellModEvaluare viewWithTag:3]).selected = YES; 
    else if ([p isEqualToString:@"valoare-inlocuire"])
        ((UIButton *)[cellModEvaluare viewWithTag:4]).selected = YES;

    locuinta.modEvaluare = p;
}
@end
