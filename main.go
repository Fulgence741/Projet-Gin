package main

import (
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	router.GET("/", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "Bienvenue dans l'API de gestion de stock",
		})
	})

	router.Run(":8080")
}
