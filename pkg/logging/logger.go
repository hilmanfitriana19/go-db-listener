package logging

import (
	"os"

	"github.com/hilmanfitriana19/go-db-listener/pkg/config"
	"github.com/sirupsen/logrus"
)

func Logger() *logrus.Logger {
	// Get Config
	cfg := config.GetConfig()

	// Set Logger
	logger := logrus.New()
	logger.SetFormatter(&logrus.JSONFormatter{})
	logLevel := logrus.TraceLevel
	logOutput := os.Stdout
	if cfg.AppEnv == "production" {
		logLevel = logrus.InfoLevel
		logOutput = os.Stdout
	}
	logger.SetLevel(logLevel)
	logger.SetOutput(logOutput)

	return logger
}
