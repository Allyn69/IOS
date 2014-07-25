//
//  YTOComenziViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/26/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOComenziViewController.h"
#import "YTOAsigurareViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"

@interface YTOComenziViewController ()

@end

@implementation YTOComenziViewController

@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i433", [YTOUserDefaults getLanguage],@"Lista asigurari");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOComenziViewController";
    lblZeroComenzi.text = NSLocalizedStringFromTable(@"i174", [YTOUserDefaults getLanguage],@"Nu ai comandat nicio asigurare.\nAsigurarile comandate din\n aplicatie vor aparea automat.");
    list = [YTOOferta Oferte];
    
    [self  verifyViewMode];
    ((UILabel *)[vwEmpty viewWithTag:11]).textColor = [YTOUtils colorFromHexString:@"#6f6e6e"];
    ((UILabel *)[vwEmpty viewWithTag:10]).textColor = [YTOUtils colorFromHexString:@"#4d4d4d"];
    
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22];
    
    NSString *string1 = NSLocalizedStringFromTable(@"i749", [YTOUserDefaults getLanguage],@"Istoric");
    NSString *string2 = NSLocalizedStringFromTable(@"i750", [YTOUserDefaults getLanguage],@"comenzi");
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
    
    lbl22.text = NSLocalizedStringFromTable(@"i751", [YTOUserDefaults getLanguage],@"aici vezi toate asigurarile comandate");
    // Do any additional setup after loading the view from its nib.
}

- (void) verifyViewMode
{
    if (list.count == 0)
    {
        //self.navigationItem.rightBarButtonItem = nil;
         [YTOUtils rightImageVodafone:self.navigationItem];
        [vwEmpty setHidden:NO];
    }
    else
    {
        [vwEmpty setHidden:YES];
        UIBarButtonItem *btnEdit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(callEditItems)];
        self.navigationItem.rightBarButtonItem = btnEdit;
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  55;
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
    return list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellView";
    UITableViewCell *cell; // = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    YTOOferta * oferta = [list objectAtIndex:indexPath.row];
    
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]];
    //cell.textLabel.text = oferta.numeAsigurare;
    //cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f %@", oferta.prima, [oferta.moneda uppercaseString]];
    
    UILabel * lblProdus = [[UILabel alloc] initWithFrame:CGRectMake(140, 7, 150, 20)];
    lblProdus.backgroundColor = [UIColor clearColor];
    lblProdus.text = [oferta.numeAsigurare stringByReplacingOccurrencesOfString:@"Asigurare" withString:@""];
    lblProdus.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblProdus.textAlignment = NSTextAlignmentCenter;
    lblProdus.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    [cell.contentView addSubview:lblProdus];
    
    UILabel * lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(140, 30, 180, 20)];
    lblPrima.backgroundColor = [UIColor clearColor];
    lblPrima.text = [NSString stringWithFormat:@"%.2f %@", (oferta.primaReducere>0? oferta.primaReducere : oferta.prima), [oferta.moneda uppercaseString]];
    lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblPrima.textAlignment = NSTextAlignmentCenter;
    lblPrima.font = [UIFont fontWithName:@"Arial" size:13];
    [cell.contentView addSubview:lblPrima];
    
    UILabel *lblDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(230, 7, 100, 20)];
    lblDataLabel.backgroundColor = [UIColor clearColor];
    lblDataLabel.text = @"Data inceput";
    lblDataLabel.textAlignment = NSTextAlignmentCenter;
    lblDataLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblDataLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    [cell.contentView addSubview:lblDataLabel];
    
    UILabel *lblData = [[UILabel alloc] initWithFrame:CGRectMake(240, 30, 100, 20)];
    lblData.backgroundColor = [UIColor clearColor];
    lblData.text = [YTOUtils formatDate:oferta.dataInceput withFormat:@"dd.MM.yyyy"];
    lblData.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblData.textAlignment = NSTextAlignmentCenter;
    lblData.font = [UIFont fontWithName:@"Arial" size:13];
    [cell.contentView addSubview:lblData];
    
    //    cell.textLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    //    cell.textLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    //    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    //    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:14];
    
    if (indexPath.row % 2 != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 40);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    YTOOferta * oferta = [list objectAtIndex:indexPath.row];
//    YTOAsigurareViewController * aView = [[YTOAsigurareViewController alloc] init];
//    aView.asigurare = oferta;
//    [self.navigationController pushViewController:aView animated:YES];
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        YTOOferta * asigurare = [list objectAtIndex:indexPath.row];
        [asigurare deleteOferta];
        [self reloadData];
    }
}

- (IBAction)addAsigurare:(id)sender
{
    YTOAsigurareViewController * aView = [[YTOAsigurareViewController alloc] init];
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    //aView.controller = self;
    [appDelegate.setariNavigationController pushViewController:aView animated:YES];
}

- (void) reloadData
{
    list = [YTOOferta Oferte];
    if (list.count > 0)
    {
        [vwEmpty setHidden:YES];
//        if ([self.controller isKindOfClass:[YTOSetariViewController class]])
//        {
//            YTOSetariViewController * parent = (YTOSetariViewController *)self.controller;
//            [parent reloadData];
//        }
    }
    if (list.count == 0)
         [YTOUtils rightImageVodafone:self.navigationItem];
    [tableView reloadData];
    [self verifyViewMode];
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
@end
