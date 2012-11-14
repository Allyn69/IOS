//
//  YTOSumarRCAViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOSumarRCAViewController.h"
#import "YTOAppDelegate.h"
#import "YTOFinalizareRCAViewController.h"

@interface YTOSumarRCAViewController ()

@end

@implementation YTOSumarRCAViewController

@synthesize oferta, masina, asigurat;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Sumar RCA", @"Sumar RCA");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSLog(@"%@", [oferta toJSON]);
    
    if (oferta && masina && asigurat)
    {
        lblMarcaModel.text = [NSString stringWithFormat:@"%@, %@", masina.marcaAuto, masina.modelAuto];
        lblSerieSasiu.text = masina.serieSasiu;
        lblNrInmatriculare.text = masina.nrInmatriculare;
        
        lblNume.text = asigurat.nume;
        lblCodUnic.text = asigurat.codUnic;
        lblJudetLocalitate.text = [NSString stringWithFormat:@"%@, %@", asigurat.judet, asigurat.localitate];
        
        lblPrima.text = [NSString stringWithFormat:@"%.2f RON", oferta.prima];
        imgCompanie.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
        lblDurata.text = [NSString stringWithFormat:@"Durata %d luni", oferta.durataAsigurare];
        lblBonusMalus.text = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];
    }
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

- (IBAction)showFinalizareRCA:(id)sender
{
    if (!oferta._isDirty)
        [oferta addOferta];
    else
        [oferta updateOferta];
    
    YTOFinalizareRCAViewController * aView = [[YTOFinalizareRCAViewController alloc] init];
    aView.asigurat = asigurat;
    aView.masina = masina;
    aView.oferta = oferta;
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController pushViewController:aView animated:YES];
}

@end
