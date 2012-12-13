//
//  YTOListaAsiguratiViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/17/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOPersoana.h"
#import "YTOUtils.h"

@interface YTOListaAsiguratiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView *  tableView;
    
    IBOutlet UIView *       vwInfoCalatorie;
    NSMutableArray *        listaAsigurati;

    YTOPersoana *           activePersoana;
    IBOutlet UILabel *      lblPersoanaActiva;
    IBOutlet UIView * vwEmpty;
    BOOL editingMode;
    
    IBOutlet UILabel * lblOk;
    IBOutlet UIButton * btnOk;
    
    BOOL goingBack;
}

@property (nonatomic, retain) NSMutableArray *         listaAsiguratiSelectati;
@property (nonatomic, retain) NSMutableArray *         listAsiguratiIndecsi;

@property (nonatomic, retain) UIViewController * controller;
@property (readwrite) ProdusAsigurare produsAsigurare;

- (IBAction)adaugaPersoana:(id)sender;
- (IBAction)hideInfoCalatorie:(id)sender;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)doneSelecting:(id)sender;
- (void) reloadData;
- (void) verifyViewMode;

- (void) loadInfoCalatorie;
- (void) setInfoCalatorie:(BOOL)k forButton:(UIButton *)btn;

- (void) checkVisibilityForOk;
@end
