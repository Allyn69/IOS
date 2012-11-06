//
//  YTOFormAlertaViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/29/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOAlerta.h"
#import "YTOAutovehicul.h"
#import "YTOLocuinta.h"

@interface YTOFormAlertaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView     * tableView;
    UITableViewCell          * cellHeader;
    IBOutlet UITableViewCell * cellTipAlerta;
    UITableViewCell          * cellObiectAsigurat;
    IBOutlet UITableViewCell * cellEsteRata;
    UITableViewCell          * cellDataAlerta;
    UITableViewCell          * cellSC;
    
    IBOutlet UIView          * vwNomenclator;
    NSMutableArray           * listTipAlerta;
    
    BOOL                       areRata;
    BOOL                       goingBack;
    UITextField              * activeTextField;
}

@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;

@property (nonatomic, retain) UIViewController * controller;
@property (nonatomic, retain) YTOAlerta * alerta;

- (void) setAutovehicul:(YTOAutovehicul *)masina;
- (void) setLocuinta:(YTOLocuinta *)loc;
- (void) initCells;
- (void) loadAlerta;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)checkboxRataSelected:(id)sender;

- (void) setTipAlerta:(NSString *) v;
- (void) setDataAlerta:(NSString *) v;
- (void) setEsteRata:(NSString *)v;
- (void) loadListTipAlerta;

- (void) showNomenclator;
-(IBAction) hideNomenclator;
@end
