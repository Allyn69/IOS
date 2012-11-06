//
//  YTOSetariViewController.m
//  i-asigurare
//
//  Created by Administrator on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "YTOSetariViewController.h"
#import "YTOComenziViewController.h"
#import "YTOListaAutoViewController.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOAutovehicul.h"
#import "YTOLocuinta.h"
#import "YTOPersoana.h"

@interface YTOSetariViewController ()

@end

@implementation YTOSetariViewController

@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Datele mele", @"Datele mele");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-datele-mele.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCells];
    
    UIBarButtonItem *btnSync = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(callSyncItems)];
    self.navigationItem.rightBarButtonItem = btnSync;
    
    // Do any additional setup after loading the view from its nib.
//    [self startLoadingAnimantion];
//    [self performSelector:@selector(stopLoadingAnimantion) withObject:nil afterDelay:3.2];
}

- (void) viewWillAppear:(BOOL)animated  
{
    [tableView reloadData];
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
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 6;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
        return 35;
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.section == 0)
    {
        cell = cellHeader;
    }
    else if (indexPath.section == 1)
    {
        cell = cellProfilulMeu;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-profilul-meu.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"PROFILUL MEU";
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        if (proprietar && proprietar.nume.length > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = proprietar.nume;
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#cb2929"];
        }
        else {
            ((UILabel *)[cell viewWithTag:3]).text = @"Configureaza profilul tau";
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 2)
    {
        cell = cellMasinileMele;        
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-masinile-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"MASINILE MELE";
//        UIScrollView * scrollView = (UIScrollView *)[cell viewWithTag:4];
        NSMutableArray * masini = [YTOAutovehicul Masini];
//        for (int i=0; i<masini.count; i++) {
//            UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(i*60, 5, 30, 30)];
//            img.image = [UIImage imageNamed:@"marca-auto.png"]; //[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", ((YTOAutovehicul *)[masini objectAtIndex:i]).marcaAuto]];
//            UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(i*60, 35, 60, 20)];
//            lbl.text = [((YTOAutovehicul *)[masini objectAtIndex:i]).nrInmatriculare uppercaseString];
//            lbl.font = [UIFont fontWithName:@"Arial" size:10];
//            [scrollView addSubview:img];
//            [scrollView addSubview:lbl];
//        }
        if (masini.count > 0) 
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", masini.count, (masini.count == 1 ? @"masina" : @"masini" )];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];            
        }
        else 
        {
            ((UILabel *)[cell viewWithTag:3]).text = @"0 masini";
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 3)
    {
        cell = cellLocuinteleMele;        
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-locuintele-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"LOCUINTELE MELE";        
        
        NSMutableArray * locuinte = [YTOLocuinta Locuinte];
        if (locuinte.count > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", locuinte.count, (locuinte.count == 1 ? @"locuinta" : @"locuinte" )];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];            
        }
        else
        {
            ((UILabel *)[cell viewWithTag:3]).text = @"0 locuinte";
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }
    else if (indexPath.section == 4)
    {
        cell = cellAltePersoane;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-alte-persoane.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"ALTE PERSOANE"; 
        NSMutableArray * persoane = [YTOPersoana AltePersoane];
        if (persoane.count > 0)
        {
            ((UILabel *)[cell viewWithTag:3]).text = [NSString stringWithFormat:@"%d %@", persoane.count, (persoane.count == 1 ? @"persoana" : @"persoane" )];
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#4b4b4b"];            
        }
        else
        {
            ((UILabel *)[cell viewWithTag:3]).text = @"0 persoane";
            ((UILabel *)[cell viewWithTag:3]).textColor = [YTOUtils colorFromHexString:@"#b3b3b3"];
        }
    }   
    else 
    { 
        cell = cellComenzileMele;
        ((UIImageView *)[cell viewWithTag:1]).image = [UIImage imageNamed:@"setari-asigurarile-mele.png"];
        ((UILabel *)[cell viewWithTag:2]).text = @"ASIGURARILE MELE";
    }
    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
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
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.section == 1)
    {
        YTOAsiguratViewController *aView = [[YTOAsiguratViewController alloc] init];
        aView.proprietar = YES;
        aView.controller = self;
        aView.navigationItem.title = @"Contul meu";
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
    else if (indexPath.section == 2)
    {
        YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.section == 3)
    {
        YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.section == 4)
    {
        YTOListaAsiguratiViewController * aView = [[YTOListaAsiguratiViewController alloc] init];
        aView.controller = self;
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];
    
    }
    else if (indexPath.section == 5)
    {
        YTOComenziViewController * aView = [[YTOComenziViewController alloc] init];
        [appDelegate.setariNavigationController pushViewController:aView animated:YES];        
    }
}

- (void) initCells
{
    cellHeader = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIImageView * imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(0, -10, 320, 59)];
    imgHeader.image = [UIImage imageNamed:@"logo.png"];
    [cellHeader addSubview:imgHeader];
    
    NSArray *topLevelObjects1 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellProfilulMeu = [topLevelObjects1 objectAtIndex:0];
    
    NSArray *topLevelObjects2 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellMasinileMele = [topLevelObjects2 objectAtIndex:0];
    
    NSArray *topLevelObjects3 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellLocuinteleMele = [topLevelObjects3 objectAtIndex:0];
    
    NSArray *topLevelObjects4 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellAltePersoane = [topLevelObjects4 objectAtIndex:0];
    
    NSArray *topLevelObjects5 = [[NSBundle mainBundle] loadNibNamed:@"CellView_Setari" owner:self options:nil];
    cellComenzileMele = [topLevelObjects5 objectAtIndex:0];

}

- (void)reloadData
{
    [tableView reloadData];
}

- (void) startLoadingAnimantion
{
    NSArray * imgs = [NSArray arrayWithObjects: [UIImage imageNamed:@"1.png"], 
                      [UIImage imageNamed:@"2.png"],
                      [UIImage imageNamed:@"3.png"],
                      [UIImage imageNamed:@"4.png"],
                      [UIImage imageNamed:@"5.png"],
                      [UIImage imageNamed:@"6.png"],
                      [UIImage imageNamed:@"7.png"],
                      [UIImage imageNamed:@"8.png"],
                      [UIImage imageNamed:@"9.png"],
                      [UIImage imageNamed:@"10.png"],
                      [UIImage imageNamed:@"11.png"],
                      [UIImage imageNamed:@"12.png"],
                      [UIImage imageNamed:@"13.png"],
                      [UIImage imageNamed:@"14.png"],
                      [UIImage imageNamed:@"15.png"],
                      [UIImage imageNamed:@"16.png"],
                      [UIImage imageNamed:@"17.png"],
                      [UIImage imageNamed:@"18.png"],
                      [UIImage imageNamed:@"19.png"],
                      [UIImage imageNamed:@"20.png"],
                      [UIImage imageNamed:@"21.png"],
                      [UIImage imageNamed:@"22.png"],
                      [UIImage imageNamed:@"23.png"],
                      [UIImage imageNamed:@"24.png"],
                      [UIImage imageNamed:@"25.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@"26.png"],
                      [UIImage imageNamed:@""], nil];
    
    imgAnimation.animationDuration = 2.5;
    imgAnimation.animationRepeatCount = 1;
    imgAnimation.animationImages = imgs;
    [imgAnimation startAnimating];
}

- (void) stopLoadingAnimantion
{
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.view setNeedsLayout]; 
    self.hidesBottomBarWhenPushed = NO;
}

- (void) callSyncItems
{
    [self showCustomLoading];
    
    
	//NSURL * url = [NSURL URLWithString:@"http://192.168.1.176:8082/sync.asmx"];
	NSURL * url = [NSURL URLWithString:@"https://api.i-business.ro/MaAsigurApiTest/sync.asmx"];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:10.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestForAuto]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/ExistingClient" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
}

- (NSString *) XmlRequestForAuto
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
        "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
            "<soap:Body>"
            "<ExistingClient xmlns=\"http://tempuri.org/\">"
                "<udid>%@</udid>"
            "</ExistingClient>"
            "</soap:Body>"
        "</soap:Envelope>",[[UIDevice currentDevice] uniqueIdentifier]];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
}
- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	
    //NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	//NSLog(@"Response string: %@", responseString);
    
	//to do parseXML
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
    
	if (succes)
    {
        NSError * err = nil;
        NSData *dataMasini = [jsonMasini dataUsingEncoding:NSUTF8StringEncoding];
        if (dataMasini)
        {
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataMasini options:kNilOptions error:&err];
            
            for(NSDictionary *item in jsonArray) {
                NSString * idIntern = [item objectForKey:@"IdIntern"];
                masina = [YTOAutovehicul getAutovehicul:idIntern];
                if (!masina)
                {    masina = [[YTOAutovehicul alloc] init];
                    masina.idIntern = [item objectForKey:@"IdIntern"];
                }
                masina.marcaAuto = [item objectForKey:@"Marca"];
                masina.modelAuto = [item objectForKey:@"Model"];
                masina.categorieAuto = [[item objectForKey:@"IndexCategorieAuto"] intValue];
                masina.subcategorieAuto = [item objectForKey:@"SubcategorieAuto"];
                masina.judet = [item objectForKey:@"Judet"];
                masina.localitate = [item objectForKey:@"Localitate"];
                masina.nrInmatriculare = [item objectForKey:@"NrInmatriculare"];
                masina.serieSasiu = [item objectForKey:@"SerieSasiu"];
                masina.cm3 = [[item objectForKey:@"CC"] intValue];
                masina.putere = [[item objectForKey:@"Putere"] intValue];
                masina.nrLocuri = [[item objectForKey:@"NrLocuri"] intValue];
                masina.masaMaxima = [[item objectForKey:@"MasaMax"] intValue];
                masina.anFabricatie = [[item objectForKey:@"AnFabricatie"] intValue];
                masina.serieCiv = [item objectForKey:@"CI"];
                masina.destinatieAuto = [item objectForKey:@"DestinatieAuto"];
                masina.combustibil = [item objectForKey:@"Combustibil"];
                masina.inLeasing = [[item objectForKey:@"Leasing"] boolValue] ? @"da" : @"nu";
                masina.firmaLeasing = [item objectForKey:@"FirmaLeasing"];
                
                if (!masina._isDirty)
                    [masina addAutovehicul];
                else
                    [masina updateAutovehicul];
            }
        }
        
        NSData * dataProprietar = [jsonProprietar dataUsingEncoding:NSUTF8StringEncoding];
        if (dataProprietar)
        {
            NSDictionary * jsonItem = [NSJSONSerialization JSONObjectWithData:dataProprietar options:kNilOptions error:&err];
            YTOPersoana * proprietar = [YTOPersoana Proprietar];
            if (!proprietar)
            {
                proprietar = [[YTOPersoana alloc] init];
                proprietar.proprietar = @"da";
            }
            proprietar.nume = [jsonItem objectForKey:@"Nume"];
            proprietar.codUnic = [jsonItem objectForKey:@"CodUnic"];
            proprietar.telefon = [jsonItem objectForKey:@"Telefon"];
            proprietar.email =[jsonItem objectForKey:@"Email"];
            
            if (!proprietar._isDirty)
                [proprietar addPersoana];
            else
                [proprietar updatePersoana];
        }
    }
    
    [self hideCustomLoading];
    [self reloadData];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);

    [self hideCustomLoading];
	
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}



#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
	attributes:(NSDictionary *)attributeDict {
	
	if ([elementName isEqualToString:@"ExistingClientResponse"]) {
        //	masina = [[YTOAutovehicul alloc] init];
        //    [listTarife addObject:cotatie];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if (![elementName isEqualToString:@"ExistingClientResponse"]
        && ![elementName isEqualToString:@"soap:Envelope"]
        && ![elementName isEqualToString:@"soap:Body"]) {
		
        if ([elementName isEqualToString:@"masini"])
            jsonMasini = currentElementValue;
        else if ([elementName isEqualToString:@"proprietar"])
            jsonProprietar = currentElementValue;
        
		NSLog(@"%@=%@\n", elementName, currentElementValue);
	}
    
	currentElementValue = nil;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	//MainViewController * mainController = [[MainViewController alloc] init];
	//[self presentModalViewController:mainController animated:YES];
    //[self dismissModalViewControllerAnimated:YES];
    YTOAppDelegate * delegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    [delegate.rcaNavigationController popViewControllerAnimated:YES];
}

- (void) showCustomLoading
{
    [vwLoading setHidden:NO];
}
- (IBAction) hideCustomLoading
{
    [vwLoading setHidden:YES];
}

@end
