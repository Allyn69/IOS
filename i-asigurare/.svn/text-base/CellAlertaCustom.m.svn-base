//
//  CellAlertaCustom.m
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/30/12.
//
//

#import "CellAlertaCustom.h"
#import "YTOUtils.h"

@implementation CellAlertaCustom

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        img = [[UIImageView alloc] initWithFrame:CGRectMake(13, 23, 13, 13)];
        
        lblTipAlerta = [[UILabel alloc] initWithFrame:CGRectMake(47,7,77,45)];
        lblTipAlerta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblTipAlerta.numberOfLines = 2;
        lblTipAlerta.textAlignment = UITextAlignmentCenter;
        lblTipAlerta.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        
        lblDetaliuAlerta = [[UILabel alloc] initWithFrame:CGRectMake(132,7,77,45)];
        lblDetaliuAlerta.textColor = [YTOUtils colorFromHexString:ColorTitlu];
        lblDetaliuAlerta.numberOfLines = 2;
        lblDetaliuAlerta.textAlignment = UITextAlignmentCenter;
        lblDetaliuAlerta.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        
        lblNumar = [[UILabel alloc] initWithFrame:CGRectMake(228,7,86,45)];
        lblNumar.textColor = [UIColor grayColor];
        lblNumar.textAlignment = UITextAlignmentCenter;
        lblNumar.font = [UIFont fontWithName:@"Arial Rounded MT Bold" size:14];
        
        [self.contentView addSubview:img];
        [self.contentView addSubview:lblTipAlerta];
        [self.contentView addSubview:lblDetaliuAlerta];
        [self.contentView addSubview:lblNumar];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAlertaImage:(UIImage *)v
{
    img.image = v;
}

- (void) setTipAlerta:(NSString *) v
{
    lblTipAlerta.text = v;
}

- (void) setDetaliuAlerta:(NSString *)v
{
    lblDetaliuAlerta.text = v;
}

- (void) setNumar:(NSString *)v
{
    lblNumar.text = v;
}

@end
