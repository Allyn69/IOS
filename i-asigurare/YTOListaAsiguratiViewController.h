//
//  YTOListaAsiguratiViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOListaAsiguratiViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * listaAsigurati;
}

@property (nonatomic, retain) UIViewController * controller;

- (IBAction)adaugaPersoana:(id)sender;
@end
