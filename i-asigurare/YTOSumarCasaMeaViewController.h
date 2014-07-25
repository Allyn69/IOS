//
//  YTOSumarCasaMeaViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 29/04/14.
//
//

#import <UIKit/UIKit.h>
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import "YTOLocuinta.h"
#import "CotatieLocuinta.h"

@interface YTOSumarCasaMeaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    
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
    
    IBOutlet UITableViewCell * cellHeader;
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
}

@property (nonatomic, retain) YTOOferta         * oferta;
@property (nonatomic, retain) YTOPersoana       * asigurat;
@property (nonatomic, retain) YTOLocuinta       * locuinta;
@property (nonatomic, retain) NSDate *   DataInceput;
- (void) initCells;


@end
