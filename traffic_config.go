package servermanager

import (
	"bufio"
	"net/http"
	"os"
	"path/filepath"

	"github.com/sirupsen/logrus"
)

const (
	serverTrafficConfigYamlPath = "extra_cfg.yml"
)

type TrafficConfigHandler struct {
	*BaseHandler

	store Store
}

type trafficConfigTemplateVar struct {
	BaseTemplateVars
	Config string
}

type TrafficConfig struct {
	Config string
}

func (tch *TrafficConfigHandler) view(w http.ResponseWriter, r *http.Request) {
	tc := TrafficConfig{}

	if err := tc.readConfig(); err != nil {
		logrus.WithError(err).Errorf("couldn't read config")
		AddErrorFlash(w, r, "Fail to read config")
	}
	tch.viewRenderer.MustLoadTemplate(w, r, "traffic-config/index.html", &trafficConfigTemplateVar{
		Config: tc.Config,
	})
}

func (tch *TrafficConfigHandler) save(w http.ResponseWriter, r *http.Request) {

	if err := r.ParseForm(); err != nil {
		logrus.WithError(err).Errorf("couldn't save config")
		AddErrorFlash(w, r, "Failed to parse form")
	}

	config := TrafficConfig{
		r.FormValue("traffic-config"),
	}

	if err := config.saveConfig(); err != nil {
		logrus.WithError(err).Errorf("couldn't save config")
		AddErrorFlash(w, r, "Failed to save config options")
	} else {
		AddFlash(w, r, "Traffic config successfully saved!")
	}

	tch.viewRenderer.MustLoadTemplate(w, r, "traffic-config/index.html", &trafficConfigTemplateVar{
		Config: config.Config,
	})
}

func (tc *TrafficConfig) readConfig() error {
	dat, err := os.ReadFile(filepath.Join(ServerInstallPath, ServerConfigPath, serverTrafficConfigYamlPath))
	if err != nil {
		return err
	}
	tc.Config = string(dat)
	return err
}

func (tc *TrafficConfig) saveConfig() error {
	path := filepath.Join(ServerInstallPath, ServerConfigPath, serverTrafficConfigYamlPath)
	// open output file
	fo, err := os.Create(path)
	if err != nil {
		return err
	}
	w := bufio.NewWriter(fo)

	_, err = w.WriteString(tc.Config)

	if err != nil {
		return err
	}

	w.Flush()
	// close fo on exit and check for its returned error
	defer func() {
		if err := fo.Close(); err != nil {
			return
		}
	}()
	return err
}

func NewTrafficConfigHandler(baseHandler *BaseHandler, store Store) *TrafficConfigHandler {
	return &TrafficConfigHandler{
		BaseHandler: baseHandler,
		store:       store,
	}
}
