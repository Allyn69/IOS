//
//  YTOFinalizareRCAViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/30/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>


@interface YTOFinalizareRCAViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource, PickerVCSearchDelegate>
{
    IBOutlet UITableView *      tableView;
    UITextField *               activeTextField;
    
    UITableViewCell *           cellJudetLocalitate;
    UITableViewCell *           cellAdresa;
    UITableViewCell *           cellTelefon;
    UITableViewCell *           cellEmail;
    UITableViewCell *           cellTotal;
    UITableViewCell *           cellSumar;
    IBOutlet UITableViewCell *  cellPlata;
    UITableViewCell *           cellCalculeaza;
    UITableViewCell *           cellCostLivrare;
    UITableViewCell *           cellVoucher;
    
    IBOutlet UIActivityIndicatorView * loadCost;
    
    BOOL goingBack;
    
    NSString * judetLivrare;
    NSString * localitateLivrare;
    NSString * adresaLivrare;
    NSString * telefonLivrare;
    NSString * emailLivrare;
    float costVoucher;
    int modPlata;
    BOOL firstTime;
    
   	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString	* idOferta;
	NSString    * mesajFinal;
    int comanda1cost2;
    
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
    
    IBOutlet UIView      *      vwLoading;
    IBOutlet UILabel     * lblLoading;
    IBOutlet UIActivityIndicatorView * loading;
    IBOutlet UIImageView * imgLoading;
    IBOutlet UIButton    * btnClosePopup;
    
    BOOL saveAsigurat;
    UIView * viewTooltip;
    YTOPersoana * proprietar;
    
    UITextField * txtEmailLivare;
    UITextField * txtTelefonLivrare;
    UITextField * txtCodVoucher;
    
    SLComposeViewController *mySLComposerSheet;
    
    IBOutlet UILabel     * lblModPlata;
    IBOutlet UILabel     * lblCashLaLivrare;
    IBOutlet UILabel     * lblPrinOP;
    IBOutlet UILabel     * lblOnlineCuCard;
    IBOutlet UILabel * lblEroare;
    
    IBOutlet UITableViewCell * cellHeader;
    
    NSString * costLivrare;
    NSString * idLivrare;
}

@property (nonatomic, retain) YTOOferta *       oferta;
@property (nonatomic, retain) YTOPersoana *     asigurat;
@property (nonatomic, retain) YTOAutovehicul *  masina;
@property (nonatomic, retain) NSMutableData * responseData;

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
