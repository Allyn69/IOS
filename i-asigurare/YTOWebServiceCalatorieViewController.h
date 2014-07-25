//
//  YTOWebServiceCalatorieViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/31/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOPersoana.h"
#import "YTOOferta.h"
#import "CotatieCalatorie.h"
#import "CellTarifCalatorie.h"
#import "CellTarifCustom.h"


@interface YTOWebServiceCalatorieViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate, UITableViewDelegate, UITableViewDataSource> {
	NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	
	CotatieCalatorie * cotatie;
	YTOAppDelegate * appDelegate;
    
    IBOutlet UIView *       vwLoading;
    IBOutlet UIImageView *  imgLoading;
    IBOutlet UITableView *  tableView;
    IBOutlet UIButton *     btnTarif;
    
    NSString * taraDestinatie;
    
    // Custom POPUP
    IBOutlet UIView  *      vwPopup;
    IBOutlet UILabel *      lblPopupTitle;
    IBOutlet UILabel *      lblPopupDescription;
    
    IBOutlet UIImageView * imgSA;
    IBOutlet UILabel     * lbl5k;
    IBOutlet UILabel     * lbl10k;
    IBOutlet UILabel     * lbl30k;
    IBOutlet UILabel     * lbl50k;
    
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
    

    
    
    BOOL resume;
}

@property (nonatomic, retain) CotatieCalatorie * cotatie;
@property (nonatomic, retain) NSMutableArray * listTarife;
@property (nonatomic, retain) NSMutableArray * listAsigurati;
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) YTOOferta *       oferta;

- (void) calculCalatorie;
- (NSString *) XmlRequest;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;

- (void) showPopupWithTitle:(NSString *)title;
- (void) showPopupErrorWithTitle:(NSString *)title andDescription:(NSString *)description;
- (void) showPopupServiciu:description;

- (IBAction) hidePopupError;
- (IBAction) hidePopupServiciu;
- (IBAction)hidePopup:(id)sender;
- (IBAction)calculeazaDupaAltaSA:(id)sender;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
- (IBAction)noPlatinum:(id)sender;
- (IBAction)okPlatinum:(id)sender;
@end
