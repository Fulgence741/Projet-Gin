package config

import (
	"log"

	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	database, err := gorm.Open(
		sqlite.Open("database.db"),
		&gorm.Config{})
	if err != nil {
		log.Fatal("Erreur de connexion à Sqlite:", err)
	}

	DB = database

	log.Println("Connexion reussie à Sqlite")
}
