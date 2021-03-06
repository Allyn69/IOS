//
//  YTOCalatorieViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/31/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOCalatorieViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOWebServiceCalatorieViewController.h"
#import "YTOPersoana.h"
#import "YTOUserDefaults.h"

@interface YTOCalatorieViewController ()

@end

@implementation YTOCalatorieViewController

@synthesize DataInceput = _DataInceput;
@synthesize controller;

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
    //self.trackedViewName = @"YTOCalatorieViewController";
    
    [self initCells];
    [self setScopCalatorie:@"turism"];
    [self setTaraDestinatie:@"Turcia"];
    [self setSumaAsigurata:@"30.000-eur"];
    [self setNrZile:5];
    [self setTranzit:@"nu"];
    
    lblSumaAsig.text = NSLocalizedStringFromTable(@"i126", [YTOUserDefaults getLanguage],@"Suma asigurata");
    lblScop.text = NSLocalizedStringFromTable(@"i162", [YTOUserDefaults getLanguage],@"Scop calatorie");
    lblAfaceri.text = NSLocalizedStringFromTable(@"i71", [YTOUserDefaults getLanguage],@"Afaceri");
    lblTurism.text = NSLocalizedStringFromTable(@"i65", [YTOUserDefaults getLanguage],@"Turism");
    lblSofer.text =NSLocalizedStringFromTable(@"i81", [YTOUserDefaults getLanguage],@"Sofer profesionist");
    lblStudii.text =NSLocalizedStringFromTable(@"i82", [YTOUserDefaults getLanguage],@"Studii");
    
    _DataInceput = [YTOUtils getDataMinimaInceperePolita];
    [self setDataInceput:_DataInceput];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    // Do any additional setup after loading the view from its nib.
}

//- (void) viewDidAppear:(BOOL)animated
//{
//    
//    [self setCuloareCellCalatori];
//}

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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 5)
        return 100;
    else if (indexPath.row == 4) // In tranzit
        return 47;
    else if (indexPath.row == 6)
        return 75;
    return 69;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;

    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellScopCalatorie;
    else if (indexPath.row == 2) cell = cellNrZile;
    else if (indexPath.row == 3) cell = cellTaraDestinatie;
    else if (indexPath.row == 4) cell = cellTranzit;
    else if (indexPath.row == 5) cell = cellSumaAsigurata;
    else if (indexPath.row == 6) cell = cellCalatori;
    else if (indexPath.row == 7) cell = cellDataInceput;
    else cell = cellCalculeaza;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 3) {
        //[self doneEditing];
        [self showTaraDestinatieList:indexPath];
    } 
    else if (indexPath.row == 6)
    {
        YTOListaAsiguratiViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
        else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
        aView.produsAsigurare = Calatorie;
        aView.listaAsiguratiSelectati = listaAsigurati;
        aView.listAsiguratiIndecsi = listaAsiguratiIndecsi;
        aView.controller = self;
        aView.tagViewControllerFrom = 1;
        
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 8)
    {
        if (!listaAsigurati.count)
        {
            UILabel * lblCell = (UILabel *)[cellCalatori viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else {
            UILabel * lblCell = (UILabel *)[cellCalatori viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        oferta = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        oferta.dataInceput = _DataInceput;
        oferta.tipAsigurare = 2;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] init];
        
        for (int i=0; i<listaAsigurati.count; i++) {
            YTOPersoana * p = (YTOPersoana *)[listaAsigurati objectAtIndex:i];
            if ([p isValidForCompute]) {
                
                if (i == 0)
                    oferta.idAsigurat = p.idIntern;
                [oferta.obiecteAsigurate addObject:p.idIntern];
            
            }
            else {
                
                UILabel * lblCell = (UILabel *)[cellCalatori viewWithTag:2];
                lblCell.textColor = [UIColor redColor];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
                [tv scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
                return;
                
            }
            
        }
        
        [oferta setCalatorieScop:scopCalatorie];
        [oferta setCalatorieDestinatie:taraDestinatie];
        [oferta setCalatorieTranzit:tranzit];
        [oferta setCalatorieProgram:sumaAsigurata];
        
        oferta.durataAsigurare = nrZile;

        oferta.numeAsigurare = [NSString stringWithFormat:@"Calatorie, %@", taraDestinatie];
        
        YTOWebServiceCalatorieViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOWebServiceCalatorieViewController alloc] initWithNibName:@"YTOWebServiceCalatorieViewController_R4" bundle:nil];
        else aView = [[YTOWebServiceCalatorieViewController alloc] initWithNibName:@"YTOWebServiceCalatorieViewController" bundle:nil];

        aView.listAsigurati = listaAsigurati;
        aView.oferta = oferta;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    
    if (indexPath.row == 3) // TARA DESTINATIE
    {
       [self setTaraDestinatie:selected];
    }
    goingBack = YES;
}

#pragma Other Methods

- (void) showTaraDestinatieList:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithObjects:@"Turcia", @"Bulgaria", @"Italia", @"Spania", @"Franta", @"Austria", @"Cehia", @"Ungaria", @"Olanda", @"Aland-Islands",  @"Albania", @"Andorra", @"Belarus", @"Belgia", @"Bosnia-Herzegovina", @"Croatia", @"Danemarca", @"Elvetia", @"Estonia", @"Finlanda", @"Germania", @"Gibraltar", @"Grecia", @"Insulele-Faroe", @"Irlanda", @"Islanda", @"Israel", @"Letonia", @"Liechtenstein", @"Lituania", @"Luxembourg", @"Macedonia", @"Malta", @"Marea-Britanie", @"Moldova", @"Monaco", @"Norvegia", @"Polonia", @"Portugalia", @"Romania", @"Rusia", @"San-Marino", @"Serbia-Muntenegru", @"Slovacia", @"Slovenia", @"SUA", @"SUA-Minor-Outlying-Islands", @"Suedia", @"Svalbard-Jan-Mayen", @"Ucraina", @"Vatican",nil];
    actionPicker._indexPath = index;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Tara Destinatie";
   // [YTOUtils rightImageVodafone:actionPicker.navigationItem]
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-calatorie-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-calatorie-en.png"];
    else img.image = [UIImage imageNamed:@"asig-calatorie.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:portocaliuCalatorie];
    
    lbl1.text = NSLocalizedStringFromTable(@"i773", [YTOUserDefaults getLanguage],@"Asigurare calatorie");
    lbl2.text = NSLocalizedStringFromTable(@"i771", [YTOUserDefaults getLanguage],@"● Tarife direct de la companii");
    lbl3.text = NSLocalizedStringFromTable(@"i775", [YTOUserDefaults getLanguage],@"● Livrare electronica in 5 minute");
    lbl1.adjustsFontSizeToFitWidth = YES;
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl3.adjustsFontSizeToFitWidth = YES;
    cellHeader.userInteractionEnabled = NO;

    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = NSLocalizedStringFromTable(@"i127", [YTOUserDefaults getLanguage],@"Data inceput");
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged];
    ((UIImageView *)[cellDataInceput viewWithTag:4]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    [YTOUtils setCellFormularStyle:cellDataInceput];
    
    NSArray *topLevelObjectsNrZile = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrZile = [topLevelObjectsNrZile objectAtIndex:0];
    ((UILabel *)[cellNrZile viewWithTag:1]).text = NSLocalizedStringFromTable(@"i83", [YTOUserDefaults getLanguage],@"Numar zile");   
    UIStepper * stepperNrZile = (UIStepper *)[cellNrZile viewWithTag:3];
    stepperNrZile.value = 5;
    stepperNrZile.minimumValue = 2;
    stepperNrZile.maximumValue = 365;
    [stepperNrZile addTarget:self action:@selector(nrZileStepper_Changed:) forControlEvents:UIControlEventValueChanged]; 
    ((UIImageView *)[cellNrZile viewWithTag:4]).image = [UIImage imageNamed:@"arrow-calatorie.png"] ;  
    [YTOUtils setCellFormularStyle:cellNrZile];
    
    NSArray *topLevelObjectsTara = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellTaraDestinatie = [topLevelObjectsTara objectAtIndex:0];
    [(UILabel *)[cellTaraDestinatie viewWithTag:1] setText:NSLocalizedStringFromTable(@"i85", [YTOUserDefaults getLanguage],@"Tara Destinatie")];
    [YTOUtils setCellFormularStyle:cellTaraDestinatie];
 
    NSArray *topLevelObjectsTranzit = [[NSBundle mainBundle] loadNibNamed:@"CellView_DaNu" owner:self options:nil];
    cellTranzit = [topLevelObjectsTranzit objectAtIndex:0];
    [(UILabel *)[cellTranzit viewWithTag:6] setText:NSLocalizedStringFromTable(@"i159", [YTOUserDefaults getLanguage],@"Se face tranzit")];
    UIImageView * imgTranzit = (UIImageView *)[cellTranzit viewWithTag:5];
    [imgTranzit setImage:[UIImage imageNamed:@"da-nu-nu-calatorie.png"]];
    UIButton * btnTranzitDa = (UIButton *)[cellTranzit viewWithTag:1];
    [btnTranzitDa addTarget:self action:@selector(btnTranzit_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnTranzitNu = (UIButton *)[cellTranzit viewWithTag:2];
    [btnTranzitNu addTarget:self action:@selector(btnTranzit_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectsCalator = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellCalatori = [topLevelObjectsCalator objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellCalatori viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = NSLocalizedStringFromTable(@"i458", [YTOUserDefaults getLanguage],@"Alege Calatori");
    ((UILabel *)[cellCalatori viewWithTag:3]).text = NSLocalizedStringFromTable(@"i459", [YTOUserDefaults getLanguage],@"Poti alege mai multe persoane");
    UIImageView * imgBg = (UIImageView *)[cellCalatori viewWithTag:5];
    imgBg.image = [UIImage imageNamed:@"alege-calator.png"];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * img2 = (UIImageView *)[cellCalculeaza viewWithTag:1];
    img2.image = [UIImage imageNamed:@"calculeaza-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i128", [YTOUserDefaults getLanguage],@"Calculeaza");
}

#pragma Events
- (IBAction) btnScop_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    if (btn.tag == 1)
    {
        [self setScopCalatorie:@"turism"];
    }
    if (btn.tag == 2)
    {
        [self setScopCalatorie:@"afaceri"];
    }
    if (btn.tag == 3)
    {
        [self setScopCalatorie:@"sofer-profesionist"];
    }
    if (btn.tag == 4)
    {
        [self setScopCalatorie:@"studii"];
    }

    for (int i=1; i<=4; i++) {
        UIButton * _btn = (UIButton *)[cellScopCalatorie viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
}

- (IBAction) btnSA_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    for (int i=1; i<=4; i++) {
        UIButton * _btn = (UIButton *)[cellSumaAsigurata viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (btn.tag == 1)
        [self setSumaAsigurata:@"5.000-eur"];
    else if (btn.tag == 2)
        [self setSumaAsigurata:@"10.000-eur"];
    else if (btn.tag == 3)
        [self setSumaAsigurata:@"30.000-eur"];
    else if (btn.tag == 4)
        [self setSumaAsigurata:@"50.000-eur"];
}

- (IBAction)nrZileStepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    
    [self setNrZile:stepper.value];
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
    [self setDataInceput:date];
}

- (void) btnTranzit_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL _tranzit = btn.tag == 1;
        
    [self setTranzit:_tranzit ? @"da" : @"nu"];
}
     
#pragma Properties

- (void) setCuloareCellCalatori {
    UILabel * lblCell = (UILabel *)[cellCalatori viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
}

- (void) setDataInceput:(NSDate *)DataInceput
{
    UILabel * lbl = (UILabel *)[cellDataInceput viewWithTag:2];
    lbl.text = [YTOUtils formatDate:DataInceput withFormat:@"dd.MM.yyyy"];

    _DataInceput = DataInceput;
    oferta.dataInceput = DataInceput;
}

- (void) setNrZile:(int)zile
{
    UILabel * lbl = (UILabel *)[cellNrZile viewWithTag:2];
    lbl.text = [NSString stringWithFormat:@"%d", zile];    
    
    nrZile = zile;
}

- (void) setScopCalatorie:(NSString *)scop
{
    if ([scop isEqualToString:@"turism"])
        ((UIButton *)[cellScopCalatorie viewWithTag:1]).selected = YES;
    else if ([scop isEqualToString:@"afaceri"])
        ((UIButton *)[cellScopCalatorie viewWithTag:2]).selected = YES;
    else if ([scop isEqualToString:@"sofer-profesionist"])
        ((UIButton *)[cellScopCalatorie viewWithTag:3]).selected = YES;    
    else if ([scop isEqualToString:@"studii"])
        ((UIButton *)[cellScopCalatorie viewWithTag:4]).selected = YES;    

    scopCalatorie = scop;
}

- (void) setSumaAsigurata:(NSString *)sa
{
    if ([sa isEqualToString:@"5.000-eur"])
        ((UIButton *)[cellSumaAsigurata viewWithTag:1]).selected = YES;
    else if ([sa isEqualToString:@"10.000-eur"])
        ((UIButton *)[cellSumaAsigurata viewWithTag:2]).selected = YES;
    else if ([sa isEqualToString:@"30.000-eur"])
        ((UIButton *)[cellSumaAsigurata viewWithTag:3]).selected = YES;    
    else if ([sa isEqualToString:@"50.000-eur"])
        ((UIButton *)[cellSumaAsigurata viewWithTag:4]).selected = YES; 
    
    sumaAsigurata = sa;
}

- (void) setTaraDestinatie:(NSString *)tara
{
    UILabel * lbl = (UILabel *)[cellTaraDestinatie viewWithTag:2]; 
    lbl.text = tara;
    
    taraDestinatie = tara;
}

- (void) setListaAsigurati:(NSMutableArray *) list withIndex:(NSMutableArray *) indexList;
{
    listaAsigurati = list;
    ((UILabel *)[cellCalatori viewWithTag:2]).text = [NSString stringWithFormat:@"%@ %d",NSLocalizedStringFromTable(@"i457", [YTOUserDefaults getLanguage],@"Numar calatori"), listaAsigurati.count];
    listaAsiguratiIndecsi = indexList;
}
     
- (void) setTranzit:(NSString *)v
{
    UILabel *lblDA = (UILabel *)[cellTranzit viewWithTag:3];
    UILabel *lblNU = (UILabel *)[cellTranzit viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellTranzit viewWithTag:5];
         
    if ([v isEqualToString:@"nu"])
    {
        img.image = [UIImage imageNamed:@"da-nu-nu-calatorie.png"];
        lblDA.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblNU.textColor = [UIColor whiteColor];
        lblDA.text = NSLocalizedStringFromTable(@"i92", [YTOUserDefaults getLanguage],@"DA");
        lblNU.text = NSLocalizedStringFromTable(@"i98", [YTOUserDefaults getLanguage],@"NU");
        tranzit = @"nu";
    }
    else if ([v isEqualToString:@"da"])
    {
        img.image = [UIImage imageNamed:@"da-nu-da-calatorie.png"];
        lblNU.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDA.textColor = [UIColor whiteColor];
        tranzit = @"da";
    }
}
@end
