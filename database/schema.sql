PRAGMA foreign_keys = ON;

BEGIN TRANSACTION;



CREATE TABLE IF NOT EXISTS roles (
   id_role INTEGER PRIMARY KEY AUTOINCREMENT,
 nom TEXT NOT NULL UNIQUE, 
 description TEXT );



CREATE TABLE IF NOT EXISTS permissions (
   id_permission INTEGER PRIMARY KEY AUTOINCREMENT, 
   nom TEXT NOT NULL UNIQUE, 
   description TEXT );



CREATE TABLE IF NOT EXISTS users ( 
  id INTEGER PRIMARY KEY AUTOINCREMENT,
   nom TEXT NOT NULL, prenom TEXT, 
   email TEXT NOT NULL UNIQUE, 
   password_hash TEXT NOT NULL, 
   statut TEXT NOT NULL DEFAULT 'actif',
    telephone TEXT, id_role INTEGER NOT NULL, 
    date_creation DATETIME DEFAULT CURRENT_TIMESTAMP, 
    date_modification DATETIME DEFAULT CURRENT_TIMESTAMP, 
    FOREIGN KEY (id_role) REFERENCES roles(id_role) ON UPDATE CASCADE ON DELETE RESTRICT );



CREATE TABLE IF NOT EXISTS disposer ( 
  id_role INTEGER NOT NULL,
   id_permission INTEGER NOT NULL,
    PRIMARY KEY (id_role, id_permission),
     FOREIGN KEY (id_role) REFERENCES roles(id_role) ON UPDATE CASCADE ON DELETE CASCADE,
      FOREIGN KEY (id_permission) REFERENCES permissions(id_permission) ON UPDATE CASCADE ON DELETE CASCADE );





CREATE TABLE IF NOT EXISTS refresh_token (
   id_token INTEGER PRIMARY KEY AUTOINCREMENT,
    token_hash TEXT NOT NULL UNIQUE,
     date_expiration DATETIME NOT NULL,
      id INTEGER NOT NULL,
       FOREIGN KEY (id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE );




CREATE TABLE IF NOT EXISTS entrepots (
   id_entrepot INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
     adresse TEXT,
      statut TEXT NOT NULL DEFAULT 'actif',
       date_creation DATETIME DEFAULT CURRENT_TIMESTAMP );




CREATE TABLE IF NOT EXISTS mouvements (
   id_mouvement INTEGER PRIMARY KEY AUTOINCREMENT,
    type TEXT NOT NULL,
     quantite INTEGER NOT NULL CHECK (quantite > 0),
      motif TEXT,
       date_mouvement DATETIME DEFAULT CURRENT_TIMESTAMP,
        id INTEGER NOT NULL,
         FOREIGN KEY (id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE RESTRICT );




CREATE TABLE IF NOT EXISTS categories (
   id_categorie INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL UNIQUE,
     description TEXT,
      date_creation DATETIME DEFAULT CURRENT_TIMESTAMP );




CREATE TABLE IF NOT EXISTS produits (
   id_produit INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
     sku TEXT NOT NULL UNIQUE,
      description TEXT,
       prix_achat REAL NOT NULL DEFAULT 0 CHECK (prix_achat >= 0),
        prix_vente REAL NOT NULL DEFAULT 0 CHECK (prix_vente >= 0),
         statut TEXT NOT NULL DEFAULT 'actif',
          id_mouvement INTEGER,
           id_categorie INTEGER NOT NULL,
            date_creation DATETIME DEFAULT CURRENT_TIMESTAMP,
             date_modification DATETIME DEFAULT CURRENT_TIMESTAMP,
              FOREIGN KEY (id_mouvement) REFERENCES mouvements(id_mouvement) ON UPDATE CASCADE ON DELETE SET NULL,
               FOREIGN KEY (id_categorie) REFERENCES categories(id_categorie) ON UPDATE CASCADE ON DELETE RESTRICT );



CREATE TABLE IF NOT EXISTS stocks (
   id_stock INTEGER PRIMARY KEY AUTOINCREMENT,
    quantite INTEGER NOT NULL DEFAULT 0 CHECK (quantite >= 0),
     id_entrepot INTEGER NOT NULL,
      id_produit INTEGER NOT NULL,
       date_modification DATETIME DEFAULT CURRENT_TIMESTAMP,
        UNIQUE (id_entrepot, id_produit),
         FOREIGN KEY (id_entrepot) REFERENCES entrepots(id_entrepot) ON UPDATE CASCADE ON DELETE RESTRICT,
          FOREIGN KEY (id_produit) REFERENCES produits(id_produit) ON UPDATE CASCADE ON DELETE RESTRICT );



CREATE TABLE IF NOT EXISTS fournisseurs (
   id_fournisseur INTEGER PRIMARY KEY AUTOINCREMENT,
    nom TEXT NOT NULL,
     email TEXT,
      telephone TEXT,
       adresse TEXT,
        date_creation DATETIME DEFAULT CURRENT_TIMESTAMP );



CREATE TABLE IF NOT EXISTS fournir (
   id_fournisseur INTEGER NOT NULL,
    id_produit INTEGER NOT NULL,
     PRIMARY KEY (id_fournisseur,
      id_produit),
       FOREIGN KEY (id_fournisseur) REFERENCES fournisseurs(id_fournisseur) ON UPDATE CASCADE ON DELETE CASCADE,
        FOREIGN KEY (id_produit) REFERENCES produits(id_produit) ON UPDATE CASCADE ON DELETE CASCADE );



CREATE TABLE IF NOT EXISTS details_mouvements (
   id_detail INTEGER PRIMARY KEY AUTOINCREMENT,
    id_mouvement INTEGER NOT NULL,
     id_produit INTEGER NOT NULL,
      id_entrepot INTEGER NOT NULL,
       quantite INTEGER NOT NULL CHECK (quantite > 0),
        FOREIGN KEY (id_mouvement) REFERENCES mouvements(id_mouvement) ON UPDATE CASCADE ON DELETE CASCADE,
         FOREIGN KEY (id_produit) REFERENCES produits(id_produit) ON UPDATE CASCADE ON DELETE RESTRICT,
          FOREIGN KEY (id_entrepot) REFERENCES entrepots(id_entrepot) ON UPDATE CASCADE ON DELETE RESTRICT );



CREATE TABLE IF NOT EXISTS historique_stocks (
   id_historique INTEGER PRIMARY KEY AUTOINCREMENT,
    id_stock INTEGER NOT NULL,
     ancienne_quantite INTEGER NOT NULL,
      nouvelle_quantite INTEGER NOT NULL,
       date_operation DATETIME DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (id_stock) REFERENCES stocks(id_stock) ON UPDATE CASCADE ON DELETE RESTRICT );



CREATE INDEX IF NOT EXISTS idx_users_role ON users(id_role); CREATE INDEX IF NOT EXISTS idx_refresh_token_user ON refresh_token(id); CREATE INDEX IF NOT EXISTS idx_refresh_token_expiration ON refresh_token(date_expiration); CREATE INDEX IF NOT EXISTS idx_mouvements_user ON mouvements(id); CREATE INDEX IF NOT EXISTS idx_produits_categorie ON produits(id_categorie); CREATE INDEX IF NOT EXISTS idx_produits_mouvement ON produits(id_mouvement); CREATE INDEX IF NOT EXISTS idx_stocks_entrepot ON stocks(id_entrepot); CREATE INDEX IF NOT EXISTS idx_stocks_produit ON stocks(id_produit); CREATE INDEX IF NOT EXISTS idx_fournir_produit ON fournir(id_produit); CREATE INDEX IF NOT EXISTS idx_disposer_permission ON disposer(id_permission); CREATE INDEX IF NOT EXISTS idx_details_mouvement ON details_mouvements(id_mouvement); CREATE INDEX IF NOT EXISTS idx_details_produit ON details_mouvements(id_produit); CREATE INDEX IF NOT EXISTS idx_historique_stock ON historique_stocks(id_stock);

COMMIT;