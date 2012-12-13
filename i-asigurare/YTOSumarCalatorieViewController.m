//
//  YTOSumarCalatorieViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/11/12.
//
//

#import "YTOSumarCalatorieViewController.h"
#import "YTOWebViewController.h"
#import "YTOFinalizareCalatorieViewController.h"
#import "YTOAppDelegate.h"

@interface YTOSumarCalatorieViewController ()

@end

@implementation YTOSumarCalatorieViewController

@synthesize oferta, listAsigurati, cotatie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Sumar calatorie", @"Sumar calatorie");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCells];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell ;
    
    if (indexPath.row == 0) cell = cellSumar1;
    else if (indexPath.row == 1) cell = cellPers1;
    else if (indexPath.row == 2) cell = cellProdus;
    else cell = cellCalculeaza;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 3)
    {
        YTOFinalizareCalatorieViewController * aView = [[YTOFinalizareCalatorieViewController alloc] init];
        aView.listAsigurati = listAsigurati;
        aView.oferta = oferta;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma METHODS
- (void) initCells
{
    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsHeader objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"calculator-calatorie.png"];
    
    
    NSArray *topLevelObjectsSumar1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellSumar1 = [topLevelObjectsSumar1 objectAtIndex:0];
    ((UILabel *)[cellSumar1 viewWithTag:1]).text = [NSString stringWithFormat:@"%@, %@", [oferta CalatorieDestinatie], [oferta CalatorieProgram]];
    ((UIImageView *)[cellSumar1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellSumar1 viewWithTag:3]).text = [NSString stringWithFormat:@"scopul calatoriei: %@", [oferta CalatorieScop]];
    ((UILabel *)[cellSumar1 viewWithTag:4]).text = [NSString stringWithFormat:@"durata asigurare: %d zile", oferta.durataAsigurare];
    ((UIImageView *)[cellSumar1 viewWithTag:5]).image = ((UIImageView *)[cellSumar1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    
    YTOPersoana * persoana1 = [listAsigurati objectAtIndex:0];
    
    NSArray *topLevelObjectsPers1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellPers1 = [topLevelObjectsPers1 objectAtIndex:0];
    ((UILabel *)[cellPers1 viewWithTag:1]).text = persoana1.nume;
    ((UIImageView *)[cellPers1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellPers1 viewWithTag:3]).text = persoana1.codUnic;
    ((UILabel *)[cellPers1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@, %@", persoana1.judet, persoana1.localitate];
    ((UIImageView *)[cellPers1 viewWithTag:5]).image = ((UIImageView *)[cellPers1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellProdus = [topLevelObjectsProdus objectAtIndex:0];
    ((UILabel *)[cellProdus viewWithTag:1]).text = [NSString stringWithFormat:@"%.2f RON", oferta.prima];
    ((UIImageView *)[cellProdus viewWithTag:2]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
    
    ((UILabel *)[cellProdus viewWithTag:3]).text = @"";
    ((UILabel *)[cellProdus viewWithTag:4]).text = @"";
    ((UIImageView *)[cellProdus viewWithTag:5]).image = ((UIImageView *)[cellProdus viewWithTag:6]).image = nil ;//[UIImage imageNamed:@"arrow-calatorie.png"];
    UIButton * btnConditii = ((UIButton *)[cellProdus viewWithTag:7]);
    UIButton * btnSumar = ((UIButton *)[cellProdus viewWithTag:9]);
    btnConditii.hidden = ((UILabel *)[cellProdus viewWithTag:8]).hidden =
    btnSumar.hidden = ((UILabel *)[cellProdus viewWithTag:10]).hidden = NO;
    
    [btnConditii addTarget:self action:@selector(showConditiiComplete) forControlEvents:UIControlEventTouchUpInside];
    [btnSumar addTarget:self action:@selector(showSumarAcoperiri) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"calculeaza-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = @"Continua";
}

- (void) showConditiiComplete
{
    if (cotatie.LinkConditii == nil || [cotatie.LinkConditii isEqualToString:@"(null)"] || cotatie.LinkConditii.length == 0)
        return;
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.URL = cotatie.LinkConditii;
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void) showSumarAcoperiri
{
    if (cotatie.ConditiiHint == nil || [cotatie.ConditiiHint isEqualToString:@"(null)"] || cotatie.ConditiiHint.length == 0)
        return;
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.HTMLContent = [YTOUtils getHTMLWithStyle:cotatie.ConditiiHint];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
