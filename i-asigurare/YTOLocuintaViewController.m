//
//  YTOLocuintaViewController.m
//  i-asigurare
//
//  Created by Administrator on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOLocuintaViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOCasaViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOWebServiceLocuintaViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"

@interface YTOLocuintaViewController ()

@end

@implementation YTOLocuintaViewController

@synthesize DataInceput = _DataInceput;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Calculator", @"Calculator");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initCells];
    [self initCustomValues];
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

- (void) initCustomValues
{
    oferta = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
    oferta.moneda = @"eur";
    [self setModEvaluare:@"valoare-reala"];
    
    YTOPersoana * prop = [YTOPersoana Proprietar];
    if (prop)
    {
        [self setAsigurat:prop];
    }
    
    _DataInceput = [[NSDate date] dateByAddingTimeInterval:86400];
    [self setDataInceput:_DataInceput];
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
    return 8;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 75;
    else if (indexPath.row == 3)
        return 100;
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
    else if (indexPath.row == 6) cell = cellDataInceput;
    else if (indexPath.row == 7) cell = cellCalculeaza;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];    
    if (indexPath.row == 1)
    {
        [self doneEditing];
        // Daca exista locuinte salvate, afisam lista
        if ([YTOLocuinta Locuinte].count > 0)
        {
            YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOCasaViewController * aView = [[YTOCasaViewController alloc] init];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        [self doneEditing];
        // Daca exista persoane salvate, afisam lista
        if ([delegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView = [[YTOListaAsiguratiViewController alloc] init];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            aView.controller = self;
            [delegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 7)
    {
        if (locuinta.idIntern.length == 0 || asigurat.idIntern.length == 0)
            return;
        
        oferta.tipAsigurare = 3;
        oferta.idAsigurat = asigurat.idIntern;
        oferta.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:locuinta.idIntern, nil];
        oferta.numeAsigurare = [NSString stringWithFormat:@"Asigurare Locuinta, pentru %@, %d mp, %d %@", locuinta.tipLocuinta, locuinta.suprafataUtila, locuinta.sumaAsigurata, [oferta.moneda uppercaseString]];
        
        locuinta.idProprietar = asigurat.idIntern;
        [locuinta updateLocuinta];
        
        YTOWebServiceLocuintaViewController * aView = [[YTOWebServiceLocuintaViewController alloc] init];
        aView.oferta = oferta;
        aView.locuinta = locuinta;
        aView.asigurat = asigurat;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField 
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row == 4 || indexPath.row == 5)
    {
        [self addBarButton];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" EUR" withString:@""];
        textField.text = [textField.text stringByReplacingOccurrencesOfString:@" LEI" withString:@""];
    }
    // to do - [self showTooltip];
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
    // to do [self hideTooltip];
    
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
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
	self.navigationItem.rightBarButtonItem = nil;
}

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"calculator-locuinta.png"];
    
    NSArray *topLevelObjectsLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellLocuinta = [topLevelObjectsLocuinta objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellLocuinta viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = @"Alege locuinta";
    UIImageView * img2 = (UIImageView *)[cellLocuinta viewWithTag:4];
    img2.image = [UIImage imageNamed:@"icon-foto-casa.png"];
    UIImageView * bg = (UIImageView *)[cellLocuinta viewWithTag:5];
    bg.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = @"Alege proprietar";
    UIImageView * bg2 = (UIImageView *)[cellProprietar viewWithTag:5];
    bg2.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    NSArray *topLevelObjectsSA = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSumaAsigurata = [topLevelObjectsSA objectAtIndex:0];
    [(UILabel *)[cellSumaAsigurata viewWithTag:1] setText:@"Suma Asigurata (EUR)"];
//    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSumaAsigurata];
    
    NSArray *topLevelObjectsSARC = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellSumaAsigurataRC = [topLevelObjectsSARC objectAtIndex:0];
    [(UILabel *)[cellSumaAsigurataRC viewWithTag:1] setText:@"Suma Asigurata Raspundere Civila (EUR)"];
    //    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellSumaAsigurataRC];
    
    NSArray *topLevelObjectsDataInceput = [[NSBundle mainBundle] loadNibNamed:@"CellStepper" owner:self options:nil];
    cellDataInceput = [topLevelObjectsDataInceput objectAtIndex:0];
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
    lblCellC.text = @"Calculeaza";
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
    _DataInceput = date;
    [self setDataInceput:date];
}

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellProprietar viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];    
    lblCellP.text = a.nume;
    ((UILabel *)[cellProprietar viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    asigurat = a;

    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:locuinta.idProprietar])
    {
        YTOLocuinta * _loc = [YTOLocuinta getLocuintaByProprietar:a.idIntern];
        if (_loc && _loc.idIntern)
            [self setLocuinta:_loc];
    }
}

- (void) setLocuinta:(YTOLocuinta *) a
{
    UILabel * lblCellP = ((UILabel *)[cellLocuinta viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];    
    lblCellP.text = a.tipLocuinta;
    ((UILabel *)[cellLocuinta viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@, %d mp", a.judet, a.localitate, a.suprafataUtila];
    locuinta = a;
    
    if (![locuinta.modEvaluare isEqualToString:@""])
        [self setModEvaluare:locuinta.modEvaluare];
    else [self setModEvaluare:@"valoare-reala"];
    
    if (locuinta.sumaAsigurata > 0)
        [self setSumaAsigurata:[NSString stringWithFormat:@"%d",locuinta.sumaAsigurata]];
    if (locuinta.sumaAsigurataRC > 0)
        [self setSumaAsigurataRC:[NSString stringWithFormat:@"%d",locuinta.sumaAsigurataRC]];
    
    if (locuinta.idProprietar.length > 0 && ![locuinta.idProprietar isEqualToString:asigurat.idIntern])
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:locuinta.idProprietar];
        if (prop)
            [self setAsigurat:prop];
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
    locuinta.sumaAsigurata = [p intValue];
    [(UITextField *)[cellSumaAsigurata viewWithTag:2] setText:[NSString stringWithFormat:@"%.2f %@", [p floatValue], [oferta.moneda uppercaseString]]];
}
- (void) setSumaAsigurataRC:(NSString *)p
{
    locuinta.sumaAsigurataRC = [p intValue];
    [(UITextField *)[cellSumaAsigurataRC viewWithTag:2] setText:[NSString stringWithFormat:@"%.2f %@", [p floatValue], [oferta.moneda uppercaseString]]];
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
    if ([p isEqualToString:@"valoare-reala"])
        ((UIButton *)[cellModEvaluare viewWithTag:1]).selected = YES;
    else if ([p isEqualToString:@"valoare-piata"])
        ((UIButton *)[cellModEvaluare viewWithTag:2]).selected = YES;
    else if ([p isEqualToString:@"evaluare-banca"])
        ((UIButton *)[cellModEvaluare viewWithTag:3]).selected = YES; 
    else if ([p isEqualToString:@"valoare-inlocuire"])
        ((UIButton *)[cellModEvaluare viewWithTag:3]).selected = YES; 

    locuinta.modEvaluare = p;
}
@end
