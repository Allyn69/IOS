//
//  YTOCASCOViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"
#import "YTOOferta.h"

@interface YTOCASCOViewController : UIViewController<NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView     *  tableView;
    UITableViewCell          *  cellHeader;
    UITableViewCell          *  cellMasina;
    UITableViewCell          *  cellProprietar;
    UITableViewCell          *  cellNrKm;
    UITableViewCell          *  cellCuloare;
    IBOutlet UITableViewCell *  cellNrRate;
    UITableViewCell          *  cellCalculeaza;
    IBOutlet UITableViewCell *  cellAsigurareCasco;
    
    YTOPersoana     * asigurat;
    YTOAutovehicul  * masina;
    YTOOferta       * oferta;
    
    UITextField * activeTextField;
    
    IBOutlet UIView *   vwNomenclator;
    
    NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString	* idOferta;
	NSString    * mesajFinal;
    
    IBOutlet UIView      * vwPopup;
    IBOutlet UILabel     * lblPopupTitle;
    IBOutlet UILabel     * lblPopupDescription;
    
    IBOutlet UIImageView * imgError;
    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    
    IBOutlet UIView      * vwErrorAlert;
    IBOutlet UIButton    * btnErrorAlertOK;
    IBOutlet UIButton    * btnErrorAlertNO;
    
    IBOutlet UIView      * vwDetailErrorAlert;
    IBOutlet UIButton    * btnDetailErrorAlertOK;
    
    IBOutlet UIView      * vwLoading;    
    IBOutlet UILabel     * lblLoading;
    IBOutlet UIActivityIndicatorView * loading;
    IBOutlet UIImageView * imgLoading;
    IBOutlet UIButton    * btnClosePopup;
    
    IBOutlet UIView      * vwServiciu;
    IBOutlet UILabel     * lblServiciuDescription;
    
    IBOutlet UIView      * vwMessage;
    IBOutlet UIButton    * btnMessageOK;
    IBOutlet UIButton    * btnMessageNO;
    
    
    BOOL cautLegaturaDintreMasinaSiAsigurat;
    
    UITextField * txtNumarKm;
    UITextField * txtCuloare;
    
    int nrRate;
    
    BOOL isOK;
    
}
@property (nonatomic, retain) NSDate *   DataInceput;
@property (nonatomic, retain) NSMutableArray * listaCompaniiAsigurare;
@property (nonatomic, retain) NSMutableData * responseData;

// START for vwNomenclator
@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;
- (IBAction)checkboxCompanieCascoSelected:(id)sender;
- (IBAction)checkboxNrRateSelected:(id)sender;
- (void) showNomenclator;
- (IBAction) hideNomenclator;
- (IBAction) btnNomenclator_Clicked:(id)sender;
// END for vwNomenclator

- (void) initCells;
- (void) initCustomValues;

- (void)setAsigurat:(YTOPersoana *) a;
- (void)setAutovehicul:(YTOAutovehicul *)a;
- (void)setNumarKm:(int)v;
- (void)setCuloare:(NSString *)v;
- (void)setCompanieCasco:(NSString *)v;

- (void) showCustomLoading;
- (IBAction) hideCustomLoading;
- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index;
- (void) showPopup:(NSString*) title;
- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index;
- (void) showPopupServiciu:description;
- (void) showMessage;

- (IBAction) hideMessage:(id)sender;
- (IBAction) hidePopupServiciu;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
- (IBAction) hidePopup;
@end
