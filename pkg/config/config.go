package config

import (
	"fmt"
	"log"
	"os"
	"strconv"

	"github.com/joho/godotenv"
)

// Environment variables
const (
	AppEnv               = "APP_ENV"
	AppName              = "APP_NAME"
	AppPort              = "APP_PORT"
	AppVersion           = "APP_VERSION"
	LogLevel             = "LOG_LEVEL"
	ShutdownDelay        = "SHUTDOWN_DELAY"
	DbHost               = "DB_HOST"
	DbPort               = "DB_PORT"
	DbUser               = "DB_USER"
	DbName               = "DB_NAME"
	DbPassword           = "DB_PASSWORD"
	DbMaxPool            = "DB_MAX_POOL"
	DbMinPool            = "DB_MIN_POOL"
	DbSslMode            = "DB_SSL_MODE"
	StoreIOEndpoint      = "STOREIO_ENDPOINT"
	StoreIOUseSSL        = "STOREIO_USE_SSL"
	StoreIOAccessKey     = "STOREIO_ACCESS_KEY"
	StoreIOSecretKey     = "STOREIO_SECRET_KEY"
	StoreIOPrivateBucket = "STOREIO_PRIVATE_BUCKET"
	StoreIODirectory     = "STOREIO_DIRECTORY"
	MaxRequestSizeInMb   = "MAX_REQUEST_SIZE_IN_MB"
)

type EnvConfig struct {
	AppEnv             string
	AppName            string
	AppPort            string
	AppVersion         string
	LogLevel           string
	ShutdownDelay      int
	DbDetails          string
	DbName             string
	DbMaxPool          int
	DbMinPool          int
	MaxRequestSizeInMb int
}

// Load environment variables with godotenv and initialize configuration
func init() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found")
	}
}

func GetConfig() *EnvConfig {
	dbDetails, dbName := getDbDetails()

	return &EnvConfig{
		AppEnv:        os.Getenv(AppEnv),
		AppName:       os.Getenv(AppName),
		AppPort:       os.Getenv(AppPort),
		AppVersion:    os.Getenv(AppVersion),
		LogLevel:      os.Getenv(LogLevel),
		ShutdownDelay: getEnvAsInt(ShutdownDelay, 10),
		DbDetails:     dbDetails,
		DbName:        dbName,
		DbMaxPool:     getEnvAsInt(DbMaxPool, 10),
		DbMinPool:     getEnvAsInt(DbMinPool, 5),
	}
}

func getDbDetails() (string, string) {
	host := os.Getenv(DbHost)
	port := os.Getenv(DbPort)
	user := os.Getenv(DbUser)
	password := os.Getenv(DbPassword)
	name := os.Getenv(DbName)
	sslMode := os.Getenv(DbSslMode)

	return fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=Asia/Jakarta",
		host, user, password, name, port, sslMode), name
}

func getEnvAsInt(key string, defaultVal int) int {
	if value, exists := os.LookupEnv(key); exists {
		val, err := strconv.Atoi(value)
		if err == nil {
			return val
		}
		log.Println("Invalid integer value for environment variable", key)
	}
	return defaultVal
}

func getEnvAsBool(key string, defaultVal bool) bool {
	if value, exists := os.LookupEnv(key); exists {
		val, err := strconv.ParseBool(value)
		if err == nil {
			return val
		}
		log.Println("Invalid boolean value for environment variable", key)
	}
	return defaultVal
}
