//
//  YTOAsiguratViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOPersoana.h"

@interface YTOAsiguratViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UIBarButtonItem * btnDone;
    IBOutlet UIView * vwTooltip;
    IBOutlet UILabel * lblTootlip;
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
}

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
@end
