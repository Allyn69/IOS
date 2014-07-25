//
//  YTOCalculatorViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
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
    //YTOPersoana * asigurat;
    YTOAutovehicul * masina;
    YTOOferta * oferta;
    UITextField * activeTextField;
    
    UITableViewCell * cellHeader;
    UITableViewCell * cellMasina;
    UITableViewCell * cellProprietar;
    UITableViewCell * cellCalculeaza;
    UITableViewCell * cellCodUnic;

    IBOutlet UIView *   vwNomenclator;
    
    BOOL cautLegaturaDintreMasinaSiAsigurat;
    
    IBOutlet UILabel * lblInfoReduceri;
    IBOutlet UILabel * lblAlegeCasco;
    
}
@property (nonatomic, retain) YTOPersoana *  asigurat;
@property (nonatomic, retain) NSDate *   DataInceput;
@property (nonatomic, retain) NSString * Durata;



// START for vwNomenclator
@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;
@property (nonatomic, retain) NSMutableArray * listaCompanii;

@property BOOL isWrongAuto;
- (IBAction)checkboxCompanieCascoSelected:(id)sender;
- (void) showNomenclator;
- (IBAction) hideNomenclator;
- (IBAction) btnNomenclator_Clicked:(id)sender;
// END for vwNomenclator

- (IBAction)selectPersoana:(id)sender;
//- (void)setAsigurat:(YTOPersoana *) a;
- (void)setAutovehicul:(YTOAutovehicul *)a;

- (IBAction)dateStepper_Changed:(id)sender;

- (void) showCoduriCaen:(NSIndexPath *)index;

-(IBAction) doneEditing;
- (void) addBarButton;
- (void) deleteBarButton;

- (IBAction)calculeaza;

- (void) initCells;
- (void) initCustomValues;

- (void) setPersoanaFizica:(BOOL)k;
- (void) setCodCaen:(NSString *)k;
- (void) setDataInceput:(NSDate *)DataInceput;

- (void) setCompanieCasco:(NSString*)v;


@end
