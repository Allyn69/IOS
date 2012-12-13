//
//  YTOListaAutoViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOListaAutoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * listaMasini;
    IBOutlet UIView * vwEmpty;
    
    BOOL editingMode;
}

@property (nonatomic, retain) UIViewController * controller;

- (IBAction)adaugaAutovehicul:(id)sender;
- (void) reloadData;

@end
