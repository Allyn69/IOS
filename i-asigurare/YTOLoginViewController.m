//
//  YTOLoginViewController.m
//  i-asigurare
//
//  Created by Stern Edi on 14/01/14.
//
//

#import "YTOLoginViewController.h"
#import "YTOUserDefaults.h"
#import "YTOUtils.h"
#import "YTOAppDelegate.h"
#import "YTOAutovehicul.h"
#import "YTOLocuinta.h"
#import "YTOPersoana.h"
#import "YTORegisterViewController.h"
#import "YTOSetariParolaViewController.h"
#import "YTOPreferinteNotificariViewController.h"
#import "VerifyNet.h"
#import "YTOAlerta.h"


@interface YTOLoginViewController ()

@end

@implementation YTOLoginViewController

@synthesize controller,fieldArray;
//@synthesize indexAsigurat;
@synthesize responseData;

int setTag = 0; // sa stiu cand apas pe da sau nu daca e pentru resetare parola
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Setari";
        self.tabBarItem.image = [UIImage imageNamed:@"menu-setari.png"];
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
    //self.trackedViewName = @"YTOLoginViewController";
    
    keyboardFirstTimeActive = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    [self initCellsIfLogedIn];
    [self initCells];
    [tableView setAllowsSelection:YES];
    [YTOUtils rightImageVodafone:self.navigationItem];
    
    YTOPersoana * proprietar = [YTOPersoana Proprietar];
    YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
    NSString * email;
    if (proprietar.email && proprietar.email.length > 0)
        email = proprietar.email;
    else if (proprietarPJ.email && proprietarPJ.email.length > 0)
        email = proprietarPJ.email;
    txtUser.text = email;
}





- (void) viewDidAppear:(BOOL)animated
{
    UILabel *lbl11 = (UILabel * ) [cellHead viewWithTag:11];
    //UILabel *lbl22 = (UILabel * ) [cellHead viewWithTag:22]
    
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        loggedIn = YES;
        lblTitluHeader.text = @"bine ai venit!";
    }else {
        loggedIn = NO;
        lblTitluHeader.text = @"introdu datele tale de acces";
        UITextField * txtLogin = (UITextField *)[cellLogin viewWithTag:2];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray * listaMasini;
        NSMutableArray * listaPersoane;
        NSMutableArray * listaLocuinte;
        listaMasini = [delegate Masini];
        listaPersoane = [delegate Persoane];
        listaLocuinte = [delegate Locuinte];
        if (listaLocuinte.count >0 || listaMasini.count >0 || listaPersoane.count){
            ((UITextField *)[cellLogin viewWithTag:12]).hidden = NO ;
            ((UITextField *)[cellLogin viewWithTag:12]).font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
            txtLogin.text = @"";
            YTOPersoana * proprietar = [YTOPersoana Proprietar];
            YTOPersoana * proprietarPJ = [YTOPersoana ProprietarPJ];
            NSString * email;
            if (proprietar.email && proprietar.email.length > 0)
                email = proprietar.email;
            else if (proprietarPJ.email && proprietarPJ.email.length > 0)
                email = proprietarPJ.email;
            txtUser.text = email;
        }
        else {
            ((UITextField *)[cellLogin viewWithTag:12]).hidden = YES ;
            txtLogin.text = @"Intra in cont";
        }
    }
    [tableView reloadData];

    

    
    NSString *string1 = @"Contul tau";
    NSString *string2 = @"i-Asigurare";
    NSString *string  = [[NSString alloc]initWithFormat:@"%@ %@",string1,string2];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string];
        [attributedString beginEditing];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:rosuProfil] range:NSMakeRange(0, string1.length+1)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[YTOUtils colorFromHexString:ColorTitlu] range:NSMakeRange(string1.length+1, string2.length)];
        [attributedString beginEditing];
        
        [lbl11 setAttributedText:attributedString];
    }else{
        [lbl11 setText:string];
        [lbl11 setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
    }
}




- (void)keyboardWillShow {
    
    keyboardFirstTimeActive = YES;
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
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        loggedIn = YES;
    }else {
        loggedIn = NO;
    }
    if (loggedIn) return  4;
    return 6;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        loggedIn = YES;
    }else {
        loggedIn = NO;
    }
    if (loggedIn){
        return 60;
    }else {
    if (indexPath.row == 3 || indexPath.row == 4 || indexPath.row == 5)
        return 47;
    return 65;
    }
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell;
    if (![[YTOUserDefaults getUserName] isEqualToString:@""] && ![[YTOUserDefaults getPassword] isEqualToString:@""] && [YTOUserDefaults getUserName] != nil && [YTOUserDefaults getPassword] != nil  )
    {
        loggedIn = YES;
    }else {
        loggedIn = NO;
    }
    if (loggedIn){
        if (indexPath.row == 0) cell = cellUserLI;
        else if (indexPath.row == 1) cell = cellSetariLI;
        else if (indexPath.row == 2) cell = cellChangePasswordLI;
        else if (indexPath.row == 3) cell = cellLogOutLI;
        if (indexPath.row % 2 == 0) {
            CGRect frame;
            frame = CGRectMake(0, 0, 320, 60);
            UIView *bgColor = [[UIView alloc] initWithFrame:frame];
            [cell addSubview:bgColor];
            [cell sendSubviewToBack:bgColor];
            bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
        }
    }else {
    if (indexPath.row == 0) cell = cellUser;
    else if (indexPath.row == 1) cell = cellPassword;
    else if (indexPath.row == 2) cell = cellLogin;
    else if (indexPath.row == 3) cell = cellRegister;
    else if (indexPath.row == 4) cell = cellForgotPass;
    else if (indexPath.row == 5) cell = cellDeleteAll;
    if (indexPath.row % 2 == 0) {
        CGRect frame;
        if (indexPath.row ==3 || indexPath.row == 4)
            frame = CGRectMake(0, 0, 320, 47);
        else  frame = CGRectMake(0, 0, 320, 65);
        UIView *bgColor = [[UIView alloc] initWithFrame:frame];
        [cell addSubview:bgColor];
        [cell sendSubviewToBack:bgColor];
        bgColor.backgroundColor = [YTOUtils colorFromHexString:@"#fafafa"];
    }
    }
        
    
    return cell;
}

#pragma mark - Table view delegate


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (loggedIn){
        if (indexPath.row == 1){
            YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
            YTOPreferinteNotificariViewController *aView = [[YTOPreferinteNotificariViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOPreferinteNotificariViewController alloc] initWithNibName:@"YTOPreferinteNotificariViewController" bundle:nil];
            else aView = [[YTOPreferinteNotificariViewController alloc] initWithNibName:@"YTOPreferinteNotificariViewController" bundle:nil];
            aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Intra in cont");
            [appDelegate.contNavigationController pushViewController:aView animated:YES];
        }
        if (indexPath.row == 2){
            YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
            YTOSetariParolaViewController *aView = [[YTOSetariParolaViewController alloc] init];
            if (IS_IPHONE_5)
                aView = [[YTOSetariParolaViewController alloc] initWithNibName:@"YTOSetariParolaViewController_R4" bundle:nil];
            else aView = [[YTOSetariParolaViewController alloc] initWithNibName:@"YTOSetariParolaViewController" bundle:nil];
            aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Intra in cont");
            [appDelegate.contNavigationController pushViewController:aView animated:YES];
        }
         if (indexPath.row == 3)
            [self showLogout];
            

    }else {
        if (indexPath.row == 2)
        {
            [self doneEditing];
            if (txtUser.text.length == 0)
            {
                [activeTextField resignFirstResponder];
                [txtUser becomeFirstResponder];
                return;
            }
            else if (txtPassword.text.length == 0)
            {
                [activeTextField resignFirstResponder];
                [txtPassword becomeFirstResponder];
                return;
            }
            else
            {
                VerifyNet * vn = [[VerifyNet alloc] init];
                if ([vn hasConnectivity])
                    [self callLogin];
                else {
                 [self showPopup:@"Eroare" withDescription:@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!" withColor:[YTOUtils colorFromHexString:rosuProfil]];
                    return;
                }
            }
        }
    }
}

#pragma mark TEXTFIELD


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    UITableViewCell *currentCell;
    currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath *indexPath;
    if (IS_OS_7_OR_LATER){
        UIView* contentView =[textField superview];
        CGPoint center = [self->tableView convertPoint:textField.center fromView:contentView];
        indexPath =[tableView indexPathForRowAtPoint:center];
    }
    else indexPath = [tableView indexPathForCell:currentCell];
    

    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    UIToolbar *toolbar = [[UIToolbar alloc] init];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    [toolbar sizeToFit];
    
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing)];
    
    UIBarButtonItem *flexButton1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *prevButton =[[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"prev", [YTOUserDefaults getLanguage],@"Inapoi")style:UIBarButtonItemStyleBordered target:self action:@selector(prevEditing)];
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"next", [YTOUserDefaults getLanguage],@"Inainte") style:UIBarButtonItemStyleBordered  target:self action:@selector(nextEditing)];
    
    
    NSArray *itemsArray = [NSArray arrayWithObjects: prevButton, nextButton, flexButton1, doneButton, nil];
    
    [toolbar setItems:itemsArray];
    
    [activeTextField setInputAccessoryView:toolbar];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UIView *keyboardView = [[UIView alloc] initWithFrame:CGRectMake(0, 265, 320, 215)];
    tableView.tableFooterView = keyboardView;
    
    UITableViewCell *currentCell;
    currentCell =  (UITableViewCell *) [[textField superview] superview];
    NSIndexPath *indexPath;
    if (IS_OS_7_OR_LATER){
        UIView* contentView =[textField superview];
        CGPoint center = [self->tableView convertPoint:textField.center fromView:contentView];
        indexPath =[tableView indexPathForRowAtPoint:center];
    }
    else indexPath = [tableView indexPathForCell:currentCell];
    

    
    int index = 0;
    
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:indexPath.section]
                     atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
	activeTextField = textField;
	//tableView.contentInset = UIEdgeInsetsMake(65, 0, 210, 0);
    
    activeTextField.tag = indexPath.row;
    
	return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
	if(activeTextField == textField)
	{
		activeTextField = nil;
	}
    
	[textField resignFirstResponder];
	//btnDone.enabled = NO;
    [self doneEditing];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    UITableViewCell *currentCell ;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];

    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
    
    // In cazul in care tastatura este activa si se da back
    int index = 0;
    if (indexPath != nil)
        index = indexPath.row;
    else
        index = textField.tag;
    
    
}

-(IBAction) doneEditing
{
    tableView.tableFooterView = nil;
    [activeTextField resignFirstResponder];
	activeTextField = nil;
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
	[self deleteBarButton];
}


-(void) nextEditing
{
    UITableViewCell *currentCell ;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];

    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index + 1 == fieldArray.count) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    id nextField = [fieldArray objectAtIndex:index + 1];
    if (nextField == (id) txtPassword) {
        activeTextField = nextField;
        [nextField becomeFirstResponder];
    }
    
}

- (void) prevEditing
{
    UITableViewCell *currentCell ;
    if (IS_OS_7_OR_LATER) currentCell = (UITableViewCell *) activeTextField.superview.superview.superview;
    else currentCell =  (UITableViewCell *) [[activeTextField superview] superview];

    NSIndexPath * indexPath = [tableView indexPathForCell:currentCell];
	[tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    
    BOOL didResign = [activeTextField resignFirstResponder];
    if (!didResign) return;
    
    NSUInteger index = [self.fieldArray indexOfObject:activeTextField];
    if (index == NSNotFound || index == 0) {
        [self deleteBarButton];
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.tableFooterView = nil;
        return;
    }
    
    id prevField = [fieldArray objectAtIndex:index - 1];
    activeTextField = prevField;
    [prevField becomeFirstResponder];
    
}


- (void) addBarButton {
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"checked.png"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneEditing)];
    self.navigationItem.rightBarButtonItem = backButton;
    self.navigationItem.hidesBackButton = YES;
}
- (void) deleteBarButton {
    [YTOUtils rightImageVodafone:self.navigationItem];
    //self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.hidesBackButton = NO;
}


- (void) initCells
{
    
    NSArray *topLevelObjectsUser = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellUser = [topLevelObjectsUser objectAtIndex:0];
    [(UITextField *)[cellUser viewWithTag:2] setKeyboardType:UIKeyboardTypeEmailAddress];
    [(UITextField *)[cellUser viewWithTag:2] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    txtUser = (UITextField *)[cellUser viewWithTag:2];
    
    [(UILabel *)[cellUser viewWithTag:1] setText:@"Adresa de email"];
    [YTOUtils setCellFormularStyle:cellUser];
    
    NSArray *topLevelObjectsPassword = [[NSBundle mainBundle] loadNibNamed:@"CellView_String" owner:self options:nil];
    cellPassword = [topLevelObjectsPassword objectAtIndex:0];
    txtPassword = (UITextField *)[cellPassword viewWithTag:2];
    txtPassword.secureTextEntry = YES;
    [(UILabel *)[cellPassword viewWithTag:1] setText:@"Parola"];
    [YTOUtils setCellFormularStyle:cellPassword];
    
    NSArray *topLevelObjectsForgot = [[NSBundle mainBundle] loadNibNamed:@"CellPasswordForget" owner:self options:nil];
    cellForgotPass = [topLevelObjectsForgot objectAtIndex:0];
    UILabel * btn = (UILabel *)[cellForgotPass viewWithTag:12];
    btn.textColor = [YTOUtils colorFromHexString:@"#007aff"];
    [(UIButton *)[cellForgotPass viewWithTag:11] addTarget:self action:@selector(forgotPassword) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *topLevelObjectsRegister = [[NSBundle mainBundle] loadNibNamed:@"CellContNou" owner:self options:nil];
    cellRegister = [topLevelObjectsRegister objectAtIndex:0];
    UIButton * btn1 = (UIButton *)[cellRegister viewWithTag:11];
    [btn1 setTitleColor:[YTOUtils colorFromHexString:@"#007aff"] forState:UIControlStateNormal];
    [(UIButton *)[cellRegister viewWithTag:11] addTarget:self action:@selector(registerCont) forControlEvents:UIControlEventTouchUpInside];
    UIButton * btn12 = (UIButton *)[cellRegister viewWithTag:123];
    UILabel * lbl12 = (UILabel *) [cellRegister viewWithTag:12];
    lbl12.text = @"                 CONT NOU";
    btn12.hidden = YES;
    
    
    NSArray *topLevelObjectsLogin = [[NSBundle mainBundle] loadNibNamed:@"CellCalculeaza" owner:self options:nil];
    cellLogin = [topLevelObjectsLogin objectAtIndex:0];
    UITextField * txtLogin = (UITextField *)[cellLogin viewWithTag:2];
    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray * listaMasini;
    NSMutableArray * listaPersoane;
    NSMutableArray * listaLocuinte;
    listaMasini = [delegate Masini];
    listaPersoane = [delegate Persoane];
    listaLocuinte = [delegate Locuinte];
    if (listaLocuinte.count >0 || listaMasini.count >0 || listaPersoane.count > 0){
        ((UITextField *)[cellLogin viewWithTag:12]).hidden = NO ;
        ((UITextField *)[cellLogin viewWithTag:12]).font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        txtLogin.text = @"";
    }
    else {
        txtLogin.text = @"Intra in cont";
        ((UITextField *)[cellLogin viewWithTag:12]).hidden = YES ;
    }
    NSArray *topLevelObjectsDelete = [[NSBundle mainBundle] loadNibNamed:@"CellPasswordForget" owner:self options:nil];
    cellDeleteAll = [topLevelObjectsDelete objectAtIndex:0];
    UITextField * txtDelete = (UITextField *)[cellDeleteAll viewWithTag:12];
    txtDelete.textColor = [YTOUtils colorFromHexString:@"#007aff"];
    [(UIButton *)[cellDeleteAll viewWithTag:11] addTarget:self action:@selector(showPopupWithDelete) forControlEvents:UIControlEventTouchUpInside];
    txtDelete.text = @"Sterge datele din telefon";
    
    fieldArray = [[NSMutableArray alloc] initWithObjects:txtUser, txtPassword,  nil];
    
}

- (void) initCellsIfLogedIn
{
    NSArray *topLevelObjectsUser = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellUserLI = [topLevelObjectsUser objectAtIndex:0];
    [(UILabel *)[cellUserLI viewWithTag:11] setText:[YTOUserDefaults getUserName]];
    [(UILabel *)[cellUserLI viewWithTag:11] setTextColor:[YTOUtils colorFromHexString:@"#b3b3b3"]];
    [(UILabel *)[cellUserLI viewWithTag:11] setTextAlignment:NSTextAlignmentCenter];
    cellUserLI.accessoryType = UITableViewCellAccessoryNone;
    [YTOUtils setCellFormularStyle:cellUserLI];
    
    NSArray *topLevelObjectsSetari = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellSetariLI = [topLevelObjectsSetari objectAtIndex:0];
    [(UILabel *)[cellSetariLI viewWithTag:11] setText:@"Preferinte notificari & alerte"];
    [YTOUtils setCellFormularStyle:cellSetariLI];
    
    NSArray *topLevelObjectChangePass = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellChangePasswordLI = [topLevelObjectChangePass objectAtIndex:0];
    [(UILabel *)[cellChangePasswordLI viewWithTag:11] setText:@"Schimba parola"];
    [YTOUtils setCellFormularStyle:cellChangePasswordLI];
    
    NSArray *topLevelObjectsLogout = [[NSBundle mainBundle] loadNibNamed:@"Cell_ContSetari" owner:self options:nil];
    cellLogOutLI = [topLevelObjectsLogout objectAtIndex:0];
    [(UILabel *)[cellLogOutLI viewWithTag:11] setText:@"Iesi din cont"];
    [(UILabel *)[cellLogOutLI viewWithTag:11] setTextAlignment:NSTextAlignmentCenter];
    [(UILabel *)[cellLogOutLI viewWithTag:11] setTextColor:[YTOUtils colorFromHexString:@"#007aff"]];
    UILabel * label = (UILabel *)[cellLogOutLI viewWithTag:10];
    cellLogOutLI.accessoryType = UITableViewCellAccessoryNone;
    label.hidden = YES;
    [YTOUtils setCellFormularStyle:cellLogOutLI];
    
    
}

- (void) showPopupWithDelete
{
    setTag = 3;
    vwLogOut.hidden = NO;
    lblDescLogOut.text = @"Datele de pe acest device vor fi sterse definitiv si nu vor putea fi recuperate. Esti sigur ca vrei sa le stergi?";
    lblTitluRosuLogOut.text = @"Sterge date";

}


- (IBAction)hidePopup:(id)sender
{
    vwPopup.hidden = YES;
    lblTitluPopNegru.text = @"";
}

- (IBAction)logOut:(id)sender
{
    if (setTag == 1){
        vwLogOut.hidden = YES;
        [self callForgetPassword];
        setTag = 0;
    }else if (setTag == 3){
        [YTOUtils deleteWhenLogOff
         ];
        UITextField * txtLogin = (UITextField *)[cellLogin viewWithTag:2];
        ((UITextField *)[cellLogin viewWithTag:12]).hidden = YES ;
        ((UITextField *)[cellLogin viewWithTag:12]).font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
        txtLogin.text = @"Intra in cont";
        vwLogOut.hidden = YES;
        setTag = 0;
    }else{
        vwLogOut.hidden = YES;
        txtPassword.text = @"";
        txtUser.text = @"";
        lblTitluHeader.text = @"introdu datele tale de acces";
        [YTOUserDefaults setUserName:nil];
        [YTOUserDefaults setPassword:nil];
        [YTOUtils deleteWhenLogOff];
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        NSMutableArray * listaMasini;
        NSMutableArray * listaPersoane;
        NSMutableArray * listaLocuinte;
        listaMasini = [delegate Masini];
        listaPersoane = [delegate Persoane];
        listaLocuinte = [delegate Locuinte];
        UITextField * txtLogin = (UITextField *)[cellLogin viewWithTag:2];
        if (listaLocuinte.count >0 || listaMasini.count >0 || listaPersoane.count > 0){
            ((UITextField *)[cellLogin viewWithTag:12]).hidden = NO ;
            ((UITextField *)[cellLogin viewWithTag:12]).font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:16];
            txtLogin.text = @"";
        }
        else {
            txtLogin.text = @"Intra in cont";
            ((UITextField *)[cellLogin viewWithTag:12]).hidden = YES ;
        }
    }
     [tableView reloadData];
}

- (void) showLogout
{
    vwLogOut.hidden = NO;
    //lblTitluLogOut.hidden = YES;
    if (setTag == 1){
        lblTitluLogOut.text = @"Parola uitata";
        lblDescLogOut.text = [NSString stringWithFormat:@"Se va genera o noua parola si se va trimite pe adresa de e-mail %@. Vrei sa continui?",txtUser.text];
        lblTitluRosuLogOut.text = @"Resetare parola";
    }else {
        lblDescLogOut.text = [NSString stringWithFormat:@"Esti autentificat cu %@. \nVrei sa deconectezi contul de pe acest device?",[YTOUserDefaults getUserName]];
        lblTitluLogOut.text = @"Deconectare";
        lblTitluRosuLogOut.text = @"";
    }
}

- (IBAction)hideLogOut:(id)sender
{
    setTag = 0 ;
    vwLogOut.hidden = YES;
}



#pragma mark Consume WebService

- (NSString *) XmlRequestLogin
{
    NSString * password = [YTOUtils md5:txtPassword.text];
    NSString * xml =  [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<AccountLogin xmlns=\"http://tempuri.org/\">"
                       "<username>%@</username>"
                       "<password>%@</password>"
                       "</AccountLogin>"
                       "</soap:Body>"
                       "</soap:Envelope>",txtUser.text,password];
    return xml;
}

- (NSString *) XmlRequestRegisterId
{
    NSString * idInternRca=@"";
    NSString * serieSasiu=@"";
    NSString * email=@"";
    NSString * codUnic=@"";
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    if ([appDelegate.Masini count] > 0)
    {
        YTOAutovehicul * _masina = (YTOAutovehicul*)[appDelegate.Masini objectAtIndex:0];
        idInternRca = _masina != nil ? _masina.idIntern : @"";
        serieSasiu = _masina != nil ? _masina.serieSasiu : @"";
    }
    
    NSString * idInternLocuinta = @"";
    if ([appDelegate.Locuinte count] > 0)
    {
        YTOLocuinta * _locuinta = (YTOLocuinta*)[appDelegate.Locuinte objectAtIndex:0];
        idInternLocuinta = _locuinta != nil ? _locuinta.idIntern : @"";
    }
    
    NSString * idInternPersoana = @"";
    YTOPersoana * _persoana = [YTOPersoana Proprietar];
    if (_persoana == nil && [appDelegate.Persoane count] > 0)
    {
        _persoana = (YTOPersoana*)[appDelegate.Persoane objectAtIndex:0];
    }
    if (_persoana != nil)
    {
        idInternPersoana = _persoana != nil ? _persoana.idIntern :@"";
        email = _persoana != nil ? _persoana.email : @"";
        codUnic = _persoana != nil ? _persoana.codUnic : @"";
    }
    NSString *platforma = [[UIDevice currentDevice].model stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    
    
    NSString * xml =  [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<RegisterIdCont xmlns=\"http://tempuri.org/\">"
                       "<user>vreaurca</user>"
                       "<password>123</password>"
                       "<udid>%@</udid>"
                       "<push_token>%@</push_token>"
                       "<idintern_rca>%@</idintern_rca>"
                       "<idintern_locuinta>%@</idintern_locuinta>"
                       "<idintern_persoana>%@</idintern_persoana>"
                       "<cod_unic>%@</cod_unic>"
                       "<email>%@</email>"
                       "<serie_sasiu>%@</serie_sasiu>"
                       "<platforma>%@</platforma>"
                       "<cont_user>%@</cont_user>"
                       "<cont_password>%@</cont_password>"
                       "</RegisterIdCont>"
                       "</soap:Body>"
                       "</soap:Envelope>",[[UIDevice currentDevice] xUniqueDeviceIdentifier],
                       [YTOUserDefaults getPushToken],
                       idInternRca,
                       idInternLocuinta,
                       idInternPersoana,
                       codUnic,
                       email,
                       serieSasiu,
                       platforma,
                       [YTOUserDefaults getUserName],
                       [YTOUserDefaults getPassword]];
    return xml;
}

- (void) forgotPassword
{
    if (txtUser.text.length > 0){
        setTag = 1;
        [self showLogout];
        [self doneEditing];
        
    }
         else [self showPopup:@"Atentie!" withDescription:@"Completeaza adresa de e-mail pentru a primi o noua parola" withColor:[YTOUtils colorFromHexString:rosuProfil]];
}

- (NSString *) XmlRequestForgetPass
{
    NSString * xml =  [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
                       "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                       "<soap:Body>"
                       "<AccountForgotPassword xmlns=\"http://tempuri.org/\">"
                       "<username>vreaurca</username>"
                       "<password>123</password>"
                       "<email>%@</email>"
                       "</AccountForgotPassword>"
                       "</soap:Body>"
                       "</soap:Envelope>",txtUser.text];
    return xml;
}

int paramForRequest = -1;

- (void) callForgetPassword {
    
    [self showLoading];
    paramForRequest = 1;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:15.0];
    
    NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestForgetPass]];
    NSLog(@"Request=%@", parameters);
    NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/AccountForgotPassword" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.responseData = [NSMutableData data];
    }else {
        [self showPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") withDescription:NSLocalizedStringFromTable(@"i450", [YTOUserDefaults getLanguage],@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!")withColor:[YTOUtils colorFromHexString:rosuTermeni]];
    }
    
}


- (void) callLogin {
    clientId = @"0";
    [self showLoading];
    paramForRequest = 2;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:20.0];
    
    NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestLogin]];
    NSLog(@"Request=%@", parameters);
    NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/AccountLogin" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.responseData = [NSMutableData data];
    }else {
        [self showPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") withDescription:NSLocalizedStringFromTable(@"i450", [YTOUserDefaults getLanguage],@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!")withColor:[YTOUtils colorFromHexString:rosuProfil]];
    }
    
    
}

- (void) callRegisterId: (NSString *) idCont{
    
    [self showLoading];
    paramForRequest = 3;
    
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                        timeoutInterval:15.0];
    
    NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestRegisterId]];
    NSLog(@"Request=%@", parameters);
    NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
    
    [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"http://tempuri.org/RegisterIdCont" forHTTPHeaderField:@"SOAPAction"];
    [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
        self.responseData = [NSMutableData data];
    }else {
        [self showPopup:NSLocalizedStringFromTable(@"i123", [YTOUserDefaults getLanguage],@"Atentie !") withDescription:NSLocalizedStringFromTable(@"i450", [YTOUserDefaults getLanguage],@"Ne pare rau! \nCererea nu a fost trimisa pentru ca nu esti conectat la internet. \nTe rugam sa te asiguri ca ai o conexiune la internet activa si sa incerci din nou.\n Iti multumim!")withColor:[YTOUtils colorFromHexString:rosuProfil]];
    }
    
    
}

- (void) callSyncItems
{
    [self showLoading];
    paramForRequest = 4;
	NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@sync.asmx", LinkAPI]];
    
    
    VerifyNet * vn = [[VerifyNet alloc] init];
    if ([vn hasConnectivity]) {
        
        
        NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url
                                                                cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:30.0];
        
        NSString * parameters = [[NSString alloc] initWithString:[self XmlRequestForAuto]];
        NSLog(@"Request=%@", parameters);
        NSString * msgLength = [NSString stringWithFormat:@"%d", [parameters length]];
        
        [request addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [request addValue:@"http://tempuri.org/ExistingClientByCont" forHTTPHeaderField:@"SOAPAction"];
        [request addValue:msgLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[parameters dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (connection) {
            self.responseData = [NSMutableData data];
        }
    }
    else {
        vwPopup.hidden = NO;
        [self showLoading];
    }
}

- (NSString *) XmlRequestForAuto
{
    return [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>"
            "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
            "<soap:Body>"
            "<ExistingClientByCont xmlns=\"http://tempuri.org/\">"
            "<udid>%@</udid>"
            "<cont_user>%@</cont_user>"
            "<cont_parola>%@</cont_parola>"
            "</ExistingClientByCont>"
            "</soap:Body>"
            "</soap:Envelope>",[[UIDevice currentDevice] xUniqueDeviceIdentifier],
            [YTOUserDefaults getUserName],
            [YTOUserDefaults getPassword]];
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
    
	NSXMLParser * xmlParser = [[NSXMLParser alloc] initWithData:responseData];
	xmlParser.delegate = self;
	BOOL succes = [xmlParser parse];
	
	if (succes) {
        NSError * err = nil;
        NSData *data = [raspuns dataUsingEncoding:NSUTF8StringEncoding];
        
        if (data == nil) {
            if (paramForRequest == 1)
            {
                lblTitluPopNegru.text = @"Eroare";
                [self showPopup:@"Cont inexistent" withDescription:@"Nu exista un cont creat pentru aceasta adresa de e-mail. Verifica adresa introdusa sau creeaza un cont nou." withColor:[YTOUtils colorFromHexString:rosuProfil]];
                [YTOUserDefaults setPassword:@""];
                [YTOUserDefaults setUserName:@""];
            }
            else if (paramForRequest == 2)
            {
                lblTitluPopNegru.text = @"Eroare";
                [self showPopup:@"Autentificare esuata" withDescription:@"Adresa de e-mail sau parola introdusa nu este corecta." withColor:[YTOUtils colorFromHexString:rosuProfil]];
                [YTOUserDefaults setPassword:@""];
                [YTOUserDefaults setUserName:@""];
                txtPassword.text = @"";
            }
            else if (paramForRequest == 3){
                [self showPopup:@"Autentificare esuata" withDescription:@"Adresa de e-mail sau parola introdusa nu este corecta." withColor:[YTOUtils colorFromHexString:rosuProfil]];
                [YTOUserDefaults setPassword:@""];
                [YTOUserDefaults setUserName:@""];
                txtPassword.text = @"";
               
            }
            [self hideLoading];
            return;
            
        }
        if (paramForRequest == 1){
            if (![raspuns isEqualToString:@""]){
                [YTOUserDefaults setUserName:txtUser.text];
                lblTitluPopNegru.text = @"Resetare parola";
                [self showPopup:@"Parola resetata cu succes" withDescription:[NSString stringWithFormat:@" O noua parola s-a trimis pe adresa de e-mail %@. Dupa autentificare, iti recomandam sa o schimbi cu o parola usor de retinut.",txtUser.text] withColor:[YTOUtils colorFromHexString:verde]];
                [self hideLoading];
                raspuns = @"";
            }else {
                lblTitluPopNegru.text = @"Eroare";
                [self showPopup:@"Cont inexistent" withDescription:@"Nu exista un cont creat pentru aceasta adresa de e-mail. Verifica adresa introdusa sau creeaza un cont nou." withColor:[YTOUtils colorFromHexString:rosuProfil]];
                [self hideLoading];
            }
    
        }
        else if (paramForRequest == 2){
            clientId = raspuns;
            if ([clientId isEqualToString:@""] || [clientId isEqualToString:@"0"]){
                lblTitluPopNegru.text = @"Eroare";
                [self hideLoading];
                [self showPopup:@"Autentificare esuata" withDescription:@"Adresa de e-mail sau parola introdusa nu este corecta." withColor:[YTOUtils colorFromHexString:rosuProfil]];
            }
            else {
                [YTOUserDefaults setUserName:txtUser.text];
                NSString * pass = [YTOUtils md5:txtPassword.text];
                [YTOUserDefaults setPassword:pass];
                [self callRegisterId:clientId];
            }
        }else if (paramForRequest == 3){
            if ([raspuns isEqualToString:@"ok"]){
                NSMutableArray * listaMasini;
                NSMutableArray * listaPersoane;
                NSMutableArray * listaLocuinte;
                YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
                listaMasini = [delegate Masini];
                listaPersoane = [delegate Persoane];
                listaLocuinte = [delegate Locuinte];
                for (int i =0 ;i<listaMasini.count; i++){
                    [[listaMasini objectAtIndex:i] updateAutovehicul:NO];
                }
                for (int i =0 ;i<listaPersoane.count; i++){
                    if ([[[listaPersoane objectAtIndex:i] proprietar] isEqualToString:@"nu"])
                        [[listaPersoane objectAtIndex:i] updatePersoana:NO];
                }
                for (int i =0 ;i<listaLocuinte.count; i++){
                    [[listaLocuinte objectAtIndex:i] updateLocuinta:NO];
                }
                
                [self callSyncItems];
            }
            else {
                [self showPopup:@"Eroare" withDescription:@"A aparut o eroare,va rugam incercati din nou" withColor:[YTOUtils colorFromHexString:rosuProfil]];
                [self hideLoading];
            }
        }else if (paramForRequest == 4){
            NSData *dataMasini = [jsonMasini dataUsingEncoding:NSUTF8StringEncoding];
            if (dataMasini)
            {
                NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataMasini options:kNilOptions error:&err];
                
                for(NSDictionary *item in jsonArray) {
                    NSString * idIntern = [item objectForKey:@"IdIntern"];
                    
                    // Daca exista idIntern, cautam in baza de date
                    // Altfel, generam un guid
                    if (idIntern && idIntern.length >0)
                        masina = [YTOAutovehicul getAutovehicul:idIntern];
                    else
                        idIntern = [YTOUtils GenerateUUID];
                    
                    // Daca masina nu exista in baza de date,
                    // se creeaza un obiect cu idIntern
                    if (!masina)
                    {
                        masina = [[YTOAutovehicul alloc] init];
                        masina.idIntern = [item objectForKey:@"IdIntern"];
                        NSLog(@"%@", masina.idIntern);
                    }
                    
                    // Mapare valori
                    masina.marcaAuto = [item objectForKey:@"Marca"];
                    masina.modelAuto = [item objectForKey:@"Model"];
                    masina.categorieAuto = [[item objectForKey:@"Categorie"] intValue];
                    masina.subcategorieAuto = [item objectForKey:@"Subcategorie"];
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
                    masina.adresa = [item objectForKey:@"Adresa"];
                    masina.savedInCont = @"da";
                    
                    [self getAlerte:item];
                    
                    // Daca masina exista in baza de date, se face update
                    // Altfel se face insert
                    if (!masina._isDirty)
                        [masina addAutovehicul:YES];
                    else
                        [masina updateAutovehicul:YES];
                    
                    masina = nil;
                    
                    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [delegate refreshMasini];
                }
                
            }
            
            
            NSData *dataLocuinte = [jsonLocuinte dataUsingEncoding:NSUTF8StringEncoding];
            if (dataLocuinte)
            {
                NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataLocuinte options:kNilOptions error:&err];
                
                for(NSDictionary *item in jsonArray) {
                    NSString * idIntern = [item objectForKey:@"IdIntern"];
                    
                    // Daca exista idIntern, cautam in baza de date
                    // Altfel, generam un guid
                    if (idIntern && idIntern.length >0)
                        locuinta = [YTOLocuinta getLocuinta:idIntern];
                    else
                        idIntern = [YTOUtils GenerateUUID];
                    
                    // Daca masina nu exista in baza de date,
                    // se creeaza un obiect cu idIntern
                    if (!locuinta)
                    {
                        locuinta = [[YTOLocuinta alloc] init];
                        locuinta.idIntern = [item objectForKey:@"IdIntern"];
                        NSLog(@"%@", locuinta.idIntern);
                    }
                    
                    // Mapare valori
                    locuinta.tipLocuinta = [item objectForKey:@"TipLocuinta"];
                    locuinta.structuraLocuinta = [item objectForKey:@"StructuraLocuinta"];
                    locuinta.regimInaltime = [[item objectForKey:@"RegimInaltime"] intValue];
                    locuinta.etaj = [[item objectForKey:@"Etaj"] intValue];
                    locuinta.anConstructie = [[item objectForKey:@"AnConstructie"] intValue];
                    if ([[item objectForKey:@"NrCamere"] isEqualToString:@""])
                        locuinta.nrCamere = [[item objectForKey:@"NrCamere"] intValue];
                    else locuinta.nrCamere = 2;
                    locuinta.suprafataUtila = [[item objectForKey:@"SuprafataUtila"] intValue];
                     if ([[item objectForKey:@"NrCamere"] isEqualToString:@""])
                         locuinta.nrLocatari = [[item objectForKey:@"NrLocatari"] intValue];
                    else locuinta.nrLocatari = 2;
                    locuinta.tipGeam = [[item objectForKey:@"TipGeam"] boolValue] ? @"da" : @"nu";
                    locuinta.areAlarma = [[item objectForKey:@"AreAlarma"] boolValue] ? @"da" : @"nu";
                    locuinta.areGrilajeGeam = [[item objectForKey:@"AreGrilajeGeam"] boolValue] ? @"da" : @"nu";
                    locuinta.zonaIzolata = [[item objectForKey:@"ZonaIzolata"]  boolValue] ? @"da" : @"nu";
                    locuinta.clauzaFurtBunuri = [[item objectForKey:@"ClauzaFurtBunuri"] boolValue] ? @"da" : @"nu";
                    locuinta.clauzaApaConducta = [[item objectForKey:@"ClauzaApaConducta"] boolValue] ? @"da" : @"nu";
                    locuinta.detectieIncendiu = [[item objectForKey:@"DetectieIncendiu"] boolValue] ? @"da" : @"nu";
                    locuinta.arePaza = [[item objectForKey:@"ArePaza"] boolValue] ? @"da" : @"nu";
                    locuinta.areTeren= [[item objectForKey:@"AreTeren"] boolValue] ? @"da" : @"nu";
                    locuinta.locuitPermanent = [[item objectForKey:@"LocuitPermanent"] boolValue] ? @"da" : @"nu";
                    locuinta.judet = [item objectForKey:@"Judet"];
                    locuinta.localitate = [item objectForKey:@"Localitate"];
                    locuinta.adresa = [item objectForKey:@"Adresa"];
                    locuinta.modEvaluare = [[item objectForKey:@"ModEvaluare"] boolValue] ? @"da" : @"nu";
                    locuinta.nrRate = [[item objectForKey:@"NrRate"] intValue];
                    locuinta.sumaAsigurata = [[item objectForKey:@"SumaAsigurata"] intValue];
                    locuinta.sumaAsigurataRC = [[item objectForKey:@"SumaAsigurataRC"] intValue];
                    
                    [self getAlerte:item];
                    
                    // Daca masina exista in baza de date, se face update
                    // Altfel se face insert
                    if (!locuinta._isDirty)
                        [locuinta addLocuinta:YES];
                    else
                        [locuinta updateLocuinta:YES];
                    
                    locuinta = nil;
                    
                    YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
                    [delegate refreshLocuinte];
                }
                
            }
            NSData * dataPersoane;
            dataPersoane= [jsonPersoane dataUsingEncoding:NSUTF8StringEncoding];
            if (dataPersoane)
            {
                NSDictionary * jsonArray = [NSJSONSerialization JSONObjectWithData:dataPersoane options:kNilOptions error:&err];
                
                for(NSDictionary *item in jsonArray) {
                    NSString * idIntern = [item objectForKey:@"IdIntern"];
                    if (![[item objectForKey:@"TipPersoana"] isKindOfClass:[NSNull class]] && [item objectForKey:@"TipPersoana"]){
                        if (![[item objectForKey:@"TipPersoana"] isEqualToString:@"juridica"] && [[item objectForKey:@"Proprietar"] isEqualToString:@"da"])
                        {
                            persoana = [YTOPersoana ProprietarPJ];
                        }
                        // Daca exista idIntern, cautam in baza de date
                        // Altfel, generam un guid
                        else if (idIntern && idIntern.length > 0)
                            persoana = [YTOPersoana getPersoana:idIntern];
                        else
                            idIntern = [YTOUtils GenerateUUID];
                    
                        // Daca persoana nu exista in baza de date,
                        // se creeaza un obiect cu idIntern
                        if (!persoana)
                        {
                            persoana = [[YTOPersoana alloc] init];
                            if (![[item objectForKey:@"IdIntern"] isKindOfClass:[NSNull class]] && [item objectForKey:@"IdIntern"])
                                persoana.idIntern = [item objectForKey:@"IdIntern"];
                            NSLog(@"%@", persoana.idIntern);
                        }
                    
                        if (![[item objectForKey:@"Nume"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Nume"])
                        persoana.nume = [item objectForKey:@"Nume"];
                        if (![[item objectForKey:@"CodUnic"] isKindOfClass:[NSNull class]] && [item objectForKey:@"CodUnic"])
                        persoana.codUnic = [item objectForKey:@"CodUnic"];
                        NSString * tel = nil;
                        if (![[item objectForKey:@"Telefon"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Telefon"])
                            tel= [item objectForKey:@"Telefon"];
                        persoana.telefon = tel ? tel : @"";
                    
                        
                        persoana.email = [YTOUserDefaults getUserName];
                        if (![[item objectForKey:@"Judet"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Judet"]){
                            persoana.judet = [item objectForKey:@"Judet"];
                            persoana.localitate = [item objectForKey:@"Localitate"];
                        }
                        if (![[item objectForKey:@"Adresa"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Adresa"])
                            persoana.adresa = [item objectForKey:@"Adresa"];
                        if (![[item objectForKey:@"AnPermis"] isKindOfClass:[NSNull class]] && [item objectForKey:@"AnPermis"])
                            persoana.dataPermis = [item objectForKey:@"AnPermis"];
                        if (![[item objectForKey:@"CodCaen"] isKindOfClass:[NSNull class]] && [item objectForKey:@"CodCaen"])
                            persoana.codCaen = [item objectForKey:@"CodCaen"];
                        if (![[item objectForKey:@"TipPersoana"] isKindOfClass:[NSNull class]] && [item objectForKey:@"TipPersoana"])
                            persoana.tipPersoana = [item objectForKey:@"TipPersoana"];
                        if (![[item objectForKey:@"Proprietar"] isKindOfClass:[NSNull class]] && [item objectForKey:@"Proprietar"])
                            persoana.proprietar = [item objectForKey:@"Proprietar"];
                        else persoana.proprietar = @"nu";
                    
                        if (!persoana._isDirty)
                            [persoana addPersoana:NO];
                        else
                            [persoana updatePersoana:NO];
                    }
                }
            }
            
            NSData * dataProprietar = [jsonProprietar dataUsingEncoding:NSUTF8StringEncoding];
            if (dataProprietar)
            {
                NSDictionary * jsonItem = [NSJSONSerialization JSONObjectWithData:dataProprietar options:kNilOptions error:&err];
                YTOPersoana * proprietar = [YTOPersoana Proprietar];
                if (![[jsonItem objectForKey:@"IdIntern"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"IdIntern"])
                {
                    if (![proprietar.idIntern isEqualToString:[jsonItem objectForKey:@"IdIntern"]])
                    {
                        [proprietar deletePersoana];
                        proprietar = nil;
                    }
                }
                if (!proprietar)
                {
                    proprietar = [[YTOPersoana alloc] initWithGuid:[jsonItem objectForKey:@"IdIntern"]];
                    proprietar.proprietar = @"da";
                }
                if (![[jsonItem objectForKey:@"Nume"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Nume"])
                    proprietar.nume = [jsonItem objectForKey:@"Nume"];
                if (![[jsonItem objectForKey:@"CodUnic"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"CodUnic"])
                    proprietar.codUnic = [jsonItem objectForKey:@"CodUnic"];
                else proprietar.codUnic = @"";
                if (proprietar.codUnic && proprietar.codUnic.length == 13)
                    proprietar.tipPersoana = @"fizica";
                else if (proprietar.codUnic && proprietar.codUnic.length > 0)
                    proprietar.tipPersoana = @"juridica";
                
                NSString * tel = nil;
                if (![[jsonItem objectForKey:@"Telefon"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Telefon"])
                    tel = [jsonItem objectForKey:@"Telefon"];
                proprietar.telefon = tel ? tel : @"";
                
               
                proprietar.email = [YTOUserDefaults getUserName];
                if (![[jsonItem objectForKey:@"Judet"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Judet"]){
                    proprietar.judet = [jsonItem objectForKey:@"Judet"];
                    proprietar.localitate = [jsonItem objectForKey:@"Localitate"];
                }
                if (![[jsonItem objectForKey:@"Adresa"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"Adresa"])
                    proprietar.adresa = [jsonItem objectForKey:@"Adresa"];
                if (![[jsonItem objectForKey:@"AnPermis"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"AnPermis"])
                    proprietar.dataPermis = [jsonItem objectForKey:@"AnPermis"];
                if (![[jsonItem objectForKey:@"CodCaen"] isKindOfClass:[NSNull class]] && [jsonItem objectForKey:@"CodCaen"])
                    proprietar.codCaen = [jsonItem objectForKey:@"CodCaen"];
                
                //NSLog(@"%@", [jsonItem objectForKey:@"DataPermisDR"]);
                
                if (!proprietar._isDirty)
                    [proprietar addPersoana:YES];
                else
                    [proprietar updatePersoana:YES];
            }

            [tableView reloadData];
            [(UILabel *)[cellUserLI viewWithTag:11] setText:[YTOUserDefaults getUserName]];
            lblTitluHeader.text = @"bine ai venit!";
            [self hideLoading];
        }
        else{
                [YTOUserDefaults setUserName:@""];
                [YTOUserDefaults setPassword:@""];
                lblTitluPopNegru.text = @"Eroare";
                [self showPopup:@"Autentificare esuata" withDescription:@"Adresa de e-mail sau parola introdusa nu este corecta." withColor:[YTOUtils colorFromHexString:rosuProfil]];
        }
            
    }
}


- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"connection:didFailWithError:");
	NSLog(@"%@", [error localizedDescription]);
    [self hideLoading];
    [self showPopup:@"Eroare" withDescription:@"A aparut o eroare,va rugam incercati din nou" withColor:[YTOUtils colorFromHexString:rosuProfil]];
}

- (void) getAlerte:(NSDictionary*) item
{
    NSDictionary * alerte;
    alerte = [item objectForKey:@"Alerte"];
    
    for(NSDictionary *item in alerte) {
        NSString * idObiect = [item objectForKey:@"IdIntern"];
        
        // Daca exista idIntern, cautam in baza de date
        // Altfel, generam un guid
        
        int tipAlerta = [[item objectForKey:@"TipAlerta"] intValue];
        
        if (idObiect && idObiect.length > 0)
            alerta = [YTOAlerta getAlerta:idObiect forType:tipAlerta];
        
        // Daca alerta nu exista in baza de date,
        // se creeaza un obiect cu idIntern
        if (!alerta)
        {
            alerta = [[YTOAlerta alloc] initWithGuid:[YTOUtils GenerateUUID]];
            alerta.idObiect = [item objectForKey:@"IdIntern"];
            NSLog(@"%@", alerta.idObiect);
        }
        
        alerta.tipAlerta = [[item objectForKey:@"TipAlerta"] intValue];
        NSString * dataString = [item objectForKey:@"DataAlerta"];
        if (dataString && dataString.length > 0)
        {
            alerta.dataAlerta = [YTOUtils getDateFromString:dataString withFormat:@"dd.MM.yyyy"];
            
            if (!alerta._isDirty)
                [alerta addAlerta:YES];
            else
                [alerta updateAlerta:YES];
        }
        alerta = nil;
        
        YTOAppDelegate * delegate = (YTOAppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate refreshAlerte];
    }
}

#pragma mark NSXMLParser Methods
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if (paramForRequest == 1) {
        if ([elementName isEqualToString:@"AccountForgotPasswordResult"]) {
            raspuns = currentElementValue;
        }
    }else if (paramForRequest == 2)
    {
        if ([elementName isEqualToString:@"AccountLoginResult"]){
            raspuns = currentElementValue;
        }
        
    }else if (paramForRequest == 3)
    {
        if ([elementName isEqualToString:@"RegisterIdContResult"]){
            raspuns = currentElementValue;
        }
        
    }else if (paramForRequest == 4)
    {
        if (![elementName isEqualToString:@"ExistingClientResponse"]
            && ![elementName isEqualToString:@"soap:Envelope"]
            && ![elementName isEqualToString:@"soap:Body"]) {
            
            if ([elementName isEqualToString:@"masini"])
                jsonMasini = currentElementValue;
            else if ([elementName isEqualToString:@"proprietar"])
                jsonProprietar = currentElementValue;
            else if ([elementName isEqualToString:@"locuinte"])
                jsonLocuinte = currentElementValue;
            else if ([elementName isEqualToString:@"persoane"])
                jsonPersoane = currentElementValue;
            
            NSLog(@"%@=%@\n", elementName, currentElementValue);
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

#pragma POPUP
- (void) showLoading
{
    [vwLoading setHidden:NO];
}
- (IBAction) hideLoading
{
    [vwLoading setHidden:YES];
}

int back = 0;

- (void) showPopup:(NSString *)title withDescription:(NSString *)description withColor:(UIColor *) color
{
    [lblPopUpDescription setHidden:NO];
    [lblPopUpDescription setText:description];
    [lblPopUpTitlu setText:title];
    [lblPopUpTitlu setTextColor:[YTOUtils colorFromHexString:rosuProfil]];
    [vwLoading setHidden:YES];
    [vwPopup setHidden:NO];
    if ([description isEqualToString:@"Ai fost logat cu succes"]){
        back = 1;
        //[YTOUserDefaults setSyncronized:NO];
    }
    else back = 0;
}

- (void) onPreviousScreen
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) registerCont
{
    YTOAppDelegate * appDelegate = (YTOAppDelegate*)[[UIApplication sharedApplication] delegate];
    YTORegisterViewController *aView = [[YTORegisterViewController alloc] init];
    if (IS_IPHONE_5)
        aView = [[YTORegisterViewController alloc] initWithNibName:@"YTORegisterViewController_R4" bundle:nil];
    else aView = [[YTORegisterViewController alloc] initWithNibName:@"YTORegisterViewController" bundle:nil];
    aView.navigationItem.title = NSLocalizedStringFromTable(@"i233", [YTOUserDefaults getLanguage],@"Inregistrare");
    [appDelegate.contNavigationController pushViewController:aView animated:YES];

}

@end
