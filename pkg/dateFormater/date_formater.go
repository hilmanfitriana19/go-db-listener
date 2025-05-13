package dateFormater

import (
	"strings"
)

func SplitDateTime(dateString string) string {
	split := strings.Split(dateString, "T")
	if len(split) == 0 {
		return dateString
	}

	return split[0]
}
