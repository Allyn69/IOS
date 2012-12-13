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
    IBOutlet UITableViewCell * cellReduceri;
    IBOutlet UITableViewCell * cellTipPersoana;
    UITableViewCell * cellSC;
    IBOutlet UIButton * btnCasatorit;

    BOOL goingBack;
    BOOL shouldSave;
    
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
    
    UITextField * txtNume;
    UITextField * txtCodUnic;
    UITextField * txtAdresa;
    UITextField * txtTelefon;
    UITextField * txtEmail;
}

@property (nonatomic, retain) NSMutableData * responseData;

@property (nonatomic, retain) YTOPersoana *      asigurat;
@property (nonatomic, retain) UIViewController * controller;
@property BOOL                                   proprietar;
@property BOOL                                   persoanaFizica;

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

// Props
- (void) setNume:(NSString *)v;
- (void) setcodUnic:(NSString *)v;
- (void) setJudet:(NSString *)v;
- (NSString *) getJudet;
- (void) setLocalitate:(NSString *)v;
- (NSString *) getLocalitate;
- (NSString *) getLocatie;
- (void) setAdresa:(NSString *)v;
- (void) setTelefon:(NSString *)v;
- (void) setEmail:(NSString *)v;

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;
@end
