# set the version if it's not already set
VERSION?=dev-$(shell date +'%y.%m.%d-%H-%M')

export GO111MODULE=on

clean:
	rm -rf server-manager server-manager.exe -f
	rm -rf static/manager.js -f
	rm -rf build/ -f
	rm -rf rsrc.syso -f 
	rm -rf views/static_embed.go -f
	rm -rf static/static_embed.go -f
	rm -rf typescript/.gulp-cache -f

run:
	go build -ldflags "-s -w -X github.com/JustaPenguin/assetto-server-manager.BuildVersion=${VERSION} ${LDFLAGS}"
	FILESYSTEM_HTML=true DEBUG=true ./server-manager

assets:
	$(MAKE) -C typescript build

asset-embed:
	go install github.com/mjibson/esc@latest
	go generate ./...

deploy: clean assets asset-embed
	# directory structure
	mkdir -p build/linux build/windows
	cp linux.config.example.yml build/linux/config.yml
	cp windows.config.example.yml build/windows/config.yml
	mkdir -p build/linux/assetto build/windows/assetto build/linux/assetto/cfg build/windows/assetto/cfg
	cp -fR AssettoServer build/linux/assetto/ || echo "skip copying due to other thread"
	cp -fR AssettoServer build/windows/assetto/ || echo "skip copying due to other thread"
	cp extra_cfg.example.yml build/linux/assetto/cfg/extra_cfg.yml
	cp extra_cfg.example.yml build/windows/assetto/cfg/extra_cfg.yml
	sed -i 's/executable_path\: acServer/executable_path\: acServer.exe/' build/windows/config.yml


	# build
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -trimpath -a -installsuffix cgo -ldflags="-s -w -X github.com/JustaPenguin/assetto-server-manager.BuildVersion=${VERSION} ${LDFLAGS}" -o build/linux/server-manager
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -trimpath -ldflags="-s -w -X github.com/JustaPenguin/assetto-server-manager.BuildVersion=${VERSION} ${LDFLAGS}" -o build/windows/server-manager.exe

	cp ../../README.md build/README.txt
	cp ../../INSTALL.txt build/INSTALL.txt
	cp ../../LICENSE build/LICENSE.txt
	cp ../../CHANGELOG.md build/CHANGELOG.txt
	cp -R plugins build/
	mv build/plugins/lua_readme.md build/plugins/lua_readme.txt
	unix2dos build/README.txt build/LICENSE.txt build/CHANGELOG.txt build/windows/config.yml build/INSTALL.txt

	# archive
	cd build && zip -r ../server-manager_${VERSION}.zip *
