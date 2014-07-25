//
//  YTOMyTravelsViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 04/04/14.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOLocuinta.h"
#import "YTOOferta.h"

@interface YTOMyTravelsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UILabel         * lblHeader;
    IBOutlet UITableView     * tableView;
    UITableViewCell          * cellCalator;
    UITableViewCell          * cellAcoperiri;
    IBOutlet UITableViewCell * cellOptiuni;
    IBOutlet UITableViewCell * cellScopCalatorie;
    UITableViewCell          * cellConditii;
    IBOutlet UITableViewCell * cellTarif;
    UITableViewCell          * cellCalculeaza;
    UITableViewCell          * cellDataInceput;
    
    IBOutlet UIView          * vwServiciu;
    IBOutlet UILabel         * lblServiciuDescription;
    IBOutlet UIView          * vwLoading;
    IBOutlet UILabel         * lblEroare;
    IBOutlet UIButton        * btnCustomAlertOK;
    IBOutlet UILabel         * lblCustomAlertOK;
    IBOutlet UIButton        * btnCustomAlertNO;
    IBOutlet UILabel         * lblCustomAlertNO;
    IBOutlet UILabel         * lblCustomAlertTitle;
    IBOutlet UILabel         * lblCustomAlertMessage;
    IBOutlet UIView          * vwCustomAlert;
    IBOutlet UILabel         * lblTarif;
    IBOutlet UILabel         * lblTarifIntreg;
    IBOutlet UILabel         * sumaAsigurata;
    IBOutlet UIImageView     * acopBagaje;
    IBOutlet UIImageView     * acopSport;
    NSString                 * scopCalatorie;
    NSString                 * responseMessage;
    NSString                 * idOferta;
    NSString                 * jsonString;
    NSString                 * mesajComanda;
    IBOutlet UILabel         * lblTop;
    
    IBOutlet UIWebView *webView;
    IBOutlet UIView *wvWebView;
    
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    
    BOOL isCalculating;
    BOOL isSport;
    BOOL isBagaje;
    BOOL shouldSetAsigurat;
}

@property (nonatomic, retain) YTOPersoana *  asigurat;
@property (nonatomic, retain) YTOOferta   * oferta;
@property (nonatomic, retain) NSDate *   DataInceput;
- (IBAction)setBagaje:(id)sender;
- (IBAction)setSport:(id)sender;
- (IBAction) btnScop_Clicked:(id)sender;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction)hidePopUpServiciu:(id)sender;
- (IBAction)hideWebView:(id)sender;
- (IBAction)goToSumar:(id)sender;

@end
