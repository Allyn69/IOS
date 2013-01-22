//
//  YTOAutovehiculViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/18/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//




///gfsdhsdfhsxdfgzxsrexrxctrfchgfcgfrtcctr

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTONomenclatorViewController.h"
#import "YTOAutovehicul.h"
#import "YTOUtils.h"
#import "YTOAlerta.h"

@interface YTOAutovehiculViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PickerVCSearchDelegate, YTONomenclatorDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView * tableView;
    UITextField * activeTextField;
    IBOutlet UIBarButtonItem * btnDone;
    IBOutlet UIView * vwTooltip;
    IBOutlet UILabel * lblTootlip;

    IBOutlet UIView *   vwKeyboardAddon;
    IBOutlet UIView *   vwNomenclator;
    YTOAutovehicul * autovehicul;
    BOOL goingBack;
    NSMutableArray * categoriiAuto;
    NSMutableArray * tipCombustibil;
    NSMutableArray * destinatiiAuto;
    
    // CELLS COMUNE
    UITableViewCell          * cellAutoHeader;
    IBOutlet UITableViewCell * cellInfoAlerte;
    // CELLS PENTRU INFO MASINA
    UITableViewCell          * cellMarcaAuto;
    UITableViewCell          * cellModelAuto;
    UITableViewCell          * cellJudetLocalitate;
    IBOutlet UITableViewCell * cellSubcategorieAuto;
    UITableViewCell          * cellNrInmatriculare;
    UITableViewCell          * cellSerieSasiu;
    UITableViewCell          * cellCm3;
    UITableViewCell          * cellPutere;
    UITableViewCell          * cellNrLocuri;
    UITableViewCell          * cellMasaMaxima;
    UITableViewCell          * cellAnFabricatie;
    UITableViewCell          * cellSerieCiv;
    IBOutlet UITableViewCell * cellDestinatieAuto;
    IBOutlet UITableViewCell * cellCombustibil;
    UITableViewCell          * cellInLeasing;
    UITableViewCell          * cellLeasingFirma;
    UITableViewCell          * cellSC;
    // CELLS PENTRU ALERTE MASINA
    UITableViewCell          * cellExpirareRCA;
    UITableViewCell          * cellExpirareITP;
    UITableViewCell          * cellExpirareRovinieta;
    UITableViewCell          * cellExpirareCASCO;
//    UITableViewCell          * cellNumarRate;
    UITableViewCell          * cellExpirareRataCASCO;
    
    NSMutableArray           * listCellRateCasco;
    
    float percentCompletedOnLoad;
    BOOL  selectatInfoMasina;
    BOOL  shouldSave;
    BOOL editingMode;
    YTOAlerta * alertaRataCasco;
    
    YTOAlerta * alertaRca;
    YTOAlerta * alertaItp;
    YTOAlerta * alertaRovinieta;
    YTOAlerta * alertaCasco;
    
    UITextField * txtAlertaRca;
    UITextField * txtAlertaItp;
    UITextField * txtAlertaRovinieta;
    UITextField * txtAlertaCasco;
    UITextField * txtAlertaRataCasco;
    
    UITextField * txtPutere;
    UITextField * txtCm3;
    UITextField * txtGreutate;
}

@property (nonatomic, retain) YTOAutovehicul * autovehicul;
@property (nonatomic, retain) UIViewController * controller;

@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;

- (IBAction) selectMarcaAuto;
- (IBAction) chooseImage;

- (void) initCells;
- (void) showListaMarciAuto:(NSIndexPath *)index;
- (void) showListaJudete:(NSIndexPath *)index;
- (void) showListaDestinatieAuto:(NSIndexPath *)index;
- (void) showListaTipCombustibil:(NSIndexPath *)index;
- (void) addBarButton;
- (void) deleteBarButton;
- (void) save;
- (void) btnSave_Clicked;
- (void) btnCancel_Clicked;
- (void) load:(YTOAutovehicul *)a;
- (void) loadCategorii;
- (void) loadTipCombustibil;
- (void) loadDestinatieAuto;

- (IBAction)checkboxSelected:(id)sender;
- (IBAction)checkboxCombustibilSelected:(id)sender;
- (IBAction)checkboxDestinatieSelected:(id)sender;
- (IBAction)btnInfoAlerte_OnClick:(id)sender;

- (void) btnEditShouldAppear;

- (void) showNomenclator;
- (IBAction) hideNomenclator;

- (void) showTooltip:(NSString *)tooltip;
- (void) hideTooltip;
// PROPRIETATI
- (NSString *) getJudet;
- (void) setJudet:(NSString *)judet;
- (void) setLocalitate:(NSString *)localitate;
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

- (int) getCm3;
- (void) setCm3:(int)v;

- (int) getPutere;
- (void) setPutere:(int)v;

- (int) getAnFabricatie;
- (void) setAnFabricatie:(int)v;
- (void) setInLeasing:(NSString *)v;
- (void) setNumeFirmaLeasing:(NSString *)v;
- (void) setImage:(UIImage *)img;

- (void) setAlerta:(int)index withDate:(NSDate *)data savingData:(BOOL)toSave;
//- (void) setNumarRate:(int)x;

@end
