//
//  YTOWebServiceLocuintaViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/6/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOOferta.h"
#import "CotatieLocuinta.h"
#import "CellTarifCustom.h"
#import "YTOLocuinta.h"
#import "YTOPersoana.h"


@interface YTOWebServiceLocuintaViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate>
{
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	
	CotatieLocuinta * cotatie;
	YTOAppDelegate * appDelegate;
    
    NSString *              jsonString;
    
    IBOutlet UITableView *  tableView;
    IBOutlet UIView *       vwLoading;
    IBOutlet UIImageView *  imgLoading;
    
    // Custom POPUP
    IBOutlet UIView  *      vwPopup;
    IBOutlet UILabel *      lblPopupTitle;
    IBOutlet UILabel *      lblPopupDescription;
    
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
    
    IBOutlet UILabel     * lblLoad1;
    IBOutlet UILabel     * lblLoad2;
    IBOutlet UILabel     * lblLoad3;
    IBOutlet UILabel     * lblLoad0;
    
    IBOutlet UILabel     * lblNointernet1;
    IBOutlet UILabel     * lblNointernet2;
    IBOutlet UILabel     * lblTarifeleNu;
    IBOutlet UILabel     * lblDetaliiEroare;
    IBOutlet UILabel     * lblInchide;
    
    IBOutlet UILabel     * lblCauze1;
    IBOutlet UILabel     * lblCauze2;
    IBOutlet UILabel     * lblCauze3;
    IBOutlet UILabel     * lblCauze4;
    
    IBOutlet UIView     * vwPlatinum;
    IBOutlet UILabel    * lblPlatinum;
    IBOutlet UILabel    * lblAtentiePlatinum;
    IBOutlet UILabel    * lblBtnOkPlatinum;
    IBOutlet UILabel    * lblBtnNoPlatinum;
    
    IBOutlet UITableViewCell * cellHead;
    IBOutlet UILabel * lblMultumim1;
    IBOutlet UILabel * lblMultumim2;
    IBOutlet UILabel * lblSorry1;
    IBOutlet UILabel * lblSorry2;
    IBOutlet UILabel * lblDetaliiErr1;
    IBOutlet UILabel * lblEroare;
    IBOutlet UILabel * lblEroare2;
}

//@property (nonatomic, retain) CotatieCalatorie * cotatie;
@property (nonatomic, retain) NSMutableArray    * listTarife;
@property (nonatomic, retain) NSMutableData     * responseData;
@property (nonatomic, retain) YTOOferta         * oferta;
@property (nonatomic, retain) YTOLocuinta       * locuinta;
@property (nonatomic, retain) YTOPersoana       * asigurat;

- (void) calculLocuinta;
- (NSString *) XmlRequest;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;
- (void) showPopupWithTitle:(NSString *)title; //andDescription:(NSString *)description;
- (void) showPopupErrorWithTitle:(NSString *)title andDescription:(NSString *)description;
- (void) showPopupServiciu:description;

- (IBAction) hidePopupError;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
- (IBAction) hidePopupServiciu;

- (IBAction)noPlatinum:(id)sender;
- (IBAction)okPlatinum:(id)sender;

@end
