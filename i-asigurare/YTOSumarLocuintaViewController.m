//
//  YTOSumarLocuintaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/8/12.
//
//

#import "YTOSumarLocuintaViewController.h"
#import "YTOAppDelegate.h"
#import "YTOFinalizareLocuintaViewController.h"
#import "YTOWebViewController.h"
#import "YTOUserDefaults.h"

@interface YTOSumarLocuintaViewController ()

@end

@implementation YTOSumarLocuintaViewController

@synthesize oferta, asigurat, locuinta, cotatie;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i465", [YTOUserDefaults getLanguage],@"Sumar locuinta");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSumarLocuintaViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self initCells];
     [YTOUtils rightImageVodafone:self.navigationItem];
    
    
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:0];
    img.image = nil;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-locuinte-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-locuinte-en.png"];
    else img.image = [UIImage imageNamed:@"asig-locuinte.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:albastruLocuinta];
    
    lbl1.text = NSLocalizedStringFromTable(@"i791", [YTOUserDefaults getLanguage],@"Sumar");
    lbl2.text = NSLocalizedStringFromTable(@"i792", [YTOUserDefaults getLanguage],@"Verifica cu atentie datele introduse");
    lbl3.text = NSLocalizedStringFromTable(@"i793", [YTOUserDefaults getLanguage],@"si asigura-te ca sunt corecte");
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl3.adjustsFontSizeToFitWidth = YES;
    cellHeader.userInteractionEnabled = NO;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
//    if (indexPath.row == 2)
//    {
//        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
//        aView.URL = cotatie.LinkConditii;
//        [delegate.rcaNavigationController pushViewController:aView animated:YES];
//    }
//    else if (indexPath.row == 3)

    if (indexPath.row == 3)
    {
        YTOFinalizareLocuintaViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOFinalizareLocuintaViewController alloc] initWithNibName:@"YTOFinalizareLocuintaViewController_R4" bundle:nil];
        else aView = [[YTOFinalizareLocuintaViewController alloc] initWithNibName:@"YTOFinalizareLocuintaViewController" bundle:nil];
        aView.oferta = oferta;
        aView.asigurat = asigurat;
        aView.locuinta = locuinta;
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
    }
}

#pragma METHODS
- (void) initCells
{
    NSArray *topLevelObjectsSumar1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellSumar1 = [topLevelObjectsSumar1 objectAtIndex:0];
    ((UILabel *)[cellSumar1 viewWithTag:1]).text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"i18", [YTOUserDefaults getLanguage],@"Asigurare locuinta")];
    ((UIImageView *)[cellSumar1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-casa.png"];
    ((UILabel *)[cellSumar1 viewWithTag:3]).text = [NSString stringWithFormat:@"%@: %d %@",NSLocalizedStringFromTable(@"i126", [YTOUserDefaults getLanguage],@"Suma asigurata"), locuinta.sumaAsigurata, [oferta.moneda uppercaseString]];
    NSString *str = @"";
    NSString *p = locuinta.structuraLocuinta;
    if ([p isEqualToString:@"beton-armat"])
        str =  NSLocalizedStringFromTable(@"i382", [YTOUserDefaults getLanguage],@"beton-armat");
    else if ([p isEqualToString:@"beton"])
        str = NSLocalizedStringFromTable(@"i383", [YTOUserDefaults getLanguage],@"beton");
    else if ([p isEqualToString:@"bca"])
        str =NSLocalizedStringFromTable(@"i384", [YTOUserDefaults getLanguage],@"bca");
    else if ([p isEqualToString:@"caramida"])
        str =NSLocalizedStringFromTable(@"i385", [YTOUserDefaults getLanguage],@"caramida");
    else if ([p isEqualToString:@"caramida-nearsa"])
        str =NSLocalizedStringFromTable(@"i386", [YTOUserDefaults getLanguage],@"caramida-nearsa");
    else if ([p isEqualToString:@"chirpici-paiata"])
        str =NSLocalizedStringFromTable(@"i387", [YTOUserDefaults getLanguage],@"chirpici-paiata");
    else if ([p isEqualToString:@"lemn"])
        str =NSLocalizedStringFromTable(@"i388", [YTOUserDefaults getLanguage],@"lemn");
    else if ([p isEqualToString:@"zidarie-lemn"])
        str =NSLocalizedStringFromTable(@"i389", [YTOUserDefaults getLanguage],@"zidarie-lemn");
    ((UILabel *)[cellSumar1 viewWithTag:4]).text = [NSString stringWithFormat:@"%d mp2, %@", locuinta.suprafataUtila, str];
    ((UIImageView *)[cellSumar1 viewWithTag:5]).image = ((UIImageView *)[cellSumar1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    
    
    NSArray *topLevelObjectsPers1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellPers1 = [topLevelObjectsPers1 objectAtIndex:0];
    ((UILabel *)[cellPers1 viewWithTag:1]).text = asigurat.nume;
    ((UIImageView *)[cellPers1 viewWithTag:2]).image = [UIImage imageNamed:@"icon-foto-person-xs.png"];
    ((UILabel *)[cellPers1 viewWithTag:3]).text = asigurat.codUnic;
    ((UILabel *)[cellPers1 viewWithTag:4]).text = [NSString stringWithFormat:@"%@, %@", asigurat.judet, asigurat.localitate];
    ((UIImageView *)[cellPers1 viewWithTag:5]).image = ((UIImageView *)[cellPers1 viewWithTag:6]).image = [UIImage imageNamed:@"arrow-locuinta.png"];
    
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellView_Sumar" owner:self options:nil];
    cellProdus = [topLevelObjectsProdus objectAtIndex:0];
    ((UILabel *)[cellProdus viewWithTag:1]).text = [NSString stringWithFormat:@"%.2f %@", oferta.prima, [oferta.moneda uppercaseString]];
    ((UIImageView *)[cellProdus viewWithTag:2]).image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
    
    
    ((UILabel *)[cellProdus viewWithTag:3]).text = @"";
    ((UILabel *)[cellProdus viewWithTag:4]).text = @"";
    ((UIImageView *)[cellProdus viewWithTag:5]).image = ((UIImageView *)[cellProdus viewWithTag:6]).image = nil ;//[UIImage imageNamed:@"arrow-calatorie.png"];
    UIButton * btnConditii = ((UIButton *)[cellProdus viewWithTag:7]);
    UIButton * btnSumar = ((UIButton *)[cellProdus viewWithTag:9]);
    ((UILabel *) [cellProdus viewWithTag:8]).text = NSLocalizedStringFromTable(@"i169", [YTOUserDefaults getLanguage],@"Conditii\ncomplete");
    ((UILabel *) [cellProdus viewWithTag:10]).text = NSLocalizedStringFromTable(@"i170", [YTOUserDefaults getLanguage],@"Sumar\nacoperiri");
    btnConditii.hidden = ((UILabel *)[cellProdus viewWithTag:8]).hidden =
    btnSumar.hidden = ((UILabel *)[cellProdus viewWithTag:10]).hidden = NO;
    
    [btnConditii addTarget:self action:@selector(showConditiiComplete) forControlEvents:UIControlEventTouchUpInside];
    [btnSumar addTarget:self action:@selector(showSumarAcoperiri) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"calculeaza-locuinta.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i17", [YTOUserDefaults getLanguage],@"Continua");
}

- (void) showConditiiComplete
{
    if (cotatie.linkConditii == nil || [cotatie.linkConditii isEqualToString:@"(null)"] || cotatie.linkConditii.length == 0)
        return;
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.URL = cotatie.linkConditii;
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

- (void) showSumarAcoperiri
{
    if (cotatie.conditiiHint == nil || [cotatie.conditiiHint isEqualToString:@"(null)"] || cotatie.conditiiHint.length == 0)
        return;
    
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.HTMLContent = [YTOUtils getHTMLWithStyle:cotatie.conditiiHint];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}
@end
