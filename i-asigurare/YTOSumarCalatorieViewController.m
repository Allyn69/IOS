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
#import "YTOUserDefaults.h"

@interface YTOSumarCalatorieViewController ()

@end

@implementation YTOSumarCalatorieViewController

@synthesize oferta, listAsigurati, cotatie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title =NSLocalizedStringFromTable(@"i466", [YTOUserDefaults getLanguage],@"Sumar calatorie");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSumarCalatorieViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    // Do any additional setup after loading the view from its nib.
    [self initCells];
    [YTOUtils rightImageVodafone:self.navigationItem];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2 || indexPath.row == 3)
        return 100;
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


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 3)
    {
        YTOFinalizareCalatorieViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOFinalizareCalatorieViewController alloc] initWithNibName:@"YTOFinalizareCalatorieViewController_R4" bundle:nil];
        else aView = [[YTOFinalizareCalatorieViewController alloc] initWithNibName:@"YTOFinalizareCalatorieViewController" bundle:nil];
        aView.listAsigurati = listAsigurati;
        aView.oferta = oferta;
        aView.cotatie = cotatie;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma METHODS
- (void) initCells
{
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    img.image = nil;
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
    
    lbl1.text = NSLocalizedStringFromTable(@"i791", [YTOUserDefaults getLanguage],@"Sumar");
    lbl2.text = NSLocalizedStringFromTable(@"i792", [YTOUserDefaults getLanguage],@"Verifica cu atentie datele introduse");
    lbl3.text = NSLocalizedStringFromTable(@"i793", [YTOUserDefaults getLanguage],@"si asigura-te ca sunt corecte");
    cellHeader.userInteractionEnabled = NO;
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl3.adjustsFontSizeToFitWidth = YES;
    
    
    NSArray *topLevelObjectsSumar1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SumarCalatorie" owner:self options:nil];
    cellSumar1 = [topLevelObjectsSumar1 objectAtIndex:0];
    ((UILabel *)[cellSumar1 viewWithTag:1]).text = [NSString stringWithFormat:@"%@, %@", [oferta CalatorieDestinatie], [cotatie SumaAsigurata]];
    ((UIImageView *)[cellSumar1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    NSString * scop;
    if ([[oferta CalatorieScop] isEqualToString:@"turism"])
        scop = NSLocalizedStringFromTable(@"i65", [YTOUserDefaults getLanguage],@"Turism");
    else if ([[oferta CalatorieScop] isEqualToString:@"afaceri"])
        scop = NSLocalizedStringFromTable(@"i71", [YTOUserDefaults getLanguage],@"Afaceri");
    else  if ([[oferta CalatorieScop] isEqualToString:@"sofer-profesionist"])
        scop = NSLocalizedStringFromTable(@"i81", [YTOUserDefaults getLanguage],@"Sofer profesionist");
    else if ([[oferta CalatorieScop] isEqualToString:@"studii"])
        scop = NSLocalizedStringFromTable(@"i82", [YTOUserDefaults getLanguage],@"Studii");
    ((UILabel *)[cellSumar1 viewWithTag:3]).text = [NSString stringWithFormat:@"%@ %@",NSLocalizedStringFromTable(@"i461", [YTOUserDefaults getLanguage],@"scopul calatoriei : "), scop];
    ((UILabel *)[cellSumar1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedStringFromTable(@"i462", [YTOUserDefaults getLanguage],@"durata asigurare : "), oferta.durataAsigurare,NSLocalizedStringFromTable(@"i468", [YTOUserDefaults getLanguage],@"zile")];
    ((UIImageView *)[cellSumar1 viewWithTag:5]).image = ((UIImageView *)[cellSumar1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UIImageView *)[cellSumar1 viewWithTag:11]).image  = ((UIImageView *)[cellSumar1 viewWithTag:11]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    if (listAsigurati.count == 1)
         ((UILabel *)[cellSumar1 viewWithTag:12]).text = [NSString stringWithFormat:@"%@ : 1 %@",NSLocalizedStringFromTable(@"i457", [YTOUserDefaults getLanguage],@"numar calatori"),NSLocalizedStringFromTable(@"i747", [YTOUserDefaults getLanguage],@"persoaa")];
    else ((UILabel *)[cellSumar1 viewWithTag:12]).text = [NSString stringWithFormat:@"%@ : %d %@ ",NSLocalizedStringFromTable(@"i457", [YTOUserDefaults getLanguage],@"numar calatori"),listAsigurati.count,NSLocalizedStringFromTable(@"i415", [YTOUserDefaults getLanguage],@"persoane")];
     
    YTOPersoana * persoana1 = [listAsigurati objectAtIndex:0];
    
    NSArray *topLevelObjectsPers1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_SumarCalatorie" owner:self options:nil];
    cellPers1 = [topLevelObjectsPers1 objectAtIndex:0];
    ((UILabel *)[cellPers1 viewWithTag:1]).text = persoana1.nume;
    ((UIImageView *)[cellPers1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellPers1 viewWithTag:3]).text = persoana1.codUnic;
    ((UILabel *)[cellPers1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@, %@", persoana1.judet, persoana1.localitate];
    ((UIImageView *)[cellPers1 viewWithTag:5]).image = ((UIImageView *)[cellPers1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UIImageView *)[cellPers1 viewWithTag:11]).image  = ((UIImageView *)[cellPers1 viewWithTag:11]).image = [UIImage imageNamed:@"arrow-calatorie.png"];
    ((UILabel *)[cellPers1 viewWithTag:12]).text = [NSString stringWithFormat:@"%@",persoana1.serieAct];
    
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellProdus = [topLevelObjectsProdus objectAtIndex:0];
    ((UILabel *)[cellProdus viewWithTag:1]).text = [NSString stringWithFormat:@"%.2f RON", oferta.prima];
    ((UIImageView *)[cellProdus viewWithTag:2]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
    
//     BOOL isVodafone = [[YTOUserDefaults getOperator] isEqualToString:@"Vodafone"]? YES:NO;
//    if (isVodafone)
//        {
//            ((UIImageView *)[cellPers1 viewWithTag:100]).image =  [UIImage imageNamed:@"vodafone-text.png"];
//            ((UIImageView *) [cellProdus viewWithTag:100]).hidden = NO;
//        }
    
    ((UILabel *)[cellProdus viewWithTag:3]).text = @"";
    ((UILabel *)[cellProdus viewWithTag:4]).text = @"";
    ((UIImageView *)[cellProdus viewWithTag:5]).image = ((UIImageView *)[cellProdus viewWithTag:6]).image = nil ;//[UIImage imageNamed:@"arrow-calatorie.png"];
    UIButton * btnConditii = ((UIButton *)[cellProdus viewWithTag:7]);
    UIButton * btnSumar = ((UIButton *)[cellProdus viewWithTag:9]);
    btnConditii.hidden = ((UILabel *)[cellProdus viewWithTag:8]).hidden = NO;
    btnSumar.hidden = ((UILabel *)[cellProdus viewWithTag:10]).hidden = NO;
    ((UILabel *) [cellProdus viewWithTag:8]).text = NSLocalizedStringFromTable(@"i169", [YTOUserDefaults getLanguage],@"Conditii\ncomplete");
    ((UILabel *) [cellProdus viewWithTag:10]).text = NSLocalizedStringFromTable(@"i170", [YTOUserDefaults getLanguage],@"Sumar\nacoperiri");
    [btnConditii addTarget:self action:@selector(showConditiiComplete) forControlEvents:UIControlEventTouchUpInside];
    [btnSumar addTarget:self action:@selector(showSumarAcoperiri) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"calculeaza-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i17", [YTOUserDefaults getLanguage],@"Continua");
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
