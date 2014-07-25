//
//  YTOPromotiiViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/21/12.
//
//

#import "YTOPromotiiViewController.h"
#import "YTOUtils.h"

@interface YTOPromotiiViewController ()

@end

@implementation YTOPromotiiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Promotii", @"Promotii");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOPromotiiViewController";
     [YTOUtils rightImageVodafone:self.navigationItem];
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
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.row == 0)
    {
        cell.imageView.image = [UIImage imageNamed:@"promotie-livrare-gratuita.png"];
        cell.textLabel.text = @"Livrare gratuita";
        cell.detailTextLabel.text = @"Orice polita de asigurare RCA se livreaza gratuit prin curier rapid.";
    }
    else if (indexPath.row == 1)
    {
        cell.imageView.image = [UIImage imageNamed:@"promotie-cadou.png"];
        cell.textLabel.text = @"Cadou";
        cell.detailTextLabel.text = @"Primesti cadou un odorizant auto pentru fiecare polita RCA comandata.";
    }
    else if (indexPath.row == 2)
    {
        cell.imageView.image = [UIImage imageNamed:@"promotie-livrare-imediata.png"];
        cell.textLabel.text = @"Livrare imediata";
        cell.detailTextLabel.text = @"Toate politele de asigurare se livreaza electronic in cateva minute.";
    }
    else if (indexPath.row == 3)
    {
        cell.imageView.image = [UIImage imageNamed:@"promotie-vodafone.png"];
        cell.textLabel.text = @"i-Asigurare & Vodafone";
        cell.detailTextLabel.text = @"Daca esti client Vodafone beneficiezi de 20% reducere la asigurarea de calatorie.";
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
