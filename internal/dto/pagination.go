package dto

type PaginationMeta struct {
	Page          int `json:"page"`
	Limit         int `json:"limit"`
	Total         int `json:"total"`
	TotalFiltered int `json:"total_filtered"`
}
