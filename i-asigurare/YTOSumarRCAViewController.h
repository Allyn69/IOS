//
//  YTOSumarRCAViewController.h
//  i-asigurare
//
//  Created by Administrator on 7/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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
    IBOutlet UILabel * lblDurata;
    IBOutlet UILabel * lblBonusMalus;
    IBOutlet UIImageView * imgCompanie;
}

@property (nonatomic, retain) YTOOferta *       oferta;
@property (nonatomic, retain) YTOPersoana *     asigurat;
@property (nonatomic, retain) YTOAutovehicul *  masina;

- (IBAction)showFinalizareRCA:(id)sender;
@end
