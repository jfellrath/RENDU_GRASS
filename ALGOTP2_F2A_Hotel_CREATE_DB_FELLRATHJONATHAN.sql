CREATE SCHEMA GESTION_HOTEL;

Create table TCHAMBRE (
		CHB_ID int  not null,
		CHB_NUMERO int not null,
		CHB_ETAGE char not null,
		CHB_BAIN int not null,
        CHB_DOUCHE int not null,
        CHB_WC int not null,
        CHB_COUCHAGE int not null,
        CHB_POSTE_TEL int not null,
Primary key (CHB_ID));


Create table TTITRE (
		TIT_CODE int not null,
		TIT_LIBELLE int not null,
Primary key (TIT_CODE));


Create table TADRESSE (
		ADR_ID int not null,
		ADR_LIGNE1 int not null,
		ADR_LIGNE2 int not null,
		ADR_LIGNE3 int not null,
        ADR_LIGNE4 int not null,
        ADR_CP int not null,
        ADR_VILLE int not null,
Primary key (ADR_ID));


Create table TEMAIL (
		EML_ID int not null,
		EML_ADRESSE int not null,
		EML_LOCALISATION int not null,
Primary key (EML_ID));


Create table TELEPHONE (
		TEL_ID int not null,
		TEL_NUMERO int not null,
		TEL_LOCALISATION int not null,
Primary key (TEL_ID));


Create table TCLIENT (
		CLI_ID int not null,
		CLI_NOM char not null,
		CLI_PRENOM char not null,
		CLI_ENSEIGNE char null,
Primary key (CLI_ID));


Create table TLIGNE_FACTURE (
		LIF_ID int not null,
		LIF_QTE int not null,
		LIF_REMISE_POURCENT real not null,
		LIF_REMISE_MONTANT real not null,
        LIF_MONTANT real not null,
        LIF_TAUX_TVA real not null,
Primary key (LIF_ID));


Create table MODE_PAIEMENT (
		PMT_CODE int not null,
		PMT_LIBELLE int not null,
Primary key (PMT_CODE));


Create table TTYPE (
		TYP_CODE int not null,
		TYP_LIBELLE int not null,
Primary key (TYP_CODE));


Create table FACTURE (
		FAC_ID int not null,
		FAC_DATE int not null,
Primary key (FAC_ID));










