//
//  YTOCasaMeaViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 04/04/14.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOLocuinta.h"
#import "YTOOferta.h"

@interface YTOCasaMeaViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    
    IBOutlet UITableView     * tableView;
    
    UITableViewCell          * cellLocuinta;
    UITableViewCell          * cellProprietar;
    UITableViewCell          * cellAcoperiri;
    UITableViewCell          * cellConditii;
    IBOutlet UITableViewCell * cellTarif;
    UITableViewCell          * cellCalculeaza;
    UITableViewCell          * cellSumaAsigurata;
    UITableViewCell         * cellDataInceput;
    IBOutlet UIView          * vwServiciu;
    IBOutlet UILabel         * lblServiciuDescription;
    IBOutlet UIView          * vwLoading;
    UITextField              * activeTextField;
    
    NSString                 * responseMessage;
    NSString                 * mesajComanda;
    NSString                 * idOferta;
    IBOutlet UILabel         * lblEroare;
    IBOutlet UIButton        * btnCustomAlertOK;
    IBOutlet UILabel         * lblCustomAlertOK;
    IBOutlet UIButton        * btnCustomAlertNO;
    IBOutlet UILabel         * lblCustomAlertNO;
    IBOutlet UILabel         * lblCustomAlertTitle;
    IBOutlet UILabel         * lblCustomAlertMessage;
    IBOutlet UIView          * vwCustomAlert;
    IBOutlet UILabel         * lblSumaAsig;
    IBOutlet UILabel         * lblTarif;
    IBOutlet UILabel         * lblNumeProdus;
    
    IBOutlet UIWebView *webView;
    IBOutlet UIView *wvWebView;

    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString *              jsonString;
    IBOutlet UILabel        *lblHeader;
    
    
    BOOL shouldSet;
}

@property (nonatomic, retain) YTOPersoana *  asigurat;
@property (nonatomic, retain) YTOLocuinta *  locuinta;
@property (nonatomic, retain) YTOOferta   * oferta;
@property (nonatomic, retain) NSDate *   DataInceput;
- (IBAction)hidePopUpServiciu:(id)sender;
- (IBAction) hideCustomAlert:(id)sender;
- (IBAction)hideWebView:(id)sender;
- (IBAction)goToSumar:(id)sender;

@end
