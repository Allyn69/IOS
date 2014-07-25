//
//  YTOListaAsiguratiViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/17/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOListaAsiguratiViewController.h"
#import "YTOAppDelegate.h"
#import "YTOCalculatorViewController.h"
#import "YTOCASCOViewController.h"
#import "YTOCalatorieViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOSetariViewController.h"
#import "YTOAsiguratViewController.h"
#import "Database.h"
#import "UILabel+dynamicSizeMe.h"
#import "YTOUserDefaults.h"
#import "YTOMyTravelsViewController.h"
#import "YTOCasaMeaViewController.h"

@interface YTOListaAsiguratiViewController ()

@end

@implementation YTOListaAsiguratiViewController

@synthesize controller;
@synthesize produsAsigurare;
@synthesize listaAsiguratiSelectati, listAsiguratiIndecsi, tagViewControllerFrom;
//@synthesize indexAsigurat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i417", [YTOUserDefaults getLanguage],@"Lista persoane");
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
    //self.trackedViewName = @"YTOListaAsiguratiViewController";
    //indexAsigurat = -1;
    tableView.allowsSelectionDuringEditing = YES;
    goingBack = YES;
    
    // Do any additional setup after loading the view from its nib.
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    lblWvEmpty1.text =  NSLocalizedStringFromTable(@"i419", [YTOUserDefaults getLanguage],@"Adauga asigurat");
    lblWvEmpty2.text =  NSLocalizedStringFromTable(@"i168", [YTOUserDefaults getLanguage],@"Adauga asigurat");
    lblEditeaza.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    lblAdauga.textColor = [YTOUtils colorFromHexString:@"#78a9b9"];
    if (produsAsigurare == RCA || produsAsigurare == Locuinta){
        lblAdauga.text = NSLocalizedStringFromTable(@"i418", [YTOUserDefaults getLanguage],@"Adauga asigurat");
    }
    if (produsAsigurare == Calatorie)
    {
        lblAdauga.text = NSLocalizedStringFromTable(@"i15", [YTOUserDefaults getLanguage],@"Adauga calator");
        [self checkVisibilityForOk];
        listaAsigurati = [YTOPersoana PersoaneFizice];
        if (listaAsiguratiSelectati.count == 0)
        {
            listaAsiguratiSelectati = [[NSMutableArray alloc] init];
            listAsiguratiIndecsi = [[NSMutableArray alloc] init];
            
        }
    }
    if (produsAsigurare == MyTravels)
    {
        lblAdauga.text = NSLocalizedStringFromTable(@"i15", [YTOUserDefaults getLanguage],@"Adauga calator");
        [self checkVisibilityForOk];
        listaAsigurati = [YTOPersoana PersoaneFizice];
    }
    else {
        if ([controller isKindOfClass:[YTOSetariViewController class]])
            listaAsigurati = [YTOPersoana AltePersoane];
        else
            listaAsigurati = [appDelegate Persoane];
    }
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#f15a24"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];
    
    lblStudent.text = NSLocalizedStringFromTable(@"i2", [YTOUserDefaults getLanguage],@"Elev/\nStudent");
    lblBoliCardio.text = NSLocalizedStringFromTable(@"i5", [YTOUserDefaults getLanguage],@"Boli\nCardio");
    lblSportAgrement.text = NSLocalizedStringFromTable(@"i3", [YTOUserDefaults getLanguage],@"Sport\nAgrement");
    lblReduceriMajorari.text = NSLocalizedStringFromTable(@"i11", [YTOUserDefaults getLanguage],@"Reduceri/Majorari");
    lblBoliAfectiuni.text = NSLocalizedStringFromTable(@"i0", [YTOUserDefaults getLanguage],@"Boli/Afectiuni");
    lblBoliNeuro.text = NSLocalizedStringFromTable(@"i6", [YTOUserDefaults getLanguage],@"Boli\nNeuro");
    lblBoliInterne.text = NSLocalizedStringFromTable(@"i7", [YTOUserDefaults getLanguage],@"Boli\nInterne");
    lblBoliAparatResp.text = NSLocalizedStringFromTable(@"i8", [YTOUserDefaults getLanguage],@"Boli aparat\nRespirator");
    lblBoliDef.text = NSLocalizedStringFromTable(@"i9", [YTOUserDefaults getLanguage],@"Boli\ndefinitive");
    lblAlteBoli.text = NSLocalizedStringFromTable(@"i10", [YTOUserDefaults getLanguage],@"Alte\nBoli");
    lblGradInv.text = NSLocalizedStringFromTable(@"i4", [YTOUserDefaults getLanguage],@"Grad\nInvalidate");
    
    lblVarsta.text = NSLocalizedStringFromTable(@"i811", [YTOUserDefaults getLanguage],@"Este indicat sa faci o comanda separata pentru persoanele care au peste 65 de ani sau cele mai mici de 2 ani, deoarece nu toate companiile ofera asigurari de calatorie pentru acestea");
    lblContinua.text = NSLocalizedStringFromTable(@"i813", [YTOUserDefaults getLanguage],@"Continua");
    lblDeAcord.text = NSLocalizedStringFromTable(@"i812", [YTOUserDefaults getLanguage],@"De acord");
    lblAtentie.text =NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie");
    
    varstaNeg = NO;
    conditieVarstaChecked = NO;
    
    [self verifyViewMode];
}


- (void) verifyViewMode
{
    if (listaAsigurati.count == 0)
    {
        //self.navigationItem.rightBarButtonItem = nil;
        [YTOUtils rightImageVodafone:self.navigationItem];
        [vwEmpty setHidden:NO];
    }
    else if ([controller isKindOfClass:[YTOSetariViewController class]])
    {
        [vwEmpty setHidden:YES];
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
    if (![controller isKindOfClass:[YTOSetariViewController class]])
        [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void) viewWillDisappear:(BOOL)animated
{
    if (produsAsigurare == Calatorie && goingBack)
    {
        goingBack = YES;
        YTOCalatorieViewController  * parent = (YTOCalatorieViewController *)controller;
        [parent setListaAsigurati:listaAsiguratiSelectati withIndex:listAsiguratiIndecsi];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return listaAsigurati.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    if (produsAsigurare == Calatorie)
    {
        [self checkVisibilityForOk];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        for (int i = 0; i < listAsiguratiIndecsi.count; i++) {
            NSUInteger num = [[listAsiguratiIndecsi objectAtIndex:i] intValue];
            YTOPersoana * p = [listaAsiguratiSelectati objectAtIndex:i];
            
            //tagViewControllerForm e 2, inseamna ca vine din asiguratviewcontroller, altfel din calculator calatorie
            
            //cu lastRow aflu ultimul rand, ca sa stiu sa nu pun bifa, daca e adaugat un calator
            NSInteger lastRow = [tableView numberOfRowsInSection:[indexPath section]];
            if (num == indexPath.row) {
                //trebe sa vad daca e corect
                if ([p isValidForComputeCalatorie]) {
                    if (self.tagViewControllerFrom == 2 && num == lastRow)
                        [cell setAccessoryType:UITableViewCellAccessoryNone];
                    else
                        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
                else
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                
                // Once we find a match there is no point continuing the loop
                break;
            }
        }
    }
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (!editingMode){
        cell.textLabel.font = [UIFont fontWithName:@"Arial-Regular" size:20];
    }else{
        cell.textLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:17];
    }
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    if (!editingMode){
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:16];
    }else{
        cell.detailTextLabel.font = [UIFont fontWithName:@"Arial-ItalicMT" size:16];
    }
    YTOPersoana * p = (YTOPersoana *)[listaAsigurati objectAtIndex:indexPath.row];
    if ([p.proprietar isEqualToString:@"da"])
    {
        if ([p.tipPersoana isEqualToString:@"fizica"])
            cell.imageView.image = [UIImage imageNamed:@"icon-foto-person-xs-profil.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"icon-foto-person-profil-pj.png"];
    }
    else
    {
        if ([p.tipPersoana isEqualToString:@"fizica"])
            cell.imageView.image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
        else
            cell.imageView.image = [UIImage imageNamed:@"icon-foto-person-pj-xs.png"];
    }
    cell.textLabel.text = [p.nume uppercaseString];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", p.judet, p.localitate];
    
    if (indexPath.row % 2 != 0 && indexPath.row != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (produsAsigurare == Calatorie)
    {
        YTOPersoana * p = [listaAsigurati objectAtIndex:indexPath.row];
        YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        UITableViewCell *thisCell = [tv cellForRowAtIndexPath:indexPath];
        if (editingMode){
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.asigurat = p;
            aView.controller = self.controller;
            aView.produsAsigurare = self.produsAsigurare;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        // sa intre in formular daca nu sunt completate toate campurile
        else if (![p isValidForComputeCalatorie]) {
            
            //thisCell.accessoryType = UITableViewCellAccessoryNone;
            //remove the object at the index from array
            for (int i=0; i< listaAsiguratiSelectati.count; i++)
            {
                YTOPersoana * ps = [listaAsiguratiSelectati objectAtIndex:i];
                if ([ps.idIntern isEqualToString:p.idIntern])
                {
                    [listaAsiguratiSelectati removeObjectAtIndex:i];
                    break;
                }
            }
            [listAsiguratiIndecsi removeObject:[NSString stringWithFormat:@"%d", indexPath.row]];
            
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.asigurat = p;
            aView.controller = self.controller;
            // Retin indexul asiguratului pentru a bifa persoana cand revine din formular
            // indexAsigurat = indexPath.row;
            // aView.indexAsigurat = indexAsigurat;
            aView.produsAsigurare = self.produsAsigurare;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            
            return;
        }
        
        if (thisCell.accessoryType == UITableViewCellAccessoryNone) {
            
            thisCell.accessoryType = UITableViewCellAccessoryCheckmark;
            //add object in an array
            
            BOOL exista = NO;
            for (int i=0; i< listaAsiguratiSelectati.count; i++)
            {
                YTOPersoana * ps = [listaAsiguratiSelectati objectAtIndex:i];
                if ([ps.idIntern isEqualToString:p.idIntern])
                {
                    exista = YES;
                    break;
                }
            }
            
            YTOCalatorieViewController * parent = (YTOCalatorieViewController *)self.controller;
            [parent setCuloareCellCalatori];
            
            if (!exista)
            {
                if (!conditieVarstaChecked && ([[YTOUtils getVarsta:p.codUnic] intValue] <= 3 || [[YTOUtils getVarsta:p.codUnic] intValue] >= 65))
                    varstaNeg = YES;
                if (varstaNeg && [listaAsiguratiSelectati count] >=1 ){
                    [self vWVarstaShow:p];
                    persoanaVarsta = p;
                    indexPersoana = indexPath.row;
                }else{
                    [listaAsiguratiSelectati addObject:p];
                    [listAsiguratiIndecsi addObject:[NSString stringWithFormat:@"%d", indexPath.row]];
                    [self checkVisibilityForOk];
                    
                    [vwInfoCalatorie setHidden:NO];
                    activePersoana = p;
                    [lblPersoanaActiva setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i469", [YTOUserDefaults getLanguage],@"Despre"), p.nume]];
                    [self loadInfoCalatorie];
                }
            }
        }
        else{
            if (!editingMode){
                thisCell.accessoryType = UITableViewCellAccessoryNone;
                //remove the object at the index from array
                for (int i=0; i< listaAsiguratiSelectati.count; i++)
                {
                    YTOPersoana * ps = [listaAsiguratiSelectati objectAtIndex:i];
                    if ([ps.idIntern isEqualToString:p.idIntern])
                    {
                        [listaAsiguratiSelectati removeObjectAtIndex:i];
                        break;
                    }
                }
                [listAsiguratiIndecsi removeObject:[NSString stringWithFormat:@"%d", indexPath.row]];
                
                [self checkVisibilityForOk];
            }else if (editingMode){
                YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
                if (IS_IPHONE_5)
                    aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
                else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
                aView.asigurat = p;
                aView.controller = self.controller;
                aView.produsAsigurare = self.produsAsigurare;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
        }
        
    }
    else
    {
        YTOPersoana * persoana = [listaAsigurati objectAtIndex:indexPath.row];
        YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
        
        if (!editingMode && [self.controller isKindOfClass:[YTOCalculatorViewController class]] && persoana.isValidForCompute)
        {
            YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
            [parent setAsigurat:persoana];
            [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
        }else if ((editingMode || !persoana.isValidForCompute) && [self.controller isKindOfClass:[YTOCalculatorViewController class]]) {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.asigurat = persoana;
            aView.controller = self.controller;
            aView.produsAsigurare = self.produsAsigurare;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
//        if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
//        {
//            YTOCASCOViewController * parent = (YTOCASCOViewController *)self.controller;
//            
//            if ([persoana isValidForCompute] && !editingMode)
//            {
//                [parent setAsigurat:persoana];
//                [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
//            }
//            else
//            {
//                YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
//                if (IS_IPHONE_5)
//                    aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
//                else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
//                aView.asigurat = persoana;
//                aView.controller = self.controller;
//                aView.produsAsigurare = self.produsAsigurare;
//                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
//            }
//        }
        else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
        {
            YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
            
            // TRUE -  Daca persoana este valida, se poate
            //         folosi pentru calculatia asigurarii de locuinta
            // FALSE - Se incarca formularul de persoana, iar la
            //         salvare, se afiseaza calculatorul de asigurare de locuinta
            if ([persoana isValidForCompute] && !editingMode)
            {
                [parent setAsigurat:persoana];
                [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
            }
            else
            {
                YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
                if (IS_IPHONE_5)
                    aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
                else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
                aView.asigurat = persoana;
                aView.controller = self.controller;
                aView.produsAsigurare = self.produsAsigurare;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
        }
        
        else if ([self.controller isKindOfClass:[YTOCasaMeaViewController class]])
        {
            YTOCasaMeaViewController * parent = (YTOCasaMeaViewController *)self.controller;
            
            if ([persoana isValidForCompute] && !editingMode)
            {
                parent.asigurat = persoana;
                [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
            }
            else
            {
                YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
                //YTOPersoana *pers = persoana;
                if (IS_IPHONE_5)
                    aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
                else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
                aView.asigurat = persoana;
                aView.controller = self.controller;
                aView.produsAsigurare = self.produsAsigurare;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
            
            
        }
        else if ([self.controller isKindOfClass:[YTOMyTravelsViewController class]])
        {
            YTOMyTravelsViewController * parent = (YTOMyTravelsViewController *)self.controller;
            
            if ([persoana isValidForGothaer] && !editingMode)
            {
                parent.asigurat = persoana;
                [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
            }
            else
            {
                YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
                //YTOPersoana *pers = persoana;
                if (IS_IPHONE_5)
                    aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
                else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
                aView.asigurat = persoana;
                aView.controller = self.controller;
                aView.produsAsigurare = self.produsAsigurare;
                [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
            }
            
            
        }
        else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
        {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.asigurat = persoana;
            aView.controller = self;
            [appDelegate.setariNavigationController pushViewController:aView animated:YES];
        }
    }
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        YTOPersoana * persoana = [listaAsigurati objectAtIndex:indexPath.row];
        [persoana deletePersoana];
        [self reloadData];
    }
}

- (void) vWVarstaShow: (YTOPersoana *) p
{
    vwVarsta.hidden = NO;
}

- (void) vWVarstaHide
{
    vwVarsta.hidden = YES;
}

- (IBAction)btnContinua_clicked:(id)sender
{
    conditieVarstaChecked = YES;
    varstaNeg = NO;
    [listaAsiguratiSelectati addObject:persoanaVarsta];
    [listAsiguratiIndecsi addObject:[NSString stringWithFormat:@"%d", indexPersoana]];
    vwVarsta.hidden = YES;
    [vwInfoCalatorie setHidden:NO];
    activePersoana = persoanaVarsta;
    [lblPersoanaActiva setText:[NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i469", [YTOUserDefaults getLanguage],@"Despre"), persoanaVarsta.nume]];
    [self loadInfoCalatorie];
}

- (IBAction)btnDeAcord_clicked:(id)sender
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexPersoana inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    conditieVarstaChecked = YES;
    varstaNeg = NO;
    vwVarsta.hidden = YES;
}

- (IBAction)adaugaPersoana:(id)sender
{
    goingBack = NO;
    
    YTOAsiguratViewController * aView;
    if (IS_IPHONE_5)
        aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
    else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]] || [self.controller isKindOfClass:[YTOCasaMeaViewController class]] ||[self.controller isKindOfClass:[YTOMyTravelsViewController class]])
    {
        aView.controller = (YTOCalculatorViewController *)self.controller;
        
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
    {
        aView.controller = (YTOLocuintaViewController *)self.controller;;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOCalatorieViewController class]])
    {
        aView.controller = self;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
    {
        aView.controller = self;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
    {
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    
}

- (void) reloadData
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate refreshPersoane];
    
    if ([controller isKindOfClass:[YTOSetariViewController class]])
        listaAsigurati = [YTOPersoana AltePersoane];
    else if ([controller isKindOfClass:[YTOCalatorieViewController class]])
        listaAsigurati = [YTOPersoana PersoaneFizice];
    else
        listaAsigurati = [appDelegate Persoane];
    
    
    if (listaAsigurati.count > 0)
    {
        // [listAsiguratiIndecsi addObject:[NSString stringWithFormat:@"%d", (listaAsigurati.count -1)]];
        // [listaAsiguratiSelectati addObject:[listaAsigurati objectAtIndex:(listaAsigurati.count -1)]];
        
        [vwEmpty setHidden:YES];
        if ([self.controller isKindOfClass:[YTOSetariViewController class]])
        {
            YTOSetariViewController * parent = (YTOSetariViewController *)self.controller;
            [parent reloadData];
        }
    }
    if (listaAsigurati.count == 0)
        [YTOUtils rightImageVodafone:self.navigationItem];
    [tableView reloadData];
    [self verifyViewMode];
    
    
    // inseamna ca a ajuns in formularul de persoana,
    // a modificat persoana -> trebuie selectata
    //    if (indexAsigurat != -1)
    //    {
    //        NSIndexPath * _indexPath = [NSIndexPath indexPathForRow:indexAsigurat inSection:0];
    //        [self tableView:tableView didDeselectRowAtIndexPath:_indexPath];
    //    }
}

- (void) loadInfoCalatorie
{
    if ([activePersoana.elevStudent isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:1]).selected = YES;
    else
    {
        ((UIButton *)[vwInfoCalatorie viewWithTag:1]).selected = NO;
        activePersoana.elevStudent = @"nu";
    }
    
    if ([activePersoana.handicapLocomotor isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:3]).selected = YES;
    else
    {
        ((UIButton *)[vwInfoCalatorie viewWithTag:3]).selected = NO;
        activePersoana.handicapLocomotor = @"nu";
    }
    
    
    if([activePersoana.boliCardio isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:4]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:4]).selected = NO;
        activePersoana.boliCardio = @"nu";
    }
    
    if ([activePersoana.boliNeuro isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:5]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:5]).selected = NO;
        activePersoana.boliNeuro = @"nu";
    }
    if([activePersoana.boliInterne isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:6]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:6]).selected = NO;
        activePersoana.boliInterne = @"nu";
    }
    
    if([activePersoana.boliAparatRespirator isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:7]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:7]).selected = NO;
        activePersoana.boliAparatRespirator = @"nu";
    }
    
    if([activePersoana.boliDefinitive isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:8]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:8]).selected = NO;
        activePersoana.boliDefinitive = @"nu";
    }
    
    if([activePersoana.alteBoli isEqualToString:@"da"])
        ((UIButton *)[vwInfoCalatorie viewWithTag:9]).selected = YES;
    else {
        ((UIButton *)[vwInfoCalatorie viewWithTag:9]).selected = NO;
        activePersoana.alteBoli = @"nu";
    }
}

- (IBAction)hideInfoCalatorie:(id)sender
{
    [vwInfoCalatorie setHidden:YES];
    [activePersoana updatePersoana:NO];
    activePersoana = nil;
    [lblPersoanaActiva setText:@""];
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    //[btn setSelected:checkboxSelected];
    [self setInfoCalatorie:checkboxSelected forButton:btn];
}

- (void) setInfoCalatorie:(BOOL)k forButton:(UIButton *)btn
{
    btn.selected = k;
    if (btn.tag == 1) // Elev/Student
        activePersoana.elevStudent = (k ? @"da" : @"nu");
    //    else if (btn.tag == 2) // Sport Agrement
    //        activePersoana.
    else if (btn.tag == 3) // Grad Invaliditate
        activePersoana.handicapLocomotor = (k ? @"da" : @"nu");
    else if (btn.tag == 4) // Boli cardio
        activePersoana.boliCardio = (k ? @"da" : @"nu");
    else if (btn.tag == 5) // Boli neuro
        activePersoana.boliNeuro = (k ? @"da" : @"nu");
    else if (btn.tag == 6) // Boli interne
        activePersoana.boliInterne = (k ? @"da" : @"nu");
    else if (btn.tag == 7) // Boli respiratorii
        activePersoana.boliAparatRespirator = (k ? @"da" : @"nu");
    else if (btn.tag == 8) // Boli definitive
        activePersoana.boliDefinitive = (k ? @"da" : @"nu");
    else if (btn.tag == 9)
        activePersoana.alteBoli = (k ? @"da" : @"nu");
}

- (IBAction) callEditItems
{
    if (!editingMode)
    {
        editingMode = YES;
        [tableView reloadData];
        [tableView setEditing:YES];
        UIBarButtonItem *btnDone = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnDone;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStyleDone];
        lblEditeaza.font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:14];
    }
    else
    {
        editingMode = NO;
        [tableView reloadData];
        [tableView setEditing:NO];
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
        [self.navigationItem.leftBarButtonItem setStyle:UIBarButtonItemStylePlain];
        [YTOUtils rightImageVodafone:self.navigationItem];
        lblEditeaza.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:14];
    }
}

- (IBAction)doneSelecting:(id)sender
{
    goingBack = YES;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) checkVisibilityForOk
{
    if (listaAsiguratiSelectati.count == 0)
    {
        btnOk.hidden = YES;
        lblOk.hidden = YES;
    }
    else
    {
        btnOk.hidden = NO;
        lblOk.hidden = NO;
    }
}
@end
