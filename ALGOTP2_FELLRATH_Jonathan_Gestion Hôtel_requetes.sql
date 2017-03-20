--Nombre de clients
SELECT COUNT(CLI_NOM) as NOMBRE_CLIENT from T_CLIENT

--Les clients triés sur le titre et le nom
SELECT CLI_NOM as NOM,CLI_PRENOM as PRENOM,TIT_CODE as TITRE from T_CLIENT ORDER BY TIT_CODE,CLI_NOM

--Les clients triés sur le libellé du titre et le nom
SELECT CLI_NOM as NOM,CLI_PRENOM as PRENOM,TIT_LIBELLE AS LIBELLE FROM T_CLIENT INNER JOIN  T_TITRE ORDER BY TIT_LIBELLE,CLI_NOM

--Les clients commençant par 'B'
SELECT CLI_NOM AS 'NOM QUI COMMENCE PAR B' FROM T_CLIENT WHERE CLI_NOM LIKE 'B%'
--Les clients homonymes

--Nombre de titres différents
SELECT COUNT(TIT_LIBELLE) AS 'NOMBRE DE TITRE DIFFERENT' FROM T_TITRE 
--Nombre d'enseignes
SELECT CLI_ENSEIGNE AS 'NOMBRE ENSEIGNE' FROM T_CLIENT WHERE CLI_ENSEIGNE <> ""
--Les clients qui représentent une enseigne 
SELECT *  FROM T_CLIENT WHERE CLI_ENSEIGNE <> ""
--Les clients qui représentent une enseigne de transports
SELECT *  FROM T_CLIENT WHERE CLI_ENSEIGNE LIKE UPPER( "%transp%")
--Nombre d'hommes,Nombres de femmes, de demoiselles, Nombres de sociétés
SELECT COUNT(CLI_NOM),COUNT(CLI_ENSEIGNE)  
FROM T_CLIENT 
INNER JOIN T_TITRE 
WHERE (T_TITRE.TIT_CODE = 'M.' 
AND T_CLIENT.TIT_CODE = T_TITRE.TIT_CODE) 
--Nombre d''emails
SELECT COUNT(EML_ADRESSE) as 'NOMBRE EMAIL'
FROM T_EMAIL
WHERE EML_ADRESSE <> ""
--Client sans email 
SELECT CLI_NOM AS "CLIENT SANS EMAIL"
FROM T_CLIENT AS C
WHERE NOT EXISTS (SELECT EML_ADRESSE FROM T_EMAIL WHERE CLI_ID = C.CLI_ID)
--Clients sans téléphone 
SELECT T_CLIENT.CLI_NOM
FROM T_CLIENT
WHERE
    NOT EXISTS (SELECT T_TELEPHONE.CLI_ID 
         FROM T_TELEPHONE WHERE T_TELEPHONE.CLI_ID = T_CLIENT.CLI_ID)
--Les phones des clients
SELECT TEL_NUMERO AS NUMERO,T_CLIENT.CLI_NOM AS NOM FROM T_TELEPHONE
INNER JOIN T_CLIENT
WHERE T_CLIENT.CLI_ID = T_TELEPHONE.CLI_ID ORDER BY T_CLIENT.CLI_NOM
--Ventilation des phones par catégorie

--Les clients ayant plusieurs téléphones
SELECT T_CLIENT.CLI_NOM
FROM T_CLIENT
WHERE T_CLIENT.CLI_ID 
    IN(SELECT T_CLIENT.CLI_ID 
         FROM T_TELEPHONE WHERE T_TELEPHONE.CLI_ID > 1)
--Clients sans adresse:
SELECT T_CLIENT.CLI_NOM
FROM T_CLIENT
WHERE
    NOT EXISTS (SELECT T_ADRESSE.CLI_ID 
         FROM T_ADRESSE WHERE T_ADRESSE.CLI_ID = T_CLIENT.CLI_ID)
--Clients sans adresse mais au moins avec mail ou phone 
SELECT T_CLIENT.CLI_NOM 
FROM T_CLIENT
 WHERE
    NOT EXISTS (SELECT T_ADRESSE.CLI_ID 
         FROM T_ADRESSE WHERE T_ADRESSE.CLI_ID = T_CLIENT.CLI_ID) 
AND ( T_CLIENT.CLI_ID IN (SELECT T_TELEPHONE.CLI_ID
         FROM T_TELEPHONE WHERE T_TELEPHONE.CLI_ID = T_CLIENT.CLI_ID))
OR  ( T_CLIENT.CLI_ID IN (SELECT T_EMAIL.CLI_ID
         FROM T_EMAIL WHERE T_EMAIL.CLI_ID = T_CLIENT.CLI_ID))
--Dernier tarif renseigné
SELECT MAX(TRF_DATE_DEBUT) AS 'DERNIER TARIF RENSEIGNE' FROM T_TARIF
--Tarif débutant le plus tôt 
SELECT MIN(TRF_DATE_DEBUT) AS 'DTARIF DEBUTANT PLUS LE PLUS TOT' FROM T_TARIF
--Différentes Années des tarifs
SELECT TRF_DATE_DEBUT AS 'DIFFERENTE ANNE' FROM T_TARIF GROUP BY TRF_DATE_DEBUT
--Nombre de chambres de l'hotel 
SELECT COUNT(CHB_NUMERO) AS 'NBR CHAMBRE' FROM T_CHAMBRE
--Nombre de chambres par étage
SELECT COUNT(CHB_NUMERO) AS 'NBR CHAMBRE' FROM T_CHAMBRE GROUP BY CHB_ETAGE
--Chambres sans telephone
SELECT CHB_ID AS 'CHAMBRE SANS TELEPHONE'
FROM T_CHAMBRE
 WHERE CHB_POSTE_TEL = 0
--Existence d'une chambre n°13 ?
SELECT CHB_NUMERO AS '13 Existe ?'
FROM T_CHAMBRE
WHERE CHB_NUMERO = 13
--Chambres avec sdb
SELECT T_CHAMBRE.CHB_ID AS 'CHAMBRE AVEC SALLE DE BAIN'
FROM T_CHAMBRE
 WHERE CHB_BAIN = 1
--Chambres avec douche
SELECT T_CHAMBRE.CHB_ID AS 'CHAMBRE AVEC DOUCHE'
FROM T_CHAMBRE
 WHERE CHB_DOUCHE = 1
--Chambres avec WC
SELECT T_CHAMBRE.CHB_ID AS 'CHAMBRE AVEC WC'
FROM T_CHAMBRE
 WHERE CHB_WC = 1
--Chambres sans WC séparés
SELECT T_CHAMBRE.CHB_ID AS 'CHAMBRE SANS WC SEPARE'
FROM T_CHAMBRE
 WHERE CHB_WC = 0
--Quels sont les étages qui ont des chambres sans WC séparés ?
SELECT CHB_ETAGE AS 'ETAGE CHAMBRE SANS WC SEPARE'
FROM T_CHAMBRE
 WHERE CHB_WC = 0 
--Nombre d'équipements sanitaires par chambre trié par ce nombre d'équipement croissant
SELECT ABS(CHB_BAIN+CHB_DOUCHE+CHB_COUCHAGE) AS 'NOMBRE EQUIPEMENT',CHB_NUMERO AS 'CHAMBRE' 
FROM T_CHAMBRE ORDER BY ABS(CHB_BAIN+CHB_DOUCHE+CHB_COUCHAGE) DESC
--Chambres les plus équipées et leur capacité

--Repartition des chambres en fonction du nombre d'équipements et de leur capacité

--Nombre de clients ayant utilisé une chambre
SELECT COUNT(T_CLIENT.CLI_ID) AS 'CLIENT AYANT UTILISE UNE CHAMBRE'
FROM T_CLIENT 
WHERE T_CLIENT.CLI_ID
IN (SELECT TJ_CHB_PLN_CLI.CLI_ID FROM TJ_CHB_PLN_CLI 
      WHERE TJ_CHB_PLN_CLI.CLI_ID = T_CLIENT.CLI_ID)
--Clients n'ayant jamais utilisé une chambre (sans facture)
SELECT T_CLIENT.CLI_ID AS 'CLIENT AYANT JAMAIS UTILISE UNE CHAMBRE (SANS FACTURE)'
FROM T_CLIENT 
WHERE NOT EXISTS (SELECT T_FACTURE.CLI_ID FROM T_FACTURE
      WHERE T_FACTURE.CLI_ID = T_CLIENT.CLI_ID)
--Nom et prénom des clients qui ont une facture
SELECT T_CLIENT.CLI_NOM AS 'NOM',T_CLIENT.CLI_PRENOM AS PRENOM
FROM T_CLIENT 
WHERE EXISTS (SELECT T_FACTURE.CLI_ID FROM T_FACTURE
      WHERE T_FACTURE.CLI_ID = T_CLIENT.CLI_ID)
--Nom, prénom, telephone des clients qui ont une facture
SELECT T_TELEPHONE.TEL_NUMERO, T_CLIENT.CLI_NOM AS 'NOM',T_CLIENT.CLI_PRENOM AS PRENOM
FROM T_TELEPHONE,T_CLIENT
WHERE EXISTS (SELECT T_CLIENT.CLI_NOM AS 'NOM',T_CLIENT.CLI_PRENOM AS PRENOM
FROM T_CLIENT 
WHERE EXISTS (SELECT T_FACTURE.CLI_ID FROM T_FACTURE
      WHERE T_FACTURE.CLI_ID = T_CLIENT.CLI_ID))
--Attention si email car pas obligatoire : jointure externe

--Adresse où envoyer factures aux clients

--Répartition des factures par mode de paiement (libellé)

--Répartition des factures par mode de paiement 

--Différence entre ces 2 requêtes ? 

--Factures sans mode de paiement 

--Repartition des factures par Années

--Repartition des clients par ville

--Montant TTC de chaque ligne de facture (avec remises)

--Classement du montant total TTC (avec remises) des factures

--Tarif moyen des chambres par années croissantes

--Tarif moyen des chambres par étage et années croissantes

--Chambre la plus cher et en quelle année

--Chambre la plus cher par année 

--Clasement décroissant des réservation des chambres 

--Classement décroissant des meilleurs clients par nombre de réservations

--Classement des meilleurs clients par le montant total des factures

--Factures payées le jour de leur édition

--Facture dates et Délai entre date de paiement et date d'édition de la facture