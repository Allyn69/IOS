//
//  YTOFinalizareRCAViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/30/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import "YTOFinalizareRCAViewController.h"
#import "YTOUtils.h"
#import "Database.h"
#import "YTOWebViewController.h"
#import "YTOAppDelegate.h"
#import "YTOUserDefaults.h"
#import "YTOToast.h"

@interface YTOFinalizareRCAViewController ()

@end

@implementation YTOFinalizareRCAViewController

@synthesize oferta, asigurat, masina;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i454", [YTOUserDefaults getLanguage],@"Finalizare comanda RCA");
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
    }
    costVoucher = 0;
    
    //self.trackedViewName = @"YTOFinalizareRcaViewController";
    loadCost.hidden = YES;
    // Do any additional setup after loading the view from its nib.
    goingBack = YES;
    
    proprietar = [YTOPersoana Proprietar];
    firstTime = YES;
    [self initCells];
    [self setTipPlata:@"cash"];
    [self setLocalitate:asigurat.localitate];
    [self setJudet:asigurat.judet];
    [self setAdresa:asigurat.adresa];
    [self setTelefon:asigurat.telefon];
    [self setEmail:asigurat.email];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    lblModPlata.text = NSLocalizedStringFromTable(@"i90", [YTOUserDefaults getLanguage],@"Modalitate de plata");
    lblCashLaLivrare.text = NSLocalizedStringFromTable(@"i177", [YTOUserDefaults getLanguage],@"CASH,\n la livrare");
    lblOnlineCuCard.text = NSLocalizedStringFromTable(@"i179", [YTOUserDefaults getLanguage],@"ONLINE, \n cu cardul");
    lblPrinOP.text = NSLocalizedStringFromTable(@"i178", [YTOUserDefaults getLanguage],@"Prin OP / \n transfer");
    lblLoading.text = NSLocalizedStringFromTable(@"i444", [YTOUserDefaults getLanguage],@"se incarca...");
    lblCustomAlertNO.text = NSLocalizedStringFromTable(@"i98", [YTOUserDefaults getLanguage],@"NU");
    lblCustomAlertOK.text = NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA");
    lblCustomFacebook.text = NSLocalizedStringFromTable(@"i592", [YTOUserDefaults getLanguage],@"fb");
    lblCustomTwitter.text = NSLocalizedStringFromTable(@"i593", [YTOUserDefaults getLanguage],@"tweet");
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
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
    
    lbl1.text = NSLocalizedStringFromTable(@"i767", [YTOUserDefaults getLanguage],@"Finalizare comanda");
    lbl2.text = NSLocalizedStringFromTable(@"i768", [YTOUserDefaults getLanguage],@"livrare gratuita");
    lbl3.text = NSLocalizedStringFromTable(@"i769", [YTOUserDefaults getLanguage],@"odorizant");
    lbl1.adjustsFontSizeToFitWidth = YES;
    
    //    if ([YTOUserDefaults isRedus])
    //    {
    //        lbl2.hidden = YES;
    //    }
    
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
    {
        [lblCashLaLivrare setFont:[UIFont systemFontOfSize:10]];
    }
    [self callGetCostLivrare];
    
    
    
    cellHeader.userInteractionEnabled = NO;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    return 10;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 4)
        return 100;
    if (indexPath.row == 5)
        return 100;
    if (indexPath.row == 6)
        return 41;
    if (indexPath.row == 8)
        return 41;
    
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.row == 0) cell = cellJudetLocalitate;
    else if (indexPath.row == 1) cell = cellAdresa;
    else if (indexPath.row == 2) cell = cellTelefon;
    else if (indexPath.row == 3) cell = cellEmail;
    else if (indexPath.row == 4) cell = cellSumar;
    else if (indexPath.row == 5) cell = cellPlata;
    else if (indexPath.row == 6) cell = cellCostLivrare;
    else if (indexPath.row == 7) cell = cellVoucher;
    else if (indexPath.row == 8) cell = cellTotal;
    else cell = cellCalculeaza;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame;
        if (indexPath.row ==  6 || indexPath.row == 8)
            frame = CGRectMake(0, 0, 320, 41);
        else if (indexPath.row == 4)
            frame = CGRectMake(0, 0, 320, 100);
        else frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showListaJudete:indexPath];
    }
    else if ((indexPath.row == 9))
    {
        [self doneEditing];
        
        if (txtTelefonLivrare.text.length == 0)
        {
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (txtTelefonLivrare.text.length !=10)
        {
            [[[[iToast makeText:NSLocalizedString(@"Ai introdus gresit numarul de telefon", @"")]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [txtTelefonLivrare becomeFirstResponder];
            return;
        }
        if (txtEmailLivare.text.length == 0)
        {
            [txtEmailLivare becomeFirstResponder];
            return;
        }
        if (![YTOUtils validateEmail:emailLivrare])
        {
            [[[[iToast makeText:NSLocalizedString(@"Ai introdus gresit adresa de e-mail", @"")]
               setGravity:iToastGravityCenter] setDuration:iToastDurationShort] show];
            [txtEmailLivare becomeFirstResponder];
            return;
        }
        
        [self showCustomConfirm:NSLocalizedStringFromTable(@"i451", [YTOUserDefaults getLanguage],@"Confirma date") withDescription:NSLocalizedStringFromTable(@"i452", [YTOUserDefaults getLanguage],@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui apasa NU") withButtonIndex:100];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    if (indexPath.row != 0)
    {
        [self addBarButton];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}
    
	activeTextField = textField;
	
	UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    activeTextField.tag = indexPath.row;
    
	tableView.contentInset = UIEdgeInsetsMake(64, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
	if(activeTextField == textField)
	{
        [self textFieldDidEndEditing:activeTextField];
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	[self deleteBarButton];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) textField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    if (index == 1)
        [self setAdresa:textField.text];
    if (index == 2)
        [self setTelefon:textField.text];
    else if (index == 3)
        [self setEmail:textField.text];
    if (textField == txtCodVoucher && textField.text.length>0)
        [self callGetValoareVoucher];
}

-(IBAction) doneEditing
{
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}

- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
}

- (void) deleteBarButton {
	//self.navigationItem.rightBarButtonItem = nil;
    [YTOUtils rightImageVodafone:self.navigationItem];
}

#pragma Others
- (void) initCells
{
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:NSLocalizedStringFromTable(@"i120", [YTOUserDefaults getLanguage],@"LIVRARE(JUDET,LOCALITATE)")];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:NSLocalizedStringFromTable(@"i121", [YTOUserDefaults getLanguage],@"LIVRARE (STRADA,NUMAR,BLOC)")];
    [(UITextField *)[cellAdresa viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    txtEmailLivare = (UITextField *)[cellEmail viewWithTag:2];
    [(UILabel *)[cellEmail viewWithTag:1] setText:NSLocalizedStringFromTable(@"i180", [YTOUserDefaults getLanguage],@"EMAIL CONTACT")];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    txtTelefonLivrare = (UITextField *)[cellTelefon viewWithTag:2];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:NSLocalizedStringFromTable(@"i181", [YTOUserDefaults getLanguage],@"TELEFON CONTACT")];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-rca.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = NSLocalizedStringFromTable(@"i96", [YTOUserDefaults getLanguage],@"COMANDA");
    
    NSArray *topLevelObjectsCost = [[NSBundle mainBundle] loadNibNamed:@"CellVIew_Label" owner:self options:nil];
    cellCostLivrare = [topLevelObjectsCost objectAtIndex:0];
    [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
    [(UILabel *)[cellCostLivrare viewWithTag:1] setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
    [(UILabel *)[cellCostLivrare viewWithTag:1] setTextColor:[YTOUtils colorFromHexString:rosuTermeni]];
    
    NSArray *topLevelObjectsVoucher = [[NSBundle mainBundle] loadNibNamed:@"CellView_Voucher" owner:self options:nil];
    cellVoucher = [topLevelObjectsVoucher objectAtIndex:0];
    txtCodVoucher = (UITextField *)[cellVoucher viewWithTag:2];
    [txtCodVoucher setDelegate:self];
    [(UILabel *)[cellVoucher viewWithTag:99] setText:@""];
    [(UILabel *)[cellVoucher viewWithTag:1] setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
    [YTOUtils setCellFormularStyle:cellVoucher];
    
    NSArray *topLevelObjectsSumar = [[NSBundle mainBundle] loadNibNamed:@"CellView_RCASumar" owner:self options:nil];
    cellSumar = [topLevelObjectsSumar objectAtIndex:0];
    [(UILabel *)[cellSumar viewWithTag:1] setText:[NSString stringWithFormat: @"%.2f lei",oferta.primaReducere ]];
    [(UILabel *)[cellSumar viewWithTag:2] setText:[NSString stringWithFormat: @"%.2f lei",oferta.prima ]];
    if ([oferta.idReducere isEqualToString:@""]){
        ((UILabel *) [cellSumar viewWithTag:99]).hidden = YES;
        ((UILabel *)[cellSumar viewWithTag:1]).hidden = YES;
    }
    [(UIImageView *)[cellSumar viewWithTag:3] setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg", [oferta.companie lowercaseString]]]];
    [(UILabel *)[cellSumar viewWithTag:4] setText:[NSString stringWithFormat:@"%@ %d %@",NSLocalizedStringFromTable(@"i589", [YTOUserDefaults getLanguage],@"durata"), oferta.durataAsigurare,NSLocalizedStringFromTable(@"i590", [YTOUserDefaults getLanguage],@"luni")]];
    [(UILabel *)[cellSumar viewWithTag:5] setText:[NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]]];
    cellSumar.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *topLevelObjectsTotal = [[NSBundle mainBundle] loadNibNamed:@"CellView_CostTotal" owner:self options:nil];
    cellTotal = [topLevelObjectsTotal objectAtIndex:0];
    float total = oferta.primaReducere;
    if ([oferta.idReducere isEqualToString:@""])
    {
        total = oferta.prima;
    }
    [(UILabel *)[cellTotal viewWithTag:1] setText:[NSString stringWithFormat: @"Total : %.2f lei",total]];
    
    [YTOUtils setCellFormularStyle:cellCostLivrare];
    
}

- (void) showListaJudete:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = NSLocalizedStringFromTable(@"i304", [YTOUserDefaults getLanguage],@"Judete");;
    [self presentModalViewController:actionPicker animated:YES];
}

#pragma Picker View Nomenclator
-(void)chosenIndexAfterSearch:(NSString*)selected rowIndex:(NSIndexPath *)indexPath  forView:(PickerVCSearch *)vwSearch {
    if (indexPath.row == 0) // JUDET + LOCALITATE
    {
        if (vwSearch.nomenclator == kJudete) {
            [self setJudet:selected];
        }
        else {
            [self setLocalitate:selected];
        }
    }
    goingBack = YES;
}

- (void) setJudet:(NSString *)judet
{
    judetLivrare = judet;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [[judetLivrare stringByAppendingString:@","] stringByAppendingString:localitateLivrare];
    //    if (!firstTime && ![oferta.idReducere isEqualToString:@""])
    //        [self callGetCostLivrare];
}

- (void) setLocalitate:(NSString *)localitate
{
    localitateLivrare = localitate;
}

- (void) setAdresa:(NSString *)adresa
{
    adresaLivrare = adresa;
    UITextField * txt = (UITextField *)[cellAdresa viewWithTag:2];
    txt.text = adresa;
}

- (void) setEmail:(NSString *)email
{
    if ([email isEqualToString:@""] && proprietar.email.length >0 )
    {
        email = proprietar.email;
    }
    else if (asigurat.email == nil || [asigurat.email isEqualToString:@"null"])
    {
        asigurat.email = email;
        saveAsigurat = YES;
    }
    
    emailLivrare = email;
    txtEmailLivare.text = email;
}

- (void) setTelefon:(NSString *)telefon
{
    if ([telefon isEqualToString:@""] && proprietar.telefon.length >0 )
    {
        telefon = proprietar.telefon;
    }
    else if (asigurat.telefon == nil || [asigurat.telefon isEqualToString:@"null"] || [asigurat.telefon isEqualToString:@"(null)"])
    {
        asigurat.telefon = telefon;
        saveAsigurat = YES;
    }
    
    telefonLivrare = telefon;
    txtTelefonLivrare.text = telefon;
}

- (IBAction)btnTipPlata_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    for (int i=1; i<=3; i++) {
        UIButton * _btn = (UIButton *)[cellPlata viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (btn.tag == 1)
        [self setTipPlata:@"cash"];
    else if (btn.tag == 2)
        [self setTipPlata:@"op"];
    else if (btn.tag ==3)
        [self setTipPlata:@"online"];
    
    [self doneEditing];
}

- (void) setTipPlata:(NSString *)p
{
    if ([p isEqualToString:@"cash"]) {
        ((UIButton *)[cellPlata viewWithTag:1]).selected = YES;
        modPlata = 1;
    }
    else if ([p isEqualToString:@"op"])
    {
        ((UIButton *)[cellPlata viewWithTag:2]).selected = YES;
        modPlata = 2;
    }
    else if ([p isEqualToString:@"online"])
    {
        ((UIButton *)[cellPlata viewWithTag:3]).selected = YES;
        modPlata = 3;
    }
    //    if (!firstTime && ![oferta.idReducere isEqualToString:@""])
    //        [self callGetCostLivrare];
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{
    NSString * bonusMalus = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];
    NSString * primaReducere ;
    if ([oferta.idReducere isEqualToString:@""])
        primaReducere = @"";
    else primaReducere =[NSString stringWithFormat:@"%.2f",oferta.primaReducere];
    
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<InregistrareComandaSmartphone5 xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<oferta_prima>%.2f</oferta_prima>"
                      "<oferta_companie>%@</oferta_companie>"
                      "<oferta_cod>%@</oferta_cod>"
                      "<oferta_clasa_bm>%@</oferta_clasa_bm>"
                      "<livrare_adresa>%@</livrare_adresa>"
                      "<livrare_localitate>%@</livrare_localitate>"
                      "<livrare_judet>%@</livrare_judet>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<mod_plata>%d</mod_plata>"
                      "<udid>%@</udid>"
                      "<id_masina>%@</id_masina>"
                      "<durata>%@</durata>"
                      "<platforma>%@</platforma>"
                      "<cont_user>%@</cont_user>"
                      "<cont_parola>%@</cont_parola>"
                      "<limba>ro</limba>"
                      "<versiune>%@</versiune>"
                      "<prima_reducere>%@</prima_reducere>"
                      "<id_reducere>%@</id_reducere>"
                      "<id_livrare>%@</id_livrare>"
                      "<cost_livrare>%@</cost_livrare>"
                      "<cod_voucher>%@</cod_voucher>"
                      "</InregistrareComandaSmartphone5>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      oferta.prima, oferta.companie, oferta.codOferta, bonusMalus, adresaLivrare, localitateLivrare, judetLivrare, telefonLivrare, emailLivrare, modPlata,
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier],
                      masina.idIntern, [NSString stringWithFormat:@"%d", oferta.durataAsigurare],
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword],
                      [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]],
                      primaReducere,
                      oferta.idReducere,idLivrare,costLivrare,
                      costVoucher==0? @"":txtCodVoucher.text];
    return xml;
}

- (NSString *) XmlRequestVoucher
{
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"dd.MM.yyyy"];
    NSString *strDataCurenta = [DateFormatter stringFromDate:[NSDate date]];
    
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<GetValoareVoucher xmlns=\"http://tempuri.org/\">"
                      "<username>vreaurca</username>"
                      "<password>123</password>"
                      "<codVoucher>%@</codVoucher>"
                      "<dataUtilizareVoucher>%@</dataUtilizareVoucher>"
                      "<prima>%f</prima>"
                      "<categorieProdus>RCA</categorieProdus>"
                      "<companie>%@</companie>"
                      "<platforma>%@</platforma>"
                      "<tipDestinatar>1</tipDestinatar>"
                      "<destinatar>%@</destinatar>"
                      "<contUser>%@</contUser>"
                      "<contParola>%@</contParola>"
                      "</GetValoareVoucher>"
                      "</soap:Body>"
                      "</soap:Envelope>",txtCodVoucher.text,strDataCurenta,
                      (![oferta.idReducere isEqualToString:@""]? oferta.primaReducere : oferta.prima),
                      oferta.companie,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"],
                      txtEmailLivare.text,
                      [YTOUserDefaults getUserName],
                      [YTOUserDefaults getPassword]];
    NSLog (@"%@",xml);
    return xml;
}


- (IBAction) callInregistrareComanda {
    [self showCustomLoading];
    comanda1cost2 = 1;
    self.navigationItem.hidesBackButton = YES;
    
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@rca.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d",[parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/InregistrareComandaSmartphone5" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
}

- (IBAction) callGetValoareVoucher {
    loadCost.hidden = NO;
    comanda1cost2 = 0;
    self.navigationItem.hidesBackButton = YES;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@utils.asmx", LinkAPI]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:30.0];
    
    NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestVoucher]];
    NSLog(@"Request=%@", parameters);
    NSString * msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[parameters length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/GetValoareVoucher" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.responseData = [NSMutableData data];
    }
}

- (IBAction) callGetCostLivrare {
    [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"0 lei" ]];
    //[(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
    [(UILabel *)[cellCostLivrare viewWithTag:1] setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
    [(UILabel *)[cellCostLivrare viewWithTag:1] setTextColor:[YTOUtils colorFromHexString:rosuTermeni]];
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
	NSString * responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
	NSLog(@"Response string: %@", responseString);
    if (comanda1cost2 == 2){
        NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
        xmlParser.delegate = self;
        BOOL succes = [xmlParser parse];
        if (succes)
        {
            NSError * err = nil;
            NSData *data = [responseMessage dataUsingEncoding:NSUTF8StringEncoding];
            @try {
                NSDictionary * item = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
                idLivrare = [item objectForKey:@"IdLivrare"];
                costLivrare = [item objectForKey:@"CostLivrare"];
                firstTime = NO;
                [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setTextColor:[YTOUtils colorFromHexString:rosuTermeni]];
            }@catch (NSException * e) {
                costLivrare = @"10";
                idLivrare=@"-1";
                firstTime = NO;
                [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setText:[NSString stringWithFormat: @"%@ lei",costLivrare ]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setFont:[UIFont fontWithName:@"Arial Rounded MT Bold" size:17]];
                [(UILabel *)[cellCostLivrare viewWithTag:1] setTextColor:[YTOUtils colorFromHexString:rosuTermeni]];
            }@finally {
                loadCost.hidden = YES;
                self.navigationItem.hidesBackButton = NO;
                float total = oferta.primaReducere + [costLivrare floatValue];
                [(UILabel *)[cellTotal viewWithTag:1] setText:[NSString stringWithFormat: @"Total : %.2f lei",total]];
            }
            
            
        }
        loadCost.hidden = YES;
        self.navigationItem.hidesBackButton = NO;
    }else if (comanda1cost2 == 0){
        NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
        xmlParser.delegate = self;
        BOOL succes = [xmlParser parse];
        
        if (succes) {
            if (costVoucher == 0)
                [self showCustomAlert:@"Eroare" withDescription:@"A aparut o eroare cu voucher-ul" withError:YES withButtonIndex:99];
            else {
                [(UILabel *) cellVoucher viewWithTag:99].hidden = NO;
                [(UILabel *)[cellVoucher viewWithTag:99] setText:[NSString stringWithFormat: @"-%.2f lei",costVoucher ]];
                double primaDouble = [oferta.idReducere isEqualToString:@""]? oferta.prima : oferta.primaReducere;
                [(UILabel *)[cellTotal viewWithTag:1] setText:[NSString stringWithFormat: @"Total : %.2f lei",primaDouble - costVoucher]];
                [txtCodVoucher setEnabled:NO];
                [txtEmailLivare setEnabled:NO];
                [txtCodVoucher setTextColor:[YTOUtils colorFromHexString:menuLighGray]];
                [txtEmailLivare  setTextColor:[YTOUtils colorFromHexString:menuLighGray]];
            }
        }
        loadCost.hidden = YES;
    }else {
        self.navigationItem.hidesBackButton = NO;
        
        
        NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
        xmlParser.delegate = self;
        BOOL succes = [xmlParser parse];
        
        if (succes) {
            if (idOferta == nil || [idOferta isEqualToString:@""])
                [self showCustomAlert:NSLocalizedStringFromTable(@"i454", [YTOUserDefaults getLanguage],@"Finalizare comanda RCA") withDescription:responseMessage withError:YES withButtonIndex:2];
            else {
                oferta.idExtern = [idOferta intValue];
                
                if (!oferta._isDirty)
                    [oferta addOferta];
                else
                    [oferta updateOferta];
                
                // in cazul in care nu avea telefon sau email introdus,
                // salvam aceste valori
                if (saveAsigurat)
                    [asigurat updatePersoana:NO];
                [self hideCustomLoading];
                // daca este pentru plata ONLINE
                if (modPlata == 3) {
                    [self showCustomAlert:@"Finalizare comanda RCA" withDescription:responseMessage withError:NO withButtonIndex:3];
                }
                else [self showCustomAlert:@"Finalizare comanda RCA" withDescription:responseMessage withError:NO withButtonIndex:1];
                
            }
            
        }
        else
        {
            [self showCustomAlert:NSLocalizedStringFromTable(@"i454", [YTOUserDefaults getLanguage],@"Finalizare comanda RCA") withDescription:@"Comanda NU a fost transmisa." withError:YES withButtonIndex:4];
            
        }
    }
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    //	UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Atentie!" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //	[alertView show];
    [self hideCustomLoading];
    [self showCustomAlert:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") withDescription:[error localizedDescription] withError:YES withButtonIndex:4];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (comanda1cost2 == 1){
        if ([elementName isEqualToString:@"NumarComanda"]) {
            idOferta = currentElementValue;
            if (idOferta.length > 0)
            {
                //setari.idOferta = idOferta;
                //[appDelegate salveazaSetari];
            }
        }
        else if ([elementName isEqualToString:@"MesajComanda"]) {
            responseMessage = [NSString stringWithString:currentElementValue];
        }
    } else {
        if ([elementName isEqualToString:@"GetValoareVoucherResult"]) {
            responseMessage = [NSString stringWithString:currentElementValue];
            costVoucher = [responseMessage floatValue];
        }
        if ([elementName isEqualToString:@"GetCostLivrareResult"]) {
            responseMessage = [NSString stringWithString:currentElementValue];
        }
    }
	currentElementValue = nil;
}


- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(!currentElementValue)
		currentElementValue = [[NSMutableString alloc] initWithString:string];
	else
		[currentElementValue appendString:string];
}

- (void) showCustomLoading
{
    self.navigationItem.hidesBackButton = YES;
    [self hideCustomLoading];
    [btnClosePopup setHidden:YES];
    [loading setHidden:NO];
    [lblLoading setHidden:NO];
    // [imgLoading setImage:[UIImage imageNamed:@"popup-generic.png"]];
    [vwLoading setHidden:NO];
}

- (IBAction) hideCustomLoading
{
    self.navigationItem.hidesBackButton = NO;
    [vwLoading setHidden:YES];
    [YTOUserDefaults setFirstInsuranceRequest:YES];
    if (idOferta && ![idOferta isEqualToString:@""] && [YTOUserDefaults IsFirstInsuranceRequest])
    {
        [YTOUserDefaults setFirstInsuranceRequest:YES];
        //  [self showPopupDupaComanda:@""];
    }
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    if (error){
        lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
        lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    }else{
        lblEroare.text = NSLocalizedStringFromTable(@"i809", [YTOUserDefaults getLanguage],@"Comanda a fost inregistrata");
        lblEroare.textColor = [YTOUtils colorFromHexString:verde];
        lblEroare.textColor = [YTOUtils colorFromHexString:verde];
        [lblEroare setFont:[UIFont fontWithName:@"Chalkboard SE" size:16]];
    }
    
    btnCustomAlertOK.tag = index;
    //    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    if (modPlata != 3 && !SYSTEM_VERSION_LESS_THAN(@"6.0") && !error){
        [btnCustomFacebook setHidden:NO];
        [lblCustomFacebook setHidden:NO];
        [btnCustomTwitter setHidden:NO];
        [lblCustomTwitter setHidden:NO];
    }
    
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}



- (IBAction) hideButtonSocialMedia:(id)sender
{
    [btnCustomFacebook setHidden:YES];
    [lblCustomFacebook setHidden:YES];
    [btnCustomTwitter setHidden:YES];
    [lblCustomTwitter setHidden:YES];
    
    self.navigationItem.hidesBackButton = NO;
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    
    if (btn.tag == 2) {
        // share pe Facebook
        
        // ca sa vedem pe analytics cate share-uri s-au dat
        
        //        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
        //        [tracker sendSocial:@"Facebook"
        //                 withAction:@"Share"
        //                 withTarget:@"https://developers.google.com/analytics"];
        
        YTOFinalizareRCAViewController *self_ = self;
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cumparat asigurarea RCA direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            NSString * bonusMalus = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];
            if ([[[bonusMalus substringFromIndex:13] substringToIndex:1] isEqualToString:@"B"]){
                img= [UIImage imageNamed:@"socialmedia-ios-rca-bonus.png"];
                text = [[NSString alloc] initWithFormat:@"    Am obtinut \n   %@ (bonus %@) \n       la RCA",[bonusMalus substringFromIndex:13],[bonusMalus substringFromIndex:14] ];
            }
            else {
                img = [UIImage imageNamed:@"socialmedia-ios-rca-malus.png"];
                text = [[NSString alloc] initWithFormat:@"    Am obtinut \n   %@ (malus %@) \n       la RCA",[bonusMalus substringFromIndex:13],[bonusMalus substringFromIndex:14] ];
            }
            NSString *text2 = [[NSString alloc] initWithFormat:@" %.0f lei \n pe %d luni \n %@",oferta.prima,oferta.durataAsigurare,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(55, 370)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            int output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = 0;
                    break;
                case SLComposeViewControllerResultDone:
                    output = 1;
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
            
            //            if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
            //                if (output)
            //                    [self showPopupDupaComanda:@"Fb"];
            //                else
            //                    [self showPopupDupaComanda:@""];
            //            }
            //            else{
            // [self.navigationController popToRootViewControllerAnimated:YES];
            //}
            
            [self_.navigationController popToRootViewControllerAnimated:YES];
            
            
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
    else if (btn.tag == 4) {
        
        //        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
        //        [tracker sendSocial:@"Tweeter"
        //                 withAction:@"Tweet"
        //                 withTarget:@"https://developers.google.com/analytics"];
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cumparat asigurarea RCA direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            NSString * bonusMalus = [NSString stringWithFormat:@"Bonus/Malus: %@", [oferta RCABonusMalus]];
            if ([[[bonusMalus substringFromIndex:13] substringToIndex:1] isEqualToString:@"B"]){
                img= [UIImage imageNamed:@"socialmedia-ios-rca-bonus.png"];
                text = [[NSString alloc] initWithFormat:@"    Am obtinut \n   %@ (bonus %@) \n       la RCA",[bonusMalus substringFromIndex:13],[bonusMalus substringFromIndex:14] ];
            }
            else {
                img = [UIImage imageNamed:@"socialmedia-ios-rca-malus.png"];
                text = [[NSString alloc] initWithFormat:@"    Am obtinut \n   %@ (malus %@) \n       la RCA",[bonusMalus substringFromIndex:13],[bonusMalus substringFromIndex:14] ];
            }
            NSString *text2 = [[NSString alloc] initWithFormat:@" %.0f lei \n pe %d luni \n %@",oferta.prima,oferta.durataAsigurare,oferta.companie ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(55, 370)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
        }
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            [mySLComposerSheet dismissViewControllerAnimated:YES completion:nil];
            int output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = 0;
                    break;
                case SLComposeViewControllerResultDone:
                    output = 1;
                    break;
                default:
                    break;
            } //check if everythink worked properly. Give out a message on the state.
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
            
            //            if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
            //            if (output)
            //                [self showPopupDupaComanda:@"Tweet"];
            //            else
            //                [self showPopupDupaComanda:@""];
            //            }
            //            else{
            [self.navigationController popToRootViewControllerAnimated:YES];
            [mySLComposerSheet removeFromParentViewController];
            //  }
        }];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (IBAction) hideCustomAlert:(id)sender
{
    self.navigationItem.hidesBackButton = NO;
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    
    NSLog(@"tag=%d", btn.tag);
    
    if (btn.tag == 1)
    {
        //        if ([YTOUserDefaults IsFirstInsuranceRequest] && [YTOUserDefaults getUserName] != nil &&  ![[YTOUserDefaults getUserName] isEqualToString:@""]) {
        //            [self showPopupDupaComanda:@""];
        //        }
        //        else
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 11 || btn.tag == 5)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else if (btn.tag == 3)
    {
        NSString *prima,*primaInitiala;
        //   costLivrare = @"2";
        if ([oferta.idReducere isEqualToString:@""]){
            primaInitiala = @"";
            prima = [NSString stringWithFormat:@"%.2f" , oferta.prima - costVoucher ];
        }else {
            primaInitiala = [NSString stringWithFormat:@"%.2f" , oferta.prima- costVoucher ];
            prima =  [NSString stringWithFormat:@"%.2f" , oferta.primaReducere - costVoucher ];
        }
        NSString * url = [NSString stringWithFormat:@"%@pre-pay.aspx?numar_oferta=%@"
                          "&email=%@"
                          "&nume=%@"
                          "&adresa=%@"
                          "&localitate=%@"
                          "&judet=%@"
                          "&telefon=%@"
                          "&codProdus=%@"
                          "&valoare=%@"
                          "&companie=%@"
                          "&valoareInitiala=%@"
                          "&costLivrare=%@"
                          "&udid=%@",
                          LinkAPI,
                          idOferta, emailLivrare, asigurat.nume, asigurat.adresa, asigurat.localitate, asigurat.judet, telefonLivrare,
                          @"RCA", prima, oferta.companie,primaInitiala,(costLivrare ? costLivrare : @""), [[[UIDevice currentDevice] xUniqueDeviceIdentifier] stringByAppendingString:[NSString stringWithFormat:@"---%@",masina.idIntern]]];
        
        NSURL * nsURL = [[NSURL alloc] initWithString:[url stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
        NSLog(@"%@",nsURL);
        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.rcaNavigationController pushViewController:aView animated:YES];
        //        [[UIApplication sharedApplication] openURL:nsURL];
        
        //        YTOWebViewController * aView = [[YTOWebViewController alloc] init];
        //        aView.URL = [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        //        [delegate.rcaNavigationController pushViewController:aView animated:YES];
        //   [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 100)
    {
        [self doneEditing];
        
        [self callInregistrareComanda];
    }
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    self.navigationItem.hidesBackButton = YES;
    lblEroare.text =NSLocalizedStringFromTable(@"i808", [YTOUserDefaults getLanguage],@"Datele sunt corecte ?");
    lblEroare.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index;
    //    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:NSLocalizedStringFromTable(@"i343", [YTOUserDefaults getLanguage],@"DA")];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (void) showPopupDupaComanda:(NSString*) share
{
    self.navigationItem.hidesBackButton = YES;
    
    if (IS_IPHONE_5) {
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"popup-dupa-comanda-r4.png"]];
        
        [viewTooltip addSubview:img];
        
        if ([share isEqualToString:@"Fb"]) {
            UIImageView * imgFb = [[UIImageView alloc] initWithFrame:CGRectMake(45, 150, 238, 50)];
            [imgFb setImage:[UIImage imageNamed:@"popup-facebook.png"]];
            [img addSubview:imgFb];
        }
        else if ([share isEqualToString:@"Tweet"]) {
            UIImageView * imgTw = [[UIImageView alloc] initWithFrame:CGRectMake(45, 150, 238, 50)];
            [imgTw setImage:[UIImage imageNamed:@"popup-twitter.png"]];
            [img addSubview:imgTw];
        }
        
        UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = 2;
        btnClose.frame = CGRectMake(126, 480, 70, 31);
        [btnClose addTarget:self action:@selector(closeTooltip) forControlEvents:UIControlEventTouchUpInside];
        [viewTooltip addSubview:btnClose];
    }
    else {
        viewTooltip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        img.tag = 1;
        [img setImage:[UIImage imageNamed:@"popup-dupa-comanda.png"]];
        [viewTooltip addSubview:img];
        
        if ([share isEqualToString:@"Fb"]) {
            UIImageView * imgFb = [[UIImageView alloc] initWithFrame:CGRectMake(45, 110, 238, 50)];
            [imgFb setImage:[UIImage imageNamed:@"popup-facebook.png"]];
            [img addSubview:imgFb];
        }
        else if ([share isEqualToString:@"Tweet"]) {
            UIImageView * imgTw = [[UIImageView alloc] initWithFrame:CGRectMake(45, 110, 238, 50)];
            [imgTw setImage:[UIImage imageNamed:@"popup-twitter.png"]];
            [img addSubview:imgTw];
        }
        
        UIButton * btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        btnClose.tag = 2;
        btnClose.frame = CGRectMake(126, 400, 70, 31);
        [btnClose addTarget:self action:@selector(closeTooltip) forControlEvents:UIControlEventTouchUpInside];
        [viewTooltip addSubview:btnClose];
    }
    
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.window addSubview:viewTooltip];
    [iRate sharedInstance].usesCount +=2;
    [iRate sharedInstance].eventCount+=2;
}

- (void) closeTooltip
{
    self.navigationItem.hidesBackButton = NO;
    [viewTooltip removeFromSuperview];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
