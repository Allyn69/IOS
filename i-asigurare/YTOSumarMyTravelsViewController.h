//
//  YTOSumarMyTravelsViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 28/04/14.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOOferta.h"
#import "CotatieCalatorie.h"

@interface YTOSumarMyTravelsViewController  : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    
    IBOutlet UITableViewCell * cellHeader;
    UITableViewCell * cellPers1;
    UITableViewCell * cellSumar1;
    UITableViewCell * cellProdus;
    UITableViewCell * cellCalculeaza;
    NSString                 * responseMessage;
    NSString                 * idOferta;
    NSString                 * jsonString;
    NSString                 * mesajComanda;
    
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
    IBOutlet UILabel         * lblEroare1;
    
    IBOutlet UIWebView *webView;
    IBOutlet UIView *wvWebView;
    IBOutlet UILabel *lblHeader;
    
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    
    BOOL isCalculating;
    
}

@property (nonatomic, retain) YTOPersoana      * asigurat;
@property (nonatomic, retain) YTOOferta        * oferta;
@property (nonatomic, retain) NSString        * scopCalatorie;
@property (nonatomic, retain) NSDate *   DataInceput;

- (void) initCells;
- (IBAction)hideWebView:(id)sender;

@end
