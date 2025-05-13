package routes

import (
	"github.com/gofiber/fiber/v2"
	"github.com/hilmanfitriana19/go-db-listener/pkg/customValidator"
	"github.com/jmoiron/sqlx"
)

func InitRoutes(f *fiber.App, db *sqlx.DB, validate *customValidator.CustomStructValidator) {
	// Init group route
	v4 := f.Group("/v4")

	// Health Check
	v4.Get("/prv-health-check", func(c *fiber.Ctx) error {
		return c.JSON(fiber.Map{
			"success": true,
			"message": "FABD Core Provisioning Service is Running Properly",
		})
	})

	// Init Routes
}
