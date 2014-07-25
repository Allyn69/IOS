//
//  YTOComenziFromWebViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 20/01/14.
//
//

#import "YTOComenziFromWebViewController.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"
#import "VerifyNet.h"
#import "YTOComanda.h"
#import "YTOAppDelegate.h"
#import "YTOWebViewController.h"
#import "UIDevice+IdentifierAddition.h"

@interface YTOComenziFromWebViewController ()

@end

@implementation YTOComenziFromWebViewController

@synthesize comenzi;
@synthesize responseData;
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
    if (IS_OS_7_OR_LATER){
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
    }else [tableView setBackgroundView: nil];
    //self.trackedViewName = @"YTOComenziViewController";
    lblZeroComenzi.text = NSLocalizedStringFromTable(@"i174", [YTOUserDefaults getLanguage],@"Nu ai comandat nicio asigurare.\nAsigurarile comandate din\n aplicatie vor aparea automat.");
    if ([[YTOUserDefaults getUserName] isEqualToString:@""] || [[YTOUserDefaults getPassword] isEqualToString:@""] || [YTOUserDefaults getUserName] == nil || [YTOUserDefaults getPassword] == nil  )
    {
        noLogIn.hidden = NO;
        lblChangeView.textColor = [YTOUtils colorFromHexString:@"#007aff"];
        [self hideLoading];
    }
    else{
        
        [self callGetComenzi];
        noLogIn.hidden = YES;
    }
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

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if ([[YTOUserDefaults getUserName] isEqualToString:@""] || [[YTOUserDefaults getPassword] isEqualToString:@""] || [YTOUserDefaults getUserName] == nil || [YTOUserDefaults getPassword] == nil  )
    {
        noLogIn.hidden = NO;
        lblChangeView.textColor = [YTOUtils colorFromHexString:@"#007aff"];
    }
//    else{
//        
//        [self callGetComenzi];
//        noLogIn.hidden = YES;
//    }
}

- (void) verifyViewMode
{
    if (comenzi.count == 0)
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[comenzi objectAtIndex:indexPath.row] isOpen])
        return 110;
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
    return comenzi.count;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell; // = [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    YTOComanda * comanda = [comenzi objectAtIndex:indexPath.row];
    
    UIImageView *imgComp = [[UIImageView alloc] initWithFrame:CGRectMake(5, 2, 90, 50)];
    imgComp.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [comanda.companie lowercaseString]]];
    [cell.contentView addSubview:imgComp];
    
    UILabel * lblProdus = [[UILabel alloc] initWithFrame:CGRectMake(120, 7, 150, 20)];
    lblProdus.backgroundColor = [UIColor clearColor];
    NSString *str;
    if ([comanda.tipPolita isEqualToString:@"RCA"])
       str = [NSString stringWithFormat:@"%@ %@", [comanda.tipPolita stringByReplacingOccurrencesOfString:@"Asigurare" withString:@""],comanda.nrInmatriculare];
    else if ([comanda.tipPolita isEqualToString:@"Medicale externe"])
        str = comanda.tipPolita;
    else str = comanda.tipPolita;
    lblProdus.text = [NSString stringWithFormat:@"%@ %@", [comanda.tipPolita stringByReplacingOccurrencesOfString:@"Asigurare" withString:@""],comanda.nrInmatriculare];
    lblProdus.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblProdus.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
    [cell.contentView addSubview:lblProdus];
    
    UILabel * lblPrima = [[UILabel alloc] initWithFrame:CGRectMake(130, 30, 180, 20)];
    lblPrima.backgroundColor = [UIColor clearColor];
    lblPrima.text = [NSString stringWithFormat:@"%@", comanda.prima];
    lblPrima.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblPrima.font = [UIFont fontWithName:@"Arial" size:13];
    [cell.contentView addSubview:lblPrima];
    
    UIButton *lblDetalii = [UIButton buttonWithType:UIButtonTypeCustom];
    lblDetalii.frame = CGRectMake(205, 17, 100, 20);
    lblDetalii.backgroundColor = [UIColor clearColor];
    [lblDetalii setTitleColor:[YTOUtils colorFromHexString:ColorTitlu] forState:UIControlStateNormal];
    [lblDetalii setTitle:@"Detalii" forState:UIControlStateNormal];
    //lblDetalii.titleLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblDetalii.titleLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
    [lblDetalii addTarget:self action:@selector(veziDetalii:) forControlEvents:UIControlEventTouchUpInside];
    [lblDetalii setTag:indexPath.row];
    [cell.contentView addSubview:lblDetalii];
    
    UIButton *btnDetalii = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetalii.frame = CGRectMake(288, 18, 19, 19);
    if (comanda.isOpen)
        btnDetalii.selected = YES;
    else btnDetalii.selected = NO;
    [btnDetalii setImage:[UIImage imageNamed:@"comenzi-detalii-plus@2x.png"] forState:UIControlStateNormal];
    [btnDetalii setImage:[UIImage imageNamed:@"comenzi-detalii-minus@2x.png"] forState:UIControlStateSelected];
    [btnDetalii addTarget:self action:@selector(veziDetalii:) forControlEvents:UIControlEventTouchUpInside];
    btnDetalii.backgroundColor = [UIColor clearColor];
    [btnDetalii setTag:indexPath.row];
    [cell.contentView addSubview:btnDetalii];
    
    if (comanda.isOpen)
    {
        UILabel *lblDataIncLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60 , 100, 20)];
        lblDataIncLabel.backgroundColor = [UIColor clearColor];
        lblDataIncLabel.text = @"Data inceput";
        lblDataIncLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDataIncLabel.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        [cell.contentView addSubview:lblDataIncLabel];
        
        UILabel *lblDLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 80 , 100, 20)];
        lblDLabel.backgroundColor = [UIColor clearColor];
        lblDLabel.text = comanda.dataComanda;
        lblDLabel.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [cell.contentView addSubview:lblDLabel];
        
        UILabel *lblDataExp = [[UILabel alloc] initWithFrame:CGRectMake(120, 60 , 100, 20)];
        lblDataExp.backgroundColor = [UIColor clearColor];
        lblDataExp.text = @"Valabil pana la";
        lblDataExp.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDataExp.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        [cell.contentView addSubview:lblDataExp];
        
        UILabel *lblDataExpD = [[UILabel alloc] initWithFrame:CGRectMake(130, 80 , 100, 20)];
//        lblDataExpD.backgroundColor = [UIColor clearColor];
//        NSString *dateStr = comanda.dataComanda;;
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"dd.mm.yyyy"];
//        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
//        int durata = [comanda.durata integerValue];
//        [dateComponents setMonth:durata];
//        NSDate *date = [dateFormat dateFromString:dateStr];
//        NSCalendar* calendar = [NSCalendar currentCalendar];
//        NSDate * newDate = [calendar dateByAddingComponents:dateComponents toDate:date options:0];
        lblDataExpD.text = [NSString stringWithFormat:@"%@",comanda.dataSfarsit];
        lblDataExpD.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDataExpD.font = [UIFont fontWithName:@"Arial" size:14];
        [cell.contentView addSubview:lblDataExpD];
         NSString * str = [NSString stringWithFormat:@"%@",comanda.idDirector];
       
        UIButton *lblPDF = [UIButton buttonWithType:UIButtonTypeCustom];
        lblPDF.frame = CGRectMake(215, 60 , 100, 40);
        lblPDF.backgroundColor = [UIColor clearColor];
        lblPDF.titleLabel.numberOfLines = 2;
        [lblPDF setTitle:@"Descarca\n PDF" forState:UIControlStateNormal];
        if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""])
            [lblPDF setTitleColor:[YTOUtils colorFromHexString:@"#b1b1b1"] forState:UIControlStateNormal];
        else [lblPDF setTitleColor:[YTOUtils colorFromHexString:@"#007aff"] forState:UIControlStateNormal];
        lblPDF.titleLabel.font = [UIFont fontWithName:@"Arial" size:14];
        [lblPDF addTarget:self action:@selector(descarcaPDF:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:lblPDF];
        
        UIButton *btnPDF = [UIButton buttonWithType:UIButtonTypeCustom];
        btnPDF.frame = CGRectMake(298, 73, 19, 19);
       
        if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""])
            [btnPDF setImage:[UIImage imageNamed:@"comenzi-detalii-pdfNA@2x.png"] forState:UIControlStateNormal];
        else   [btnPDF setImage:[UIImage imageNamed:@"comenzi-detalii-pdf@2x.png"] forState:UIControlStateNormal];
        [btnPDF addTarget:self action:@selector(descarcaPDF:) forControlEvents:UIControlEventTouchUpInside];
        btnPDF.backgroundColor = [UIColor clearColor];
        [btnPDF setTag:indexPath.row];
        [cell.contentView addSubview:btnPDF];
        
    }
    
    
    if (indexPath.row % 2 != 0) {
        CGRect frame = CGRectMake(0, 0, 320, 55);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   // cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}


-(void)veziDetalii:(UIButton*)sender
{
    YTOComanda * cm = [comenzi objectAtIndex:sender.tag];
    if (cm.isOpen){
        cm.isOpen = NO;
        sender.selected = NO;
    }else{
        cm.isOpen = YES;
        sender.selected = YES;
    }
    [comenzi replaceObjectAtIndex:sender.tag withObject:cm];
    [tableView reloadData];
    
}

-(void)descarcaPDF:(UIButton*)sender
{
    YTOComanda * c = [comenzi objectAtIndex:sender.tag];
    NSString * str = [[NSString alloc] initWithFormat:@"%@",c.idDirector ];
    if (str == nil || str.length == 0 || [str isEqualToString:@"null"] || [str isEqualToString:@"<null>"])
        return;
    YTOAppDelegate * delegate =  (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTOWebViewController * aView = [[YTOWebViewController alloc] init];
    aView.URL = [[NSString alloc] initWithFormat:@"http://rc.i-crm.ro/maasigurapi/GetDocument.aspx?idDirector=%@&udid=%@",str,@"355361051888821"];//[[UIDevice currentDevice] xUniqueDeviceIdentifier]
    [delegate.setariNavigationController pushViewController:aView animated:YES];
    
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // do nothing
}

- (NSString *) XmlRequest
{
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<AccountGetComenzileMele xmlns=\"http://tempuri.org/\">"
                      "<username>%@</username>"
                      "<password>%@</password>"
                      "</AccountGetComenzileMele>"
                      "</soap:Body>"
                      "</soap:Envelope>",[YTOUserDefaults getUserName],[YTOUserDefaults getPassword]];
    NSLog(@"xml=%@", xml);
    return xml;
}

- (IBAction) callGetComenzi{
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/AccountGetComenzileMele" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        [self arataPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") ];
        self.navigationItem.hidesBackButton = NO;
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"Response: %@", [response textEncodingName]);
	[self.responseData setLength:0];
    self.navigationItem.hidesBackButton = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"connection:DidReceiveData");
	[self.responseData appendData:data];
    self.navigationItem.hidesBackButton = NO;
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    self.navigationItem.hidesBackButton = NO;
	
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
	if (succes) {
        NSError * err = nil;
        NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
        if (data!=nil){
            NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            comenzi = [[NSMutableArray alloc] init];
            
            for(NSDictionary *json in jsonArray) {
                YTOComanda *comanda= [[YTOComanda alloc] init];
                comanda.id = [json objectForKey:@"Id"];
                comanda.dataComanda = [json objectForKey:@"DataInceputString"];
                comanda.tipPolita = [json objectForKey:@"TipPolita"];
                comanda.statusPolita = [json objectForKey:@"StatusPolita"];
                comanda.idDirector = [json objectForKey:@"IdDirector"];
                comanda.idCont = [json objectForKey:@"IdCont"];
                comanda.companie = [json objectForKey:@"Companie"];
                comanda.prima = [json objectForKey:@"Prima"];
                comanda.durata = [json objectForKey:@"Durata"];
                comanda.dataSfarsit = [json objectForKey:@"DataSfarsitString"];
                comanda.nrInmatriculare = [json objectForKey:@"NrInmatriculare"];
                comanda.isOpen = NO;
                [comenzi addObject:comanda];
            }
            if (comenzi.count > 0)
            {
                lblZeroComenzi.hidden = YES;
                vwEmpty.hidden = YES;
            }
        }
        [tableView reloadData];
        [self hideLoading];
    }
	else {
        
	}
}
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"AccountGetComenzileMeleResult"]) {
        jsonResponse = currentElementValue;
	}
    
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) showLoading
{
    [wvLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [wvLoading setHidden:YES];
    self.navigationItem.hidesBackButton = NO;
}
- (void) showPopup:(NSString *)title withDescription:(NSString *)description
{
    [wvLoading setHidden:NO];
}


- (void) arataPopup:(NSString *)title
{
    wvPopup.hidden = NO;
    lblPopupTitle.text = title;
}

- (IBAction) hidePopup
{
    //    vwPopup.hidden = YES;
    wvLoading.hidden = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToLogin:(id)sender
{
    [self.tabBarController setSelectedIndex:3];
}




@end
