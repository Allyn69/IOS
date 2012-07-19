//
//  YTOSetariViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YTOSetariViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView * tableView;
    UITableViewCell * cellProfilulMeu;
    UITableViewCell * cellMasinileMele;
    UITableViewCell * cellLocuinteleMele;
    UITableViewCell * cellAltePersoane;
}

@end
