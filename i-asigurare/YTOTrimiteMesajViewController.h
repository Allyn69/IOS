//
//  YTOTrimiteMesajViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/25/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"

@interface YTOTrimiteMesajViewController : UIViewController<NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    IBOutlet UITableView * tableView;
    UITableViewCell * cellEmail;
    UITableViewCell * cellTelefon;
    UITableViewCell * cellSubiect;
    IBOutlet UITableViewCell * cellDescriere;
    UITableViewCell * cellTrimite;
    
    UITextField * activeTextField;
    UITextView  * activeTextView;
    IBOutlet UIBarButtonItem * btnDone;
    
    YTOPersoana * proprietar;
    
    IBOutlet UIView     * vwLoading;
    IBOutlet UILabel    * lblLoadingTitlu;
    IBOutlet UILabel    * lblLoadingDescription;
    IBOutlet UIButton   * btnLoadingOk;
    IBOutlet UILabel    * lblLoadingOk;
    IBOutlet UIActivityIndicatorView * loading;
    
    IBOutlet UIView      * vwPopup;
    IBOutlet UILabel     * lblPopupTitle;
    IBOutlet UILabel     * lblPopupDescription;
    
    NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString    * jsonResponse;
    
    NSString    * email;
    NSString    * telefon;
    NSString    * subiect;
    NSString    * descriere;
    
    UITextField * txtEmail;
    UITextField * txtTelefon;
    UITextField * txtSubiect;
    UITextField * txtDescriere;
}

@property (nonatomic, retain) NSMutableData * responseData;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) setEmail:(NSString *)v;
- (void) setTelefon:(NSString *)v;
- (void) setSubiect:(NSString *)v;
- (void) setDescriere:(NSString *)v;

- (IBAction)callTrimiteMesaj;

- (void) showPopupError:(NSString *)title;
- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

- (IBAction) hidePopupError;

@end
