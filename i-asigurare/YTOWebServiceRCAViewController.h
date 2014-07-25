//
//  YTOWebServiceRCAViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/20/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "CotatieRCA2.h"
#import "TarifRCA.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"
#import "YTOOferta.h"
#import "YTOCustomPopup.h"


@interface YTOWebServiceRCAViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource, YTOCustomPopupDelegate> {
    
	NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	
	//CotatieRCA * cotatie;
	NSMutableArray * listTarife;
	YTOAppDelegate * appDelegate;
    
    NSString *              jsonString;


    // LOADING
    IBOutlet UIView *       vwLoading;
    IBOutlet UIImageView *  imgLoading;

    // Custom POPUP
    IBOutlet UIView  *      vwPopup;
    IBOutlet UILabel *      lblPopupTitle;
    IBOutlet UILabel *      lblPopupDescription;
    
    IBOutlet UITableView *  tableView;
    IBOutlet UIButton *     btnTarif;
    IBOutlet UILabel *     lblTarif;
    
    IBOutlet UIImageView * imgDurata;
    IBOutlet UILabel     * lbl6Luni;
    IBOutlet UILabel     * lbl12Luni;
    
    IBOutlet UIView      * vwErrorAlert;
    IBOutlet UIButton    * btnErrorAlertOK;
    IBOutlet UIButton    * btnErrorAlertNO;
    
    IBOutlet UIView      * vwDetailErrorAlert;
    IBOutlet UIButton    * btnDetailErrorAlertOK;
    
    IBOutlet UIView      * vwPopupError;
    IBOutlet UILabel     * lblPopupErrorTitle;
    IBOutlet UILabel     * lblPopupErrorDescription;
    
    IBOutlet UIView      * vwServiciu;
    IBOutlet UILabel     * lblServiciuDescription;
    
    IBOutlet UILabel     * lblB01;
    IBOutlet UILabel     * lblB02;
    IBOutlet UILabel     * lblB03;
    IBOutlet UILabel     * lblB04;
    //cell BO
    
    IBOutlet UILabel     * lblLoad1;
    IBOutlet UILabel     * lblLoad2;
    IBOutlet UILabel     * lblLoad0;
    
    IBOutlet UILabel     * lblNointernet;
    IBOutlet UILabel     * lblTarifeleNu;
    IBOutlet UILabel     * lblDetaliiEroare;
    
    IBOutlet UILabel     * lblCauze1;
    IBOutlet UILabel     * lblCauze2;
    IBOutlet UILabel     * lblCauze3;
    IBOutlet UILabel     * lblCauze4;
    
    IBOutlet UIImageView * imgArrow;
    
    IBOutlet UITableViewCell * cellHead;
    
    IBOutlet UIView *cellB0;
    BOOL B0Closed;
    
    NSMutableData * responseCalcul6Luni;
    NSMutableData * responseCalcul12Luni;
    
    IBOutlet UILabel * lblMultumim1;
    IBOutlet UILabel * lblMultumim2;
    IBOutlet UILabel * lblSorry1;
    IBOutlet UILabel * lblSorry2;
    IBOutlet UILabel * lblDetaliiErr1;
    IBOutlet UILabel * lblEroare;
    IBOutlet UILabel * lblEroare2;
}

@property (nonatomic, retain) CotatieRCA2 * cotatie;
//@property (nonatomic, retain) NSMutableArray * listTarife;
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) YTOAutovehicul *  masina;
@property (nonatomic, retain) YTOPersoana *     asigurat;
@property (nonatomic, retain) YTOOferta *       oferta;



- (IBAction)calculeazaRCADupaAltaDurata;
- (void) calculRCA;
- (NSString *) XmlRequest;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;

- (void) showPopupWithTitle:(NSString *)title;// andDescription:(NSString *)description;
- (void) showPopupErrorWithTitle:(NSString *)title andDescription:(NSString *)description;
- (void) showPopupServiciu:description;

- (IBAction) hidePopupError;
- (IBAction) hidePopup:(id)sender;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
- (IBAction) hidePopupServiciu;
- (IBAction)hideB0:(id)sender;

@end
