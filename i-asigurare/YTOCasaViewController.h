//
//  YTOCasaViewController.h
//  i-asigurare
//
//  Created by Administrator on 8/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOLocuinta.h"

@interface YTOCasaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, PickerVCSearchDelegate, UIActionSheetDelegate>
{
    IBOutlet UITableView        * tableView;
    IBOutlet UIView             * vwNomenclator;
    
    // CELL COMUNE
    UITableViewCell             * cellHeader;
    IBOutlet UITableViewCell    * cellInfoAlerte;
    // CELL PENTRU INFO LOCUINTA
    UITableViewCell             * cellJudetLocalitate;
    UITableViewCell             * cellAdresa;
    IBOutlet UITableViewCell    * cellTipLocuinta;
    UITableViewCell             * cellStructura;
    UITableViewCell             * cellInaltime;
    UITableViewCell             * cellEtaj;
    UITableViewCell             * cellAnConstructie;
    UITableViewCell             * cellNrCamere;
    UITableViewCell             * cellSuprafata;
    UITableViewCell             * cellNrLocatari;
    UITableViewCell             * cellDescriereLocuinta;
    UITableViewCell             * cellSC;
    //CELLS PENTRU ALERTE LOCUINTA
    UITableViewCell             * cellExpirareLoc;
    UITableViewCell             * cellExpirareRataLoc;
    
    UITextField         * activeTextField;
    IBOutlet UIView     * vwTooltip;
    IBOutlet UILabel    * lblTootlip;
    
    NSMutableArray      * structuriRezistenta;
    
    float percentCompletedOnLoad;
    BOOL  selectatInfoLocuinta;
    BOOL  shouldSave;
}

@property BOOL goingBack;
@property (nonatomic, retain) YTOLocuinta * locuinta;
@property (nonatomic, retain) UIViewController * controller;

@property int _nomenclatorNrItems;
@property int _nomenclatorSelIndex;
@property (readwrite) Nomenclatoare _nomenclatorTip;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) showNomenclator;
- (IBAction) hideNomenclator;

- (IBAction)nrCamere_Changed:(id)sender;
- (IBAction)nrLocatari_Changed:(id)sender;
- (IBAction)btnTipLocuinta_Clicked:(id)sender;
- (IBAction)btnInfoAlerte_OnClick:(id)sender;

- (void) showListaJudete:(NSIndexPath *)index;
- (void) showStructuraRezistenta:(NSIndexPath *)index;
- (void) showListaDescriereLocuinta:(NSIndexPath *)index;
- (void) loadStructuriRezistenta;

- (void) load:(YTOLocuinta *)p;
- (void) save;
- (void) btnSave_Clicked;
- (void) btnCancel_Clicked;

- (void) showTooltip:(NSString *)tooltip;
- (void) hideTooltip;

// PROPRIETATI
- (void) setAdresa:(NSString *)p;
- (NSString *) getJudet;
- (void) setJudet:(NSString *)judet;
- (NSString *) getLocalitate;
- (NSString *) getLocatie;
- (void) setTipLocuinta:(NSString *)p;
- (void) setStructura:(NSString *)p;
- (void) setInaltime:(int)p;
- (void) setEtaj:(int)p;
- (void) setAnConstructie:(int)p;
- (void) setNrCamere:(int)p;
- (void) setSuprafata:(int)p;
- (void) setNrLocatari:(int)p;
- (void) setAlerta:(int)index withDate:(NSDate *)data savingData:(BOOL)toSave;

- (void) setAlarma:(NSString *)v;
- (void) setGrilajeGeam:(NSString *)v;
- (void) setDetectieIncendiu:(NSString *)v;
- (void) setPaza:(NSString *)v;
- (void) setTeren:(NSString *)v;
- (void) setZonaIzolata:(NSString*)v;
- (void) setLocuitPermananet:(NSString *)v;
- (void) setClauzaFurtBunuri:(NSString *)v;
- (void) setClauzaApaConducta:(NSString *)v;
@end
