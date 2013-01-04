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

@interface YTOListaAsiguratiViewController ()

@end

@implementation YTOListaAsiguratiViewController

@synthesize controller;
@synthesize produsAsigurare;
@synthesize listaAsiguratiSelectati, listAsiguratiIndecsi;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Lista persoane", @"Lista persoane");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    goingBack = YES;
    
    // Do any additional setup after loading the view from its nib.
    YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (produsAsigurare == RCA || produsAsigurare == Locuinta)
        ((UILabel *)[self.view viewWithTag:2]).text = @"Adauga asigurat";
    
    if (produsAsigurare == Calatorie)
    {
        ((UILabel *)[self.view viewWithTag:2]).text = @"Adauga calator";
        [self checkVisibilityForOk];
        listaAsigurati = [YTOPersoana PersoaneFizice];
        if (listaAsiguratiSelectati.count == 0)
        {   
            listaAsiguratiSelectati = [[NSMutableArray alloc] init];
            listAsiguratiIndecsi = [[NSMutableArray alloc] init];
            
        }
    }
    else {
        if ([controller isKindOfClass:[YTOSetariViewController class]])
            listaAsigurati = [YTOPersoana AltePersoane];
        else
            listaAsigurati = [appDelegate Persoane];
    }
    
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#f15a24"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];

    [self verifyViewMode];
}

- (void) verifyViewMode
{
    if (listaAsigurati.count == 0)
    {
        self.navigationItem.rightBarButtonItem = nil;
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
            
            if (num == indexPath.row) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                // Once we find a match there is no point continuing the loop
                break;
            }
        }
    }
    else
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
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
       
       UITableViewCell *thisCell = [tv cellForRowAtIndexPath:indexPath];
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
           if (!exista)
           {
               [listaAsiguratiSelectati addObject:p];
               [listAsiguratiIndecsi addObject:[NSString stringWithFormat:@"%d", indexPath.row]];
               
               [vwInfoCalatorie setHidden:NO];
               activePersoana = p;
               [lblPersoanaActiva setText:[NSString stringWithFormat:@"Despre %@", p.nume]];
               [self loadInfoCalatorie];
           }
       }
       else{
           
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
       }
       [self checkVisibilityForOk];
   }
   else 
   {
       YTOPersoana * persoana = [listaAsigurati objectAtIndex:indexPath.row];
       YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
       
       if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
       {
           YTOCalculatorViewController * parent = (YTOCalculatorViewController *)self.controller;
           [parent setAsigurat:persoana];
           [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
       }
       else if ([self.controller isKindOfClass:[YTOCASCOViewController class]])
       {
           YTOCASCOViewController * parent = (YTOCASCOViewController *)self.controller;
           [parent setAsigurat:persoana];
           [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
       }
       else if ([self.controller isKindOfClass:[YTOLocuintaViewController class]])
       {
           YTOLocuintaViewController * parent = (YTOLocuintaViewController *)self.controller;
           
           // TRUE -  Daca persoana este valida, se poate
           //         folosi pentru calculatia asigurarii de locuinta
           // FALSE - Se incarca formularul de persoana, iar la
           //         salvare, se afiseaza calculatorul de asigurare de locuinta
           if ([parent.asigurat isValidForCompute])
           {
               [parent setAsigurat:persoana];
               [appDelegate.rcaNavigationController popViewControllerAnimated:YES];
           }
           else
           {
               YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
               aView.asigurat = parent.asigurat;
               aView.controller = self;
               [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
           }
       }
       else if ([self.controller isKindOfClass:[YTOSetariViewController class]])
       {
           YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
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

- (IBAction)adaugaPersoana:(id)sender
{
    goingBack = NO;
    
    YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([self.controller isKindOfClass:[YTOCalculatorViewController class]])
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
    else
        listaAsigurati = [appDelegate Persoane];
    
    
    if (listaAsigurati.count > 0)
    {
        [listAsiguratiIndecsi addObject:[NSString stringWithFormat:@"%d", (listaAsigurati.count -1)]];
        [listaAsiguratiSelectati addObject:[listaAsigurati objectAtIndex:(listaAsigurati.count -1)]];
        
        [vwEmpty setHidden:YES];    
        if ([self.controller isKindOfClass:[YTOSetariViewController class]])
        {
            YTOSetariViewController * parent = (YTOSetariViewController *)self.controller;
            [parent reloadData];
        }
    }
    [tableView reloadData];
    [self verifyViewMode];
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
    [activePersoana updatePersoana];
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

- (IBAction)doneSelecting:(id)sender
{
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
