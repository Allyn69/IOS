//
//  YTOSumarRCAViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/27/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOOferta.h"
#import "YTOPersoana.h"
#import "YTOAutovehicul.h"


@interface YTOSumarRCAViewController : UIViewController
{
    IBOutlet UILabel * lblMarcaModel;
    IBOutlet UILabel * lblSerieSasiu;
    IBOutlet UILabel * lblNrInmatriculare;
    
    IBOutlet UILabel * lblNume;
    IBOutlet UILabel * lblCodUnic;
    IBOutlet UILabel * lblJudetLocalitate;
    
    IBOutlet UILabel * lblPrima;
    IBOutlet UILabel * lblPrimaInitiala;
    IBOutlet UILabel * lblStrike;
    IBOutlet UILabel * lblDurata;
    IBOutlet UILabel * lblBonusMalus;
    IBOutlet UIImageView * imgCompanie;
    
    IBOutlet UITableViewCell *cellHeader;
    
    IBOutlet UILabel * lblContinua;

    
}

@property                     BOOL              pretRedus;
@property (nonatomic, retain) YTOOferta *       oferta;
@property (nonatomic, retain) YTOPersoana *     asigurat;
@property (nonatomic, retain) YTOAutovehicul *  masina;



- (IBAction)showFinalizareRCA:(id)sender;
@end
