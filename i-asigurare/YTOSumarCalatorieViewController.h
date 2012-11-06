//
//  YTOSumarCalatorieViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/11/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOOferta.h"
#import "CotatieCalatorie.h"

@interface YTOSumarCalatorieViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    
    UITableViewCell * cellHeader;
    UITableViewCell * cellPers1;
    UITableViewCell * cellSumar1;
    UITableViewCell * cellProdus;
    UITableViewCell * cellCalculeaza;
}

@property (nonatomic, retain) NSMutableArray   * listAsigurati;
@property (nonatomic, retain) YTOOferta        * oferta;
@property (nonatomic, retain) CotatieCalatorie * cotatie;

- (void) initCells;

@end
