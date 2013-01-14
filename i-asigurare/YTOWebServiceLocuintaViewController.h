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
- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description;

- (IBAction) hideErrorAlert:(id)sender;
- (IBAction) hideDetailErrorAlert;

@end
