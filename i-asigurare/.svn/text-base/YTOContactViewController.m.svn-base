//
//  YTOContactViewController.m
//  i-asigurare
//
//  Created by Administrator on 12/12/12.
//
//

#import "YTOContactViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUtils.h"

@interface YTOContactViewController ()

@end

@implementation YTOContactViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Contact", @"Contact");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"CellXYZ";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-email.png"];
        cell.textLabel.text = @"office@i-asigurare.ro";
        cell.detailTextLabel.text = @"Email";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-orange.png"];
        cell.textLabel.text = @"0753.701.451";
        cell.detailTextLabel.text = @"Orange";
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-vodafone.png"];
        cell.textLabel.text = @"0724.608.149";
        cell.detailTextLabel.text = @"Vodafone";
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-fix.png"];
        cell.textLabel.text = @"0314.329.962";
        cell.detailTextLabel.text = @"Fix";
    }
    else if (indexPath.row == 4)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-fax.png"];
        cell.textLabel.text = @"0314.329.963";
        cell.detailTextLabel.text = @"Fax";
    }
    else if (indexPath.row == 5)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-fb.png"];
        cell.textLabel.text = @"www.facebook.com/iasigurare";
        cell.detailTextLabel.text = @"Facebook";
    }
    else if (indexPath.row == 6)
    {
        cell.imageView.image = [UIImage imageNamed:@"contact-twitter.png"];
        cell.textLabel.text = @"www.twitter.com/iasigurare";
        cell.detailTextLabel.text = @"Twitter";
    }
    else if (indexPath.row == 7)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.imageView.image = [UIImage imageNamed:@"contact-adresa.png"];
        cell.textLabel.text = @"Strada Vasile Lucaciu, nr.10, et.2";
        cell.detailTextLabel.text = @"Sector 3, Bucuresti";
    }
    else if (indexPath.row == 8)
    {
        cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
        cell.imageView.image = [UIImage imageNamed:@"contact-cont-ing.png"];
        cell.textLabel.text = @"RO71 INGB 0000 9999 0248 8459";
        cell.detailTextLabel.text = @"ING Back, Sucursala Unirii";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.textColor = [YTOUtils colorFromHexString:@"#3e3e3e"];
    cell.detailTextLabel.textColor = [YTOUtils colorFromHexString:@"#888888"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Arial" size:12];
    cell.detailTextLabel.numberOfLines = 0;
    
    cell.textLabel.backgroundColor = cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row % 2 != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 70);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%d", indexPath.row);
    // email
    if (indexPath.row == 0)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://office@i-asigurare.ro"]];
    }
    else if (indexPath.row == 1) // orange
    {
        NSString * telefon = @"tel://0753701451";
        
        BOOL isOK = NO;
        
        isOK = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefon]];
        
        if (isOK == NO)
        {
            [self showPopupWithTitle:@"Atentie" andDescription:@"Apeluri telefonice indisponibile"];
        }
    }
    else if (indexPath.row == 2) // vodafone
    {
        NSString * telefon = @"tel://0724608149";
        BOOL isOK = NO;
        
        isOK = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefon]];
        
        if (isOK == NO)
        {
            [self showPopupWithTitle:@"Atentie" andDescription:@"Apeluri telefonice indisponibile"];
        }
    }
    else if (indexPath.row == 3) // fix
    {
        NSString * telefon = @"tel://0314329962";
        
        BOOL isOK = NO;
        
        isOK = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telefon]];
        
        if (isOK == NO)
        {
            [self showPopupWithTitle:@"Atentie" andDescription:@"Apeluri telefonice indisponibile"];
        }
    }
    else if (indexPath.row == 5) // facebook
    {
        NSURL * fanPageURL = [NSURL URLWithString:@"fb://profile/211048545619198"];
        if (![[UIApplication sharedApplication] openURL:fanPageURL])
        {
            NSURL *webURL = [NSURL URLWithString:@"http://www.facebook.com/iasigurare"];
            [[UIApplication sharedApplication] openURL:webURL];
        }
    }
    else if (indexPath.row == 6) // twitter
    {
        NSString *stringURL = @"https://twitter.com/iAsigurare";
        NSURL *url = [NSURL URLWithString:stringURL];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma YTOCustomPopup

- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description
{
    [vwPopup setHidden:NO];
    lblPopupDescription.text = description;
    lblPopupTitle.text = title;
}

- (IBAction)hidePopup:(id)sender
{
    [vwPopup setHidden:YES];
    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController popViewControllerAnimated:YES];
}
@end
