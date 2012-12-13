//
//  YTOListaLocuinteViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/2/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOUtils.h"

@interface YTOListaLocuinteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * listaLocuinte;
    IBOutlet UIView * vwEmpty;
    BOOL editingMode;
}

@property (nonatomic, retain) UIViewController * controller;
@property (readwrite) ProdusAsigurare produsAsigurare;

- (IBAction)adaugaLocuinta:(id)sender;
- (void) reloadData;
- (void) verifyViewMode;

@end
