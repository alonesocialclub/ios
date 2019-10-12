# Alone Social Club

[![App Store](https://img.shields.io/itunes/v/1483344112.svg?label=app%20store)](https://itunes.apple.com/kr/app/alonesocialclub/id1483344112)
[![CI](https://github.com/alonesocialclub/ios/workflows/CI/badge.svg)](https://github.com/alonesocialclub/ios/actions)
[![codecov](https://codecov.io/gh/alonesocialclub/ios/branch/master/graph/badge.svg)](https://codecov.io/gh/alonesocialclub/ios)

Work alone, together.

## Development

```console
$ brew bundle
$ bundle install
$ make project
```

Then open the generated **AloneSocialClub.xcworkspace** with Xcode.

## Distribution

### Bumping version

Change `MARKETING_VERSION` and `CURRENT_PROJECT_VERSION` in [**project.yml**](Projects/AloneSocialClub/project.yml) file.

```yml
MARKETING_VERSION: 0.1.0
CURRENT_PROJECT_VERSION: 1
```

### Uploading to App Store Connect

It is recommended to execute those commands in background using such like `screen` to prevent from terminating by mistake.

* **TestFlight**:
  ```console
  $ make testflight
  ```

* **App Store**:
  ```console
  $ make appstore
  ```
