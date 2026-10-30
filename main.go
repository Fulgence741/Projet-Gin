package main

import (
	"Gestion-stock-Gin/config"
	//"Gestion-stock-Gin/routes"
	"log"
)

func main() {
	config.ConnectDatabase()

	//router := routes.SetupRoutes()

	log.Println("Serveur démarré sur http://localhost:8080")

	// if err := router.Run(":8080"); err != nil {
	log.Fatal("Erreur au démarrage du serveur :") //err)
}
