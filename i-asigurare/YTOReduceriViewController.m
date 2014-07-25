
//
//  YTOReduceriViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 5/16/13.
//
//

#import "YTOReduceriViewController.h"
#import "YTOUtils.h"
#import "YTOUserDefaults.h"

@interface YTOReduceriViewController ()
@end

@implementation YTOReduceriViewController
@synthesize asigurat;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"i568", [YTOUserDefaults getLanguage],@"Informatii pentru REDUCERI");
    lblToateInfo.text = NSLocalizedStringFromTable(@"i19", [YTOUserDefaults getLanguage],@"Toate informatiile de mai jos se refera la proprietarul autovehiculului");

    lblAspecte.text = NSLocalizedStringFromTable(@"i210", [YTOUserDefaults getLanguage],@"Aspecte generale");
    lblCasatorit.text = NSLocalizedStringFromTable(@"i211", [YTOUserDefaults getLanguage],@"Casatorit");
    lblPensionar.text = NSLocalizedStringFromTable(@"i212", [YTOUserDefaults getLanguage],@"Pensionar");
    lblHandicap.text = NSLocalizedStringFromTable(@"i206", [YTOUserDefaults getLanguage],@"Handicap\nlocomotor");
    lblCopii.text = NSLocalizedStringFromTable(@"i205", [YTOUserDefaults getLanguage],@"Copii\nminori");
    
    lblNumarBugetari.text = NSLocalizedStringFromTable(@"i213", [YTOUserDefaults getLanguage],@"Numar bugetari (la stat) in familie");
    lblAnPermis.text = NSLocalizedStringFromTable(@"i214", [YTOUserDefaults getLanguage],@"An obtinere permis");
    lblAtentie.text = NSLocalizedStringFromTable(@"i215", [YTOUserDefaults getLanguage],@"Atentie : unele societati de asigurare pot cere acte doveditoare (pentru handicap sau bugetari in familie)");
    [self setAsigurat];
    [YTOUtils rightImageVodafone:self.navigationItem];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPHONE_5) return 450;
        return 370;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellFields;
}

- (void) setAsigurat
{
    if (asigurat.codUnic.length >2 )
    {
        NSLog(@"%@",asigurat.dataPermis);
        if (asigurat.dataPermis == [NSNull null]) asigurat.dataPermis = nil;
        
        int an = [[YTOUtils getAnMinimPermis:asigurat.codUnic] intValue];
        stepperAnPermis.minimumValue = an;//[[YTOUtils getAnMinimPermis:asigurat.codUnic] intValue];
        if (asigurat.dataPermis  && [asigurat.dataPermis isEqualToString:@""])
            asigurat.dataPermis = [NSString stringWithFormat:@"%d",an];
        
        stepperAnPermis.maximumValue = [YTOUtils getAnCurent];
        
        if (asigurat.dataPermis  && asigurat.dataPermis.length == 0)
        {
            stepperAnPermis.value = [[YTOUtils getAnMinimPermis:asigurat.codUnic] intValue];
            [self setAnPermis:stepperAnPermis.value];
        }
        else
        {
            if (asigurat.dataPermis  && asigurat.dataPermis.length == 4)
                [self setAnPermis:[asigurat.dataPermis intValue]];
            else
                [self setAnPermis:[YTOUtils getAnFromDate:[YTOUtils getDateFromString:asigurat.dataPermis withFormat:@"yyyy-MM-dd"]]];
        }
    }else
        [self setAnPermis:[YTOUtils getAnCurent]];
    
        if (asigurat.nrBugetari.length == 0)
            [self setNrBugetari:0];
        else
            [self setNrBugetari:[asigurat.nrBugetari intValue]];
        
        
        stepperNrBugetari.maximumValue = 2;
        stepperNrBugetari.minimumValue = 0;
        
        
        if (asigurat.casatorit.length == 0)
            [self setCasatorit:NO];
        else
            [self setCasatorit:[asigurat.casatorit isEqualToString:@"da"]];
        
        if (asigurat.copiiMinori.length == 0)
            [self setCopiiMinori:NO];
        else
            [self setCopiiMinori:[asigurat.copiiMinori isEqualToString:@"da"]];
        
        if (asigurat.pensionar.length == 0)
            [self setPensionar:NO];
        else
            [self setPensionar:[asigurat.pensionar isEqualToString:@"da"]];
        
        if (asigurat.handicapLocomotor.length == 0)
            [self setHandicap:NO];
        else
            [self setHandicap:[asigurat.handicapLocomotor isEqualToString:@"da"]];
}

- (void) setCasatorit:(BOOL)k
{
    asigurat.casatorit = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellFields viewWithTag:1];
    btn.selected = k;
}
- (BOOL) getCasatorit
{
    return  [asigurat.casatorit isEqualToString:@"da"];
}

- (void) setCopiiMinori:(BOOL)k
{
    asigurat.copiiMinori = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellFields viewWithTag:2];
    //btn.selected = k;
    //[self checkboxSelected:btn];
    [btn setSelected:k];
}
- (BOOL) getCopiiMinori
{
    return [asigurat.copiiMinori isEqualToString:@"da"] ? YES : NO;
}

- (void) setPensionar:(BOOL)k
{
    asigurat.pensionar = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellFields viewWithTag:3];
    btn.selected = k;
}
- (BOOL) getPensionar
{
    return [asigurat.pensionar isEqualToString:@"da"];
}
- (void) setHandicap:(BOOL)k
{
    asigurat.handicapLocomotor = (k ? @"da" : @"nu");
    UIButton * btn = (UIButton *)[cellFields viewWithTag:4];
    btn.selected = k;
}
- (BOOL) getHandicap
{
    return [asigurat.handicapLocomotor isEqualToString:@"da"];
}

- (void) setNrBugetari:(int)k
{
    asigurat.nrBugetari = [NSString stringWithFormat:@"%d", k];
    UILabel * lbl = (UILabel *)[cellFields viewWithTag:5];
    lbl.text = asigurat.nrBugetari;
    stepperNrBugetari.value = k;
}

- (void) setAnPermis:(int)k
{
    UILabel * lbl = (UILabel *)[cellFields viewWithTag:6];
    lbl.text = [NSString stringWithFormat:@"%d", k];
    stepperAnPermis.value = k;
    NSDate * azi = [NSDate date];
    int anCurent = [YTOUtils getAnFromDate:azi];
    
    // Daca anul in care si-a luat permisul este anul curent, pun luna si ziua de ieri
    // Altfel pun default 1 noiembrie + an
    if (anCurent == k)
    {
        asigurat.dataPermis = [YTOUtils formatDate:[azi dateByAddingTimeInterval: -86400.0] withFormat:@"yyyy-MM-dd"];
    }
    else
    {
        asigurat.dataPermis = [NSString stringWithFormat:@"%d-01-01", k];
    }
}

- (IBAction)okButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    // [btn setSelected:checkboxSelected];
    if (btn.tag  == 1)
        [self setCasatorit:checkboxSelected];
    else if (btn.tag == 2)
        [self setCopiiMinori:checkboxSelected];
    else if (btn.tag == 3)
        [self setPensionar:checkboxSelected];
    else [self setHandicap:checkboxSelected];
}


- (IBAction)nrBugetariSepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setNrBugetari:stepper.value];
}

- (IBAction)anPermisSepper_Changed:(id)sender
{
    UIStepper * stepper = (UIStepper *)sender;
    [self setAnPermis:stepper.value];
}



@end
