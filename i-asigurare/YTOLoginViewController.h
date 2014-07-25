//
//  YTOLoginViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 14/01/14.
//
//

#import "PickerVCSearch.h"
#import "YTOPersoana.h"

#import "YTOAlerta.h"
#import "YTOAutovehicul.h"
#import "YTOLocuinta.h"

@interface YTOLoginViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UITableViewCell * cellHead;
    UITableViewCell * cellUser;
    UITableViewCell * cellPassword;
    UITableViewCell * cellForgotPass;
    UITableViewCell * cellLogin;
    UITableViewCell * cellRegister;
    UITableViewCell * cellDeleteAll;
    UITableViewCell * cellUserLI;
    UITableViewCell * cellSetariLI;
    UITableViewCell * cellChangePasswordLI;
    UITableViewCell * cellLogOutLI;
    
    YTOAutovehicul       * masina;
    YTOLocuinta          * locuinta;
    YTOPersoana          * persoana;
    YTOAlerta            * alerta;
    
    NSString             * jsonMasini;
    NSString             * jsonProprietar;
    NSString             * jsonLocuinte;
    NSString             * jsonPersoane;
    
    NSString * clientId;
    
    // PENTRU REQUEST-uri
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
    
    // PENTRU LOADING
    IBOutlet UIView     * vwLoading;
    IBOutlet UILabel    * lblPopUpTitlu;
    IBOutlet UILabel    * lblPopUpDescription;
    IBOutlet UIButton   * btnPopUpOk;
    IBOutlet UILabel    * lblPopUpOk;
    IBOutlet UILabel    * lblTitluPopNegru;
    IBOutlet UIView     * vwPopup;
    IBOutlet UILabel    * lblTitluHeader;
    IBOutlet UIView     * vwLogOut;
    IBOutlet UILabel    * lblTitluRosuLogOut;
    IBOutlet UILabel    * lblDescLogOut;
    IBOutlet UILabel    * lblTitluLogOut;
    IBOutlet UIActivityIndicatorView * loading;
    
    UITextField * txtUser;
    UITextField * txtPassword;
    
    BOOL keyboardFirstTimeActive;
    BOOL loggedIn;
}

@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) NSMutableArray * fieldArray;
@property (nonatomic, retain) UIViewController * controller;

- (void) forgotPassword;
- (void) initCells;

- (void) showLoading;
- (IBAction) hideLoading;
- (IBAction)hidePopup:(id)sender;
- (IBAction)hideLogOut:(id)sender;
- (IBAction)logOut:(id)sender;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description withColor:(UIColor *) color;

@end
