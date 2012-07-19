//
//  YTOAutovehiculViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTONomenclatorViewController.h"
#import "YTOAutovehicul.h"

@interface YTOAutovehiculViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PickerVCSearchDelegate, YTONomenclatorDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UIBarButtonItem * btnDone;
    YTOAutovehicul * autovehicul;
    BOOL goingBack;
    NSMutableArray * categoriiAuto;
    NSMutableArray * tipCombustibil;
    NSMutableArray * destinatiiAuto;
    
    UITableViewCell * cellJudetLocalitate;
    UITableViewCell * cellSubcategorieAuto;
    UITableViewCell * cellMarca;
    UITableViewCell * cellModelNrInmatriculare;
    UITableViewCell * cellSerieSasiuCiv;
    UITableViewCell * cellCm3Putere;
    UITableViewCell * cellNrLocuriMasaMaxima;
    UITableViewCell * cellAnFabricatie;
    UITableViewCell * cellDestinatieAuto;
    UITableViewCell * cellCombustibil;
    UITableViewCell * cellAutoNouInregistrat;
    UITableViewCell * cellInLeasing;

}

@property (nonatomic, retain) YTOAutovehicul * autovehicul;
- (void) initCells;
- (void) showListaMarciAuto:(NSIndexPath *)index;
- (void) showListaJudete:(NSIndexPath *)index;
- (void) showListaDestinatieAuto:(NSIndexPath *)index;
- (void) showListaTipCombustibil:(NSIndexPath *)index;
- (void) addBarButton;
- (void) deleteBarButton;
- (void) save;
- (void) load:(YTOAutovehicul *)a;
- (void) loadCategorii;
- (void) loadTipCombustibil;
- (void) loadDestinatieAuto;

// PROPRIETATI
- (NSString *) getJudet;
- (void) setJudet:(NSString *)judet;
- (NSString *) getLocalitate;
- (NSString *) getLocatie;

- (NSString *) getMarca;
- (void) setMarca:(NSString *)marca;

- (NSString *) getModel;
- (void) setModel:(NSString *)model;

- (NSString *) getNrInmatriculare;
- (void) setNrInmatriculare:(NSString *)numar;

- (NSString *) getSerieSasiu;
- (void) setSerieSasiu:(NSString *)serie;

- (NSString *) getSerieCIV;
- (void) setSerieCIV:(NSString *)serie;

- (int) getNrLocuri;
- (void) setNrLocuri:(int)numar;

- (int) getMasaMaxima;
- (void) setMasaMaxima:(int)masa;

- (int) getCategorieAuto;
- (void) setCategorieAuto:(int)categorie;

- (NSString *) getSubcategorieAuto;
- (void) setSubcategorieAuto:(NSString *)subcategorie;

- (NSString *) getTipCombustibil;
- (void) setTipCombustibil:(NSString *)s;

- (NSString *) getDestinatieAuto;
- (void) setDestinatieAuto:(NSString *)s;
@end
