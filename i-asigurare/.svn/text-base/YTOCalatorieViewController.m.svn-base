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

@interface YTOCalatorieViewController ()

@end

@implementation YTOCalatorieViewController

@synthesize DataInceput = _DataInceput;

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
    [self setScopCalatorie:@"turism"];
    [self setTaraDestinatie:@"Turcia"];
    [self setSumaAsigurata:@"30.000-eur"];
    [self setNrZile:5];
    [self setTranzit:@"nu"];
    
    
    _DataInceput = [YTOUtils getDataMinimaInceperePolita];
    [self setDataInceput:_DataInceput];
    
    // Do any additional setup after loading the view from its nib.
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
            if (i == 0)
                oferta.idAsigurat = p.idIntern;      
            [oferta.obiecteAsigurate addObject:p.idIntern];
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
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"calculator-calatorie.png"];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
    ((UILabel *)[cellDataInceput viewWithTag:1]).text = @"Data Inceput";
    UIStepper * stepper = (UIStepper *)[cellDataInceput viewWithTag:3];
    [stepper addTarget:self action:@selector(dateStepper_Changed:) forControlEvents:UIControlEventValueChanged];
    ((UIImageView *)[cellDataInceput viewWithTag:4]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    [YTOUtils setCellFormularStyle:cellDataInceput];
    
    NSArray *topLevelObjectsNrZile = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrZile = [topLevelObjectsNrZile objectAtIndex:0];
    ((UILabel *)[cellNrZile viewWithTag:1]).text = @"Numar zile";    
    UIStepper * stepperNrZile = (UIStepper *)[cellNrZile viewWithTag:3];
    stepperNrZile.value = 5;
    stepperNrZile.minimumValue = 2;
    stepperNrZile.maximumValue = 365;
    [stepperNrZile addTarget:self action:@selector(nrZileStepper_Changed:) forControlEvents:UIControlEventValueChanged]; 
    ((UIImageView *)[cellNrZile viewWithTag:4]).image = [UIImage imageNamed:@"arrow-calatorie.png"] ;  
    [YTOUtils setCellFormularStyle:cellNrZile];
    
    NSArray *topLevelObjectsTara = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellTaraDestinatie = [topLevelObjectsTara objectAtIndex:0];
    [(UILabel *)[cellTaraDestinatie viewWithTag:1] setText:@"Tara destinatie"];
    [YTOUtils setCellFormularStyle:cellTaraDestinatie];
 
    NSArray *topLevelObjectsTranzit = [[NSBundle mainBundle] loadNibNamed:@"CellView_DaNu" owner:self options:nil];
    cellTranzit = [topLevelObjectsTranzit objectAtIndex:0];
    [(UILabel *)[cellTranzit viewWithTag:6] setText:@"Se face tranzit ?"];
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
    lblCellP.text = @"Alege calatori";
    ((UILabel *)[cellCalatori viewWithTag:3]).text = @"poti alege mai multe persoane";
    UIImageView * imgBg = (UIImageView *)[cellCalatori viewWithTag:5];
    imgBg.image = [UIImage imageNamed:@"alege-calator.png"];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * img2 = (UIImageView *)[cellCalculeaza viewWithTag:1];
    img2.image = [UIImage imageNamed:@"calculeaza-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = @"Calculeaza";
}

#pragma Events
- (IBAction) btnScop_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];

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
    ((UILabel *)[cellCalatori viewWithTag:2]).text = [NSString stringWithFormat:@"Numar Calatori %d", listaAsigurati.count];
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
