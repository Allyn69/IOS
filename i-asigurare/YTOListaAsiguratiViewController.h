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
    
    IBOutlet UILabel * lblWvEmpty1;
    IBOutlet UILabel * lblWvEmpty2;
    
    IBOutlet UILabel * lblStudent;
    IBOutlet UILabel * lblBoliCardio;
    IBOutlet UILabel * lblSportAgrement;
    IBOutlet UILabel * lblReduceriMajorari;
    IBOutlet UILabel * lblBoliAfectiuni;
    IBOutlet UILabel * lblBoliNeuro;
    IBOutlet UILabel * lblBoliInterne;
    IBOutlet UILabel * lblBoliAparatResp;
    IBOutlet UILabel * lblBoliDef;
    IBOutlet UILabel * lblAlteBoli;
    IBOutlet UILabel * lblGradInv;
    
    IBOutlet UIView  * vwVarsta;
    IBOutlet UILabel * lblAtentie;
    IBOutlet UILabel * lblVarsta;
    IBOutlet UILabel * lblContinua;
    IBOutlet UILabel * lblDeAcord;
    
    IBOutlet UILabel * lblAdauga;
    IBOutlet UILabel * lblEditeaza;
    
    YTOPersoana *persoanaVarsta;
    NSInteger indexPersoana;
    BOOL conditieVarstaChecked;
    BOOL varstaNeg;
    BOOL goingBack;
}

@property (nonatomic, retain) NSMutableArray *         listaAsiguratiSelectati;
@property (nonatomic, retain) NSMutableArray *         listAsiguratiIndecsi;

@property (nonatomic, retain) UIViewController * controller;
@property (readwrite) ProdusAsigurare produsAsigurare;

@property int tagViewControllerFrom;

//@property int indexAsigurat;

- (IBAction)adaugaPersoana:(id)sender;
- (IBAction)hideInfoCalatorie:(id)sender;
- (IBAction)checkboxSelected:(id)sender;
- (IBAction)doneSelecting:(id)sender;

- (IBAction)btnContinua_clicked:(id)sender;
- (IBAction)btnDeAcord_clicked:(id)sender;
- (void) reloadData;
- (void) verifyViewMode;
- (IBAction) callEditItems;

- (void) loadInfoCalatorie;
- (void) setInfoCalatorie:(BOOL)k forButton:(UIButton *)btn;

- (void) checkVisibilityForOk;
@end
