//
//  YTOTrimiteMesajViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/25/12.
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
    
    NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString    * jsonResponse;
    
    NSString    * email;
    NSString    * telefon;
    NSString    * subiect;
    NSString    * descriere;
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

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

@end
