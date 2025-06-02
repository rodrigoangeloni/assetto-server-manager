package main

import (
	"fmt"
	"net"
	"net/http"
	"runtime"
	"strings"

	"github.com/pkg/browser"
	"github.com/sirupsen/logrus"
)

type HTTPErrorHandler struct {
	Cause string
	Error error
}

const httpErrorMessage = `!!! An Error Occurred !!!
-------------------------

Failed to initialise server manager. 

Your configuration file is probably incorrect, or you haven't followed the instructions in the README properly. 
Please carefully check that your options are set correctly.

      Error Details
-------------------------

The error occurred attempting to: %s
The error more specifically is: %s

-------------------------

- The RodrigoAngeloni Team

Email: rodrigoangeloni@example.com
GitHub: https://github.com/rodrigoangeloni/assetto-server-manager

`

func (h *HTTPErrorHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, httpErrorMessage, h.Cause, h.Error)
}

func (h *HTTPErrorHandler) String() string {
	return fmt.Sprintf(httpErrorMessage, h.Cause, h.Error)
}

func ServeHTTPWithError(addr string, cause string, err error) {
	h := &HTTPErrorHandler{Cause: cause, Error: err}

	fmt.Println(h.String())

	listener, err := net.Listen("tcp", addr)

	if err != nil {
		return
	}

	if runtime.GOOS == "windows" {
		_ = browser.OpenURL("http://" + strings.Replace(addr, "0.0.0.0", "127.0.0.1", 1))
	}

	if err := http.Serve(listener, h); err != nil {
		logrus.Fatal(err)
	}
}
