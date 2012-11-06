//
//  Setari.h
//  i-Asigurare
//
//  Created by Administrator on 1/31/11.
//  Copyright 2011 i-Tom Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setari : NSObject<NSCoding> {
	NSString *	 ClientId;
	
	// Date de contact
	NSString *	 Nume;
	NSString *	 CodUnic;
	NSString *	 Telefon;
	NSString *	 Email;
	NSString *   Judet;
	NSInteger    JudetId;
	NSString *   Localitate;
	NSString *   Strada;
	NSString *	 DataPermis;
	
    BOOL         Casatorit;
    BOOL         CopiiMinori;
    BOOL         Pensionar;
    NSInteger    NrBugetari;
    
	// Date autoturism
	NSInteger   CategorieId;
	NSInteger   SubcategorieId;    
    NSString *  Subcategorie;
	NSString *	Marca;
	NSInteger   MarcaId;
	NSString *	Model;
	NSString *	NrInmatriculare;
	NSString *	SerieSasiu;
    NSString *	SerieCI;
	NSInteger   AutoNou;
	NSString *  Cm3;
	NSString *  kW;
	NSString *  Combustibil;
	NSInteger   NrLocuri;
	NSInteger   MasaMaxima;
	NSInteger   AnFabricatie;
	NSString *  DestinatieAuto;
	NSString *  TipPersoana;
	NSString *  CUI;
	NSString *  DenumirePJ;
    NSString *  CodCaen;
	
	// Date RCA
	NSInteger   NrDauneUltimAn;
	NSInteger   AniFaraDaune;
	NSInteger   DurataAsigurare;
	NSString *  DataInceputRCA;
	
	// Companii asigurare
	NSInteger    RcaId;
	NSInteger    CascoId;
	
	NSString *	 ExpirareRca;
	NSString *	 ExpirareItp;
	NSString *	 ExpirareRovigneta;	
	
	NSString *	 Error;
	BOOL isDirty;
	BOOL alerteConfigurate;
	BOOL inregistrat;
	BOOL intrebatInregistrare;
	
	BOOL isDirty1;
	BOOL isDirty2;
	BOOL isDirty3;
	
	BOOL isValid1;
	BOOL isValid2;
	BOOL isValid3;
	NSString * idOferta;
	
	NSString * adresaLivrare;
	
}

@property (nonatomic, retain) NSString *	ClientId;

@property (nonatomic, retain) NSString *	Nume;
@property (nonatomic, retain) NSString *	CodUnic;
@property (nonatomic, retain) NSString *	Telefon;
@property (nonatomic, retain) NSString *	Email;
@property (nonatomic, retain) NSString *	Judet;
@property NSInteger							JudetId;
@property (nonatomic, retain) NSString *	Localitate;
@property (nonatomic, retain) NSString *	Strada;
@property (nonatomic, retain) NSString *    DataPermis;

@property BOOL                              Casatorit;
@property BOOL                              CopiiMinori;
@property BOOL                              Pensionar;
@property NSInteger                         NrBugetari;

@property NSInteger                         CategorieId;
@property NSInteger                         SubcategorieId;
@property (nonatomic, retain) NSString *	Subcategorie;
@property (nonatomic, retain) NSString *	Marca;
@property NSInteger MarcaId;
@property (nonatomic, retain) NSString *	Model;
@property (nonatomic, retain) NSString *	NrInmatriculare;
@property (nonatomic, retain) NSString *	SerieSasiu;
@property (nonatomic, retain) NSString *	SerieCI;
@property NSInteger   AutoNou;
@property (nonatomic, retain) NSString *	Cm3;
@property (nonatomic, retain) NSString *	kW;
@property (nonatomic, retain) NSString *	Combustibil;
@property NSInteger   NrLocuri;
@property NSInteger   MasaMaxima;
@property NSInteger   AnFabricatie;
@property (nonatomic, retain) NSString *  DestinatieAuto;
@property (nonatomic, retain) NSString *  TipPersoana;
@property (nonatomic, retain) NSString *  CUI;
@property (nonatomic, retain) NSString *  DenumirePJ;
@property (nonatomic, retain) NSString *  CodCaen;

@property NSInteger						  NrDauneUltimAn;
@property NSInteger					      AniFaraDaune;
@property NSInteger						  DurataAsigurare;
@property (nonatomic, retain) NSString *  DataInceputRCA;

@property (nonatomic, retain) NSString *	Error;

@property (nonatomic, retain) NSString *	ExpirareRca;
@property (nonatomic, retain) NSString *	ExpirareItp;
@property (nonatomic, retain) NSString *	ExpirareRovigneta;
@property (nonatomic, retain) NSString * idOferta;

@property (nonatomic, retain) NSString * adresaLivrare;

@property NSInteger RcaId;
@property NSInteger CascoId;
@property BOOL isDirty;
@property BOOL alerteConfigurate;
@property BOOL inregistrat;
@property BOOL intrebatInregistrare;
@property BOOL isDirty1;
@property BOOL isDirty2;
@property BOOL isDirty3;

@property BOOL isValid1;
@property BOOL isValid2;
@property BOOL isValid3;

@end
