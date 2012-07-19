//
//  YTOListaAutoViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOListaAutoViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableArray * listaMasini;
}

@property (nonatomic, retain) UIViewController * controller;

- (IBAction)adaugaAutovehicul:(id)sender;


@end
