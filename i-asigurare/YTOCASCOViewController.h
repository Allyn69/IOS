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

#import <Social/Social.h>

@interface YTOCASCOViewController : UIViewController<NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    IBOutlet UITableView     *  tableView;
    UITableViewCell          *  cellMasina;
    UITableViewCell          *  cellProprietar;
    UITableViewCell          *  cellNrKm;
    UITableViewCell          *  cellCuloare;
    IBOutlet UITableViewCell *  cellNrRate;
    IBOutlet UITableViewCell *  cellPF;
    IBOutlet UILabel         *  lblPF;
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
    
    IBOutlet UIView      * vwDateleMele;
    IBOutlet UIButton    * btnDateleMele;
    IBOutlet UILabel     * lblDateleMele;
    
    IBOutlet UIButton    * btnCustomFacebook;
    IBOutlet UILabel     * lblCustomFacebook;
    IBOutlet UIButton    * btnCustomTwitter;
    IBOutlet UILabel     * lblCustomTwitter;
    
    IBOutlet UILabel * lblInfoReduceri;
    IBOutlet UILabel * lblAlegeCasco;
    
    IBOutlet UILabel * lblCumPlatesti;
    IBOutlet UILabel * lblIntegral;
    IBOutlet UILabel * lbl2Rate;
    IBOutlet UILabel * lbl4Rate;
    
    IBOutlet UIView     * vwPlatinum;
    IBOutlet UILabel    * lblPlatinum;
    IBOutlet UILabel    * lblBtnOkPlatinum;
    IBOutlet UILabel    * lblBtnNoPlatinum;
    
    IBOutlet UITableViewCell  * cellHeader;
    
    IBOutlet UILabel * lblMultumim1;
    IBOutlet UILabel * lblMultumim2;
    IBOutlet UILabel * lblMultumim3;
    IBOutlet UILabel * lblMultumim4;
    IBOutlet UILabel * lblSorry1;
    IBOutlet UILabel * lblSorry2;
    IBOutlet UILabel * lblDetaliiErr1;
    IBOutlet UILabel * lblImportant;
    IBOutlet UILabel * lblEroare;
    IBOutlet UILabel * lblComandaOK1;
    IBOutlet UILabel * lblDateIncomplete;

    
    
    SLComposeViewController *mySLComposerSheet;
    
    BOOL cautLegaturaDintreMasinaSiAsigurat;
    
    UITextField * txtNumarKm;
    UITextField * txtCuloare;
    
    int nrRate;
    
    int index;
    
    BOOL isOK;
    //BOOL updateOnServer;
    
    
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



@property BOOL isWrongAuto;
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
- (void) showDateleMele:description;

- (IBAction) hideMessage:(id)sender;
- (IBAction) hidePopupServiciu;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
- (IBAction) hidePopup;
- (IBAction) hideDateleMele;
- (IBAction) hideButtonSocialMedia:(id)sender;

@end
