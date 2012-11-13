//
//  YTOCasaViewController.m
//  i-asigurare
//
//  Created by Administrator on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOCasaViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOLocuinta.h"
#import "YTOUtils.h"
#import "Database.h"
#import "KeyValueItem.h"

@interface YTOCasaViewController ()

@end

@implementation YTOCasaViewController

@synthesize controller, locuinta, goingBack;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Locuinta", @"Locuinta");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    goingBack = YES;
    
    [self initCells];
    [self loadStructuriRezistenta];
    if (!locuinta) {
        locuinta = [[YTOLocuinta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        // set default values
        [self setTipLocuinta:@"apartament-in-bloc"];
        [self setStructura:@"beton-armat"];
        [self setNrCamere:2];
        [self setNrLocatari:2];
        locuinta.locuitPermanent = @"da";
        
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        if (proprietar)
        {
            [self setJudet:proprietar.judet];
            [self setLocalitate:proprietar.localitate];
            [self setAdresa:proprietar.adresa];
        }
        percentCompletedOnLoad = [locuinta CompletedPercent];
    }
    else {
        [self load:locuinta];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
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
    return 13;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 78;
    else if (indexPath.row == 3)
        return 100;
    return 60;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellJudetLocalitate;
    else if (indexPath.row == 2) cell = cellAdresa;
    else if (indexPath.row == 3) cell = cellTipLocuinta;
    else if (indexPath.row == 4) cell = cellStructura;
    else if (indexPath.row == 5) cell = cellInaltime;
    else if (indexPath.row == 6) cell = cellEtaj;
    else if (indexPath.row == 7) cell = cellAnConstructie;
    else if (indexPath.row == 8) cell = cellNrCamere;
    else if (indexPath.row == 9) cell = cellSuprafata;
    else if (indexPath.row == 10) cell = cellNrLocatari;
    else if (indexPath.row == 11) cell = cellDescriereLocuinta;
    else cell = cellSC;
    
    if (indexPath.row % 2 != 0) {
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
//    [self doneEditing];
//    if (indexPath.row == 3) {
//        [self showListaJudete:indexPath];
//    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];
    
    if (indexPath.row == 1)
    {
        [self showListaJudete:indexPath];
    }
    else if (indexPath.row == 4) {
        [self showNomenclator];
    }
    else if (indexPath.row == 11)
    {
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

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row > 3 || indexPath.row == 2)
    {
        [self addBarButton];
    }
    
    if (indexPath.row == 2)     // Adresa
        [self showTooltip:@"Adresa completa, strada, numar, bloc, etc."];
    else if (indexPath.row == 5) // Nr. Etaje
        [self showTooltip:@"Numarul de etaje al imobilului / blocului."];
    else if (indexPath.row == 6) // Etaj
        [self showTooltip:@"Etajul la care se afla locuinta."];
    else if (indexPath.row == 7)
        [self showTooltip:@"Anul constructiei imobilului."];
    else if (indexPath.row == 9) 
    {
        [textField.text stringByReplacingOccurrencesOfString:@" mp" withString:@""];
        [self showTooltip:@"Supfrata utila a locuintei in metri patrati."];
    }
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField 
{
//	btnDone.enabled = YES;
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
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self hideTooltip];
    
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];

    if (indexPath.row == 2)
        [self setAdresa:textField.text];
    else if (indexPath.row == 5)
        [self setInaltime:[textField.text intValue]];
    else if (indexPath.row == 6)
        [self setEtaj:[textField.text intValue]];
    else if (indexPath.row == 7)
        [self setAnConstructie:[textField.text intValue]];
    else if (indexPath.row == 9)
        [self setSuprafata:[textField.text intValue]];
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

- (void) load:(YTOLocuinta *)p
{
    [self setJudet:p.judet];
    [self setLocalitate:p.localitate];
    [self setAdresa:p.adresa];
    [self setTipLocuinta:p.tipLocuinta];
    [self setStructura:p.structuraLocuinta];
    [self setInaltime:p.regimInaltime];
    [self setEtaj:p.etaj];
    [self setAnConstructie:p.anConstructie];
    [self setNrCamere:p.nrCamere];
    [self setSuprafata:p.suprafataUtila];
    [self setNrLocatari:p.nrLocatari];
}

- (void) save
{
    if (goingBack)
    {
//        if (locuinta.judet.length > 0 && locuinta.localitate.length > 0 && locuinta.adresa.length > 0)
//        {
            if (locuinta._isDirty)
                [locuinta updateLocuinta];
            else
            {
                NSLog(@"%.2f", [locuinta CompletedPercent]);
                if ([locuinta CompletedPercent] > percentCompletedOnLoad)
                    [locuinta addLocuinta];
            }
        
        
        //}
    }
}

- (void) btnSave_Clicked
{
    [self doneEditing];
    [self save];
    if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
        [parent setLocuinta:locuinta];
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOListaLocuinteViewController class]])
    {
        YTOListaLocuinteViewController * parent = (YTOListaLocuinteViewController *)self.controller;
        [parent reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) btnCancel_Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showStructuraRezistenta:(NSIndexPath *)index;
{
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    //actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database MarciAuto]];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithObjects:@"beton-armat", @"beton", @"bca", @"caramida", @"caramida-nearsa", @"chirpici-paiata", @"lemn", @"zidarie-lemn", nil];
    actionPicker._indexPath = index;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Structura rezistenta";
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

    [lblTitle setText:@"Selecteaza structura de rezistenta"];
    _nomenclatorNrItems = structuriRezistenta.count;
    selectedItemIndex = [YTOUtils getKeyList:structuriRezistenta forValue:locuinta.structuraLocuinta];

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
        [lbl setTextAlignment:UITextAlignmentCenter];
        lbl.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl.font = [UIFont fontWithName:@"Arial" size:12];
        lbl.text = [item.value stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
        cols++;
        [button addSubview:lbl];
        if (i == selectedItemIndex)
            [button setSelected:YES];
        [scrollView addSubview:button];
    }
    
    float height = [structuriRezistenta count]/3.0;
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
    actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];
}

- (void) showListaDescriereLocuinta:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithObjects:@"Are alarma", @"Are grilaje geam", @"Are detectie incendiu", @"Are paza", @"Este intr-o zona izolata", @"Locuit permanent", @"Clauza furt bunuri", @"Clauza apa conducta", nil];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kDescriereLocuinta;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Descriere locuinta";
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
    
    [self presentModalViewController:actionPicker animated:YES];
}

-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch 
{
    if (indexPath.row == 1) // JUDET + LOCALITATE
    {
        if (vwSearch.nomenclator == kJudete) {
            [self setJudet:selected];
        }
        else { 
            [self setLocalitate:selected];
        }
    }
    else if (indexPath.row == 4) // Structura
    {
        [self setStructura:selected];
    }
    goingBack = YES;
}

- (void) initCells
{
    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellLocuintaHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsHeader objectAtIndex:0];
    [YTOUtils setCellFormularStyle:cellHeader];
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE LOCUINTA"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:@"Adresa"];
    //[(UITextField *)[cellAdresa viewWithTag:2] setPlaceholder:@"Strada, nr, bl, et, ap, etc."];
    [YTOUtils setCellFormularStyle:cellAdresa]; 
    
    NSArray *topLevelObjectsStructura = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellStructura = [topLevelObjectsStructura objectAtIndex:0];
    [(UILabel *)[cellStructura viewWithTag:1] setText:@"STRUCTURA REZISTENTA"];
    [YTOUtils setCellFormularStyle:cellStructura];
    
    NSArray *topLevelObjectsInaltime = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellInaltime = [topLevelObjectsInaltime objectAtIndex:0];
    [(UILabel *)[cellInaltime viewWithTag:1] setText:@"INALTIMEA CLADIRII (NR. ETAJE)"];
    [(UITextField *)[cellInaltime viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellInaltime viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellInaltime];  
    
    NSArray *topLevelObjectsEtaj = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellEtaj = [topLevelObjectsEtaj objectAtIndex:0];
    [(UILabel *)[cellEtaj viewWithTag:1] setText:@"ETAJ"];
    [(UITextField *)[cellEtaj viewWithTag:2] setPlaceholder:@""]; 
    [(UITextField *)[cellEtaj viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellEtaj];  

    NSArray *topLevelObjectsAnConstructie = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellAnConstructie = [topLevelObjectsAnConstructie objectAtIndex:0];
    [(UILabel *)[cellAnConstructie viewWithTag:1] setText:@"AN CONSTRUCTIE"];
    [(UITextField *)[cellAnConstructie viewWithTag:2] setPlaceholder:@""];  
    [(UITextField *)[cellAnConstructie viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellAnConstructie];  

    NSArray *topLevelObjectsNrCamere = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrCamere = [topLevelObjectsNrCamere objectAtIndex:0];
    [(UILabel *)[cellNrCamere viewWithTag:1] setText:@"NUMAR CAMERE"];
    UIStepper * stepperNrCamere = (UIStepper *)[cellNrCamere viewWithTag:3];
    ((UIImageView *)[cellNrCamere viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    stepperNrCamere.value = 2;
    stepperNrCamere.minimumValue = 1;
    stepperNrCamere.maximumValue = 10;
    [stepperNrCamere addTarget:self action:@selector(nrCamere_Changed:) forControlEvents:UIControlEventValueChanged]; 
    [YTOUtils setCellFormularStyle:cellNrCamere];
    
    
    NSArray *topLevelObjectsSuprafata = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSuprafata = [topLevelObjectsSuprafata objectAtIndex:0];
    [(UILabel *)[cellSuprafata viewWithTag:1] setText:@"SUPRAFATA (MP)"];
    [(UITextField *)[cellSuprafata viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSuprafata viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSuprafata];    
    
    NSArray *topLevelObjectsNrLocatari = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNrLocatari = [topLevelObjectsNrLocatari objectAtIndex:0];
    [(UILabel *)[cellNrLocatari viewWithTag:1] setText:@"NUMAR LOCATARI"];  
    UIStepper * stepperNrLocatari = (UIStepper *)[cellNrLocatari viewWithTag:3];
    ((UIImageView *)[cellNrLocatari viewWithTag:4]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    stepperNrLocatari.value = 2;
    stepperNrLocatari.minimumValue = 1;
    stepperNrLocatari.maximumValue = 10;
    [stepperNrLocatari addTarget:self action:@selector(nrLocatari_Changed:) forControlEvents:UIControlEventValueChanged]; 
    [YTOUtils setCellFormularStyle:cellNrLocatari];
    
    NSArray *topLevelObjectsDescrLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellDescriereLocuinta = [topLevelObjectsDescrLocuinta objectAtIndex:0];
    [(UILabel *)[cellDescriereLocuinta viewWithTag:1] setText:@"ALTE INFORMATII"];
    [YTOUtils setCellFormularStyle:cellDescriereLocuinta];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];    
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];        
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside]; 
}

- (IBAction)nrLocatari_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrLocatari:stepper.value];    
}

- (IBAction)nrCamere_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrCamere:stepper.value];
}

- (IBAction)btnTipLocuinta_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[cellTipLocuinta viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (btn.tag == 1)
        [self setTipLocuinta:@"apartament-in-bloc"];
    else if (btn.tag == 2)
        [self setTipLocuinta:@"casa-vila-comuna"];
    else if (btn.tag ==3)
        [self setTipLocuinta:@"casa-vila-individuala"];
}

- (void) setAdresa:(NSString *)p
{
    locuinta.adresa = p;
    UILabel * lbl = (UILabel *)[cellAdresa viewWithTag:2];
    lbl.text = p;
}

- (NSString *) getJudet
{
    return locuinta.judet;
}
- (void) setJudet:(NSString *)judet
{
    locuinta.judet = judet;
}

- (NSString *) getLocalitate
{
    return locuinta.localitate;    
}
- (void) setLocalitate:(NSString *)localitate
{
    locuinta.localitate = localitate;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
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
}

- (void) setStructura:(NSString *)p
{
    locuinta.structuraLocuinta = p;
    UILabel * lbl = (UILabel *)[cellStructura viewWithTag:2];
    lbl.text = p;
    locuinta.structuraLocuinta = p;
}

- (void) setInaltime:(int)p
{
    locuinta.regimInaltime = p;
    UITextField * txt = (UITextField *)[cellInaltime viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];
}
- (void) setEtaj:(int)p
{
    locuinta.etaj = p;
    UITextField * txt = (UITextField *)[cellEtaj viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];
}
- (void) setAnConstructie:(int)p
{
    locuinta.anConstructie = p;
    UITextField * txt = (UITextField *)[cellAnConstructie viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];    
}

- (void) setNrCamere:(int)p
{
    locuinta.nrCamere = p;
    UITextField * txt = (UITextField *)[cellNrCamere viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];    
}
- (void) setSuprafata:(int)p
{
    locuinta.suprafataUtila = p;
    UITextField * txt = (UITextField *)[cellSuprafata viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d mp", p];
}
- (void) setNrLocatari:(int)p
{
    locuinta.nrLocatari = p;
    UITextField * txt = (UITextField *)[cellNrLocatari viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", p];
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

- (void) loadStructuriRezistenta
{    
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"beton-armat";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"beton";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"bca";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"caramida";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"caramida-nearsa";
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 5;
    c6.value = @"chirpici-paiata";
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 6;
    c7.value = @"lemn";
    
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 1;
    c8.key = 7;
    c8.value = @"zidarie-lemn";
    
    structuriRezistenta = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7,c8, nil];
}

@end
