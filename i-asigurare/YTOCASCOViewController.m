//
//  YTOCASCOViewController.m
//  i-asigurare
//
//  Created by Administrator on 10/8/12.
//
//

#import "YTOCASCOViewController.h"
#import "YTOUtils.h"

@interface YTOCASCOViewController ()

@end

@implementation YTOCASCOViewController
@synthesize listaCompaniiAsigurare;
@synthesize _nomenclatorNrItems, _nomenclatorSelIndex, _nomenclatorTip;

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
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return 69;
    else if (indexPath.row == 1 || indexPath.row == 2)
        return 75;
    else if (indexPath.row == 4)
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
    else if (indexPath.row == 4) cell = cellAsigurareCasco;
    else cell = cellCalculeaza;
    
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma TEXTFIELD

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    if (indexPath.row == 3)
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
    [(UILabel *)[cellNrKm viewWithTag:1] setText:@"Numar kilometri autovehicul"];
    [(UITextField *)[cellNrKm viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellNrKm];
    
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
    asigurat = a;

    if (asigurat.idIntern.length > 0 && ![asigurat.idIntern isEqualToString:masina.idProprietar])
    {
        YTOAutovehicul * _auto = [YTOAutovehicul getAutovehiculByProprietar:a.idIntern];
        
        if (_auto && _auto.idIntern && [_auto isValidForRCA])
            [self setAutovehicul:_auto];
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
    if (masina.idProprietar.length > 0 && ![masina.idProprietar isEqualToString:asigurat.idIntern])
    {
        YTOPersoana * prop = [YTOPersoana getPersoana:masina.idProprietar];
        if (prop)
            [self setAsigurat:prop];
    }
    if (masina.nrKm > 0)
        [self setNumarKm:masina.nrKm];
}

- (void)setNumarKm:(int)v
{
    UITextField * txt = (UITextField *)[cellNrKm viewWithTag:2];
    txt.text = [NSString stringWithFormat:@"%d",v];
    masina.nrKm = v;
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
    BOOL checkboxSelected = btn.selected;
    checkboxSelected = !checkboxSelected;
    
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
    [vwNomenclator setHidden:NO];
    UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    NSMutableArray * listOfItems;
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = 0;
    if (_nomenclatorTip == kCompaniiAsigurare)
    {
        listaCompaniiAsigurare = [YTOUtils GETCompaniiAsigurare];
        [lblTitle setText:@"Alege compania unde ai CASCO"];
        listOfItems = listaCompaniiAsigurare;
        _nomenclatorNrItems = listaCompaniiAsigurare.count;
// to do        selectedItemIndex = [YTOUtils getKeyList:listaCompaniiAsigurare forValue: masina.];
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

@end
