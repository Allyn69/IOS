//
//  YTOSetariViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/19/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOAutovehicul.h"

@interface YTOSetariViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * tableView;
    UITableViewCell * cellHeader;
    UITableViewCell * cellProfilulMeu;
    UITableViewCell * cellMasinileMele;
    UITableViewCell * cellLocuinteleMele;
    UITableViewCell * cellAltePersoane;
    UITableViewCell * cellComenzileMele;
    
    IBOutlet UIImageView * imgAnimation;
    
    // SYNC
    NSMutableArray       * listaObiecte;
    YTOAutovehicul       * masina;
    NSMutableData        * responseData;
	NSMutableData        * capturedCharactes;
	NSMutableString      * currentElementValue;
    NSString             * jsonMasini;
    NSString             * jsonProprietar;
    
    IBOutlet UIView      * vwLoading;
    
    // Custom Alert
    IBOutlet UIImageView * imgError;
    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    
    IBOutlet UIView      * vwServiciu;
    IBOutlet UILabel     * lblServiciuDescription;
    
    IBOutlet UIView      * vwPopup;
}

@property (nonatomic, retain) NSMutableData * responseData;

- (void) initCells;
- (void) reloadData;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;
- (void) showPopupServiciu:description;
- (void) showPopup;
- (void) showCustomLoading;

- (IBAction) hidePopup;
- (IBAction) hideCustomLoading;
- (IBAction) hidePopupServiciu;

@end
