//
//  YTOSumarLocuintaViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/8/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import "YTOLocuinta.h"
#import "CotatieLocuinta.h"

@interface YTOSumarLocuintaViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *tableView;
    
    UITableViewCell * cellHeader;
    UITableViewCell * cellPers1;
    UITableViewCell * cellSumar1;
    UITableViewCell * cellProdus;
    UITableViewCell * cellCalculeaza;
}

@property (nonatomic, retain) YTOOferta         * oferta;
@property (nonatomic, retain) YTOPersoana       * asigurat;
@property (nonatomic, retain) YTOLocuinta       * locuinta;
@property (nonatomic, retain) CotatieLocuinta   * cotatie;
- (void) initCells;


@end
