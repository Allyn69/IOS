//
//  YTOAutovehiculViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOAutovehiculViewController.h"
#import "YTOAppDelegate.h"
#import "Database.h"
#import "KeyValueItem.h"
#import "YTOCalculatorViewController.h"
#import "YTOListaAutoViewController.h"
#import "YTOImage.h"

@interface YTOAutovehiculViewController ()

@end

@implementation YTOAutovehiculViewController

@synthesize autovehicul, controller;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Masina", @"Masina");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    goingBack = YES;
    selectatInfoMasina = YES;
    shouldSave = YES;
    
    [self initCells];
    
    [self loadCategorii];
    [self loadTipCombustibil];
    [self loadDestinatieAuto];
       
    if (!autovehicul) {
        autovehicul = [[YTOAutovehicul alloc] initWithGuid:[YTOUtils GenerateUUID]];
        // set default values
        [self setCategorieAuto:1];
        [self setSubcategorieAuto:@"Autoturism"];
        [self setDestinatieAuto:@"interes-personal"];
        [self setTipCombustibil:@"benzina"];
        [self setNrLocuri:5];
        [self setInLeasing:@"nu"];
        
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        if (proprietar)
        {
            [self setJudet:proprietar.judet];
            [self setLocalitate:proprietar.localitate];
        }
        
        percentCompletedOnLoad = [autovehicul CompletedPercent];
    }
    else {
        [self load:autovehicul];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self doneEditing];
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
    if (selectatInfoMasina)
    {
        if ([autovehicul.inLeasing isEqualToString:@"da"])
            return 19;
        return 18;
    }
    else
    {
        if (alertaRataCasco && alertaRataCasco.numarTotalRate > 0)
            return 7 + alertaRataCasco.numarTotalRate;
        return 7;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (selectatInfoMasina)
    {
        if (indexPath.row == 0)
            return 78;
        else if (indexPath.row == 1)
            return 30;
        else if (indexPath.row == 4 || indexPath.row == 14 || indexPath.row == 15)
            return 100;
        else if (indexPath.row == 16)
            return 47;
        return 60;
    }
    else
    {
        if (indexPath.row == 0)
            return 78;
        else if (indexPath.row == 1)
            return 30;
        else if (indexPath.row == 6)
            return 67;
        return 60;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (selectatInfoMasina)
    {
        if (indexPath.row == 0)       cell = cellAutoHeader;
        else if (indexPath.row == 1)  cell = cellInfoAlerte;
        else if (indexPath.row == 2)  cell = cellMarcaAuto;
        else if (indexPath.row == 3)  cell = cellModelAuto;
        else if (indexPath.row == 4)  cell = cellSubcategorieAuto;
        else if (indexPath.row == 5)  cell =  cellJudetLocalitate;
        else if (indexPath.row == 6)  cell = cellNrInmatriculare;
        else if (indexPath.row == 7)  cell = cellSerieSasiu;
        else if (indexPath.row == 8)  cell = cellCm3;
        else if (indexPath.row == 9)  cell = cellPutere;
        else if (indexPath.row == 10)  cell = cellNrLocuri;
        else if (indexPath.row == 11) cell = cellMasaMaxima;
        else if (indexPath.row == 12) cell = cellAnFabricatie;
        else if (indexPath.row == 13) cell = cellSerieCiv;
        else if (indexPath.row == 14) cell = cellDestinatieAuto;
        else if (indexPath.row == 15) cell = cellCombustibil;
        else if (indexPath.row == 16) cell = cellInLeasing;
        else if (indexPath.row == 17 && [autovehicul.inLeasing isEqualToString:@"da"]) cell = cellLeasingFirma;
        else return cellSC;
    }
    else
    {
        if (indexPath.row == 0)       cell = cellAutoHeader;
        else if (indexPath.row == 1)  cell = cellInfoAlerte;
        else if (indexPath.row == 2)  cell = cellExpirareRCA;
        else if (indexPath.row == 3)  cell = cellExpirareITP;
        else if (indexPath.row == 4)  cell = cellExpirareRovinieta;
        else if (indexPath.row == 5)  cell =  cellExpirareCASCO;
        else if (indexPath.row == 6)  cell = cellNumarRate;
        
        else if (alertaRataCasco && alertaRataCasco.numarTotalRate > 0)
        {
            cell = (UITableViewCell *)[listCellRateCasco objectAtIndex:(indexPath.row - 7)];
        }
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
- (void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [self doneEditing];
    if (selectatInfoMasina)
    {
        if (indexPath.row == 2) {
            [self showListaMarciAuto:indexPath];
        }
        else if (indexPath.row == 5) {
            [self showListaJudete:indexPath];
        }
    }
}

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self doneEditing];
    
    if (selectatInfoMasina)
    {
        if (indexPath.row == 2) {
            [self showListaMarciAuto:indexPath];
        }
        else if (indexPath.row == 5) {
            [self showListaJudete:indexPath];
        }
        else if (indexPath.row == 4)
        {
            //        _nomenclatorTip = kCategoriiAuto;
            //        [self showNomenclator];
        }
        else if (indexPath.row == 14)
        {
            _nomenclatorTip = kDestinatieAuto;
            [self showNomenclator];
        }
        else if (indexPath.row == 15)
        {
            //        _nomenclatorTip = kTipCombustibil;
            //        [self showNomenclator];
        }
        else {
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            UITextField * txt = (UITextField *)[cell viewWithTag:2];
            activeTextField = txt;
            [txt becomeFirstResponder];
        }
    }
    else
    {
        
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (selectatInfoMasina)
    {
        if (indexPath.row != 0 || indexPath.row != 2 || indexPath.row != 4 || indexPath.row != 5 || indexPath.row != 14 || indexPath.row != 15)
        {
            [self addBarButton];
        }
        
        if (indexPath.row == 3)     // Model Auto
            [self showTooltip:@"Introdu modelul auto. Ex. Logan, Golf, Astra"];
        if (indexPath.row == 6)     // Nr Inmatriculare
            [self showTooltip:@"Daca masina este in vederea inmatricularii, introduceti -."];
        else if (indexPath.row == 7)     // Serie Sasiu
        {
            [self showTooltip:@"Introdu corect seria de sasiu pentru obtinerea tarifelor RCA reale. Vezi talon pozitia E (model nou) sau pozitia 3 (model vechi)."];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;            
        }
        else if (indexPath.row == 8)     // Cm3
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" cm3" withString:@""];
            [self showTooltip:@"Vezi certificat inmatriculare pozitia P.1 (model nou) sau pozitia 17 (model vechi)."];
        }
        else if (indexPath.row == 9)    // Putere
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" kW" withString:@""];
            [self showTooltip:@"Vezi certificat inmatriculare pozitia P.2 (model nou) sau pozitia 17 (model vechi)."];
        }
        else if (indexPath.row == 10)     // Numar Locuri
            [self showTooltip:@"Vezi certificat inmatriculare pozitia S.1 (model nou) sau pozitia 13 (model vechi)."];
        else if (indexPath.row == 11)    // Masa maxima
        {
            textField.text = [textField.text stringByReplacingOccurrencesOfString:@" Kg" withString:@""];
            [self showTooltip:@"Vezi certificat inmatriculare pozitia F.1 (model nou) sau pozitia 11 (model vechi)."];
        }
        else if (indexPath.row == 12)    // An fabricatie
            [self showTooltip:@"Vezi certificat inmatriculare pozitia B (model nou) sau pozitia 15 (model vechi)."];
        else if (indexPath.row == 13)   // Serie CIV
        {
            [self showTooltip:@"Vezi certificat inmatriculare pozitia X (model nou) sau pozitia 4 (model vechi)."];
            ((UIImageView *)[currentCell viewWithTag:10]).hidden = YES;
        }
        
        else if (indexPath.row == 17) // Denumire Firma Leasing
            [self showTooltip:@"Daca masina este in leasing, introdu numele firmei de leasing."];
    }
    else
    {
        // Daca nu a fost salvata masina, nu setam alerte
        if (!autovehicul._isDirty)
            return;
        
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"Renunt" destructiveButtonTitle:nil otherButtonTitles:@"Selecteaza",nil];
        actionSheet.tag = indexPath.row;
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
        
		UIDatePicker *datePicker = [[UIDatePicker alloc] init];
		datePicker.tag = 101;
		datePicker.datePickerMode = 1; // date and time view
		datePicker.minimumDate = [NSDate date];
        
        YTOAlerta * alerta;
        if (indexPath.row == 2)
            alerta = [YTOAlerta getAlertaRCA:autovehicul.idIntern];
        else if (indexPath.row == 3)
            alerta = [YTOAlerta getAlertaITP:autovehicul.idIntern];
        else if (indexPath.row == 4)
            alerta = [YTOAlerta getAlertaRovinieta:autovehicul.idIntern];
        else if (indexPath.row == 5)
            alerta = [YTOAlerta getAlertaCasco:autovehicul.idIntern];
        else if (indexPath.row == 6)
            alerta = [YTOAlerta getAlertaRataCasco:autovehicul.idIntern];
        else
        {
            int numarRata = indexPath.row - 7;
            alerta = [YTOAlerta getAlertaRataCasco:autovehicul.idIntern andNumarRata:numarRata];
        }
        
        if (alerta)
            [datePicker setDate:alerta.dataAlerta];
        
		[actionSheet addSubview:datePicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    // Daca nu a fost salvata masina, nu setam alerte
    if (!autovehicul._isDirty && !selectatInfoMasina)
        return NO;
    
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}
	btnDone.enabled = YES;
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(64, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField 
{
	if(activeTextField == textField)
	{
        [self textFieldDidEndEditing:activeTextField];
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	[self deleteBarButton];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

// facem la serie sasiu validare pentru caracterele i, o, etc. ?
//- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string 
//{
//    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
//    for (int i = 0; i < [string length]; i++) {
//        unichar c = [string characterAtIndex:i];
//        if (![myCharSet characterIsMember:c]) {
//            return NO;
//        }
//    }
//    
//    return NO;
//}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];

    if (selectatInfoMasina)
    {
        [self hideTooltip];
        
        //    [self setModel:textField.text];
        
        if (indexPath.row == 3) // Model auto
            [self setModel:textField.text];
        else if (indexPath.row == 6)     // Nr Inmatriculare
            [self setNrInmatriculare:textField.text];
        else if (indexPath.row == 7)     // Serie Sasiu
            [self setSerieSasiu:textField.text];
        else if (indexPath.row == 8)     // Cm3
            [self setCm3:[textField.text intValue]];
        else if (indexPath.row == 9)    // Putere
            [self setPutere:[textField.text intValue]];
        else if (indexPath.row == 10)     // Numar Locuri
            [self setNrLocuri:[textField.text intValue]];
        else if (indexPath.row == 11)    // Masa maxima
            [self setMasaMaxima:[textField.text intValue]];
        else if (indexPath.row == 12)    // An fabricatie
            [self setAnFabricatie:[textField.text intValue]];
        else if (indexPath.row == 13)   // Serie CIV
            [self setSerieCIV:textField.text];
        else if (indexPath.row == 17)   // Firma Leasing
            [self setNumeFirmaLeasing:textField.text];
    }
    else
    {
      
    }
}

#pragma mark Action Sheet Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker *datePickerPermis = (UIDatePicker *)[actionSheet viewWithTag:101];
    if (datePickerPermis) {
		[self setAlerta:actionSheet.tag withDate:datePickerPermis.date savingData:YES];
	}
    [activeTextField resignFirstResponder];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void) setAlerta:(int)index withDate:(NSDate *)data savingData:(BOOL)toSave
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MM.yyyy";
    
    NSString *timestamp = [formatter stringFromDate:data];
    YTOAlerta * alerta;
    int tipAlerta=0;
    int numarRata = 0;
    
    UITextField * txt;
    if (index == 2)
    {
        tipAlerta = 1;
        txt = ((UITextField *)[cellExpirareRCA viewWithTag:2]);
    }
    else if (index == 3)
    {
        tipAlerta = 2;
        txt = ((UITextField *)[cellExpirareITP viewWithTag:2]);
    }
    else if (index == 4)
    {
        tipAlerta = 3;
        txt = ((UITextField *)[cellExpirareRovinieta viewWithTag:2]);
    }
    else if (index == 5)
    {
        tipAlerta = 5;
        txt = ((UITextField *)[cellExpirareCASCO viewWithTag:2]);
    }
    else if (index == 6)
    {
        tipAlerta = 6;
        txt = ((UITextField *)[cellExpirareRataCASCO viewWithTag:2]);
    }
    else
    {
        tipAlerta = 6;
        txt = ((UITextField *)[[listCellRateCasco objectAtIndex:index-7] viewWithTag:2]);
        numarRata = index - 6;
        
        if (alertaRataCasco._isDirty)
            [alertaRataCasco updateAlerta];
        else
            [alertaRataCasco addAlerta];
    }
    
    if (txt)
    {
        txt.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:20.0];
        txt.text = timestamp;
    }
    
    alerta = [YTOAlerta getAlerta:autovehicul.idIntern forType:tipAlerta];
    if (alerta == nil)
        alerta = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
    
    alerta.idObiect = autovehicul.idIntern;
    alerta.tipAlerta = tipAlerta;
    alerta.esteRata = (tipAlerta == 6 ? @"da" : @"nu");
    if (alerta.esteRata && numarRata  > 0)
        alerta.numarRata = numarRata;
    
    alerta.dataAlerta = data;
    
    if (toSave)
    {
        if (alerta._isDirty)
            [alerta updateAlerta];
        else
            [alerta addAlerta];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate setAlerteBadge];
    }
}

- (void) save
{
    if (goingBack)
    {
        if (autovehicul._isDirty)
        {
            [autovehicul updateAutovehicul];
        }
        else {
            if ([autovehicul CompletedPercent] > percentCompletedOnLoad)
                [autovehicul addAutovehicul];
        }
        
        if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
        {
            // selecteaza masina si ma duce direct in ecranul de calculator
            YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
            [parent setAutovehicul:autovehicul];
        }
        else if ([self.controller isKindOfClass:[YTOListaAutoViewController class]])
        {
            YTOListaAutoViewController * parent = (YTOListaAutoViewController *)self.controller;
            [parent reloadData];
        }
    }
}

- (void) btnSave_Clicked
{
    [self doneEditing];
    [self save];
    
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
    {
        // selecteaza masina si ma duce direct in ecranul de calculator
        YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
        [self.navigationController popToViewController:parent animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOListaAutoViewController class]])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) btnCancel_Clicked
{
    shouldSave = NO;
    
    // In cazul in care a modificat ceva si a apasat pe Cancel,
    // incarcam lista cu masini din baza de date
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate refreshMasini];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) load:(YTOAutovehicul *)a
{
    UIImageView * imgTextHeader = (UIImageView *)[cellAutoHeader viewWithTag:1];
    imgTextHeader.image = [UIImage imageNamed:@"text-header-masina-salvata.png"];
    
    [self setMarca:a.marcaAuto];
    [self setModel:a.modelAuto];
    [self setNrInmatriculare:a.nrInmatriculare];
    [self setJudet:a.judet];
    [self setLocalitate:a.localitate];
    [self setCategorieAuto:a.categorieAuto];
    [self setSubcategorieAuto:a.subcategorieAuto];
    [self setSerieSasiu:a.serieSasiu];
    [self setSerieCIV:a.serieCiv];
    [self setCm3:a.cm3];
    [self setPutere:a.putere];
    [self setMasaMaxima:a.masaMaxima];
    [self setNrLocuri:a.nrLocuri];
    [self setAnFabricatie:a.anFabricatie];
    [self setDestinatieAuto:a.destinatieAuto];
    [self setTipCombustibil:a.combustibil];
    [self setInLeasing:a.inLeasing];
    [self setNumeFirmaLeasing:a.firmaLeasing];
//    if (a.idImage && a.idImage.length > 0)
//    {
//        YTOImage *objImage = [YTOImage getImage:a.idImage];
//        [self setImage:objImage.image];
//    }
    
    // PENTRU ALERTE
    YTOAlerta * alertaRca = [YTOAlerta getAlertaRCA:autovehicul.idIntern];
    if (alertaRca)
        [self setAlerta:2 withDate:alertaRca.dataAlerta savingData:NO];
    YTOAlerta * alertaItp = [YTOAlerta getAlertaITP:autovehicul.idIntern];
    if (alertaItp)
        [self setAlerta:3 withDate:alertaItp.dataAlerta savingData:NO];
    YTOAlerta * alertaRovinieta = [YTOAlerta getAlertaRovinieta:autovehicul.idIntern];
    if (alertaRovinieta)
        [self setAlerta:4 withDate:alertaRovinieta.dataAlerta savingData:NO];
    YTOAlerta * alertaCasco = [YTOAlerta getAlertaCasco:autovehicul.idIntern];
    if (alertaCasco)
        [self setAlerta:5 withDate:alertaCasco.dataAlerta savingData:NO];
    alertaRataCasco = [YTOAlerta getAlertaRataCasco:autovehicul.idIntern];
    if (alertaRataCasco)
    {
        //[self setAlerta:6 withDate:alertaRataCasco.dataAlerta savingData:NO];
        [self setNumarRate:alertaRataCasco.numarTotalRate];
        if (alertaRataCasco.numarTotalRate > 0)
        {
            for (int i=0; i<alertaRataCasco.numarTotalRate; i++)
            {
                YTOAlerta * alert = [YTOAlerta getAlertaRataCasco:autovehicul.idIntern andNumarRata:i+1];
                if (alert)
                    [self setAlerta:(i+6) withDate:alert.dataAlerta savingData:NO];
            }
        }
    }
    else
        [self setNumarRate:0];
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
    
  //  [vwKeyboardAddon setHidden:NO];
}
- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
    
    [vwKeyboardAddon setHidden:YES];
}

#pragma YTO Nomenclator
- (void) showNomenclator
{
    [vwNomenclator setHidden:NO];
    UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    NSMutableArray * listOfItems;
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = 0;
    if (_nomenclatorTip == kCategoriiAuto)
    {
        [lblTitle setText:@"Selecteaza categoria auto"];
        listOfItems = categoriiAuto;
        _nomenclatorNrItems = categoriiAuto.count;
        selectedItemIndex = [YTOUtils getKeyList:categoriiAuto forValue:autovehicul.subcategorieAuto];
    }
    else if (_nomenclatorTip == kDestinatieAuto)
    {
        [lblTitle setText:@"Selecteaza destinatia auto"];
        listOfItems = destinatiiAuto;
        _nomenclatorNrItems = destinatiiAuto.count;
        selectedItemIndex = [YTOUtils getKeyList:destinatiiAuto forValue:autovehicul.destinatieAuto];
    }
    else if (_nomenclatorTip == kTipCombustibil)
    {
        [lblTitle setText:@"Selecteaza tipul de combustibil"];
        listOfItems = tipCombustibil;
        _nomenclatorNrItems = tipCombustibil.count;
        selectedItemIndex = [YTOUtils getKeyList:tipCombustibil forValue:autovehicul.combustibil];
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
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    for (int i=100; i<=100+_nomenclatorNrItems; i++) {
        
        UIButton * _btn = (UIButton *)[scrollView viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (_nomenclatorTip == kCategoriiAuto)
    {
        KeyValueItem * item = (KeyValueItem *)[categoriiAuto objectAtIndex:btn.tag-100];
        [self setCategorieAuto:item.parentKey];
        [self setSubcategorieAuto:item.value];
        
        // punem default cateva valori daca se adauga o masina noua
        if (!autovehicul._isDirty)
        {
            if (item.parentKey == 1) { // pentru Autoturism
                [self setNrLocuri:5];
            }
            if (item.parentKey == 3) { // pentru Autovehicul-transport-persoane
                [self setTipCombustibil:@"motorina"];
            }
            if (item.parentKey == 4) { // pentru Autovehicul-transport-marfa
                [self setTipCombustibil:@"motorina"];
            }
            if (item.parentKey == 5) { // pentru Autotractor
                [self setTipCombustibil:@"motorina"];
            }
            if (item.parentKey == 6) { // pentru Tractor-rutier
                [self setTipCombustibil:@"motorina"];
            }
            if (item.parentKey == 7) { // pentru Motociclete
                [self setNrLocuri:2];
                [self setTipCombustibil:@"benzina"];
            }
            if (item.parentKey == 8) { // pentru Remorca/Semiremorca/Rulota
                [self setTipCombustibil:@"fara"];
            }
        }
        
    }
    else if (_nomenclatorTip == kDestinatieAuto)
    {
        KeyValueItem * item = (KeyValueItem *)[destinatiiAuto objectAtIndex:btn.tag-100];
        [self setDestinatieAuto:item.value];
    }
    else if (_nomenclatorTip == kTipCombustibil)
    {
        KeyValueItem * item = (KeyValueItem *)[tipCombustibil objectAtIndex:btn.tag-100];
        [self setTipCombustibil:item.value];
    }
}

-(void)nomenclatorChosen:(KeyValueItem *)item rowIndex:(NSIndexPath *)index forView:(YTONomenclatorViewController *)view
{
    if (view.nomenclator == kCategoriiAuto)
    {
        [self setCategorieAuto:item.parentKey];
        [self setSubcategorieAuto:item.value];
    }
    else if (view.nomenclator == kTipCombustibil)
    {
        [self setTipCombustibil:item.value];
    }
    else if (view.nomenclator == kDestinatieAuto)
    {
        [self setDestinatieAuto:item.value];
    }
     goingBack = YES;
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    
    if (indexPath.row == 2) // MARCA
    {
        [self setMarca:selected];
    }
    if (indexPath.row == 5) // JUDET + LOCALITATE
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

//#pragma Action Sheet
//-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 0)
//    {
//        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        [self presentModalViewController:picker animated:YES];
//    }
//    else if (buttonIndex == 1) {
//        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
//        [self presentModalViewController:picker animated:YES];
//    }
//}

- (void) initCells {
    
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE TALON"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];

    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellAutoHeader" owner:self options:nil];
    cellAutoHeader = [topLevelObjectsHeader objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellAutoHeader viewWithTag:2];
    //UIButton * btnImage = (UIButton *)[cellAutoHeader viewWithTag:5];
    //[btnImage addTarget:self action:@selector(chooseImage) forControlEvents:UIControlEventTouchUpInside];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellMarcaAuto = [topLevelObjectsMarca objectAtIndex:0];
    [(UILabel *)[cellMarcaAuto viewWithTag:1] setText:@"MARCA AUTO"];
    [YTOUtils setCellFormularStyle:cellMarcaAuto];
    
    NSArray *topLevelObjectsModel = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellModelAuto = [topLevelObjectsModel objectAtIndex:0];
    [(UILabel *)[cellModelAuto viewWithTag:1] setText:@"MODEL AUTO"];
    [(UITextField *)[cellModelAuto viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellModelAuto];     
    
//    NSArray *topLevelObjectsSubcategorie = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
//    cellSubcategorieAuto = [topLevelObjectsSubcategorie objectAtIndex:0];
//    [(UILabel *)[cellSubcategorieAuto viewWithTag:1] setText:@"CATEGORIE AUTOVEHICUL"];
//    [YTOUtils setCellFormularStyle:cellSubcategorieAuto];
    
    NSArray *topLevelObjectsNrInmatriculare = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellNrInmatriculare = [topLevelObjectsNrInmatriculare objectAtIndex:0];
//    [(UILabel *)[cellModelNrInmatriculare viewWithTag:1] setText:@"MODEL AUTO"];
//    [(UITextField *)[cellModelNrInmatriculare viewWithTag:2] setPlaceholder:@"ex. Logan/Clio, etc."];
    [(UILabel *)[cellNrInmatriculare viewWithTag:1] setText:@"NR. INMATRICULARE"];
   // [(UITextField *)[cellNrInmatriculare viewWithTag:2] setPlaceholder:@"ex. B01ABC"];
    [(UITextField *)[cellNrInmatriculare viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellNrInmatriculare];
    
    NSArray *topLevelObjectsSasiu = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellSerieSasiu = [topLevelObjectsSasiu objectAtIndex:0];
    [(UILabel *)[cellSerieSasiu viewWithTag:1] setText:@"SERIE SASIU"];
    [(UITextField *)[cellSerieSasiu viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
   // [(UITextField *)[cellSerieSasiu viewWithTag:2] setPlaceholder:@"poz. E sau poz. 3"];
    [YTOUtils setCellFormularStyle:cellSerieSasiu]; 
    
    NSArray *topLevelObjectsCm3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellCm3 = [topLevelObjectsCm3 objectAtIndex:0];
    [(UILabel *)[cellCm3 viewWithTag:1] setText:@"CM3"];
//    [(UITextField *)[cellCm3 viewWithTag:2] setPlaceholder:@"ex.1590"];
    [(UITextField *)[cellCm3 viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellCm3];
    
    NSArray *topLevelObjectsPutere = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellPutere = [topLevelObjectsPutere objectAtIndex:0];
    [(UILabel *)[cellPutere viewWithTag:1] setText:@"Putere (kW)"];
  //  [(UITextField *)[cellPutere viewWithTag:2] setPlaceholder:@"ex.75"];
    [(UITextField *)[cellPutere viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellPutere];
    
    NSArray *topLevelObjectsNrLocuri = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellNrLocuri = [topLevelObjectsNrLocuri objectAtIndex:0];
    [(UILabel *)[cellNrLocuri viewWithTag:1] setText:@"NUMAR LOCURI"];
    //[(UITextField *)[cellNrLocuri viewWithTag:2] setPlaceholder:@"ex. 5"];
    [(UITextField *)[cellNrLocuri viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellNrLocuri];
    
    NSArray *topLevelObjectsMasaMaxima = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellMasaMaxima = [topLevelObjectsMasaMaxima objectAtIndex:0];
    [(UILabel *)[cellMasaMaxima viewWithTag:1] setText:@"MASA MAXIMA (kg)"];
    //[(UITextField *)[cellMasaMaxima viewWithTag:2] setPlaceholder:@"ex. 1600"];
    [(UITextField *)[cellMasaMaxima viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellMasaMaxima];
    
    NSArray *topLevelObjectsAnFabr = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellAnFabricatie = [topLevelObjectsAnFabr objectAtIndex:0];
    [(UILabel *)[cellAnFabricatie viewWithTag:1] setText:@"AN FABRICATIE"];
    [(UITextField *)[cellAnFabricatie viewWithTag:2] setPlaceholder:@""];    
    [(UITextField *)[cellAnFabricatie viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellAnFabricatie];     
    
    NSArray *topLevelObjectsCiv = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellSerieCiv = [topLevelObjectsCiv objectAtIndex:0];
    [(UILabel *)[cellSerieCiv viewWithTag:1] setText:@"SERIE TALON"];
    //[(UITextField *)[cellSerieCiv viewWithTag:2] setPlaceholder:@"poz. X"];
    [YTOUtils setCellFormularStyle:cellSerieCiv]; 
    
    NSArray *topLevelObjectsInLeasing = [[NSBundle mainBundle] loadNibNamed:@"CellView_DaNu" owner:self options:nil];
    cellInLeasing = [topLevelObjectsInLeasing objectAtIndex:0];
    [(UILabel *)[cellInLeasing viewWithTag:6] setText:@"AUTO IN LEASING ?"];
    [YTOUtils setCellFormularStyle:cellLeasingFirma];
    UIButton * btnLeasingDa = (UIButton *)[cellInLeasing viewWithTag:1];
    [btnLeasingDa addTarget:self action:@selector(btnInLeasing_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnLeasingNu = (UIButton *)[cellInLeasing viewWithTag:2];
    [btnLeasingNu addTarget:self action:@selector(btnInLeasing_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectsFirmaLeasing = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellLeasingFirma = [topLevelObjectsFirmaLeasing objectAtIndex:0];
    [(UILabel *)[cellLeasingFirma viewWithTag:1] setText:@"DENUMIRE FIRMA LEASING"];
    [(UITextField *)[cellLeasingFirma viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];    
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];        
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    // CELLS ALERTE
    NSArray *topLevelObjectsAlertaRca = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareRCA = [topLevelObjectsAlertaRca objectAtIndex:0];
    [(UILabel *)[cellExpirareRCA viewWithTag:1] setText:@"RCA"];
    [(UITextField *)[cellExpirareRCA viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareRCA viewWithTag:2] setPlaceholder:@"selecteaza ultima zi de valabilitate"];
    ((UITextField *)[cellExpirareRCA viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareRCA viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-rca.png"];
    [YTOUtils setCellFormularStyle:cellExpirareRCA];
    
    NSArray *topLevelObjectsAlertaITP = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareITP = [topLevelObjectsAlertaITP objectAtIndex:0];
    [(UILabel *)[cellExpirareITP viewWithTag:1] setText:@"ITP"];
    [(UITextField *)[cellExpirareITP viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareITP viewWithTag:2] setPlaceholder:@"selecteaza ultima zi de valabilitate"];
    ((UITextField *)[cellExpirareITP viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareITP viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-itp.png"];
    [YTOUtils setCellFormularStyle:cellExpirareITP];
    
    NSArray *topLevelObjectsAlertaRovinieta = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareRovinieta = [topLevelObjectsAlertaRovinieta objectAtIndex:0];
    [(UILabel *)[cellExpirareRovinieta viewWithTag:1] setText:@"Rovinieta"];
    [(UITextField *)[cellExpirareRovinieta viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareRovinieta viewWithTag:2] setPlaceholder:@"selecteaza ultima zi de valabilitate"];
    ((UITextField *)[cellExpirareRovinieta viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareRovinieta viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-rovinieta.png"];
    [YTOUtils setCellFormularStyle:cellExpirareRovinieta];
    
    NSArray *topLevelObjectsAlertaCasco = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareCASCO = [topLevelObjectsAlertaCasco objectAtIndex:0];
    [(UILabel *)[cellExpirareCASCO viewWithTag:1] setText:@"CASCO"];
    [(UITextField *)[cellExpirareCASCO viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareCASCO viewWithTag:2] setPlaceholder:@"selecteaza ultima zi de valabilitate"];
    ((UITextField *)[cellExpirareCASCO viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareCASCO viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-casco.png"];
    [YTOUtils setCellFormularStyle:cellExpirareCASCO];
    
    NSArray *topLevelObjectsNumarRate = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellNumarRate = [topLevelObjectsNumarRate objectAtIndex:0];
    [(UILabel *)[cellNumarRate viewWithTag:1] setText:@"NUMAR RATE CASCO"];
    UIStepper * stepper = (UIStepper *)[cellNumarRate viewWithTag:3];
    stepper.minimumValue = 1;
    stepper.maximumValue = 12;
    stepper.value = 0;
    [stepper addTarget:self action:@selector(numarRate_Changed:) forControlEvents:UIControlEventValueChanged];
    [YTOUtils setCellFormularStyle:cellNumarRate];
    
    listCellRateCasco = [[NSMutableArray alloc] init];
    for (int i=0; i<12; i++) {
        NSArray *topLevelObjectsXRata = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
        UITableViewCell * cellXRata = [[UITableViewCell alloc] init];
        cellXRata = [topLevelObjectsXRata objectAtIndex:0];
        [(UILabel *)[cellXRata viewWithTag:1] setText:[NSString stringWithFormat:@"RATA %d CASCO", (i+1)]];
        ((UIImageView *)[cellXRata viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-rata-casco.png"];
        [listCellRateCasco addObject:cellXRata];
    }
    
    NSArray *topLevelObjectsAlertaRataCasco = [[NSBundle mainBundle] loadNibNamed:@"CellView_String2" owner:self options:nil];
    cellExpirareRataCASCO = [topLevelObjectsAlertaRataCasco objectAtIndex:0];
    [(UILabel *)[cellExpirareRataCASCO viewWithTag:1] setText:@"RATA SCADENTA CASCO"];
    [(UITextField *)[cellExpirareRataCASCO viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [(UITextField *)[cellExpirareRataCASCO viewWithTag:2] setPlaceholder:@"selecteaza ultima zi de valabilitate"];
    ((UITextField *)[cellExpirareRataCASCO viewWithTag:2]).font = [UIFont fontWithName:@"Arial" size:12.0];
    ((UIImageView *)[cellExpirareRataCASCO viewWithTag:3]).image = [UIImage imageNamed:@"icon-alerta-rata-casco.png"];     
    //[YTOUtils setCellFormularStyle:cellExpirareRataCASCO];
}

- (void) numarRate_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    
    [self setNumarRate:stepper.value];
    [tableView reloadData];
    
    //[self setDataInceput:date];
}

- (void) showListaMarciAuto:(NSIndexPath *)index;
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database MarciAuto]];
    actionPicker._indexPath = index;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Marci Auto";
    [self presentModalViewController:actionPicker animated:YES];
}

- (IBAction) selectMarcaAuto
{
    
}

- (IBAction) chooseImage
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet * menu = [[UIActionSheet alloc] initWithTitle:@"Sursa imaginii" delegate:self cancelButtonTitle:@"Renunt" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Album", nil];
        
//        [menu showInView:self.view];
        [menu showFromTabBar:self.tabBarController.tabBar];
    }
    else {
        UIImagePickerController * picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //UIImage * selectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage * originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];

    YTOImage * img = [[YTOImage alloc] initWithGuid:[YTOUtils GenerateUUID]];
    img.image = [YTOUtils scaleImage:originalImage maxWidth:320 maxHeight:480];
    
    [img addImage];
    autovehicul.idImage = img.idIntern;
    [self setImage:img.image];
    
    [picker dismissModalViewControllerAnimated:YES];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
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

//- (void) showListaCategoriiAuto
//{
//    goingBack = NO;
//    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
//    actionPicker.listOfItems = categoriiAuto;
//    //actionPicker._indexPath = index;
//    actionPicker.nomenclator = kCategoriiAuto;
//    actionPicker.delegate = self;
//    //actionPicker.titlu = @"Judete";
//    [self presentModalViewController:actionPicker animated:YES];    
//}

- (void) showListaDestinatieAuto:(NSIndexPath *)index
{
    goingBack = NO;
    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
    actionPicker.listOfItems = destinatiiAuto;
    //actionPicker._indexPath = index;
    actionPicker.nomenclator = kDestinatieAuto;
    actionPicker.delegate = self;
    //actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES]; 
}

- (void) showListaTipCombustibil:(NSIndexPath *)index
{
    goingBack = NO;
    YTONomenclatorViewController * actionPicker = [[YTONomenclatorViewController alloc]initWithNibName:@"YTONomenclatorViewController" bundle:nil];
    actionPicker.listOfItems = tipCombustibil;
    //actionPicker._indexPath = index;
    actionPicker.nomenclator = kTipCombustibil;
    actionPicker.delegate = self;
    //actionPicker.titlu = @"Judete";
    [self presentModalViewController:actionPicker animated:YES];
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;

    if (btn.tag  == 1) {
        [self setCategorieAuto:1];
        [self setSubcategorieAuto:@"Autoturism"];
    }
    else if (btn.tag == 2)
    {
        [self setCategorieAuto:1];
        [self setSubcategorieAuto:@"Autoturism-de-teren"];
    }
    else if (btn.tag == 3) {
        [self setCategorieAuto:7];
        if ([((UILabel *)[cellSubcategorieAuto viewWithTag:33]).text isEqualToString:@"Motocicleta"])
            [self setSubcategorieAuto:@"Motocicleta"];
        else
            [self setSubcategorieAuto:((UILabel *)[cellSubcategorieAuto viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kCategoriiAuto;
        [self showNomenclator];
    }
}

- (IBAction)checkboxCombustibilSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;

    if (btn.tag  == 1) {
        [self setTipCombustibil:@"benzina"];
    }
    else if (btn.tag == 2)
    {
        [self setTipCombustibil:@"motorina"];
    }
    else if (btn.tag == 3) {
        if ([((UILabel *)[cellCombustibil viewWithTag:33]).text isEqualToString:@"gpl"])
            [self setTipCombustibil:@"gpl"];
        else
            [self setTipCombustibil:((UILabel *)[cellCombustibil viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kTipCombustibil;
        [self showNomenclator];
    }
}

- (IBAction)checkboxDestinatieSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    if (btn.tag  == 1) {
        [self setDestinatieAuto:@"interes-personal"];
    }
    else if (btn.tag == 2)
    {
        [self setDestinatieAuto:@"distributie-marfa"];
    }
    else if (btn.tag == 3) {
        if ([((UILabel *)[cellDestinatieAuto viewWithTag:33]).text isEqualToString:@"taxi"])
            [self setDestinatieAuto:@"taxi"];
        else
            [self setDestinatieAuto:((UILabel *)[cellCombustibil viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kDestinatieAuto;
        [self showNomenclator];
    }
}

- (void) loadCategorii {
    //---ATENTIE---
    // Daca modifici aici vreun id, trebuie sa modifici si in AppDelegate
    // in application didFinishLaunchingWithOptions
    
    // 1 => Autoturism/Automobil-mixt
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"Autoturism";
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"Automobil-mixt";
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"Autoturism-de-teren";
    
    // 7 => Motocicleta
    KeyValueItem * c14 = [[KeyValueItem alloc] init];
    c14.parentKey = 7;
    c14.key = 3;
    c14.value = @"Motocicleta";
    KeyValueItem * c15 = [[KeyValueItem alloc] init];
    c15.parentKey = 7;
    c15.key = 4;
    c15.value = @"Moped";    
    KeyValueItem * c16 = [[KeyValueItem alloc] init];
    c16.parentKey = 7;
    c16.key = 5;
    c16.value = @"Atas";        
    KeyValueItem * c18 = [[KeyValueItem alloc] init];
    c18.parentKey = 7;
    c18.key = 7;
    c18.value = @"Scuter";        
    KeyValueItem * c19 = [[KeyValueItem alloc] init];
    c19.parentKey = 7;
    c19.key = 8;
    c19.value = @"ATV"; 
    
    // 2 => Autosanitara/Autorulota
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 2;
    c4.key = 9;
    c4.value = @"Autosanitara";
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 2;
    c5.key = 10;
    c5.value = @"Autorulota";
    
    // 3 => Autovehicul transport persoane
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 3;
    c6.key = 11;
    c6.value = @"Microbuz";
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 3;
    c7.key = 12;
    c7.value = @"Autobuz";
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 3;
    c8.key = 13;
    c8.value = @"Autocar";
    
    // 4 => Autovehicul transport marfa
    KeyValueItem * c9 = [[KeyValueItem alloc] init];
    c9.parentKey = 4;
    c9.key = 14;
    c9.value = @"Autoutilitara";
    KeyValueItem * c10 = [[KeyValueItem alloc] init];
    c10.parentKey = 4;
    c10.key = 15;
    c10.value = @"Autofurgon";
    KeyValueItem * c11 = [[KeyValueItem alloc] init];
    c11.parentKey = 4;
    c11.key = 16;
    c11.value = @"Autocamion";
    KeyValueItem * c20 = [[KeyValueItem alloc] init];
    c20.parentKey = 4;
    c20.key = 19;
    c20.value = @"Camion";
    
    // 5 => Autotractor
    KeyValueItem * c12 = [[KeyValueItem alloc] init];
    c12.parentKey = 5;
    c12.key = 17;
    c12.value = @"Autotractor";
    
    // 6 => Tractor-rutier
    KeyValueItem * c13 = [[KeyValueItem alloc] init];
    c13.parentKey = 6;
    c13.key = 18;
    c13.value = @"Tractor-rutier";
    
    // 8 => Remorca
    KeyValueItem * c21 = [[KeyValueItem alloc] init];
    c21.parentKey = 8;
    c21.key = 20;
    c21.value = @"Remorca";
    KeyValueItem * c22 = [[KeyValueItem alloc] init];
    c22.parentKey = 8;
    c22.key = 21;
    c22.value = @"Semiremorca";
    
    categoriiAuto = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c14,c15,c16,c18,c19,c4,c5,c6,c7,c8,c9,c10,c11,c20,c12,c13,c21,c22, nil];
}

- (void) loadTipCombustibil
{
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"benzina";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"motorina";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"gpl";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"electric/hibrid";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"fara";
    
    tipCombustibil = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5, nil];
}

- (void) loadDestinatieAuto
{
    KeyValueItem * c1 = [[KeyValueItem alloc] init];
    c1.parentKey = 1;
    c1.key = 0;
    c1.value = @"interes-personal";
    
    KeyValueItem * c2 = [[KeyValueItem alloc] init];
    c2.parentKey = 1;
    c2.key = 1;
    c2.value = @"distributie-marfa";
    
    KeyValueItem * c3 = [[KeyValueItem alloc] init];
    c3.parentKey = 1;
    c3.key = 2;
    c3.value = @"transport-persoane";
    
    KeyValueItem * c4 = [[KeyValueItem alloc] init];
    c4.parentKey = 1;
    c4.key = 3;
    c4.value = @"transport-international";
    
    KeyValueItem * c5 = [[KeyValueItem alloc] init];
    c5.parentKey = 1;
    c5.key = 4;
    c5.value = @"paza-protectie-interventie";
    
    KeyValueItem * c6 = [[KeyValueItem alloc] init];
    c6.parentKey = 1;
    c6.key = 5;
    c6.value = @"taxi";
    
    KeyValueItem * c7 = [[KeyValueItem alloc] init];
    c7.parentKey = 1;
    c7.key = 6;
    c7.value = @"maxi-taxi";
    
    KeyValueItem * c8 = [[KeyValueItem alloc] init];
    c8.parentKey = 1;
    c8.key = 7;
    c8.value = @"scoala-soferi";
    
    KeyValueItem * c9 = [[KeyValueItem alloc] init];
    c9.parentKey = 1;
    c9.key = 8;
    c9.value = @"inchiriere";
    
    KeyValueItem * c10 = [[KeyValueItem alloc] init];
    c10.parentKey = 1;
    c10.key = 9;
    c10.value = @"curierat";
    
    KeyValueItem * c11 = [[KeyValueItem alloc] init];
    c11.parentKey = 1;
    c11.key = 10;
    c11.value = @"alte-activitati";
 
    destinatiiAuto = [[NSMutableArray alloc] initWithObjects:c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11, nil];
}

#pragma Proprietati

- (NSString *) getJudet
{
    return autovehicul.judet;
}
- (void) setJudet:(NSString *)judet
{
    autovehicul.judet = judet;
}

- (NSString *) getLocalitate
{
    return autovehicul.localitate;    
}
- (void) setLocalitate:(NSString *)localitate
{
    autovehicul.localitate = localitate;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [self getLocatie];
}

- (NSString *) getLocatie
{
    if ([self getJudet].length == 0 && [self getLocalitate].length ==0)
        return @"";
    return [NSString stringWithFormat:@"%@, %@", [self getJudet], [self getLocalitate]];
}

- (NSString *) getMarca
{
    return autovehicul.marcaAuto;
}
- (void) setMarca:(NSString *)marca
{
    UILabel * lbl = (UILabel *)[cellMarcaAuto viewWithTag:2];
    lbl.text = marca;
//   ((UIImageView *)[cellAutoHeader viewWithTag:3]).image = [YTOUtils getImageForValue:[NSString stringWithFormat:@"%@.png", marca]];
    autovehicul.marcaAuto = marca;
}

- (NSString *) getModel
{
    return autovehicul.modelAuto;
}
- (void) setModel:(NSString *)model
{
    UITextField * txt = (UITextField *)[cellModelAuto viewWithTag:2];
    txt.text = model;
    autovehicul.modelAuto = model;    
}

- (NSString *) getNrInmatriculare
{
    return autovehicul.nrInmatriculare;
}
- (void) setNrInmatriculare:(NSString *)numar
{
    UITextField * txt = (UITextField *)[cellNrInmatriculare viewWithTag:2];
    txt.text = [numar uppercaseString];
//    if (numar.length < 6 || numar.length > 7)
//    {    
//        [(UILabel *)[cellNrInmatriculare viewWithTag:20] setHidden:NO];
//    }
//    else {
//        [(UILabel *)[cellNrInmatriculare viewWithTag:20] setHidden:YES];
//    }
    autovehicul.nrInmatriculare = numar;
}

- (NSString *) getSerieSasiu
{
    return autovehicul.serieSasiu;
}
- (void) setSerieSasiu:(NSString *)serie
{
    UITextField * txt = (UITextField *)[cellSerieSasiu viewWithTag:2];
    UIImageView * imgAlert = (UIImageView *)[cellSerieSasiu viewWithTag:10];
    
    serie = [YTOUtils replacePossibleWrongSerieSasiu:[serie uppercaseString]];
    
    txt.text = serie;
    autovehicul.serieSasiu = serie;
    
    if (serie && serie.length > 0 && [YTOUtils validateSasiu:serie])
        [imgAlert setHidden:YES];
    else
        [imgAlert setHidden:NO];
}

- (NSString *) getSerieCIV
{
    return autovehicul.serieCiv;
}
- (void) setSerieCIV:(NSString *)serie
{
    UITextField * txt = (UITextField *)[cellSerieCiv viewWithTag:2];
    UIImageView * imgAlert = (UIImageView *)[cellSerieCiv viewWithTag:10];
    
    txt.text = serie;
    autovehicul.serieCiv = serie;
    
    if (serie && serie.length > 0 && [YTOUtils validateCIV:serie])
        [imgAlert setHidden:YES];
    else
        [imgAlert setHidden:NO];
}

- (int) getNrLocuri
{
    return autovehicul.nrLocuri;
}
- (void) setNrLocuri:(int)numar
{
    UITextField * txt = (UITextField *)[cellNrLocuri viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d", numar];
    autovehicul.nrLocuri = numar;        
}

- (int) getMasaMaxima
{
    return autovehicul.masaMaxima;
}
- (void) setMasaMaxima:(int)masa
{
    UITextField * txt = (UITextField *)[cellMasaMaxima viewWithTag:2];
    if (masa > 0)
    {
        txt.text = [NSString stringWithFormat:@"%d Kg", masa];
        autovehicul.masaMaxima = masa;
    }
}

- (int) getCategorieAuto
{
    return autovehicul.categorieAuto;
}
- (void) setCategorieAuto:(int)categorie
{
    autovehicul.categorieAuto = categorie;
}

- (NSString *) getSubcategorieAuto
{
    return autovehicul.subcategorieAuto;
}
- (void) setSubcategorieAuto:(NSString *)subcategorie
{
    // resetez butoanele selectate
    ((UIButton *)[cellSubcategorieAuto viewWithTag:1]).selected = ((UIButton *)[cellSubcategorieAuto viewWithTag:2]).selected =
        ((UIButton *)[cellSubcategorieAuto viewWithTag:3]).selected = ((UIButton *)[cellSubcategorieAuto viewWithTag:4]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([subcategorie isEqualToString:@"Autoturism"])
        ((UIButton *)[cellSubcategorieAuto viewWithTag:1]).selected = YES;
    else if ([subcategorie isEqualToString:@"Autoturism-de-teren"])
        ((UIButton *)[cellSubcategorieAuto viewWithTag:2]).selected = YES;
    else if ([subcategorie isEqualToString:@"Motocicleta"]) {
        ((UIButton *)[cellSubcategorieAuto viewWithTag:3]).selected = YES;
        ((UILabel *)[cellSubcategorieAuto viewWithTag:33]).text = subcategorie;
    }
    else {
        ((UIButton *)[cellSubcategorieAuto viewWithTag:3]).selected = YES;
        ((UILabel *)[cellSubcategorieAuto viewWithTag:33]).text = subcategorie;
    }
    autovehicul.subcategorieAuto = subcategorie;
}
         
- (NSString *) getTipCombustibil
{
    return autovehicul.combustibil;
}
- (void) setTipCombustibil:(NSString *)s
{
    ((UIButton *)[cellCombustibil viewWithTag:1]).selected = ((UIButton *)[cellCombustibil viewWithTag:2]).selected =
    ((UIButton *)[cellCombustibil viewWithTag:3]).selected = ((UIButton *)[cellCombustibil viewWithTag:4]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([s isEqualToString:@"benzina"])
        ((UIButton *)[cellCombustibil viewWithTag:1]).selected = YES;
    else if ([s isEqualToString:@"motorina"])
        ((UIButton *)[cellCombustibil viewWithTag:2]).selected = YES;
    else if ([s isEqualToString:@"gpl"]) {
        ((UILabel *)[cellCombustibil viewWithTag:33]).text = s;
        ((UIButton *)[cellCombustibil viewWithTag:3]).selected = YES;
    }
    else {
        ((UILabel *)[cellCombustibil viewWithTag:33]).text = s;
        ((UIButton *)[cellCombustibil viewWithTag:3]).selected = YES;
    }
    
    autovehicul.combustibil = s;
}

- (NSString *) getDestinatieAuto
{
    return autovehicul.destinatieAuto;
}
- (void) setDestinatieAuto:(NSString *)s
{
    // resetez butoanele selectate
    ((UIButton *)[cellDestinatieAuto viewWithTag:1]).selected = ((UIButton *)[cellDestinatieAuto viewWithTag:2]).selected =
    ((UIButton *)[cellDestinatieAuto viewWithTag:3]).selected = ((UIButton *)[cellDestinatieAuto viewWithTag:4]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([s isEqualToString:@"interes-personal"])
        ((UIButton *)[cellDestinatieAuto viewWithTag:1]).selected = YES;
    else if ([s isEqualToString:@"distributie-marfa"])
        ((UIButton *)[cellDestinatieAuto viewWithTag:2]).selected = YES;
    else if ([s isEqualToString:@"taxi"]) {
        ((UIButton *)[cellDestinatieAuto viewWithTag:3]).selected = YES;
        ((UILabel *)[cellDestinatieAuto viewWithTag:33]).text = s;
    }
    else {
        ((UIButton *)[cellDestinatieAuto viewWithTag:3]).selected = YES;
        ((UILabel *)[cellDestinatieAuto viewWithTag:33]).text = s;
    }
    autovehicul.destinatieAuto = s;
}

- (int) getCm3
{
    return autovehicul.cm3;
}
- (void) setCm3:(int)v
{
    if (v != 0)
    {
        UITextField * txt = (UITextField *)[cellCm3 viewWithTag:2];
        txt.text = [NSString stringWithFormat:@"%d cm3", v];
        autovehicul.cm3 = v;
    }
}

- (int) getPutere
{
    return autovehicul.putere;
}
- (void) setPutere:(int)v
{
    if (v != 0)
    {
        UITextField * txt = (UITextField *)[cellPutere viewWithTag:2];
        txt.text = [NSString stringWithFormat:@"%d kW", v];
        autovehicul.putere = v;
    }
    
}

- (int) getAnFabricatie
{
    return autovehicul.anFabricatie;
}
- (void) setAnFabricatie:(int)v
{
    UIImageView * imgAlert = (UIImageView *)[cellAnFabricatie viewWithTag:10];
    
    if (v != 0)
    {
        UITextField * txt = (UITextField *)[cellAnFabricatie viewWithTag:2];
        txt.text = [NSString stringWithFormat:@"%d", v];
    }
    autovehicul.anFabricatie = v;
    
    if (v > 1950 || v <= [YTOUtils getAnCurent] + 1)
        [imgAlert setHidden:YES];
    else
        [imgAlert setHidden:NO];
}

- (void) setInLeasing:(NSString *)v
{
    UILabel *lblDA = (UILabel *)[cellInLeasing viewWithTag:3];
    UILabel *lblNU = (UILabel *)[cellInLeasing viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellInLeasing viewWithTag:5];
    
    if ([v isEqualToString:@"nu"])
    {
        img.image = [UIImage imageNamed:@"da-nu-nu-rca.png"];
        lblDA.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblNU.textColor = [UIColor whiteColor];
        autovehicul.inLeasing = @"nu";
    }
    else if ([v isEqualToString:@"da"])
    {
        img.image = [UIImage imageNamed:@"da-nu-da-rca.png"];
        lblNU.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDA.textColor = [UIColor whiteColor];
        autovehicul.inLeasing = @"da";
    }
}

- (void) setNumarRate:(int)x
{
    UILabel * lbl = (UILabel *)[cellNumarRate viewWithTag:2];
    lbl.text = (x == 0 ? @"integral" : [NSString stringWithFormat:@"%d %@", x, (x == 1 ? @"rata" : @"rate")]);
    
    if (alertaRataCasco == nil)
    {
        alertaRataCasco = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        alertaRataCasco.tipAlerta = 6;
        alertaRataCasco.idObiect = autovehicul.idIntern;
        alertaRataCasco.esteRata = @"da";
        alertaRataCasco.dataAlerta = [[NSDate date] dateByAddingTimeInterval:-99999999];
    }
    alertaRataCasco.numarTotalRate = x;
}

- (void) setNumeFirmaLeasing:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellLeasingFirma viewWithTag:2];
    txt.text = v;
    autovehicul.firmaLeasing = v;
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

- (void) setImage:(UIImage *)img   
{
    UIButton * btnImg = (UIButton *)[cellAutoHeader viewWithTag:5];
    [btnImg setImage:img forState:UIControlStateNormal];
    btnImg.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma CELL LEASING
- (void) btnInLeasing_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL leasing = btn.tag == 1;
    
    [self setInLeasing:leasing ? @"da" : @"nu"];
    
    [tableView reloadData];
}

#pragma INFO || ALERTE
- (IBAction)btnInfoAlerte_OnClick:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL esteInfoMasina = btn.tag == 1;
    
    UILabel *lblInfoMasina = (UILabel *)[cellInfoAlerte viewWithTag:3];
    UILabel *lblAlerte = (UILabel *)[cellInfoAlerte viewWithTag:4];
    UIImageView * imgInfoAlerte = (UIImageView *)[cellInfoAlerte viewWithTag:5];
    
    if (!esteInfoMasina)
    {
        selectatInfoMasina = NO;
        lblInfoMasina.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblAlerte.textColor = [UIColor whiteColor];
        imgInfoAlerte.image = [UIImage imageNamed:@"selectat-dreapta-masina.png"];
        ((UIImageView *)[cellAutoHeader viewWithTag:1]).image = [UIImage imageNamed:@"header-alerte-masina.png"];
        [self save];
    }
    else
    {
        selectatInfoMasina = YES;
        lblInfoMasina.textColor = [UIColor whiteColor];
        lblAlerte.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        imgInfoAlerte.image = [UIImage imageNamed:@"selectat-stanga-masina.png"];
        ((UIImageView *)[cellAutoHeader viewWithTag:1]).image = [UIImage imageNamed:@"text-header-masina.png"];
    }
    
    [tableView reloadData];
}

@end
