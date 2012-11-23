//
//  YTOWebServiceRCAViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "CotatieRCA.h"
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
}

@property (nonatomic, retain) CotatieRCA * cotatie;
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

- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description;
- (IBAction)hidePopup:(id)sender;

@end
