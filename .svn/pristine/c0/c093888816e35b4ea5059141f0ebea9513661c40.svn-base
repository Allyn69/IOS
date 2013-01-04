//
//  YTOFormAlertaViewController.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/29/12.
//
//

#import "YTOFormAlertaViewController.h"
#import "YTOAlerteViewController.h"
#import "KeyValueItem.h"
#import "YTOUtils.h"
#import "YTOListaAutoViewController.h"
#import "YTOListaLocuinteViewController.h"

@interface YTOFormAlertaViewController ()

@end

@implementation YTOFormAlertaViewController

@synthesize _nomenclatorNrItems, _nomenclatorSelIndex;
@synthesize alerta;
@synthesize controller;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Adauga Alerta", @"Adauga Alerta");
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCells];

    listTipAlerta = [YTOUtils GETTipAlertaList];
    
    if (!alerta)
    {
        alerta = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
        [self setTipAlerta:@"RCA"];
        [self setEsteRata:@"nu"];
    }
    else
    {
        [self loadAlerta];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self doneEditing];
    [self save];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 || indexPath.row == 2)
        return 75;
    if (indexPath.row == 1 || (indexPath.row == 3 && areRata))
        return 100;

    return 60;
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
    if (areRata)
        return 6;
    else return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;

    if (indexPath.row == 0) cell = cellHeader;
    else if (indexPath.row == 1) cell = cellTipAlerta;
    else if (indexPath.row == 2) cell = cellObiectAsigurat;
    else if (indexPath.row == 3) cell = areRata ? cellEsteRata : cellDataAlerta;
    else if (indexPath.row == 4) cell = areRata ? cellDataAlerta : cellSC;
    else cell = cellSC;
    
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
    if (indexPath.row == 2)
    {
        if (alerta.tipAlerta == 6)
        {
            YTOListaLocuinteViewController * aView = [[YTOListaLocuinteViewController alloc] init];
            aView.controller = self;
            [self.navigationController pushViewController:aView animated:YES];
        }
        else
        {
            YTOListaAutoViewController * aView = [[YTOListaAutoViewController alloc] init];
            aView.controller = self;
            [self.navigationController pushViewController:aView animated:YES];
        }
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
   // UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
   // NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	activeTextField = textField;
	
	UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    if ((indexPath.row == 3 && !areRata) || (indexPath.row == 4 && areRata))
    {
        NSString *title = UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation) ? @"\n\n\n\n\n\n\n\n\n" : @"\n\n\n\n\n\n\n\n\n\n\n\n" ;
		UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Selecteaza",nil];
		//[actionSheet showInView:self.view];
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
		
		UIDatePicker *datePicker = [[UIDatePicker alloc] init];
		datePicker.tag = 101;
		datePicker.datePickerMode = 1; // date and time view
		datePicker.minimumDate = [NSDate date];

        //[actionSheet showFromTabBar:self.tabBarController.tabBar];
        //[actionSheet showFromToolbar:self.navigationController.toolbar];
		[actionSheet addSubview:datePicker];
    }
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
//    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
//    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
//    if (indexPath.row == 3)
//        [self setNume:textField.text];
}

#pragma mark Action Sheet Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UIDatePicker *datePickerPermis = (UIDatePicker *)[actionSheet viewWithTag:101];
    if (datePickerPermis) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		formatter.dateFormat = @"dd.MM.yyyy";
		
		NSString *timestamp = [formatter stringFromDate:datePickerPermis.date];
        [self setDataAlerta:timestamp];
	//	[(UITextField *)[self.cellDataPermis viewWithTag:2] setText:timestamp];
	}
    [activeTextField resignFirstResponder];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

#pragma METHODS

- (void) initCells
{
    NSArray *topLevelObjectsProdus = [[NSBundle mainBundle] loadNibNamed:@"CellProdusAsigurareHeader" owner:self options:nil];
    cellHeader = [topLevelObjectsProdus objectAtIndex:0];
    UIImageView * img = (UIImageView *)[cellHeader viewWithTag:1];
    img.image = [UIImage imageNamed:@"header-alerta-noua.png"];
    
    NSArray *topLevelObjectsMarca = [[NSBundle mainBundle] loadNibNamed:@"CellAutovehicul" owner:self options:nil];
    cellObiectAsigurat = [topLevelObjectsMarca objectAtIndex:0];
    UIImageView * imgAlegeOb = (UIImageView *)[cellObiectAsigurat viewWithTag:5];
    imgAlegeOb.image = [UIImage imageNamed:@"alege-albastru-alerte.png"];
    UILabel * lblCell = (UILabel *)[cellObiectAsigurat viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    lblCell.text = @"Alege masina";
    
    NSArray *topLevelObjectsData = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellDataAlerta = [topLevelObjectsData objectAtIndex:0];
    [(UILabel *)[cellDataAlerta viewWithTag:1] setText:@"DATA ALERTA"];
    [(UITextField *)[cellDataAlerta viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellDataAlerta];
    
    NSArray *topLevelObjectsSC = [[NSBundle mainBundle] loadNibNamed:@"CellSalveazaRenunt" owner:self options:nil];
    cellSC = [topLevelObjectsSC objectAtIndex:0];
    UIButton * btnSave = (UIButton *)[cellSC viewWithTag:1];
    UIButton * btnCancel = (UIButton *)[cellSC viewWithTag:2];
    [btnSave addTarget:self action:@selector(btnSave_Clicked) forControlEvents:UIControlEventTouchUpInside];
    [btnCancel addTarget:self action:@selector(btnCancel_Clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void) save
{
    //if (goingBack)
    //{
        if (alerta._isDirty)
        {
            [alerta updateAlerta];
        }
        else {
            //            if (autovehicul.marcaAuto.length > 0 && autovehicul.modelAuto.length > 0 && autovehicul.nrInmatriculare
            //                && autovehicul.judet.length > 0 && autovehicul.localitate.length > 0 && autovehicul.categorieAuto > 0
            //                && autovehicul.subcategorieAuto.length > 0 && autovehicul.serieSasiu.length > 0 && autovehicul.serieCiv.length > 0)
            //            {
            [alerta addAlerta];
            
            //}
        }
        [(YTOAlerteViewController *)controller reloadData];
    //}
}

- (void) btnSave_Clicked
{
    if (activeTextField)
    {
        [activeTextField resignFirstResponder];
    }
    
    [self save];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) btnCancel_Clicked
{
    [self.navigationController popViewControllerAnimated:YES];
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


- (void) loadAlerta
{
    NSString * tipAlerta = [YTOUtils getValueList:listTipAlerta forKey:alerta.tipAlerta];
    [self setTipAlerta:tipAlerta];
    [self setEsteRata:alerta.esteRata];
    [self setDataAlerta:[YTOUtils formatDate:alerta.dataAlerta withFormat:@"dd.MM.yyyy"]];
    if (alerta.idObiect)
    {
        if (alerta.tipAlerta == 6)
        {
            YTOLocuinta * locuinta = [YTOLocuinta getLocuinta:alerta.idObiect];
            [self setLocuinta:locuinta];
        }
        else{
            YTOAutovehicul * masina = [YTOAutovehicul getAutovehicul:alerta.idObiect];
            [self setAutovehicul:masina];
        }
    }
}

- (void) setTipAlerta:(NSString *) v
{
    ((UIButton *)[cellTipAlerta   viewWithTag:1]).selected = ((UIButton *)[cellTipAlerta viewWithTag:2]).selected =
    ((UIButton *)[cellTipAlerta viewWithTag:3]).selected = ((UIButton *)[cellTipAlerta viewWithTag:4]).selected = NO;
    
    
    // daca valoarea selectata se afla printre cele 3 butoane, marchez selectat butonul
    if ([v isEqualToString:@"RCA"])
        ((UIButton *)[cellTipAlerta viewWithTag:1]).selected = YES;
    else if ([v isEqualToString:@"ITP"])
        ((UIButton *)[cellTipAlerta viewWithTag:2]).selected = YES;
    else if ([v isEqualToString:@"Rovinieta"]) {
        ((UILabel *)[cellTipAlerta viewWithTag:33]).text = v;
        ((UIButton *)[cellTipAlerta viewWithTag:3]).selected = YES;
    }
    else if (v.length > 0) {
        ((UILabel *)[cellTipAlerta viewWithTag:33]).text = v;
        ((UIButton *)[cellTipAlerta viewWithTag:3]).selected = YES;
    }

    int tip = [YTOUtils getKeyList:listTipAlerta forValue:v];
    
    // daca se modifica tipul unei alerte
    // resetez campul de selectare obiect (masina, locuinta)
    if (alerta.tipAlerta > 0 && alerta.tipAlerta != tip)
    {
        alerta.idObiect = @"";
        if (tip == 6)
            [self setLocuinta:nil];
        else [self setAutovehicul:nil];
    }
    
    alerta.tipAlerta = tip;
    
    if (alerta.tipAlerta == 7 || alerta.tipAlerta == 8)
        areRata = YES;
    else
        areRata = NO;
    
        
    [self setEsteRata:alerta.esteRata];
    if (alerta.dataAlerta)
        [self setDataAlerta:[YTOUtils formatDate:alerta.dataAlerta withFormat:@"dd.MM.yyyy"]];
    
    [tableView reloadData];
}

- (void) setDataAlerta:(NSString *)v
{
    UITextField * txt = (UITextField *)[cellDataAlerta viewWithTag:2];
    txt.text = v;
    alerta.dataAlerta = [YTOUtils getDateFromString:v withFormat:@"dd.MM.yyyy"];
}

- (void) setEsteRata:(NSString *)v
{
    ((UIButton *)[cellEsteRata   viewWithTag:1]).selected = ((UIButton *)[cellEsteRata viewWithTag:2]).selected = NO;
    
    if ([v isEqualToString:@"nu"])
    {
        ((UIButton *)[cellEsteRata viewWithTag:1]).selected = YES;
        alerta.esteRata = @"nu";
    }
    else if ([v isEqualToString:@"da"])
    {
        ((UIButton *)[cellEsteRata viewWithTag:2]).selected = YES;
        alerta.esteRata = @"da";
    }
}

-(IBAction)checkboxSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    // [btn setSelected:checkboxSelected];
    if (btn.tag  == 1)
        [self setTipAlerta:@"RCA"];
    else if (btn.tag == 2)
        [self setTipAlerta:@"ITP"];
    else if (btn.tag == 3)
        [self setTipAlerta:@"Rovinieta"];
    else {
        [self showNomenclator];
    }
}

- (IBAction)checkboxRataSelected:(id)sender
{
    UIButton * btn = (UIButton *)sender;
    //BOOL checkboxSelected = btn.selected;
    //checkboxSelected = !checkboxSelected;
    // [btn setSelected:checkboxSelected];
    if (btn.tag  == 1)
        [self setEsteRata:@"nu"];
    else if (btn.tag == 2)
        [self setEsteRata:@"da"];
}

- (void) showNomenclator
{
    [vwNomenclator setHidden:NO];
   // UILabel * lblTitle = (UILabel *)[vwNomenclator viewWithTag:1];
    UIScrollView * scrollView = (UIScrollView *)[vwNomenclator viewWithTag:2];
    NSMutableArray * listOfItems;
    _nomenclatorNrItems = 0;
    int rows = 0;
    int cols =0;
    int selectedItemIndex = 0;
    
        listOfItems = listTipAlerta;
        _nomenclatorNrItems = listTipAlerta.count;
    
    selectedItemIndex = alerta.tipAlerta - 1;

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
        [button setImage:[UIImage imageNamed:@"selectat-alerta.png"] forState:UIControlStateSelected];
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
    
    KeyValueItem * item = (KeyValueItem *)[listTipAlerta objectAtIndex:btn.tag-100];
    [self setTipAlerta:item.value];
}

- (void) setAutovehicul:(YTOAutovehicul *)masina
{
    UIImageView * img = (UIImageView *)[cellObiectAsigurat viewWithTag:4];
    img.image = [UIImage imageNamed:@"alege-marca.png"];
    
    UILabel * lblCell = (UILabel *)[cellObiectAsigurat viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (masina && masina.marcaAuto.length > 0)
    {
        lblCell.text = masina.marcaAuto;
        ((UILabel *)[cellObiectAsigurat viewWithTag:3]).text = [NSString stringWithFormat:@"%@, %@", masina.modelAuto, masina.nrInmatriculare];
        alerta.idObiect = masina.idIntern;
    }
    else
    {
        lblCell.text = @"Alege masina";
        ((UILabel *)[cellObiectAsigurat viewWithTag:3]).text = @"";
    }
}

- (void) setLocuinta:(YTOLocuinta *)loc
{
    UIImageView * img = (UIImageView *)[cellObiectAsigurat viewWithTag:4];
    img.image = [UIImage imageNamed:@"icon-foto-casa.png"];
    
    UILabel * lblCell = (UILabel *)[cellObiectAsigurat viewWithTag:2];
    lblCell.textColor = [YTOUtils colorFromHexString:ColorTitlu];
    if (loc && loc.judet.length > 0)
    {
        lblCell.text = [NSString stringWithFormat:@"%@, %@", loc.judet, loc.localitate];
        ((UILabel *)[cellObiectAsigurat viewWithTag:3]).text = [NSString stringWithFormat:@"%d, %d mp2", loc.anConstructie,loc.suprafataUtila];
        alerta.idObiect = loc.idIntern;
    }
    else
    {
        lblCell.text = @"Alege locuinta";
        ((UILabel *)[cellObiectAsigurat viewWithTag:3]).text = @"";
    }
}

@end
