package middleware

import (
	"github.com/gofiber/fiber/v2"
)

func ContentSecurityMiddleware(ctx *fiber.Ctx) error {
	if ctx.Method() == "POST" {
		acceptedContentTypes := []string{"application/json"}
		isValid := false
		for _, contentType := range acceptedContentTypes {
			if ctx.Get("Content-Type") == contentType {
				isValid = true
				break
			}
		}
		if !isValid {
			return ctx.Status(fiber.StatusUnsupportedMediaType).JSON(fiber.Map{
				"error": "Unsupported content type",
			})
		}
	}

	return ctx.Next()
}
