//
//  YTOCASCOViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/8/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"
#import "YTOOferta.h"

@interface YTOCASCOViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView     *  tableView;
    UITableViewCell          *  cellHeader;
    UITableViewCell          *  cellMasina;
    UITableViewCell          *  cellProprietar;
    UITableViewCell          *  cellNrKm;
    UITableViewCell          *  cellCalculeaza;
    IBOutlet UITableViewCell *  cellAsigurareCasco;
    
    YTOPersoana     * asigurat;
    YTOAutovehicul  * masina;
    YTOOferta       * oferta;
    
    UITextField * activeTextField;
    
    IBOutlet UIView *   vwNomenclator;
}
@property (nonatomic, retain) NSDate *   DataInceput;
@property (nonatomic, retain) NSMutableArray * listaCompaniiAsigurare;

// START for vwNomenclator
@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;
- (IBAction)checkboxCompanieCascoSelected:(id)sender;
- (void) showNomenclator;
- (IBAction) hideNomenclator;
- (IBAction) btnNomenclator_Clicked:(id)sender;
// END for vwNomenclator

- (void) initCells;
- (void) initCustomValues;

- (void)setAsigurat:(YTOPersoana *) a;
- (void)setAutovehicul:(YTOAutovehicul *)a;
- (void)setNumarKm:(int)v;
- (void)setCompanieCasco:(NSString *)v;

@end
