//
//  YTOLoginViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 14/01/14.
//
//

#import "PickerVCSearch.h"
#import "YTOPersoana.h"


@interface YTORegisterViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UITableViewCell * cellHead;
    UITableViewCell * cellUser;
    UITableViewCell * cellUserConfirm;
    UITableViewCell * cellPassword;
    UITableViewCell * cellPasswordConfirm;
    UITableViewCell * cellRegister;
    
    // PENTRU REQUEST-uri
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
    
    BOOL isOkToRegister;
    BOOL emailIsOK;
    BOOL wasEmailChecked;
    int paramForRequest;
    
    // PENTRU LOADING
    IBOutlet UIView     * vwLoading;
    IBOutlet UILabel    * lblTitluPopupSus;
    IBOutlet UIView     * vwPopup;
    IBOutlet UILabel    * lblPopupTitlu;
    IBOutlet UILabel    * lblPopupDescription;
    IBOutlet UIButton   * btnPopupOk;
    IBOutlet UILabel    * lblLoadingOk;
    IBOutlet UIActivityIndicatorView * loading;
    
    UITextField * txtUser;
    UITextField * txtPassword;
    UITextField * txtUserConfirm;
    UITextField * txtPasswordConfirm;
    
    BOOL keyboardFirstTimeActive;
}

@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) NSMutableArray * fieldArray;
@property (nonatomic, retain) UIViewController * controller;

- (void) initCells;

- (void) showLoading;
- (IBAction) hideLoading;
- (IBAction)hidePopup:(id)sender;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

@end
