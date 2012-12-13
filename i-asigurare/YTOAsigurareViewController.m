//
//  YTOAsigurareViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/7/12.
//
//

#import "YTOAsigurareViewController.h"
#import "YTOAppDelegate.h"
#import "KeyValueItem.h"

@interface YTOAsigurareViewController ()

@end

@implementation YTOAsigurareViewController

@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip, listaCompanii;
@synthesize asigurare;
@synthesize masina, locuinta;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Asigurare", @"Asigurare");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initCells];
    
    shouldSave = YES;
    goingBack = YES;
    
    if (asigurare)
    {
        ((UIImageView *) [cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"text-header-asigurare-salvata.png"];
        [self setMoneda:asigurare.moneda];
        [self setCompanie:asigurare.companie];
        [self setPrima:asigurare.prima];
        [self setNumeAsigurare:asigurare.numeAsigurare];
        [self setTipAsigurare:asigurare.tipAsigurare];
    }
    else
    {
        ((UIImageView *) [cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"text-header-asigurare-noua.png"];
        asigurare = [[YTOOferta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        [self setMoneda:@"eur"];
        [self setTipAsigurare:1];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self doneEditing];
    
    if (goingBack)
    {
        if (shouldSave)
            [self save];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 78;
    else if (indexPath.row == 2)
        return 75;
    else if (indexPath.row == 1 || indexPath.row == 4)
        return 100;
    else return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (asigurare.tipAsigurare == 2 || asigurare.tipAsigurare == 3)
        return 8;
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellProdusAsigurare;
    else if (indexPath.row == 2) cell = (asigurare.tipAsigurare == 3 ? cellLocuinta : cellMasina);
    else if (indexPath.row == 3) cell = cellNumeAsigurare;
    else if (indexPath.row == 4) cell = cellCompanieAsigurare;
    else
    {
        if (asigurare.tipAsigurare == 2 || asigurare.tipAsigurare == 3)
        {
            if (indexPath.row == 5)
                cell = cellMoneda;
            else if (indexPath.row == 6)
                cell = cellPrima;
            else
                cell = cellSC;
        }
        else
        {
            if (indexPath.row == 5)
                cell = cellPrima;
            else
                cell = cellSC;
        }
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2)
    {
        [self doneEditing];
        
        YTOAppDelegate * appDelegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        
        if (asigurare.tipAsigurare == 3)
        {
            goingBack = NO;
            
            // Daca exista locuinte salvate, afisam lista
            if ([appDelegate Locuinte].count > 0)
            {
                YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
                aView.controller = self;
                [appDelegate.setariNavigationController pushViewController:aView animated:YES];
            }
            else {
                YTOCasaViewController * aView = [[YTOCasaViewController alloc] init];
                aView.controller = self;
                [appDelegate.setariNavigationController pushViewController:aView animated:YES];
            }
        }
        else
        {
            goingBack = NO;
            
            // Daca exista masini salvate, afisam lista
            if ([appDelegate Masini].count > 0)
            {
                YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
                aView.controller = self;
                [appDelegate.setariNavigationController pushViewController:aView animated:YES];
            }
            else {
                YTOAutovehiculViewController * aView = [[YTOAutovehiculViewController alloc] init];
                aView.controller = self;
                [appDelegate.setariNavigationController pushViewController:aView animated:YES];
            }
        }
    }
}

- (void) save
{
    if (asigurare.obiecteAsigurate.count == 0 && asigurare.prima == 0)
    {
        // nu salvam
    }
    else
    {
        
        if (asigurare._isDirty)
        {
            [asigurare updateOferta];
        }
        else {
            [asigurare addOferta];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) btnSave_Clicked
{
    [self doneEditing];
    
    [self save];
    
    // Am salvat o data, nu mai salvam pe viewWillDissapear
    shouldSave = YES;
}

- (void) btnCancel_Clicked
{
    shouldSave = NO;
    
    // In cazul in care a modificat ceva si a apasat pe Cancel,
    // incarcam lista cu masini din baza de date
    //YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    //[delegate refreshMasini];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) initCells
{
    NSArray *topLevelObjectsHeader = [[NSBundle mainBundle] loadNibNamed:@"CellLocuintaHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsHeader objectAtIndex:0];
    ((UIImageView *) [cellHeader viewWithTag:1]).image = [UIImage imageNamed:@"text-header-asigurare-salvata.png"];
    //[YTOUtils setCellFormularStyle:cellHeader];
    
    NSArray *topLevelObjectsNume = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellNumeAsigurare = [topLevelObjectsNume objectAtIndex:0];
    [(UILabel *)[cellNumeAsigurare viewWithTag:1] setText:@"Descriere asigurare"];
    [YTOUtils setCellFormularStyle:cellNumeAsigurare];
    ((UITextField *)[cellNumeAsigurare viewWithTag:2]).font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];

    NSArray *topLevelObjectsMoneda = [[NSBundle mainBundle] loadNibNamed:@"CellView_DaNu" owner:self options:nil];
    cellMoneda = [topLevelObjectsMoneda objectAtIndex:0];
    [(UILabel *)[cellMoneda viewWithTag:6] setText:@"MONEDA"];
    //[YTOUtils setCellFormularStyle:cellMoneda];
    UIButton * btnMonedaLei = (UIButton *)[cellMoneda viewWithTag:1];
    [btnMonedaLei addTarget:self action:@selector(btnMoneda_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btnMonedaEur = (UIButton *)[cellMoneda viewWithTag:2];
    [btnMonedaEur addTarget:self action:@selector(btnMoneda_Clicked:) forControlEvents:UIControlEventTouchUpInside];
    ((UILabel *)[cellMoneda viewWithTag:3]).text = @"LEI";
    ((UILabel *)[cellMoneda viewWithTag:4]).text = @"EUR";
    
    NSArray *topLevelObjectsPrima = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellPrima = [topLevelObjectsPrima objectAtIndex:0];
    [(UILabel *)[cellPrima viewWithTag:1] setText:@"Prima asigurare"];
    [(UITextField *)[cellPrima viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellPrima];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellMasina = [topLevelObjectsMarca objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = @"Alege masina";
    
    NSArray *topLevelObjectsLocuinta = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellLocuinta = [topLevelObjectsLocuinta objectAtIndex:0];
    UILabel * lblCellLoc = (UILabel *)[cellLocuinta viewWithTag:2];
    lblCellLoc.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellLoc.text = @"Alege locuinta";
    UIImageView * img2 = (UIImageView *)[cellLocuinta viewWithTag:4];
    img2.image = [UIImage imageNamed:@"icon-foto-casa.png"];
    UIImageView * bg = (UIImageView *)[cellLocuinta viewWithTag:5];
    bg.image = [UIImage imageNamed:@"alege-persoana-locuinta.png"];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma CELL MONEDA
- (void) btnMoneda_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL moneda = btn.tag == 1;
    
    
    [self setMoneda:moneda ? @"lei" : @"eur"];
    
  //  [tableView reloadData];
}

- (void) setMoneda:(NSString *)v
{

    UILabel *lblLei = (UILabel *)[cellMoneda viewWithTag:3];
    UILabel *lblEur = (UILabel *)[cellMoneda viewWithTag:4];
    UIImageView * img = (UIImageView *)[cellMoneda viewWithTag:5];
    
    if ([v isEqualToString:@"eur"])
    {
        img.image = [UIImage imageNamed:@"da-nu-nu-rca.png"];
        lblLei.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblEur.textColor = [UIColor whiteColor];
        asigurare.moneda = @"eur";
    }
    else if ([v isEqualToString:@"lei"])
    {
        img.image = [UIImage imageNamed:@"da-nu-da-rca.png"];
        lblEur.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblLei.textColor = [UIColor whiteColor];
        asigurare.moneda = @"lei";
    }
    
    if (asigurare.prima > 0)
        [self setPrima:asigurare.prima];
}

- (void) setCompanie:(NSString*)v;
{
    ((UIButton *)[cellCompanieAsigurare   viewWithTag:1]).selected = ((UIButton *)[cellCompanieAsigurare viewWithTag:2]).selected =
    ((UIButton *)[cellCompanieAsigurare viewWithTag:3]).selected = ((UIButton *)[cellCompanieAsigurare viewWithTag:4]).selected = NO;
    
    // Daca compania nu este deja selectata, o selectam
    // altfel o deselectam
    if (![v isEqualToString:@""])
    {
        // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
        if ([v isEqualToString:@"Allianz"])
            ((UIButton *)[cellCompanieAsigurare viewWithTag:1]).selected = YES;
        else if ([v isEqualToString:@"Omniasig"])
            ((UIButton *)[cellCompanieAsigurare viewWithTag:2]).selected = YES;
        else if ([v isEqualToString:@"Generali"]) {
            ((UILabel *)[cellCompanieAsigurare viewWithTag:33]).text = v;
            ((UIButton *)[cellCompanieAsigurare viewWithTag:3]).selected = YES;
        }
        else if (v.length > 0) {
            ((UILabel *)[cellCompanieAsigurare viewWithTag:33]).text = v;
            ((UIButton *)[cellCompanieAsigurare viewWithTag:3]).selected = YES;
        }
        asigurare.companie = v;
    }
    else
        asigurare.companie = @"";
}

- (void) setTipAsigurare:(int)v
{
    ((UIButton *)[cellProdusAsigurare viewWithTag:1]).selected = ((UIButton *)[cellProdusAsigurare viewWithTag:2]).selected =
    ((UIButton *)[cellProdusAsigurare viewWithTag:3]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if (v == 1)
    {
        ((UIButton *)[cellProdusAsigurare viewWithTag:1]).selected = YES;
        asigurare.numeAsigurare = @"Asigurare RCA";
    }
    else if (v == 2)
    {
        ((UIButton *)[cellProdusAsigurare viewWithTag:2]).selected = YES;
        asigurare.numeAsigurare = @"Asigurare CASCO";
    }
    else if (v == 3) {
        ((UILabel *)[cellProdusAsigurare viewWithTag:33]).text = @"Locuinta";
        ((UIButton *)[cellProdusAsigurare viewWithTag:3]).selected = YES;
        asigurare.numeAsigurare = @"Asigurare Locuinta";
    }
    
    asigurare.tipAsigurare = v;
    [tableView reloadData];
}
- (IBAction) btnTipAsigurare_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;

    [self setTipAsigurare:btn.tag];
}

- (void) setNumeAsigurare:(NSString *)v
{
    asigurare.numeAsigurare = v;
    UITextField * txt = (UITextField *)[cellNumeAsigurare viewWithTag:2];
    txt.text = v;
}

- (void) setPrima:(float)v
{
    asigurare.prima = v;
    UITextField * txt = (UITextField *)[cellPrima viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%.2f %@", v, ([asigurare.moneda isEqualToString:@""] ? @"LEI" : [asigurare.moneda uppercaseString])];
}

#pragma TEXTFIELD

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    //UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    //NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    //if (indexPath.row == 3 || indexPath.row == 5)
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
        [self setNumeAsigurare:textField.text];
    else if (indexPath.row == 5 || indexPath.row == 6)
        [self setPrima:[textField.text intValue]];
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

#pragma vwNomenclator

- (IBAction)checkboxCompanieCascoSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    if (checkboxSelected == NO)
    {
        [self setCompanie:@""];
        btn.selected = checkboxSelected;
    }
    else if (btn.tag  == 1) {
        [self setCompanie:@"Allianz"];
    }
    else if (btn.tag == 2)
    {
        [self setCompanie:@"Omniasig"];
    }
    else if (btn.tag == 3) {
        if ([((UILabel *)[cellCompanieAsigurare viewWithTag:33]).text isEqualToString:@"Generali"])
            [self setCompanie:@"Generali"];
        else
            [self setCompanie:((UILabel *)[cellCompanieAsigurare viewWithTag:33]).text];
    }
    else {
        _nomenclatorTip = kCompaniiAsigurare;
        [self showNomenclator];
    }
}

- (void) showNomenclator
{
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
        listaCompanii = [YTOUtils GETCompaniiAsigurare];
        [lblTitle setText:@"Alege compania de asigurare"];
        listOfItems = listaCompanii;
        _nomenclatorNrItems = listaCompanii.count;
        
        if (asigurare.companie.length > 0)
            selectedItemIndex = [YTOUtils getKeyList:listaCompanii forValue: asigurare.companie];
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
        [button setImage:[UIImage imageNamed:@"selectat-rca.png"] forState:UIControlStateSelected];
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
    [vwNomenclator setHidden:YES];
}

- (IBAction) btnNomenclator_Clicked:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    
    [btn setSelected:checkboxSelected];
    
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    for (int i=100; i<=100+_nomenclatorNrItems; i++) {
        
        UIButton * _btn = (UIButton *)[scrollView viewWithTag:i];
        if (btn.tag != i)
            [_btn setSelected:NO];
    }
    
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        if (checkboxSelected == NO)
            [self setCompanie:@""];
        else
        {
            KeyValueItem * item = (KeyValueItem *)[listaCompanii objectAtIndex:btn.tag-100];
            [self setCompanie:item.value];
        }
    }
}

- (void)setAutovehicul:(YTOAutovehicul *)a
{
    //[btnMasina.titleLabel setText:a.marcaAuto];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (a.marcaAuto.length > 0)
    {
        lblCell.text = a.marcaAuto;
        ((UILabel *)[cellMasina viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", a.modelAuto, a.nrInmatriculare];
    }
    masina = a;
    asigurare.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:masina.idIntern, nil];
    goingBack = YES;
}

- (void) setLocuinta:(YTOLocuinta *) a
{
    UILabel * lblCellP = ((UILabel *)[cellLocuinta viewWithTag:2]);
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = a.tipLocuinta;
    ((UILabel *)[cellLocuinta viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@, %d mp", a.judet, a.localitate, a.suprafataUtila];
    locuinta = a;
    asigurare.obiecteAsigurate = [[NSMutableArray alloc] initWithObjects:locuinta.idIntern, nil];
    goingBack = YES;
}

@end
