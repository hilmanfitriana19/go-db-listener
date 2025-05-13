package customValidator

import (
	"github.com/go-playground/validator/v10"
	"time"
)

type CustomStructValidator struct {
	validator *validator.Validate
}

func validateUTC7(fl validator.FieldLevel) bool {
	timestamp := fl.Field().String()
	parsedTime, err := time.Parse(time.RFC3339, timestamp)
	if err != nil {
		return false
	}
	_, offset := parsedTime.Zone()

	return offset == 7*60*60
}

func (cv *CustomStructValidator) Validate(i interface{}) error {
	return cv.validator.Struct(i)
}

func NewCustomValidator() *CustomStructValidator {
	v := validator.New()

	// Register custom validation for utc7
	_ = v.RegisterValidation("utc7", validateUTC7)

	return &CustomStructValidator{validator: v}
}
