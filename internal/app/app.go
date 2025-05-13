package app

import (
	"context"
	"fmt"
	"time"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/limiter"
	"github.com/hilmanfitriana19/go-db-listener/internal/app/routes"
	"github.com/hilmanfitriana19/go-db-listener/internal/infrastructure/databases/postgres"
	"github.com/hilmanfitriana19/go-db-listener/pkg/config"
	"github.com/hilmanfitriana19/go-db-listener/pkg/customValidator"
	"github.com/hilmanfitriana19/go-db-listener/pkg/errorHandler"
	"github.com/hilmanfitriana19/go-db-listener/pkg/logging"
	"github.com/jmoiron/sqlx"
)

type App struct {
	f         *fiber.App
	db        *sqlx.DB
	validator *customValidator.CustomStructValidator
}

func NewApp() *App {
	return &App{}
}

func (a *App) Setup() {
	// Setup Fiber with false pre-fork to make sure kafka consumer works well with child processes
	a.f = fiber.New(fiber.Config{
		IdleTimeout:  time.Second * 30,
		ReadTimeout:  time.Second * 30,
		WriteTimeout: time.Second * 30,
		Prefork:      true,
		ErrorHandler: errorHandler.GetHttpErrorHandler,
	})

	// Setup DB Connection : Postgres
	pgCon := postgres.InitConnection()
	pgDb, err := pgCon.GetDB()
	if err != nil {
		logging.Logger().Errorf("Failed to connect to database: %v", err)
	}
	a.db = pgDb

	// Setup Rate Limiter
	a.f.Use(limiter.New(limiter.Config{
		Max:        300,
		Expiration: 30 * time.Second,
		KeyGenerator: func(c *fiber.Ctx) string {
			return c.IP()
		},
		LimitReached: func(c *fiber.Ctx) error {
			return c.Status(fiber.StatusTooManyRequests).JSON(fiber.Map{
				"message": "Too many requests. Please try again later.",
			})
		},
	}))

	// Setup Global Middlewares

	// Setup Validator
	a.validator = customValidator.NewCustomValidator()

	// Set HTTP Routes
	routes.InitRoutes(a.f, a.db, a.validator)
}

func (a *App) RunMasterProcess(ctx context.Context, cancel context.CancelFunc) {
	// Start Fiber HTTP Server
	go func() {
		cfg := config.GetConfig()
		addr := fmt.Sprintf(":%s", cfg.AppPort)
		if err := a.f.Listen(addr); err != nil {
			logging.Logger().Infof("Could not start server: %v\n", err)
			cancel() // Cancel the context for Kafka consumers
		}
	}()

	// Wait for shutdown signal
	<-ctx.Done()
	a.ShutDown()
}

func (a *App) ShutDown() {
	if err := a.f.Shutdown(); err != nil {
		logging.Logger().Errorf("Could not gracefully shutdown the server: %v", err)
	}
}
