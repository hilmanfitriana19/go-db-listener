package usecases

var (
	slUN = "Service Log Usecase"
)

var (
	errAddPartition                = "failed to add partition"
	errDownloadFileFromStorage     = "failed to download file from storage"
	errDecodeBase64Text            = "failed to decode base64 text"
	errDecryptText                 = "failed to decrypt text"
	errEncryptText                 = "failed to encrypt text"
	errGetDailyServiceLogs         = "failed to get daily service logs"
	errGetServiceLogs              = "failed to get service logs"
	errGetTotalServiceLogs         = "failed to get total service logs"
	errGetTotalFilteredServiceLogs = "failed to get total filtered service logs"
	errInsertServiceLog            = "failed to insert service log"
	errInvalidLoggedDate           = "invalid logged date"
	errParseTime                   = "failed to parse time"
	errServiceLogDetailToResponse  = "failed to convert service log detail to response"
	errServiceLogListToByteArr     = "failed to convert service log list to byte array"
	errUploadFileToStorage         = "failed to upload file to storage"
	fileNotFound                   = "File not found"
)
