//
//  Cell_Locuinta.h
//  i-asigurare
//
//  Created by Stern Edi on 30/04/14.
//
//

#import <UIKit/UIKit.h>

@interface Cell_Locuinta : UITableViewCell
{
    IBOutlet UIImageView    * iconFoto;
    IBOutlet UILabel        * lblTop;
    IBOutlet UILabel        * lblBottom;
    IBOutlet UIButton       * btnEdit;
    IBOutlet UIButton       * btnSelect;
    IBOutlet UILabel        * lblEdit;
    IBOutlet UILabel        * lblSelect;
    IBOutlet UILabel        * lblVertical;
    IBOutlet UILabel        * lblOrizontal;
    IBOutlet UILabel        * lblOrizontal2;
}

@property (nonatomic, retain) IBOutlet UIButton * btnEdit;
@property (nonatomic, retain) IBOutlet UIButton * btnSelect;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

- (void) setImageIcon:(NSString *)v;
- (void) setLabelTop:(NSString *)v;
- (void) setLabelBottom:(NSString *)v;
@end
