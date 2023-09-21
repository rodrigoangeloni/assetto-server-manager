Assetto Server Manager Traffic
======================


A web interface to manage an Assetto Corsa Server.

NOTE: a lot of stuff broken after integrating with AssettoServer. do not expect everything on server manager works!

# What's different?
### AssettoServer integration
[AssettoServer](https://github.com/compujuckel/AssettoServer)

### Easy AI configuration
![image](https://user-images.githubusercontent.com/23445078/229278649-e5f88262-8db7-45bc-9726-c9fd933abb84.png)

### Easy extra_cfg.yml configuration
![image](https://user-images.githubusercontent.com/23445078/229278692-f077e06a-b8cf-490e-b901-3424db049780.png)


# Usage
Download from release section of this repo, 

1. Update steam credentials in config.yml
 avoid changing the `executable_path` unless you plan to put AssettoServer in different folder
2. run server-manager.exe
3. do initial login
4. update admin password in options (must do this or AssettoServer will throw error)
5. upload track with "ai" folder that contains fast_lane.aip
example: 
![image](https://user-images.githubusercontent.com/23445078/229277902-a8b804d7-1679-4771-94bb-f79ba53328a5.png)
6. create a new custom race with `Race` and `Qualifying` turned off (ONLY PRACTICE ENABLED)
  a. set ai cars by setting `AI Option`  to `fixed` and human cars to `none`
7. start server

Changing the traffic configuration can be found on menu `Traffic Config`, make sure to lint the yaml before saving any changes.

Any error or server not starting issue, please refer to logs first under the section `Assetto Corsa Server`
![image](https://user-images.githubusercontent.com/23445078/229278104-c4450c2d-1024-4a96-b47e-700171426083.png)


# Building

Run
```
make deploy version="<versiontag>"
```

# Docker
Docker build is not yet updated
