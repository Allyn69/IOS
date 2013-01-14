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

- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description;
- (IBAction)hidePopup:(id)sender;
- (IBAction)calculeazaDupaAltaSA:(id)sender;
- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;
@end
