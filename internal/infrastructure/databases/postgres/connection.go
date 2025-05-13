package postgres

import (
	"fmt"
	"sync"
	"time"

	"github.com/hilmanfitriana19/go-db-listener/pkg/config"
	"github.com/hilmanfitriana19/go-db-listener/pkg/dbLogger"
	"github.com/hilmanfitriana19/go-db-listener/pkg/logging"
	sqldblogger "github.com/simukti/sqldb-logger"
	"github.com/sirupsen/logrus"

	"github.com/jmoiron/sqlx"
	_ "github.com/lib/pq"
)

type DatabaseManager interface {
	Connect() (*sqlx.DB, error)
	GetDB() (*sqlx.DB, error)
}

type Database struct {
	Master string
	*sqlx.DB
}

var (
	dbOnce     sync.Once
	dbInstance DatabaseManager
)

func InitConnection() DatabaseManager {
	dbOnce.Do(func() {
		cfg := config.GetConfig()
		db := NewDatabase(cfg.DbDetails)
		_, err := db.Connect()
		if err != nil {
			logging.Logger().Error(fmt.Sprintf("Failed to connect to database: %v", err))
		}

		if cfg.AppEnv == "local" {
			db.DB.DB = sqldblogger.OpenDriver(cfg.DbDetails, db.Driver(), dbLogger.NewLogrusAdapter(logrus.New()))
		}

		dbInstance = db
	})
	return dbInstance
}

func NewDatabase(master string) *Database {
	return &Database{
		Master: master,
	}
}

func (db *Database) Connect() (*sqlx.DB, error) {
	conn, err := sqlx.Connect("postgres", db.Master)
	if err != nil {
		return nil, err
	}

	cfg := config.GetConfig()
	conn.SetMaxOpenConns(cfg.DbMaxPool)
	conn.SetMaxIdleConns(cfg.DbMinPool)
	conn.SetConnMaxLifetime(time.Minute * 10)

	db.DB = conn

	return conn, nil
}

func (db *Database) GetDB() (*sqlx.DB, error) {
	if db.DB == nil {
		return nil, fmt.Errorf("database is not connected")
	}

	stats := db.DB.Stats()
	if stats.OpenConnections > 40 {
		return nil, fmt.Errorf("database connection is full")
	}

	return db.DB, nil
}
