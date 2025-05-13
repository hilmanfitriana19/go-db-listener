package main

import (
	"context"
	"os"
	"os/signal"

	"github.com/hilmanfitriana19/go-db-listener/internal/app"
	"github.com/hilmanfitriana19/go-db-listener/pkg/config"
	"github.com/hilmanfitriana19/go-db-listener/pkg/logging"
	"gopkg.in/DataDog/dd-trace-go.v1/ddtrace/tracer"
)

func main() {
	// Init Context And Cancel Function For Graceful Shutdown
	// This is used to gracefully Shut Sown the HTTP Server, Workers, Kafka Consumers in the same context
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// datadog tracer
	appEnv := config.GetConfig().AppEnv
	appName := config.GetConfig().AppName
	if appEnv == "staging" || appEnv == "production" {
		tracer.Start(
			tracer.WithEnv(appEnv),
			tracer.WithServiceName(appName),
		)
		span := tracer.StartSpan("manual.test")
		span.Finish()
		defer tracer.Stop()
	}

	// Init And Setup Main App
	mainApp := app.NewApp()
	mainApp.Setup()

	// Run Master Process
	go mainApp.RunMasterProcess(ctx, cancel)

	// Wait for interrupt signal
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, os.Interrupt, os.Kill)
	<-quit

	// Gracefully Stop The Server
	logging.Logger().Infof("Server %s gracefully stopped", config.GetConfig().AppName)
	cancel()
}
