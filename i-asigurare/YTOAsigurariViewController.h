//
//  YTOAsigurariViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOCalculatorViewController.h"
#import "YTOCalatorieViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOCASCOViewController.h"

@interface YTOAsigurariViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;

    UITableViewCell * cellHeader;
    UITableViewCell * cellAsigurareRca;
    UITableViewCell * cellAsigurareCalatorie;
    UITableViewCell * cellAsigurareLocuinta;
    UITableViewCell * cellAsigurareCasco;
}

- (void)showRCAView;
- (void)showCalatorieView;
- (void)showLocuintaView;
- (void)showCascoView;

@end
