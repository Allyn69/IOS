//
//  YTOComanda.h
//  i-asigurare
//
//  Created by Stern Edi on 20/01/14.
//
//

#import <Foundation/Foundation.h>

@interface YTOComanda : NSObject
@property (nonatomic , retain) NSString * id;
@property (nonatomic , retain) NSString * dataComanda;
@property (nonatomic , retain) NSString * tipPolita;
@property (nonatomic , retain) NSString * statusPolita;
@property (nonatomic , retain) NSString * idDirector;
@property (nonatomic , retain) NSString * idCont;
@property (nonatomic , retain) NSString * companie;
@property (nonatomic , retain) NSString * prima;
@property (nonatomic , retain) NSString * durata;
@property (nonatomic , retain) NSString * nrInmatriculare;
@property (nonatomic , retain) NSString * dataSfarsit;
@property (readwrite , assign) BOOL isOpen;
@end
