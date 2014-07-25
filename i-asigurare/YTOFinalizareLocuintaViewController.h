//
//  YTOFinalizareLocuintaViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/8/12.
//
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import "YTOLocuinta.h"
#import <Social/Social.h>


@interface YTOFinalizareLocuintaViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;
    
    IBOutlet UIView      *      vwLoading;
    UITextField *               activeTextField;
    
    UITableViewCell *           cellJudetLocalitate;
    UITableViewCell *           cellAdresa;
    UITableViewCell *           cellTelefon;
    UITableViewCell *           cellEmail;
    UITableViewCell *           cellCesiune;
    UITableViewCell *           cellCuiBanca;
    IBOutlet UITableViewCell *  cellPlata;
    UITableViewCell *           cellCalculeaza;
    IBOutlet UIButton    * btnCustomFacebook;
    IBOutlet UILabel     * lblCustomFacebook;
    IBOutlet UIButton    * btnCustomTwitter;
    IBOutlet UILabel     * lblCustomTwitter;
    
    SLComposeViewController *mySLComposerSheet;

    
    BOOL goingBack;
    
    NSString * judetLivrare;
    NSString * localitateLivrare;
    NSString * adresaLivrare;
    NSString * telefonLivrare;
    NSString * emailLivrare;
    int modPlata;
    
   	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString	* idOferta;
	NSString    * mesajFinal;
    
    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    
    UITextField * txtEmailLivrare;
    UITextField * txtTelefonLivrare;
    UITextField * txtCesiune;
    UITextField * txtCuiBanca;
    
    IBOutlet UILabel * lblEroare;
    IBOutlet UILabel     * lblModPlata;
    IBOutlet UILabel     * lblPlataOP;
    IBOutlet UILabel     * lblCard;
    IBOutlet UILabel     * lblLoading;
    

    
    YTOPersoana * proprietar;
    
    IBOutlet UITableViewCell * cellHeader;
    
    UIView * viewTooltip;
}


@property (nonatomic, retain) YTOOferta *       oferta;
@property (nonatomic, retain) YTOPersoana *     asigurat;
@property (nonatomic, retain) YTOLocuinta *     locuinta;
@property (nonatomic, retain) NSMutableData *   responseData;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;
- (void) setJudet:(NSString *)judet;
- (void) setLocalitate:(NSString *)localitate;
- (void) setAdresa:(NSString *)adresa;
- (void) setEmail:(NSString *)email;
- (void) setTelefon:(NSString *)telefon;
- (void) showListaJudete:(NSIndexPath *)index;
- (IBAction)btnTipPlata_Clicked:(id)sender;
- (void) setTipPlata:(NSString *)p;

- (void) showCustomLoading;
- (IBAction) hideCustomLoading;
- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index;
- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction) hideButtonSocialMedia:(id)sender;

@end
