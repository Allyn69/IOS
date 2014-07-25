//
//  YTOAlteleViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/17/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOAlteleViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"
#import "YTOValabilitateRCAViewController.h"
#import "YTOTrimiteMesajViewController.h"
#import "YTOFAQViewController.h"
#import "YTOTermeniViewController.h"
#import "YTOPromotiiFromWebViewController.h"
#import "YTOSocietatiViewController.h"
#import "YTOContactViewController.h"
#import "YTONotificare.h"
#import "YTOUserDefaults.h"

@interface YTOAlteleViewController ()

@end

@implementation YTOAlteleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
            self.title = @"Egyebek";
        else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
            self.title = @"Others";
        else self.title = @"Mai mult";
        self.tabBarItem.image = [UIImage imageNamed:@"menu-altele.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOAlteleViewController";
     [YTOUtils rightImageVodafone:self.navigationItem];
    // Do any additional setup after loading the view from its nib.
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];

}

- (void) viewDidAppear:(BOOL)animated
{
    tableView.reloadData;
    if ([iRate sharedInstance].shouldPromptForRating)
        [iRate sharedInstance].promptForRating;
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        self.title = @"Egyebek";
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        self.title = @"Others";
    else self.title = @"Mai mult";
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];

    NSString *string1 = NSLocalizedStringFromTable(@"i709", [YTOUserDefaults getLanguage],@"Alte");
    NSString *string2 =  NSLocalizedStringFromTable(@"i710", [YTOUserDefaults getLanguage],@"informatii");
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:verde] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:verde]];
    }
    lbl22.text = NSLocalizedStringFromTable(@"i711", [YTOUserDefaults getLanguage],@"te tinem mereu la curent si informat");
        lbl22.adjustsFontSizeToFitWidth = YES;
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Myriad Pro" size:20];
    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Myriad Pro" size:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    if (indexPath.row == 0) {
//        cell.textLabel.text = @"NOTIFICARI";
//        cell.detailTextLabel.text = @"alertele primite de tine";
//        cell.imageView.image = [UIImage imageNamed:@"notifications-icon.png"];
//    }
    if (indexPath.row == 0) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i480", [YTOUserDefaults getLanguage],@"PROMOTII");
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i481", [YTOUserDefaults getLanguage],@"ofertele i-Asigurare");
        cell.imageView.image = [UIImage imageNamed:@"promotii.png"];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i482", [YTOUserDefaults getLanguage],@"VREI SA NE SPUI CEVA?");
            cell.textLabel.adjustsFontSizeToFitWidth = YES;
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i483", [YTOUserDefaults getLanguage],@"trimite-ne un mesaj");    
        cell.imageView.image = [UIImage imageNamed:@"trimite-mesaj.png"];
    }
//    else if (indexPath.row == 2) {
//        cell.textLabel.text = @"INTREBARI FRECVENTE";
//        cell.detailTextLabel.text = @"totul despre asigurari";    
//        cell.imageView.image = [UIImage imageNamed:@"faq.png"];
//    }
//    else if (indexPath.row == 2) {
//        cell.textLabel.text = @"COMPANII ASIGURARE";
//        cell.detailTextLabel.text = @"date de contact";        
//        cell.imageView.image = [UIImage imageNamed:@"contact-companii.png"];        
//    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i484", [YTOUserDefaults getLanguage],@"VALABILITATE RCA");
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i485", [YTOUserDefaults getLanguage],@"verifica polita ta RCA");    
        cell.imageView.image = [UIImage imageNamed:@"valabilitate-rca.png"];
    }
    else if (indexPath.row == 3) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i486", [YTOUserDefaults getLanguage],@"TERMENI");
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i487", [YTOUserDefaults getLanguage],@"citeste regulile");        
        cell.imageView.image = [UIImage imageNamed:@"termeni.png"];
    }
    else if (indexPath.row == 4) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i488", [YTOUserDefaults getLanguage],@"CONTACT");
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i489", [YTOUserDefaults getLanguage],@"cum ne gasesti");
        cell.imageView.image = [UIImage imageNamed:@"contact-iasigurare.png"];
    }
    else if (indexPath.row == 5) {
        cell.textLabel.text = NSLocalizedStringFromTable(@"i495", [YTOUserDefaults getLanguage],@"SETARI");
        cell.detailTextLabel.text = NSLocalizedStringFromTable(@"i489", [YTOUserDefaults getLanguage],@"cum ne gasesti");
        cell.imageView.image = [UIImage imageNamed:@"promotii.png"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
//    if (indexPath.row == 0)
//    {
//        YTONotificariViewController * aView;
//        if (IS_IPHONE_5)
//            aView = [[YTONotificariViewController alloc] initWithNibName:@"YTONotificariViewControler_R4" bundle:nil];
//        else aView = [[YTONotificariViewController alloc] initWithNibName:@"YTONotificariViewController" bundle:nil];
//        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
//    }
    if (indexPath.row == 0)
    {
        YTOPromotiiFromWebViewController * aView ;
        if (IS_IPHONE_5)
            aView = [[YTOPromotiiFromWebViewController alloc] initWithNibName:@"YTOPromotiiFromWebViewController_R4" bundle:nil];
        else aView = [[YTOPromotiiFromWebViewController alloc] initWithNibName:@"YTOPromotiiFromWebViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 1)
    {
        YTOTrimiteMesajViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOTrimiteMesajViewController alloc] initWithNibName:@"YTOTrimiteMesajViewController_R4" bundle:nil];
        else aView = [[YTOTrimiteMesajViewController alloc] initWithNibName:@"YTOTrimiteMesajViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
//    else if (indexPath.row == 2)
//    {
//        YTOFAQViewController * aView = [[YTOFAQViewController alloc] init];
//        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
//    }
//    else if (indexPath.row == 2)
//    {
//        YTOSocietatiViewController * aView = [[YTOSocietatiViewController alloc] init];
//        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
//    }
    else if (indexPath.row == 2)
    {
        YTOValabilitateRCAViewController * aView;
        if (IS_IPHONE_5)
            aView = [[YTOValabilitateRCAViewController alloc] initWithNibName:@"YTOValabilitateRCAViewController_R4" bundle:nil];
        else aView = [[YTOValabilitateRCAViewController alloc] initWithNibName:@"YTOValabilitateRCAViewController" bundle:nil];
        [appDelegate.alteleNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 3)
    {
       
    }
    else if (indexPath.row == 4)
    {
       
    }
}

@end
