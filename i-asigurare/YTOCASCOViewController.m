//
//  YTOCASCOViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/8/12.
//
//

#import "YTOCASCOViewController.h"
#import "YTOUtils.h"
#import "YTOListaAutoViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTOListaAsiguratiViewController.h"
#import "YTOAsiguratViewController.h"
#import "YTOAppDelegate.h"

//////////

@interface YTOCASCOViewController ()

@end

@implementation YTOCASCOViewController
@synthesize listaCompaniiAsigurare;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"CASCO", @"CASCO");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initCells];
    [self initCustomValues];
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
    return 8;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 75;
    else if (indexPath.row == 5 || indexPath.row == 6)
        return 100;
    return 66;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    
    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellMasina;
    else if (indexPath.row == 2) cell = cellProprietar;
    else if (indexPath.row == 3) cell = cellNrKm;
    else if (indexPath.row == 4) cell = cellCuloare;
    else if (indexPath.row == 5) cell = cellAsigurareCasco;
    else if (indexPath.row == 6) cell = cellNrRate;
    else cell = cellCalculeaza;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];   
    
    if (indexPath.row == 1)
    {
        // Daca exista masini salvate, afisam lista
        if ([appDelegate Masini].count > 0)
        {
            YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAutovehiculViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
            else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
    }
    else if (indexPath.row == 2)
    {
        // Daca exista persoane salvate, afisam lista
        if ([appDelegate Persoane].count > 0)
        {
            YTOListaAsiguratiViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController_R4" bundle:nil];
            else aView = [[YTOListaAsiguratiViewController alloc] initWithNibName:@"YTOListaAsiguratiViewController" bundle:nil];
            aView.controller = self;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        else {
            YTOAsiguratViewController * aView = [[YTOAsiguratViewController alloc] init];
            aView.controller = self;
            aView.proprietar = YES;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        
    }
    else if (indexPath.row == 7)
    {
        BOOL isOK = YES;
        
        // Daca nu a fost selectata masina sau datele masinii nu sunt complete
        if (!masina || ![masina isValidForRCA])
        {
            UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
        }
        else {
            UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        // Daca nu a fost selectata persoana sau datele persoanei nu sunt complete
        if (!asigurat || asigurat.idIntern.length == 0)
        {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
        }
        else {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        if (!isOK)
            return;
        
//        masina.idProprietar  = asigurat.idIntern;
//        [masina updateAutovehicul];
//        [asigurat updatePersoana];

        
        [self doneEditing];
        
        if (masina.nrKm == 0)
        {
            [txtNumarKm becomeFirstResponder];
            return;
        }
        if (masina.culoare.length == 0)
        {
            [txtCuloare becomeFirstResponder];
            return;
        }
        
        [self showCustomConfirm:@"Confirmare date" withDescription:@"Aceste informatii vor fi trimise catre un reprezentant i-Asigurare. Mergi mai departe?" withButtonIndex:100];
    }
}

#pragma TEXTFIELD

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    if (indexPath.row == 3 || indexPath.row == 4)
        [self addBarButton];

}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	if(activeTextField != nil)
	{
		//[self saveTextField];
	}

	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
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
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];

    if (indexPath.row == 3)
        [self setNumarKm:[textField.text intValue]];
    else if (indexPath.row == 4)
        [self setCuloare:textField.text];
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
	self.navigationItem.rightBarButtonItem = nil;
}

#pragma Methods

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"calculator-casco.png"];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellMasina = [topLevelObjectsMarca objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    UIImageView * imgBgAuto = (UIImageView *)[cellMasina viewWithTag:5];
    imgBgAuto.image =[UIImage imageNamed:@"alege-masina-portocaliu.png"];
    
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = @"Alege masina";
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UIImageView * imgBgProprietar = (UIImageView *)[cellProprietar viewWithTag:5];
    imgBgProprietar.image =[UIImage imageNamed:@"alege-masina-portocaliu.png"];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = @"Alege proprietar";
    
    NSArray *topLevelObjectsnrKm = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellNrKm = [topLevelObjectsnrKm objectAtIndex:0];
    txtNumarKm = (UITextField *)[cellNrKm viewWithTag:2];
    [(UILabel *)[cellNrKm viewWithTag:1] setText:@"Numar kilometri autovehicul"];
    [(UITextField *)[cellNrKm viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellNrKm];
    
    NSArray *topLevelObjectsCuloare = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellCuloare = [topLevelObjectsCuloare objectAtIndex:0];
    txtCuloare = (UITextField *)[cellCuloare viewWithTag:2];
    [(UILabel *)[cellCuloare viewWithTag:1] setText:@"Culoare autovehicul"];
    [YTOUtils setCellFormularStyle:cellCuloare];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgBgCalculeaza = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgBgCalculeaza.image =[UIImage imageNamed:@"calculeaza-casco.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = @"Cere oferta";
}

- (void) initCustomValues
{
    cautLegaturaDintreMasinaSiAsigurat = YES;
    YTOPersoana * prop = [YTOPersoana Proprietar];
    if (prop)
    {
        [self setAsigurat:prop];
    }
}

- (void)setAsigurat:(YTOPersoana *) a
{
    UILabel * lblCellP = ((UILabel *)[cellProprietar viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = a.nume;
    ((UILabel *)[cellProprietar viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.codUnic, a.judet];
    if (![asigurat.idIntern isEqualToString:a.idIntern])
        cautLegaturaDintreMasinaSiAsigurat = YES;
    asigurat = a;

    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:masina.idProprietar])
    {
        YTOAutovehicul * _auto = [YTOAutovehicul getAutovehiculByProprietar:a.idIntern];
        
        if (_auto && _auto.idIntern && [_auto isValidForRCA] && cautLegaturaDintreMasinaSiAsigurat)
        {
            [self setAutovehicul:_auto];
            cautLegaturaDintreMasinaSiAsigurat = NO;
        }
    }

    [tableView reloadData];
}

- (void)setAutovehicul:(YTOAutovehicul *)a
{
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (a.marcaAuto.length > 0)
    {
        lblCell.text = a.marcaAuto;
        ((UILabel *)[cellMasina viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.modelAuto, a.nrInmatriculare];
    }
    masina = a;
    if (masina.idProprietar.length > 0 && ![masina.idProprietar isEqualToString:asigurat.idIntern] && cautLegaturaDintreMasinaSiAsigurat)
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:masina.idProprietar];
        if (prop)
            [self setAsigurat:prop];
        cautLegaturaDintreMasinaSiAsigurat = NO;
    }
    if (masina.nrKm > 0)
        [self setNumarKm:masina.nrKm];
    
    if (masina.culoare && ![masina.culoare isEqualToString:@""])
        [self setCuloare:masina.culoare];

}

- (void)setNumarKm:(int)v
{

    UITextField * txt = (UITextField *)[cellNrKm viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d",v];
    masina.nrKm = v;

}

- (void)setCuloare:(NSString *)v
{

    UITextField * txt = (UITextField *)[cellCuloare viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%@",v];
    masina.culoare = v;
}

- (void)setNrRate:(NSString *)v
{
    ((UIButton *)[cellNrRate viewWithTag:1]).selected = ((UIButton *)[cellNrRate viewWithTag:2]).selected = ((UIButton *)[cellNrRate viewWithTag:3]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([v isEqualToString:@"Integral"]) {
        ((UIButton *)[cellNrRate viewWithTag:1]).selected = YES;
        nrRate = @"Integral";
    }
    else if ([v isEqualToString:@"2 Rate"]) {
        ((UIButton *)[cellNrRate viewWithTag:2]).selected = YES;
        nrRate = @"2 Rate";
    }
    else if ([v isEqualToString:@"4 Rate"]) {
        ((UILabel *)[cellNrRate viewWithTag:33]).text = v;
        ((UIButton *)[cellNrRate viewWithTag:3]).selected = YES;
        nrRate = @"4 Rate";
    }
}

- (IBAction)checkboxNrRateSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    if (btn.tag  == 1) {
        [self setNrRate:@"Integral"];
    }
    else if (btn.tag == 2){
        [self setNrRate:@"2 Rate"];
    }
    else if (btn.tag == 3) {
        [self setNrRate:@"4 Rate"];
    }
}


- (void)setCompanieCasco:(NSString *)v
{
    ((UIButton *)[cellAsigurareCasco   viewWithTag:1]).selected = ((UIButton *)[cellAsigurareCasco viewWithTag:2]).selected =
    ((UIButton *)[cellAsigurareCasco viewWithTag:3]).selected = ((UIButton *)[cellAsigurareCasco viewWithTag:4]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([v isEqualToString:@"Allianz"])
        ((UIButton *)[cellAsigurareCasco viewWithTag:1]).selected = YES;
    else if ([v isEqualToString:@"Omniasig"])
        ((UIButton *)[cellAsigurareCasco viewWithTag:2]).selected = YES;
    else if ([v isEqualToString:@"Generali"]) {
        ((UILabel *)[cellAsigurareCasco viewWithTag:33]).text = v;
        ((UIButton *)[cellAsigurareCasco viewWithTag:3]).selected = YES;
    }
    else {
        ((UILabel *)[cellAsigurareCasco viewWithTag:33]).text = v;
        ((UIButton *)[cellAsigurareCasco viewWithTag:3]).selected = YES;
    }
}

- (IBAction)checkboxCompanieCascoSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    if (btn.tag  == 1) {
        [self setCompanieCasco:@"Allianz"];
    }
    else if (btn.tag == 2)
    {
        [self setCompanieCasco:@"Omniasig"];
    }
    else if (btn.tag == 3) {
        if ([((UILabel *)[cellAsigurareCasco viewWithTag:33]).text isEqualToString:@"Generali"])
            [self setCompanieCasco:@"Generali"];
        else
            [self setCompanieCasco:((UILabel *)[cellAsigurareCasco viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kCompaniiAsigurare;
        [self showNomenclator];
    }
}

#pragma YTO Nomenclator
- (void) showNomenclator
{
    self.navigationItem.hidesBackButton = YES;
    [vwNomenclator setHidden:NO];
    UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    NSMutableArray * listOfItems;
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = -1;
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        listaCompaniiAsigurare = [YTOUtils GETCompaniiAsigurare];
        [lblTitle setText:@"Alege compania unde ai CASCO"];
        listOfItems = listaCompaniiAsigurare;
        _nomenclatorNrItems = listaCompaniiAsigurare.count;
        
        if (masina.cascoLa.length > 0)
            selectedItemIndex = [YTOUtils getKeyList:listaCompaniiAsigurare forValue: masina.cascoLa];
    }

    [scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<listOfItems.count; i++) {
        if (i != 0 && i%3==0)
        {
            rows++;
            cols = 0;
        }
        KeyValueItem * item = (KeyValueItem *)[listOfItems objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 100 + i;
        [button setImage:[UIImage imageNamed:@"neselectat.png"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"selectat-casco.png"] forState:UIControlStateSelected];
        [button addTarget:self
                   action:@selector(btnNomenclator_Clicked:)
         forControlEvents:UIControlEventTouchDown];
        button.titleLabel.font = [UIFont fontWithName:@"Arial" size:12];
        button.titleLabel.numberOfLines = 0;
        button.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
        button.clipsToBounds = YES;
        UILabel * lbl = [[UILabel alloc] init];
        if (cols == 0)
        {
            button.frame = CGRectMake(20, rows * 70, 67, 65);
        }
        else if (cols == 1)
        {
            button.frame = CGRectMake(cols*105, rows * 70, 67, 65);
        }
        else
        {
            button.frame = CGRectMake(cols*95, rows * 70, 67, 65);
        }
        lbl.frame = CGRectMake(1, 5, 67, 34);
        lbl.backgroundColor = [UIColor clearColor];
        lbl.numberOfLines = 0;
        [lbl setTextAlignment:UITextAlignmentCenter];
        lbl.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lbl.font = [UIFont fontWithName:@"Arial" size:12];
        lbl.text = [[item.value stringByReplacingOccurrencesOfString:@"/" withString:@"/ "] stringByReplacingOccurrencesOfString:@"-" withString:@" - "];
        cols++;
        [button addSubview:lbl];
        if (i == selectedItemIndex)
            [button setSelected:YES];
        [scrollView addSubview:button];
    }
    
    float height = [listOfItems count]/3.0;
    [scrollView  setContentSize:CGSizeMake(279, height * 75)];
}

- (IBAction) hideNomenclator
{
    self.navigationItem.hidesBackButton = NO;
    [vwNomenclator setHidden:YES];
}

- (IBAction) btnNomenclator_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (!btn.selected)
        [btn setSelected:checkboxSelected];
    
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    for (int i=100; i<=100+_nomenclatorNrItems; i++) {
        
        UIButton * _btn = (UIButton *)[scrollView viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        KeyValueItem * item = (KeyValueItem *)[listaCompaniiAsigurare objectAtIndex:btn.tag-100];
        [self setCompanieCasco:item.value];
    }
}

#pragma mark Consume WebService

- (NSString *) XmlRequest
{    
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<RequestCasco xmlns=\"http://tempuri.org/\">"
                      "<user>vreaurca</user>"
                      "<password>123</password>"
                      "<tip_persoana>%@</tip_persoana>"
                      "<nume>%@</nume>"
                      "<codunic>%@</codunic>"
                      "<telefon>%@</telefon>"
                      "<email>%@</email>"
                      "<strada>%@</strada>"
                      "<judet>%@</judet>"
                      "<localitate>%@</localitate>"
                      "<data_permis>%@</data_permis>"
                      "<casatorit>%@</casatorit>"
                      "<copii_minori>%@</copii_minori>"
                      "<pensionar>%@</pensionar>"
                      "<nr_bugetari>%@</nr_bugetari>"
                      "<tip_inregistrare>%@</tip_inregistrare>"
                      "<caen>%@</caen>"
                      "<subtip_activitate>altele</subtip_activitate>"
                      "<index_categorie_auto>%d</index_categorie_auto>"
                      "<subcategorie_auto>%@</subcategorie_auto>"
                      "<in_leasing>%@</in_leasing>"
                      "<leasing_firma>%@</leasing_firma>"
                      "<leasing_cui></leasing_cui>"
                      "<leasing_judet></leasing_judet>"
                      "<leasing_localitate></leasing_localitate>"
                      "<serie_civ>%@</serie_civ>"
                      "<marca>%@</marca>"
                      "<model>%@</model>"
                      "<nr_inmatriculare>%@</nr_inmatriculare>"
                      "<serie_sasiu>%@</serie_sasiu>"
                      "<casco>%@</casco>"
                      "<marca_id></marca_id>"
                      "<auto_nou>%@</auto_nou>"
                      "<cm3>%d</cm3>"
                      "<kw>%d</kw>"
                      "<combustibil>%@</combustibil>"
                      "<nr_locuri>%d</nr_locuri>"
                      "<masa_maxima>%d</masa_maxima>"
                      "<an_fabricatie>%d</an_fabricatie>"
                      "<destinatie_auto>%@</destinatie_auto>"
                      "<culoare>%@</culoare>"
                      "<nr_km>%d</nr_km>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<platforma>%@</platforma>"
                      "</RequestCasco>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      asigurat.tipPersoana, asigurat.nume, asigurat.codUnic, asigurat.telefon, asigurat.email,
                      asigurat.adresa, masina.judet, masina.localitate, asigurat.dataPermis, asigurat.casatorit, asigurat.copiiMinori, asigurat.pensionar, asigurat.nrBugetari,
                      @"inmatriculat", // tip inregistrare
                      asigurat.codCaen, masina.categorieAuto, masina.subcategorieAuto, masina.inLeasing, masina.firmaLeasing,
                      masina.serieCiv, masina.marcaAuto, masina.modelAuto, masina.nrInmatriculare, masina.serieSasiu, masina.cascoLa,
                      @"nu", // auto nou
                      masina.cm3, masina.putere, masina.combustibil, masina.nrLocuri, masina.masaMaxima, masina.anFabricatie, masina.destinatieAuto,
                      masina.culoare, masina.nrKm,
                      [[UIDevice currentDevice] uniqueIdentifier], masina.idIntern,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    return xml;
}

- (IBAction) callInregistrareComanda {
    
    // Daca masina nu are proprietar SAU
    // Proprietarul masinii este diferit de asigurat, modificam
    if (![masina.idProprietar isEqualToString:asigurat.idIntern] || masina.idProprietar.length == 0)
    {
        masina.idProprietar = asigurat.idIntern;
        [masina updateAutovehicul];
    }
    
    [self doneEditing];
    [self showCustomLoading];
    self.navigationItem.hidesBackButton = YES;
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@casco.asmx", LinkAPI]];
    
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:30.0];
    
	NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
	NSLog(@"Request=%@", parameters);
	NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
	
	[request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"http://tempuri.org/RequestCasco" forHTTPHeaderField:@"SOAPAction"];
	[request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
	
	NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	if (connection) {
		self.responseData = [NSMutableData data];
	}
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
    self.navigationItem.hidesBackButton = NO;
    [self hideCustomLoading];

	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
    if (succes) {
        [self showCustomAlert:@"Cerere CASCO" withDescription:responseMessage withError:NO withButtonIndex:1];
	}
	else
    {
        [self showCustomAlert:@"Cerere CASCO" withDescription:@"Cererea NU a fost transmisa." withError:YES withButtonIndex:4];
	}
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    [self hideCustomLoading];
    [self showCustomAlert:@"Atentie" withDescription:[error localizedDescription] withError:YES withButtonIndex:4];
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"RequestCascoResult"]) {
		responseMessage = [NSString stringWithString:currentElementValue];
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
    [self hideCustomLoading];
    [btnClosePopup setHidden:YES];
    [loading setHidden:NO];
    [lblLoading setHidden:NO];
    [imgLoading setImage:[UIImage imageNamed:@"popup-generic.png"]];
    [vwLoading setHidden:NO];
}

- (IBAction) hideCustomLoading
{
    [vwLoading setHidden:YES];
    if (idOferta && ![idOferta isEqualToString:@""])
        [self showPopupDupaComanda];
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    if (error)
        imgError.image = [UIImage imageNamed:@"comanda-eroare.png"];
    else
        imgError.image = [UIImage imageNamed:@"informatii-trimise.png"];
    
    btnCustomAlertOK.tag = index;
    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (IBAction) hideCustomAlert:(id)sender;
{
    UIButton * btn = (UIButton *)sender;
    [vwCustomAlert setHidden:YES];
    if (btn.tag == 1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else if (btn.tag == 11)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else if (btn.tag == 100)
        [self callInregistrareComanda];
    
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index
{
    imgError.image = [UIImage imageNamed:@"comanda-confirmare-date.png"];
    btnCustomAlertOK.tag = index;
    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:@"DA"];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (void) showPopupDupaComanda
{
    [vwLoading setHidden:NO];
    [loading setHidden:YES];
    [lblLoading setHidden:YES];
    [btnClosePopup setHidden:NO];
    btnClosePopup.tag = 11;
    [imgLoading setImage:[UIImage imageNamed:@"popup-dupa-comanda.png"]];
}


@end
