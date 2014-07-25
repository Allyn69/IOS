//
//  YTOAsigurareViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/7/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOUtils.h"
#import "YTOOferta.h"
#import "YTOListaLocuinteViewController.h"
#import "YTOAutovehiculViewController.h"
#import "YTOCasaViewController.h"
#import "YTOListaAutoViewController.h"


@interface YTOAsigurareViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView     * tableView;
    
    UITableViewCell          * cellHeader;
    IBOutlet UITableViewCell * cellProdusAsigurare;
    UITableViewCell          * cellNumeAsigurare;
    IBOutlet UITableViewCell * cellCompanieAsigurare;
    UITableViewCell          * cellMoneda;
    UITableViewCell          * cellPrima;
    UITableViewCell          * cellDataInceput;
    UITableViewCell          * cellMasina;
    UITableViewCell          * cellLocuinta;
    UITableViewCell          * cellSC;
    
    IBOutlet UIView          * vwNomenclator;
    
    UITextField              * activeTextField;
    
    BOOL shouldSave;
    BOOL goingBack;
}

@property (nonatomic, retain) YTOAutovehicul * masina;
@property (nonatomic, retain) YTOLocuinta    * locuinta;

@property (nonatomic, retain) YTOOferta * asigurare;

- (void) initCells;

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

- (IBAction) btnTipAsigurare_Clicked:(id)sender;
- (void) setTipAsigurare:(int)v;
- (void) setNumeAsigurare:(NSString *)v;
- (void) setCompanie:(NSString*)v;
- (void) setMoneda:(NSString *)v;
- (void) setPrima:(float)v;

- (void)setAutovehicul:(YTOAutovehicul *)a;
- (void) setLocuinta:(YTOLocuinta *) a;

@end
