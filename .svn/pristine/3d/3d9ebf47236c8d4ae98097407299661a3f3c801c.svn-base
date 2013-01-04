//
//  YTOLocuintaViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 8/1/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOLocuinta.h"
#import "YTOPersoana.h"
#import "YTOOferta.h"

@interface YTOLocuintaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    IBOutlet UITableView * tableView;
    
    UITableViewCell *           cellHeader;
    UITableViewCell *           cellLocuinta;
    UITableViewCell *           cellProprietar;
    IBOutlet UITableViewCell *  cellModEvaluare;
    UITableViewCell *           cellSumaAsigurata;
    UITableViewCell *           cellSumaAsigurataRC;
    UITableViewCell *           cellDataInceput;
    UITableViewCell *           cellCalculeaza;

    YTOOferta *    oferta; 
    UITextField * activeTextField;
    
    BOOL cautLegaturaDintreAsiguratSiLocuinta;    
}

@property (nonatomic, retain) YTOPersoana *  asigurat;
@property (nonatomic, retain) YTOLocuinta *  locuinta;

@property (nonatomic, retain) NSDate *   DataInceput;
- (IBAction)btnModeEvaluare_Clicked:(id)sender;

- (void) initCells;
- (void) initCustomValues;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) setDataInceput:(NSDate *)DataInceput;
- (void) setAsigurat:(YTOPersoana *) a;
- (void) setLocuinta:(YTOLocuinta *) a;

- (void) setSumaAsigurata:(NSString *)p;
- (void) setSumaAsigurataRC:(NSString *)p;

@end
