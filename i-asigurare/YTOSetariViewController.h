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
#import "YTOLocuinta.h"
#import "YTOPersoana.h"
#import "YTOAlerta.h"


@interface YTOSetariViewController : UIViewController<NSXMLParserDelegate, UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * tableView;
    UITableViewCell * cellHeader;
    UITableViewCell * cellProfilulMeu;
    UITableViewCell * cellMasinileMele;
    UITableViewCell * cellLocuinteleMele;
    UITableViewCell * cellAltePersoane;
    UITableViewCell * cellComenzileMele;
    UITableViewCell * cellCont;
    
    IBOutlet UIImageView * imgAnimation;
    
    // SYNC
    NSMutableArray       * listaObiecte;
    YTOAutovehicul       * masina;
    YTOLocuinta          * locuinta;
    YTOPersoana          * persoana;
    YTOAlerta            * alerta;
    
    NSMutableData        * responseData;
	NSMutableData        * capturedCharactes;
	NSMutableString      * currentElementValue;
    NSString             * jsonMasini;
    NSString             * jsonProprietar;
    NSString             * jsonLocuinte;
    NSString             * jsonPersoane;
    
    BOOL        canUpdate;

    
    IBOutlet UIView      * vwLoading;
    
    // Custom Alert
    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    IBOutlet UITableViewCell *cellBlank;
    IBOutlet UIView      * vwServiciu;
    IBOutlet UILabel     * lblServiciuDescription;
    UIRefreshControl     * refreshControl;
    
    IBOutlet UIView      * vwPopup;
    IBOutlet UILabel     * lblLoad;
    
    IBOutlet UITableViewCell * cellHead;
    IBOutlet UILabel * lblMultumim1;
    IBOutlet UILabel * lblSorry1;
    IBOutlet UILabel * lblEroare;
    IBOutlet UILabel * lblEroare2;
    
    IBOutlet UIView * vwDeCeInfo;
    IBOutlet UIButton *btnDeCeInfo;
    IBOutlet UIView *vwBtnDeCeInfo;
    IBOutlet UIButton * btnDeCeInfoTable;
    IBOutlet UIWebView * webView;
    
    UIButton * logInButton;
    UIButton * registerButton;
}

@property (nonatomic, retain) NSMutableData * responseData;

- (void) initCells;
- (void) reloadData;
- (void) startLoadingAnimantion;
- (void) stopLoadingAnimantion;
- (void) showPopupServiciu:description;
- (void) showCustomLoading;

- (IBAction) hidePopup;
- (IBAction) hideCustomLoading;
- (IBAction) hidePopupServiciu;

- (IBAction)hideDeCeInfo:(id)sender;
- (IBAction)showDeCeInfo:(id)sender;

@end
