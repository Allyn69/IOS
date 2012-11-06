//
//  YTOCalatorieViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOOferta.h"

@interface YTOCalatorieViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;
    IBOutlet UITableViewCell * cellScopCalatorie;
    IBOutlet UITableViewCell * cellSumaAsigurata;
    UITableViewCell * cellHeader;
    UITableViewCell * cellNrZile;
    UITableViewCell * cellDataInceput;
    UITableViewCell * cellTaraDestinatie;
    UITableViewCell * cellTranzit;
    UITableViewCell * cellCalatori;
    UITableViewCell * cellCalculeaza;
    
    NSMutableArray * listaAsigurati;
    NSMutableArray * listaAsiguratiIndecsi;
    BOOL goingBack;
    
    YTOOferta * oferta;
    NSString * scopCalatorie;
    int        nrZile;
    NSString * taraDestinatie;
    NSString * tranzit;
    NSString * sumaAsigurata;
}

- (IBAction) nrZileStepper_Changed:(id)sender;
- (IBAction) dateStepper_Changed:(id)sender;
- (IBAction) btnScop_Clicked:(id)sender;
- (IBAction) btnSA_Clicked:(id)sender;

- (void) initCells;
- (void) showTaraDestinatieList:(NSIndexPath *)index;

// Properties
- (void) setDataInceput:(NSDate *)DataInceput;
- (void) setScopCalatorie:(NSString *)scop;
- (void) setSumaAsigurata:(NSString *)sa;
- (void) setNrZile:(int)zile;
- (void) setTaraDestinatie:(NSString *)tara;
- (void) setListaAsigurati:(NSMutableArray *) list withIndex:(NSMutableArray *) indexList;
- (void) setTranzit:(NSString *)v;

@end
