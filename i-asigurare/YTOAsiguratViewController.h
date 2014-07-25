//
//  YTOAsiguratViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/16/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOPersoana.h"


@interface YTOAsiguratViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PickerVCSearchDelegate, NSXMLParserDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UIBarButtonItem * btnDone;
    IBOutlet UIView * vwTooltip;
    IBOutlet UIView * vwTooltipAtentie;
    IBOutlet UIView * vwOperator;
    IBOutlet UILabel * lblTooltipAtentie;
    IBOutlet UILabel * lblTootlip;
    IBOutlet UIImageView * imgTooltip;
    YTOPersoana * asigurat;
    UITableViewCell * cellAsigurat;
    UITableViewCell * cellNume;
    UITableViewCell * cellCodUnic;
    UITableViewCell * cellJudetLocalitate;
    UITableViewCell * cellAdresa;
    UITableViewCell * cellEmail;
    UITableViewCell * cellTelefon;
    UITableViewCell * cellOperator;
    UITableViewCell * cellSerieAct;
    UITableViewCell * cellCodPostal;
    IBOutlet UITableViewCell * cellReduceri;
    IBOutlet UITableViewCell * cellTipPersoana;
    UITableViewCell * cellSC;
    IBOutlet UIButton * btnCasatorit;
    
    BOOL goingBack;
    BOOL shouldSave;
    BOOL isLogat;
    
    // PENTRU REQUEST-uri
    NSMutableData * responseData;
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
    
    // PENTRU LOADING
    IBOutlet UIView     * vwLoading;
    IBOutlet UILabel    * lblLoadingTitlu;
    IBOutlet UILabel    * lblLoadingDescription;
    IBOutlet UIButton   * btnLoadingOk;
    IBOutlet UILabel    * lblLoadingOk;
    IBOutlet UIActivityIndicatorView * loading;
    BOOL isSearching;
    IBOutlet UILabel    *lblPopupOperator;
    
    UITextField * txtNume;
    UITextField * txtCodUnic;
    UITextField * txtAdresa;
    UITextField * txtTelefon;
    UITextField * txtEmail;
    UITextField * txtSerieAct;
    UITextField * txtCodPostal;
    
    BOOL keyboardFirstTimeActive;
}

@property (nonatomic, retain) NSMutableArray * fieldArray;
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) UITextField * txtAdresa;

@property (nonatomic, retain) YTOPersoana *      asigurat;
//@property int                                    indexAsigurat;
@property (nonatomic, retain) UIViewController * controller;
@property BOOL                                   proprietar;
@property BOOL                                   persoanaFizica;
@property (readwrite) ProdusAsigurare produsAsigurare;

- (IBAction)checkboxSelected:(id)sender;
- (IBAction)btnTipPersoana_OnClick:(id)sender;

- (void) addBarButton;
- (void) deleteBarButton;
- (void) save;
- (void) salveazaPersoana;
- (void) btnSave_Clicked;
- (void) btnCancel_Clicked;
- (void) load:(YTOPersoana *)a;
- (void) initCells;
- (void) initLabels:(BOOL )pf;

- (void) showTooltip:(NSString *)tooltip;
- (void) hideTooltip;

- (void) showTooltipAtentie:(NSString *)tooltipAtentie;
- (void) hideTooltipAtentie;

// Props
- (void) setNume:(NSString *)v;
- (void) setcodUnic:(NSString *)v;
- (void) setJudet:(NSString *)v;
- (NSString *) getJudet;
- (void) setLocalitate:(NSString *)v;
- (void) setOperator:(NSString *)v;
- (NSString *) getOperator;
- (NSString *) getLocalitate;
- (NSString *) getLocatie;
- (void) setAdresa:(NSString *)v;
- (void) setTelefon:(NSString *)v;
- (void) setEmail:(NSString *)v;
- (void) setSerieAct:(NSString *)v;

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;
- (IBAction)choseOperator:(id)sender;
- (IBAction)hidePopupOperator:(id)sender;

@end
