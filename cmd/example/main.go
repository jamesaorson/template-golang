package main

import (
	"log/slog"
	"os"

	internal "github.com/jamesaorson/template-golang/internal/example"
)

const ReadHeaderTimeoutInSec = 5

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	var config internal.Config
	if err := internal.LoadConfig(&config); err != nil {
		logger.Error("error loading config", slog.String("error", err.Error()))
		panic(err)
	}
	logger.Info("loaded config", slog.Any("config", config))
}
