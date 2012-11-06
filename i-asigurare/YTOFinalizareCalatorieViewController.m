//
//  YTOFinalizareCalatorieViewController.m
//  i-asigurare
//
//  Created by Administrator on 10/12/12.
//
//

#import "YTOFinalizareCalatorieViewController.h"
#import "Database.h"

@interface YTOFinalizareCalatorieViewController ()

@end

@implementation YTOFinalizareCalatorieViewController

@synthesize oferta, asigurat, masina;
@synthesize responseData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initCells];

    [self setJudet:asigurat.judet];
    [self setLocalitate:asigurat.localitate];
    [self setAdresa:asigurat.adresa];
    [self setTelefon:asigurat.telefon];
    [self setEmail:asigurat.email];
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
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;
    if (indexPath.row == 0) cell = cellJudetLocalitate;
    else if (indexPath.row == 1) cell = cellAdresa;
    else if (indexPath.row == 2) cell = cellTelefon;
    else if (indexPath.row == 3) cell = cellEmail;
    else cell = cellCalculeaza;
    
    if (indexPath.row % 2 == 0) {
        CGRect frame = CGRectMake(0, 0, 320, 60);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        [self showListaJudete:indexPath];
    }
    else if (indexPath.row == 4)
    {
        [self showCustomConfirm:@"Confirmare date" withDescription:@"Apasa DA pentru a confirma ca datele introduse sunt corecte si pentru a plasa comanda. Daca nu doresti sa continui, apasa NU." withButtonIndex:100];
    }
}

#pragma mark TEXTFIELD
- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
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
    //    UITableViewCell *currentCell = (UITableViewCell *) [[textField superview] superview];
    //    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    //    [self setModel:textField.text];
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
    
    //  [vwKeyboardAddon setHidden:NO];
}
- (void) deleteBarButton {
	self.navigationItem.rightBarButtonItem = nil;
}

#pragma Others
- (void) initCells
{
    NSArray *topLevelObjectsJudet = [[NSBundle mainBundle] loadNibNamed:@"CellView_Nomenclator" owner:self options:nil];
    cellJudetLocalitate = [topLevelObjectsJudet objectAtIndex:0];
    [(UILabel *)[cellJudetLocalitate viewWithTag:1] setText:@"JUDET, LOCALITATE LIVRARE"];
    [YTOUtils setCellFormularStyle:cellJudetLocalitate];
    
    NSArray *topLevelObjectsAdresa = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellAdresa = [topLevelObjectsAdresa objectAtIndex:0];
    [(UILabel *)[cellAdresa viewWithTag:1] setText:@"STRADA, NUMAR, BLOC"];
    [(UITextField *)[cellAdresa viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeAllCharacters];
    [YTOUtils setCellFormularStyle:cellAdresa];
    
    NSArray *topLevelObjectsEmail = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellEmail = [topLevelObjectsEmail objectAtIndex:0];
    [(UILabel *)[cellEmail viewWithTag:1] setText:@"EMAIL"];
    [(UITextField *)[cellEmail viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellEmail viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [YTOUtils setCellFormularStyle:cellEmail];
    
    NSArray *topLevelObjectsTelefon = [[NSBundle mainBundle] loadNibNamed:@"CellView_Numeric" owner:self options:nil];
    cellTelefon = [topLevelObjectsTelefon objectAtIndex:0];
    [(UILabel *)[cellTelefon viewWithTag:1] setText:@"TELEFON"];
    [(UITextField *)[cellTelefon viewWithTag:2] setPlaceholder:@""];
    [(UITextField *)[cellTelefon viewWithTag:2] setKeyboardType:UIKeyboardTypeNumberPad];
    [YTOUtils setCellFormularStyle:cellTelefon];
    
    NSArray *topLevelObjectscalc = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellCalculeaza = [topLevelObjectscalc objectAtIndex:0];
    UIImageView * imgComanda = (UIImageView *)[cellCalculeaza viewWithTag:1];
    imgComanda.image = [UIImage imageNamed:@"comanda-calatorie.png"];
    UILabel * lblCellC = (UILabel *)[cellCalculeaza viewWithTag:2];
    lblCellC.textColor = [UIColor whiteColor];
    lblCellC.text = @"COMANDA";
}

- (void) showListaJudete:(NSIndexPath *)index
{
    goingBack = NO;
    PickerVCSearch * actionPicker = [[PickerVCSearch alloc]initWithNibName:@"PickerVCSearch" bundle:nil];
    actionPicker.listOfItems = [[NSMutableArray alloc] initWithArray:[Database Judete]];
    actionPicker._indexPath = index;
    actionPicker.nomenclator = kJudete;
    actionPicker.delegate = self;
    actionPicker.titlu = @"Judete";
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
}

- (void) setLocalitate:(NSString *)localitate
{
    localitateLivrare = localitate;
    UILabel * lbl = (UILabel *)[cellJudetLocalitate viewWithTag:2];
    lbl.text = [[judetLivrare stringByAppendingString:@","] stringByAppendingString:localitateLivrare];
}

- (void) setAdresa:(NSString *)adresa
{
    adresaLivrare = adresa;
    UITextField * txt = (UITextField *)[cellAdresa viewWithTag:2];
    txt.text = adresa;
}

- (void) setEmail:(NSString *)email
{
    emailLivrare = email;
    UITextField * txt = (UITextField *)[cellEmail viewWithTag:2];
    txt.text = email;
}

- (void) setTelefon:(NSString *)telefon
{
    telefonLivrare = telefon;
    UITextField * txt = (UITextField *)[cellTelefon viewWithTag:2];
    txt.text = telefon;
}


#pragma mark UIAlertView
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        //        NSString * q = [NSString stringWithFormat:@"numar_oferta=%@&email=%@&nume=%@&adresa=%@&localitate=%@&judet=%@&telefon=%@&codProdus=%@&valoare=%.2f&companie=%@&udid=%@", setari.idOferta, self.person.Email, self.person.Nume, self.person.Strada, self.localitate,self.judet,self.person.Telefon,
        //                        @"RCA", tarifRCA.primaInt, tarifRCA.nume, [[UIDevice currentDevice] uniqueIdentifier]];
        //        NSLog(@"%@",q);
        //        NSString * urlAltString = [NSString stringWithFormat:@"%@?%@",[appDelegate kPaymentUrl], q];
        //        NSString * urlString = [urlAltString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        //        NSURL * url = [NSURL URLWithString:urlString];
        //
        //        if(buttonIndex == 1)
        //        {
        //            [[UIApplication sharedApplication] openURL:url];
        //
        //        }
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void) showCustomLoading
{
    [self hideCustomLoading];
    [vwLoading setHidden:NO];
}
- (IBAction) hideCustomLoading
{
    [vwLoading setHidden:YES];
}

- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index
{
    if (error)
        imgError.image = [UIImage imageNamed:@"comanda-eroare.png"];
    else
        imgError.image = [UIImage imageNamed:@"comanda-ok.png"];
    
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
        [self.navigationController popToRootViewControllerAnimated:YES];
    else if (btn.tag == 2)
    {
        // to do plata ONLINE
    }
   // else if (btn.tag == 100)
   //     [self callInregistrareComanda];
    
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

@end
