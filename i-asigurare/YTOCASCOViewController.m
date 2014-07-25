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
#import "YTOReduceriViewController.h"
#import "YTOUserDefaults.h"


#import "VerifyNet.h"

//////////

@interface YTOCASCOViewController ()

@end

@implementation YTOCASCOViewController
@synthesize listaCompaniiAsigurare;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;
@synthesize responseData;
@synthesize isWrongAuto;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedStringFromTable(@"i351", [YTOUserDefaults getLanguage],@"CASCO");
        self.tabBarItem.image = [UIImage imageNamed:@"menu-asigurari.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.trackedViewName = @"YTOCASCOViewController";
    lblAlegeCasco.text = NSLocalizedStringFromTable(@"i152", [YTOUserDefaults getLanguage],@"Daca masina are CASCO selecteaza compania");
    lblInfoReduceri.text = NSLocalizedStringFromTable(@"i156", [YTOUserDefaults getLanguage],@"Informatii pentru REDUCERI");
    lblCumPlatesti.text = NSLocalizedStringFromTable(@"i161", [YTOUserDefaults getLanguage],@"Alege cum vrei sa platesti");
    lbl2Rate.text = NSLocalizedStringFromTable(@"i164", [YTOUserDefaults getLanguage],@"2 Rate");
    lbl4Rate.text = NSLocalizedStringFromTable(@"i165", [YTOUserDefaults getLanguage],@"4 Rate");
    lblIntegral.text = NSLocalizedStringFromTable(@"i163", [YTOUserDefaults getLanguage],@"Integral");
   
    lblMultumim1.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblMultumim2.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblMultumim3.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblMultumim4.text = NSLocalizedStringFromTable(@"i798", [YTOUserDefaults getLanguage],@"Iti multumim pentru intelegere");
    lblSorry1.text = NSLocalizedStringFromTable(@"i806", [YTOUserDefaults getLanguage],@":( ne pare rau");
    lblSorry2.text = NSLocalizedStringFromTable(@"i806", [YTOUserDefaults getLanguage],@":( ne pare rau");
    lblDetaliiErr1.text = NSLocalizedStringFromTable(@"i819", [YTOUserDefaults getLanguage],@"detalii eroare");
    lblImportant.text = NSLocalizedStringFromTable(@"i802", [YTOUserDefaults getLanguage],@"Important");
    lblEroare.text = NSLocalizedStringFromTable(@"i799", [YTOUserDefaults getLanguage],@"Eroare !");
    lblComandaOK1.text = NSLocalizedStringFromTable(@"i809", [YTOUserDefaults getLanguage],@"Comanda a fost inregistrata");
    lblDateIncomplete.text = NSLocalizedStringFromTable(@"i797", [YTOUserDefaults getLanguage],@"Date incomplete");
    
    lblMultumim1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblMultumim2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblMultumim3.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblMultumim4.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblSorry1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblSorry2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblDetaliiErr1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblImportant.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    lblEroare.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    lblComandaOK1.textColor = [YTOUtils colorFromHexString:verde];
    lblDateIncomplete.textColor = [YTOUtils colorFromHexString:rosuTermeni];
    
    
    // Do any additional setup after loading the view from its nib.
    
    if (masina.nrKm > 0)
        [self setNumarKm:masina.nrKm];
    
    if (masina.culoare && ![masina.culoare isEqualToString:@""])
        [self setCuloare:masina.culoare];
    
    if (masina.cascoLa && ![masina.cascoLa isEqualToString:@""])
        [self setCompanieCasco:masina.cascoLa];
    
    [self setNrRate:@"Integral"];
    
    [self initCells];
    [self initCustomValues];
    [YTOUtils rightImageVodafone:self.navigationItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated
{
    isWrongAuto = NO;
    if ([asigurat.tipPersoana isEqualToString:@"fizica"])
    {
            UILabel *lbl = (UILabel *)[cellPF viewWithTag:1];
            lbl.text = [self setTextInLabel :asigurat];
    }
}

- (NSString *) setTextInLabel:(YTOPersoana *) asiguratPers
{
    NSString *txt = [[NSString alloc] init];
    if (asigurat.nrBugetari.intValue > 0 )
    {
        NSString *str = NSLocalizedStringFromTable(@"i578", [YTOUserDefaults getLanguage],@"Casatorit");
        txt = [NSString stringWithFormat:@"%@%@%@%@",txt,asigurat.nrBugetari,str,@" | "];
    }
    if ([asigurat.casatorit isEqualToString:@"da"])
    {
        NSString *str = NSLocalizedStringFromTable(@"i576", [YTOUserDefaults getLanguage],@"Casatorit");
        txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
    }
    if ([asigurat.pensionar isEqualToString:@"da"])
    {
        NSString *str = NSLocalizedStringFromTable(@"i577", [YTOUserDefaults getLanguage],@"Pensionar");
        txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
    }
    if ([asigurat.copiiMinori isEqualToString:@"da"])
    {
        NSString *str = NSLocalizedStringFromTable(@"i574", [YTOUserDefaults getLanguage],@"Copii\nminori");
        txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
    }
    if ([asigurat.handicapLocomotor isEqualToString:@"da"])
    {
        NSString *str = NSLocalizedStringFromTable(@"i575", [YTOUserDefaults getLanguage],@"Handicap\nlocomotor");
        txt  = [NSString stringWithFormat:@"%@%@%@",txt,str,@" | "];
    }
    if ([txt isEqualToString:@""]) txt = NSLocalizedStringFromTable(@"i157", [YTOUserDefaults getLanguage],@"alege din lista");
    return txt;
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 75;
    else if (indexPath.row == 7 || indexPath.row == 6)
        return 100;
    else if (indexPath.row == 5)
        if ([asigurat.tipPersoana isEqualToString:@"fizica"])
            return 66;
        else return 0;
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
    else if (indexPath.row == 5)
    {
        if ([asigurat.tipPersoana isEqualToString:@"fizica"])
        {
            cell = cellPF;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    else cell =  [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    }
    else if (indexPath.row == 6) cell = cellAsigurareCasco;
    else if (indexPath.row == 7) cell = cellNrRate;
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
        if ((isWrongAuto && masina==nil) || !isWrongAuto)
        {
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
        }else if (isWrongAuto && masina !=nil){
            YTOAutovehiculViewController * aView;
            if (IS_IPHONE_5)
                aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController_R4" bundle:nil];
            else aView = [[YTOAutovehiculViewController alloc] initWithNibName:@"YTOAutovehiculViewController" bundle:nil];
            aView.controller = self;
            aView.autovehicul = masina;
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
            if (IS_IPHONE_5)
                aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController-R4" bundle:nil];
            else aView = [[YTOAsiguratViewController alloc] initWithNibName:@"YTOAsiguratViewController" bundle:nil];
            aView.controller = self;
            aView.proprietar = YES;
            [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
        }
        
    }
    else if (indexPath.row == 5)
    {
        YTOReduceriViewController *aView ;
        if (IS_IPHONE_5)
            aView = [[YTOReduceriViewController alloc] initWithNibName:@"YTOReduceriViewController_R4" bundle:nil];
        else aView = [[YTOReduceriViewController alloc] initWithNibName:@"YTOReduceriViewController" bundle:nil];
        aView.asigurat = asigurat;
        [appDelegate.rcaNavigationController pushViewController:aView animated:YES];
    }
    else if (indexPath.row == 8)
    {
        BOOL isOk = NO;
        YTOPersoana * proprietar = [YTOPersoana Proprietar];
        YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
        
        if (proprietar.telefon && proprietar.telefon.length > 0)
            isOk = YES;
        if (proprietarPJ.telefon && proprietarPJ.telefon.length > 0)
            isOk = YES;
            
        if (!isOk)
        {
            [self showDateleMele:NSLocalizedStringFromTable(@"i125", [YTOUserDefaults getLanguage],@"Te rugam sa completezi campurile goale si/sau sa corectezi informatiile gresite")];
            return;
        }
        
        [activeTextField resignFirstResponder];
        
        // Daca nu a fost selectata masina sau datele masinii nu sunt complete
        if (!masina || ![masina isValidForRCA])
        {
            UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
            lblCell.textColor = [UIColor redColor];
            //isOK = NO;
            isWrongAuto = YES;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else if (masina.anFabricatie+10 < [YTOUtils getAnCurent])
        {
            [self showCustomAlert:@"" withDescription:@"Din pacate, nicio companie de asigurare nu ofera CASCO pentru masini mai vechi de 10 ani.De aceea masina ta nu poate fi asigurata CASCO." withError:YES withButtonIndex:2];//text masina mai veche de 10 ani
            return;
        }
        else if ([masina.subcategorieAuto isEqualToString:@"Motocicleta"])
        {
            [self showCustomAlert:@"  " withDescription:@"Nu putem obtine/solicita oferte CASCO deoarece companiile nu preiau in asigurare motociclete." withError:YES withButtonIndex:2];//motocicleta
            return;
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
            //isOK = NO;
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [tv scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionTop
                              animated:YES];
            return;
        }
        else {
            UILabel * lblCell = (UILabel *)[cellProprietar viewWithTag:2];
            lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        }
        
        //if (!isOK)
        //return;
        
        //        masina.idProprietar  = asigurat.idIntern;
        //        [masina updateAutovehicul];
        //        [asigurat updatePersoana];
        
        
        [self doneEditing];
        
        if (!masina.nrKm && !isOK)
        {
            [txtNumarKm becomeFirstResponder];
            return;
        }
        if (masina.culoare.length == 0)
        {
            [txtCuloare becomeFirstResponder];
            return;
        }
        
        [self showMessage];
        //[self showCustomConfirm:@"Confirmare date" withDescription:@"" withButtonIndex:100];
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

//- (BOOL) textFieldShouldReturn:(UITextField *)textField
//{
//	if(activeTextField == textField)
//	{
//        [self textFieldDidEndEditing:activeTextField];
//		activeTextField = nil;
//	}
//
////	[textField resignFirstResponder];
////	[self deleteBarButton];
////    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
////	return YES;
//
//    [[self.view viewWithTag:textField.tag+1] becomeFirstResponder];
//    return YES;
//}

-(BOOL)textFieldShouldReturn:(UITextField*)textField;
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    int index1 = 0;
    if (indexPath != nil)
        index1 = indexPath.row;
    else
        index1 = textField.tag;

    if (index1 == 3)
        [self setNumarKm:[textField.text intValue]];
    else
        [self setCuloare:textField.text];
     tableView.tableFooterView = nil;
    
//    NSString *txt = textField.text;
//    if (activeTextField == txtNumarKm)
//        [self setNumarKm:[textField.text intValue]];
//    else if (activeTextField == txtCuloare)
//        [self setCuloare:textField.text];
    
    [self deleteBarButton];
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

#pragma Methods

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:0];
    if ([[YTOUserDefaults getLanguage] isEqualToString:@"hu"])
        img.image = [UIImage imageNamed:@"asig-casco-hu.png"];
    else if ([[YTOUserDefaults getLanguage] isEqualToString:@"en"])
        img.image = [UIImage imageNamed:@"asig-casco-en.png"];
    else img.image = [UIImage imageNamed:@"asig-casco.png"];
    UILabel * lblView1 = (UILabel *) [cellHeader viewWithTag:11];
    UILabel * lblView2 = (UILabel *) [cellHeader viewWithTag:22];
    lblView1.backgroundColor = [YTOUtils colorFromHexString:portocaliuCasco];
    lblView2.backgroundColor = [YTOUtils colorFromHexString:portocaliuCasco];
    
    UILabel *lbl1 = (UILabel *) [cellHeader viewWithTag:1];
    UILabel *lbl2 = (UILabel *) [cellHeader viewWithTag:2];
    UILabel *lbl3 = (UILabel *) [cellHeader viewWithTag:3];
    lbl1.textColor = [YTOUtils colorFromHexString:portocaliuCasco];
    
    lbl1.text = NSLocalizedStringFromTable(@"i770", [YTOUserDefaults getLanguage],@"Asigurare CASCO");
    lbl2.text = NSLocalizedStringFromTable(@"i771", [YTOUserDefaults getLanguage],@"● Tarife direct de la companii");
    lbl3.text = NSLocalizedStringFromTable(@"i772", [YTOUserDefaults getLanguage],@"● Oferte personalizate");
    cellHeader.userInteractionEnabled = NO;
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellMasina = [topLevelObjectsMarca objectAtIndex:0];
    UILabel * lblCell = (UILabel *)[cellMasina viewWithTag:2];
    UIImageView * imgBgAuto = (UIImageView *)[cellMasina viewWithTag:5];
    imgBgAuto.image =[UIImage imageNamed:@"alege-masina-portocaliu.png"];
    
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = NSLocalizedStringFromTable(@"i147", [YTOUserDefaults getLanguage],@"Alege autovehicul");
    UILabel * lblCell1 = (UILabel *)[cellMasina viewWithTag:6];
    lblCell1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell1.text = NSLocalizedStringFromTable(@"i158", [YTOUserDefaults getLanguage],@"AUTOVEHICUL ASIGURAT");;
    
    NSArray *topLevelObjectsProprietar = [[NSBundle mainBundle] loadNibNamed:@"CellPersoana" owner:self options:nil];
    cellProprietar = [topLevelObjectsProprietar objectAtIndex:0];
    UIImageView * imgBgProprietar = (UIImageView *)[cellProprietar viewWithTag:5];
    imgBgProprietar.image =[UIImage imageNamed:@"alege-masina-portocaliu.png"];
    UILabel * lblCellP = (UILabel *)[cellProprietar viewWithTag:2];
    lblCellP.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellP.text = NSLocalizedStringFromTable(@"i148", [YTOUserDefaults getLanguage],@"Alege Persoana");
    UILabel * lblCell2 = (UILabel *)[cellProprietar viewWithTag:6];
    lblCell2.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell2.text = NSLocalizedStringFromTable(@"i149", [YTOUserDefaults getLanguage],@"PROPRIETAR AUTOVEHICUL (VEZI TALON)");
    
    NSArray *topLevelObjectsnrKm = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellNrKm = [topLevelObjectsnrKm objectAtIndex:0];
    txtNumarKm = (UITextField *)[cellNrKm viewWithTag:2];
    [(UILabel *)[cellNrKm viewWithTag:1] setText:NSLocalizedStringFromTable(@"i150", [YTOUserDefaults getLanguage],@"Numar kilometri autovehicul")];
    [(UITextField *)[cellNrKm viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellNrKm];
    
    NSArray *topLevelObjectsCuloare = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellCuloare = [topLevelObjectsCuloare objectAtIndex:0];
    txtCuloare = (UITextField *)[cellCuloare viewWithTag:2];
    [(UILabel *)[cellCuloare viewWithTag:1] setText:NSLocalizedStringFromTable(@"i151", [YTOUserDefaults getLanguage],@"Culoare autovehicul")];
    [YTOUtils setCellFormularStyle:cellCuloare];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgBgCalculeaza = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgBgCalculeaza.image =[UIImage imageNamed:@"calculeaza-casco.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCellC.text = NSLocalizedStringFromTable(@"i53", [YTOUserDefaults getLanguage],@"Cere oferta");
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
        
        if (a.cascoLa && ![a.cascoLa isEqualToString:@""])
            [self setCompanieCasco:a.cascoLa];
    }
    masina = a;
    [self setCompanieCasco:a.cascoLa];
    if (masina.idProprietar.length > 0 && ![masina.idProprietar isEqualToString:asigurat.idIntern] && cautLegaturaDintreMasinaSiAsigurat)
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:masina.idProprietar];
        if (prop)
            [self setAsigurat:prop];
        cautLegaturaDintreMasinaSiAsigurat = NO;
    }
    
    [self setNumarKm:masina.nrKm];
    
    if (masina.culoare && ![masina.culoare isEqualToString:@""])
        [self setCuloare:masina.culoare];
    else
        [self setCuloare:@""];
    
}

- (void)setNumarKm:(int)v
{
    
    UITextField * txt = (UITextField *)[cellNrKm viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d",v];
    masina.nrKm = v;
    if (v == 0) isOK = YES;
    
}

- (void)setCuloare:(NSString *)v
{
    //if (![v isEqualToString:@"0"]) {
    UITextField * txt = (UITextField *)[cellCuloare viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%@",v];
    masina.culoare = v;
    //}
}

- (void)setNrRate:(NSString *)v
{
    ((UIButton *)[cellNrRate viewWithTag:1]).selected = ((UIButton *)[cellNrRate viewWithTag:2]).selected = ((UIButton *)[cellNrRate viewWithTag:3]).selected = NO;
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([v isEqualToString:@"Integral"]) {
        ((UIButton *)[cellNrRate viewWithTag:1]).selected = YES;
        nrRate = 1;
    }
    else if ([v isEqualToString:@"2 Rate"]) {
        ((UIButton *)[cellNrRate viewWithTag:2]).selected = YES;
        nrRate = 2;
    }
    else if ([v isEqualToString:@"4 Rate"]) {
        ((UILabel *)[cellNrRate viewWithTag:33]).text = v;
        ((UIButton *)[cellNrRate viewWithTag:3]).selected = YES;
        nrRate = 4;
    }
}

- (IBAction)checkboxNrRateSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    
    [activeTextField resignFirstResponder];
    
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
    
    // Daca compania nu este deja selectata, o selectam
    // altfel o deselectam
    if (![v isEqualToString:@""])
    {
        if ([v isEqualToString:@"Allianz"])
            ((UIButton *)[cellAsigurareCasco viewWithTag:1]).selected = YES;
        else if ([v isEqualToString:@"Omniasig"])
            ((UIButton *)[cellAsigurareCasco viewWithTag:2]).selected = YES;
        else if ([v isEqualToString:@"Generali"]) {
            ((UILabel *)[cellAsigurareCasco viewWithTag:33]).text = v;
            ((UIButton *)[cellAsigurareCasco viewWithTag:3]).selected = YES;
        }
        else if (v.length > 0) {
            ((UILabel *)[cellAsigurareCasco viewWithTag:33]).text = v;
            ((UIButton *)[cellAsigurareCasco viewWithTag:3]).selected = YES;
        }
        masina.cascoLa = v;
    }
    else
        masina.cascoLa = @"";
}

- (IBAction)checkboxCompanieCascoSelected:(id)sender
{
    [activeTextField resignFirstResponder];
    
    
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
        [lbl setTextAlignment:NSTextAlignmentCenter];
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
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString *telefon , *email;
    if (proprietar.telefon && proprietar.telefon.length > 0)
        telefon = proprietar.telefon;
    else if (proprietarPJ.telefon && proprietarPJ.telefon.length > 0)
        telefon = proprietar.telefon;
    if (proprietar.email && proprietar.email.length > 0)
        email = proprietar.email;
    else if (proprietarPJ.email && proprietarPJ.email.length > 0)
        email = proprietarPJ.email;
    NSString * xml = [[NSString alloc] initWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                      "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                      "<soap:Body>"
                      "<RequestCasco2 xmlns=\"http://tempuri.org/\">"
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
                      "<nr_rate>%d</nr_rate>"
                      "<udid>%@</udid>"
                      "<id_intern>%@</id_intern>"
                      "<platforma>%@</platforma>"
                      "</RequestCasco2>"
                      "</soap:Body>"
                      "</soap:Envelope>",
                      asigurat.tipPersoana, asigurat.nume, asigurat.codUnic, telefon, email,
                      asigurat.adresa, masina.judet, masina.localitate, asigurat.dataPermis, asigurat.casatorit, asigurat.copiiMinori, asigurat.pensionar, asigurat.nrBugetari,
                      @"inmatriculat", // tip inregistrare
                      asigurat.codCaen, masina.categorieAuto, masina.subcategorieAuto, masina.inLeasing, masina.firmaLeasing,
                      masina.serieCiv, masina.marcaAuto, masina.modelAuto, masina.nrInmatriculare, masina.serieSasiu, masina.cascoLa,
                      @"nu", // auto nou
                      masina.cm3, masina.putere, masina.combustibil, masina.nrLocuri, masina.masaMaxima, masina.anFabricatie, masina.destinatieAuto,
                      masina.culoare, masina.nrKm, nrRate,
                      [[UIDevice currentDevice] xUniqueDeviceIdentifier], masina.idIntern,
                      [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
    
    return [xml stringByReplacingOccurrencesOfString:@"'" withString:@""];
}

- (IBAction) callInregistrareComanda {
    
    [activeTextField resignFirstResponder];
    
    // Daca masina nu are proprietar SAU
    // Proprietarul masinii este diferit de asigurat, modificam
    if (![masina.idProprietar isEqualToString:asigurat.idIntern] || masina.idProprietar.length == 0)
    {
        masina.idProprietar = asigurat.idIntern;
        
        [masina updateAutovehicul:NO];
    }
    
    self.navigationItem.hidesBackButton = YES;
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@casco.asmx", LinkAPI]];
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        [self doneEditing];
        [self showCustomLoading];
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequest]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/RequestCasco2" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    
    else {
        
        //vwErrorAlert.hidden = NO;
        //vwCustomAlert.hidden = YES;
        [self showPopup:@"Cerere CASCO"];
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
        if (!SYSTEM_VERSION_LESS_THAN(@"6.0")){
            [btnCustomFacebook setHidden:NO];
            [lblCustomFacebook setHidden:NO];
            [btnCustomTwitter setHidden:NO];
            [lblCustomTwitter setHidden:NO];
        }
	}
	else
    {
        //[self showCustomAlert:@"Cerere CASCO" withDescription:@"Cererea NU a fost transmisa." withError:YES withButtonIndex:4];
        vwErrorAlert.hidden = NO;
        //[self showPopupServiciu:@"Serviciul CASCO nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
        
	}
    
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
	
    [self hideCustomLoading];
    //[self showCustomAlert:@"Atentie" withDescription:[error localizedDescription] withError:YES withButtonIndex:4];
    [self showPopupServiciu:@"Serviciul CASCO nu functioneaza momentan. Te rugam sa revii putin mai tarziu. Intre timp incercam sa remediem aceasta problema."];
    //vwErrorAlert.hidden = NO;
    
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if ([elementName isEqualToString:@"RequestCasco2Result"]) {
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



- (IBAction) hideErrorAlert:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    [vwErrorAlert setHidden:YES];
    [vwCustomAlert setHidden:YES];
    
    if (btn == btnErrorAlertOK) {
        [vwDetailErrorAlert setHidden:NO];
        
    }
    
}

- (IBAction) hideDetailErrorAlert
{
    [vwDetailErrorAlert setHidden:YES];
}

- (void) showPopup:(NSString *)title
{
    [vwPopup setHidden:NO];
    
    lblPopupTitle.text = title;
}

- (IBAction) hidePopup
{
    vwPopup.hidden = YES;
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index1
{
    if (error){
        lblComandaOK1.text = @"ERROARE !";
        lblComandaOK1.textColor = [YTOUtils colorFromHexString:rosuProfil];
    }
    else{
        lblComandaOK1.text = @"Informatii trimise ";
        lblComandaOK1.textColor = [YTOUtils colorFromHexString:verde];
    }
    if (index1 == 2)
    {
        lblComandaOK1.text = @"ne pare rau ";
        lblComandaOK1.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    }
    btnCustomAlertOK.tag = index1;
    //    btnCustomAlertOK.frame = CGRectMake(124, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(150, 249, 42, 21);
    [lblCustomAlertOK setText:@"OK"];
    [btnCustomAlertNO setHidden:YES];
    [lblCustomAlertNO setHidden:YES];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:NO];
}

- (IBAction) hideCustomAlert:(id)sender
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

- (void) showMessage
{
    vwMessage.hidden = NO;
    
}

- (IBAction) hideMessage:(id)sender
{
    vwMessage.hidden = YES;
    UIButton *btn = (UIButton *)sender;
    vwCustomAlert.hidden = YES;
    if (btn == btnMessageOK)
    {
        lblComandaOK1.text = @"Informatii trimise ";
        lblComandaOK1.textColor = [YTOUtils colorFromHexString:verde];
        VerifyNet * vn = [[VerifyNet alloc] init];
        if ([vn hasConnectivity])
            vwCustomAlert.hidden = NO;
        else vwCustomAlert.hidden = YES;
        
        [lblCustomAlertOK setText:@"OK"];
        [btnCustomAlertNO setHidden:YES];
        [lblCustomAlertNO setHidden:YES];
    }
    else {
        vwCustomAlert.hidden = YES;
        
    }
    
}

- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index1
{
    lblComandaOK1.text = @"Datale sunt corecte ? ";
    lblComandaOK1.textColor = [YTOUtils colorFromHexString:verde];
    btnCustomAlertOK.tag = index1;
    //    btnCustomAlertOK.frame = CGRectMake(189, 239, 73, 42);
    //    lblCustomAlertOK.frame = CGRectMake(215, 249, 42, 21);
    [lblCustomAlertOK setText:@"DA"];
    
    [btnCustomAlertNO setHidden:NO];
    [lblCustomAlertNO setHidden:NO];
    
    lblCustomAlertTitle.text = title;
    lblCustomAlertMessage.text = description;
    [vwCustomAlert setHidden:YES];
}

- (void) showPopupDupaComanda
{
    [vwLoading setHidden:NO];
    [loading setHidden:YES];
    [lblLoading setHidden:YES];
    [btnClosePopup setHidden:NO];
    btnClosePopup.tag = 11;
    [iRate sharedInstance].eventCount++;
    [imgLoading setImage:[UIImage imageNamed:@"popup-dupa-comanda.png"]];
}

- (void) showPopupServiciu:description
{
    [vwServiciu setHidden:NO];
    lblServiciuDescription.text = description;
}

- (IBAction) hidePopupServiciu
{
    vwServiciu.hidden = YES;
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void) showDateleMele:description
{
    vwDateleMele.hidden = NO;
    lblDateleMele.text = description;
}

- (IBAction) hideDateleMele
{
    vwDateleMele.hidden = YES;
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
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cerut rapid & usor o oferta CASCO, direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage *sharedImg;
            sharedImg= [UIImage imageNamed:@"socialmedia-ios-casco.png"];
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
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
            
//            if ([YTOUserDefaults IsFirstInsuranceRequest]) {
//                if (output)
//                    [self showPopupDupaComanda];
//                else
//                    [self showPopupDupaComanda];
//            }
//            else
                [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
        
    }
    else {
        
        // analytics - cate tweet-uri s-au dat
        
        //        id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-8624521-11"];
        //        [tracker sendSocial:@"Twitter"
        //                 withAction:@"Tweet"
        //                 withTarget:@"https://developers.google.com/analytics"];
        
        
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Facebook Account is linked
        {
            mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
            mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter]; //Tell him with what social plattform to use it, e.g. facebook or twitter
            NSString *byPlatforma = [[NSString alloc] initWithFormat:@"Smart choice: am cerut rapid & usor o oferta CASCO, direct de pe %@! :) http://bit.ly/WKhiSD",[[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
            [mySLComposerSheet setInitialText:byPlatforma]; //the message you want to post
            UIImage * img;
            UIImage *sharedImg;
            NSString *text;
            img= [UIImage imageNamed:@"socialmedia-ios-casco.png"];
            text = [[NSString alloc] initWithFormat:@""];
            NSString *text2 = [[NSString alloc] initWithFormat:@"" ];
            sharedImg = [YTOUtils  drawText:text
                                    inImage:img
                                    atPoint:CGPointMake(20, 185)
                                  drawText2:text2
                                   atPoint2:CGPointMake(40, 400)];
            
            [mySLComposerSheet addImage:sharedImg]; //an image you could post
            
            
            [self presentViewController:mySLComposerSheet animated:YES completion:nil];
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
            //            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            //            [alert show];
            
//            if ([YTOUserDefaults IsFirstInsuranceRequest]) {
//                if (output)
//                    [self showPopupDupaComanda];
//                else
//                    [self showPopupDupaComanda];
//            }
//            else
                [self.navigationController popToRootViewControllerAnimated:YES];
        }];
        
    }
}


@end
