//
//  YTOSumarRCAViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/27/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOSumarRCAViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "YTOFinalizareRCAViewController.h"

@interface YTOSumarRCAViewController ()

@end

@implementation YTOSumarRCAViewController

@synthesize oferta, masina, asigurat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i591", [YTOUserDefaults getLanguage],@"Sumar\nacoperiri");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOSumarRcaViewController";
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }
    
    NSLog(@"%@", [oferta toJSON]);
    
    if (oferta && masina && asigurat)
    {
        lblMarcaModel.text = [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.modelAuto];
        lblSerieSasiu.text = masina.serieSasiu;
        lblNrInmatriculare.text = masina.nrInmatriculare;
        
        lblNume.text = asigurat.nume;
        lblCodUnic.text = asigurat.codUnic;
        lblJudetLocalitate.text = [NSString stringWithFormat:@"%@, %@", asigurat.judet, asigurat.localitate];
        if (_pretRedus){
            lblPrima.text = [NSString stringWithFormat:@"%.2f RON ", oferta.primaReducere];
            lblPrima.adjustsFontSizeToFitWidth = YES;
            lblPrimaInitiala.text = [NSString stringWithFormat:@"%.2f RON ", oferta.prima];
            lblPrimaInitiala.hidden = NO;
            lblStrike.hidden = NO;
            [lblPrima setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:23]];
            [lblPrima setTextColor:[YTOUtils colorFromHexString:rosuTermeni]];
        }
        else
            lblPrima.text = [NSString stringWithFormat:@"%.2f RON", oferta.prima];
        imgCompanie.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
        lblDurata.text = [NSString stringWithFormat:@"%@ %d %@",NSLocalizedStringFromTable(@"i589", [YTOUserDefaults getLanguage],@"zi"), oferta.durataAsigurare,NSLocalizedStringFromTable(@"i590", [YTOUserDefaults getLanguage],@"zi")];
        lblBonusMalus.text = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];
        
        lblContinua.text = NSLocalizedStringFromTable(@"i17", [YTOUserDefaults getLanguage],@"Continua");
    }
    // Do any additional setup after loading the view from its nib.
    [YTOUtils rightImageVodafone:self.navigationItem];
    

    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:100];
    img.image = nil;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-rca-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-rca-en.png"];
    else img.image = [UIImage imageNamed:@"asig-rca.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:verde];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:verde];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:verde];
    
    lbl1.text = NSLocalizedStringFromTable(@"i791", [YTOUserDefaults getLanguage],@"Sumar");
    lbl2.text = NSLocalizedStringFromTable(@"i792", [YTOUserDefaults getLanguage],@"Verifica cu atentie datele introduse");
    lbl3.text = NSLocalizedStringFromTable(@"i793", [YTOUserDefaults getLanguage],@"si asigura-te ca sunt corecte");
    lbl2.adjustsFontSizeToFitWidth = YES;
    lbl3.adjustsFontSizeToFitWidth = YES;
    
    cellHeader.userInteractionEnabled = NO;
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

- (IBAction)showFinalizareRCA:(id)sender
{
//    if (!oferta._isDirty)
//        [oferta addOferta];
//    else
//        [oferta updateOferta];
    
    YTOFinalizareRCAViewController * aView;
    
    if (IS_IPHONE_5)
        aView = [[YTOFinalizareRCAViewController alloc] initWithNibName:@"YTOFinalizareRCAViewController_R4" bundle:nil];
    else
        aView = [[YTOFinalizareRCAViewController alloc] initWithNibName:@"YTOFinalizareRCAViewController" bundle:nil];
    
    aView.asigurat = asigurat;
    aView.masina = masina;
    aView.oferta = oferta;
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
