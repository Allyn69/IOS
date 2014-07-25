//
//  YTOFinalizareCalatorieViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/12/12.
//
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import <Social/Social.h>

#import "CotatieCalatorie.h"

@interface YTOFinalizareCalatorieViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;

    IBOutlet UIView      *      vwLoading;
    UITextField *               activeTextField;
    
    UITableViewCell *           cellSerie;
    UITableViewCell *           cellJudetLocalitate;
    UITableViewCell *           cellAdresa;
    UITableViewCell *           cellTelefon;
    UITableViewCell *           cellEmail;
    IBOutlet UITableViewCell *  cellPlata;
    UITableViewCell *           cellCalculeaza;
       
    
    BOOL goingBack;
    
    NSMutableArray * listCells;
    NSString * seriePasaport;
    NSString * telefonLivrare;
    NSString * emailLivrare;
    int modPlata;
    
   	NSMutableData   * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString        * responseMessage;
	NSString        * idOferta;
	NSString        * mesajFinal;
    

    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    IBOutlet UIButton    * btnCustomFacebook;
    IBOutlet UILabel     * lblCustomFacebook;
    IBOutlet UIButton    * btnCustomTwitter;
    IBOutlet UILabel     * lblCustomTwitter;
    
    UITextField * txtSerie;
    UITextField * txtEmailLivrare;
    UITextField * txtTelefonLivrare;
    
    IBOutlet UILabel     * lblSeIncarca;
    IBOutlet UILabel     * lblOnlineCuCardul;
    IBOutlet UILabel     * lblModPlata;
    IBOutlet UILabel * lblEroare;
    
    UIView * viewTooltip;
    SLComposeViewController *mySLComposerSheet;
    
    IBOutlet UITableViewCell * cellHeader;
    
}

@property (nonatomic, retain) YTOOferta         * oferta;
@property (nonatomic, retain) NSMutableArray    * listAsigurati;
@property (nonatomic, retain) NSMutableData     * responseData;
@property (nonatomic, retain) CotatieCalatorie * cotatie;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) setSerieAct:(NSString *)serie forIndex:(int)index;
- (void) setEmail:(NSString *)email;
- (void) setTelefon:(NSString *)telefon;
- (void) setTipPlata:(NSString *)p;

- (void) showCustomLoading;
- (IBAction) hideCustomLoading;
- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index;
- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction) hideButtonSocialMedia:(id)sender;

@end
