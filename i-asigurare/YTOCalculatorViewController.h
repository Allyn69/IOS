//
//  YTOCalculatorViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOAppDelegate.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"
#import "YTOOferta.h"
#import "PickerVCSearch.h"

@interface YTOCalculatorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;
    IBOutlet UITableViewCell * cellTipPersoana;
    IBOutlet UITableViewCell * cellDurata;
    IBOutlet UITableViewCell * cellPF;
    IBOutlet UITableViewCell * cellPJ;
    IBOutlet UITableViewCell * cellAsiguratCasco;
    UITableViewCell * cellDataInceput;
    IBOutlet UILabel * lblDataInceput;
    IBOutlet UIStepper * dateStepper;
    IBOutlet UIButton * btnAsigurat;
    IBOutlet UIButton * btnMasina; 
    YTOPersoana * asigurat;
    YTOAutovehicul * masina;
    YTOOferta * oferta;
    
    UITextField * activeTextField;
    
    UITableViewCell * cellHeader;
    UITableViewCell * cellMasina;
    UITableViewCell * cellProprietar;
    UITableViewCell * cellCalculeaza;
    UITableViewCell * cellCodUnic;
    
    IBOutlet UIStepper * stepperAnMinimPermis;
    IBOutlet UIView *   vwNomenclator;
}

@property (nonatomic, retain) NSDate *   DataInceput;
@property (nonatomic, retain) NSString * Durata;

// START for vwNomenclator
@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;
@property (nonatomic, retain) NSMutableArray * listaCompanii;
- (IBAction)checkboxCompanieCascoSelected:(id)sender;
- (void) showNomenclator;
- (IBAction) hideNomenclator;
- (IBAction) btnNomenclator_Clicked:(id)sender;
// END for vwNomenclator

- (IBAction)selectPersoana:(id)sender;
- (void)setAsigurat:(YTOPersoana *) a;
- (void)setAutovehicul:(YTOAutovehicul *)a;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)chkTipPersoana_Selected:(id)sender;
- (IBAction)chkDurata_Selected:(id)sender;
- (IBAction)dateStepper_Changed:(id)sender;
- (IBAction)nrBugetariSepper_Changed:(id)sender;
- (IBAction)anPermisSepper_Changed:(id)sender;

- (void) showCoduriCaen:(NSIndexPath *)index;

-(IBAction) doneEditing;
- (void) addBarButton;
- (void) deleteBarButton;

- (IBAction)calculeaza;

- (void) initCells;
- (void) initCustomValues;

- (void) setPersoanaFizica:(BOOL)k;
- (void) setCodCaen:(NSString *)k;
- (void) setDurata6Luni:(BOOL)k;
- (void) setDataInceput:(NSDate *)DataInceput;
- (void) setCasatorit:(BOOL)k;
- (BOOL) getCasatorit;
- (void) setCopiiMinori:(BOOL)k;
- (BOOL) getCopiiMinori;
- (void) setPensionar:(BOOL)k;
- (BOOL) getPensionar;
- (void) setHandicap:(BOOL)k;
- (BOOL) getHandicap;
- (void) setNrBugetari:(int)k;
- (void) setAnPermis:(int)k;
- (void) setCompanieCasco:(NSString*)v;
@end
