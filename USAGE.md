From: https://github.com/Oval-Tutu/bootstrap-love2d-project

# Development & Build Guide for LÖVE Game Template

Everything you need to know about developing, debugging, building and deploying your LÖVE game using this template system - from local development workflows to automated multi-platform releases. This guide covers technical setup, IDE integration, build configurations, and deployment options.

## Structure

Overview of the key files and directories in the template. The main components are GitHub Actions workflows, IDE configuration files, game source code, and build outputs.

```
.
├── .github                   GitHub Actions configuration
├── .editorconfig             EditorConfig file
├── .vscode                   Visual Studio Code configuration
│   ├── extensions.json
│   ├── launch.json
│   └── tasks.json
├── builds                    Game builds
├── src
│   ├── conf.lua              LÖVE configuration file
│   ├── main.lua              entry point
│   ├── product.env           Settings shared between the game and GitHub Actions
└── tools                     Tools for building and packaging the game
```

### .vscode

The `.vscode` folder contains project specific configuration.

- `extensions.json`: Contains the list of recommended extensions
- `launch.json`: Contains the settings for running the game or launching the debugger
- `tasks.json`: Contains the settings for building the game

You can configure additional settings and individual preferences via your own `.vscode/settings.json` that is excluded version control.

## Secrets

Secrets are stored in the GitHub repository settings and accessed by the GitHub Actions workflow.

- `https://github.com/{username}/{repository}/settings/secrets/actions`

## Configuring

The game and build settings are configured using `src/product.env`.
The most important settings to change for your game:

- `PRODUCT_NAME` - The name of your game
- `PRODUCT_ID` - Unique identifier in reverse domain notation. **Can not contain spaces or hyphens**.

### Save directory

**`PRODUCT_ID` is always used by `t.identity` in `src/conf.lua` to determine the save directory for the game.** This is important to consider when changing the `PRODUCT_ID` after the game has been released.

### Platform-Specific Product IDs

You can override the `PRODUCT_ID` for specific platforms.
If a platform-specific ID is empty or not set, the base `PRODUCT_ID` will be used instead. This is useful for:

- Different bundle IDs per platform
- App store requirements

```shell
# Base product ID (used as fallback)
PRODUCT_ID="com.oval-tutu.game"

# Optional platform-specific overrides
PRODUCT_ID_LINUX="com.mygame.linux"
PRODUCT_ID_MACOS="com.mygame.osx"
PRODUCT_ID_WINDOWS="com.mygame.windows"
```

- `PRODUCT_UUID` - **Generate new UUID** using `uuidgen` command or the [UUID Generator](https://www.uuidgenerator.net/)
- `PRODUCT_DESC` - Short description of your game
- `PRODUCT_COPYRIGHT` - Copyright notice
- `PRODUCT_COMPANY` - Your company/organization name
- `PRODUCT_WEBSITE` - Your game or company website

### Build Targets

You can disable build targets by setting them to `"false"` if you don't need builds for certain platforms.

```shell
# LÖVE version to target (only 11.5 is supported)
LOVE_VERSION="11.5"

# Enable/disable microphone access
AUDIO_MIC="false"

# Itch.io username for publishing
ITCH_USER="ovaltutu"

# Build output directory
OUTPUT_FOLDER="./builds"

# Game metadata
PRODUCT_NAME="Template"
PRODUCT_ID="com.ovaltutu.template"
PRODUCT_DESC="A template game made with LÖVE"
PRODUCT_COPYRIGHT="Copyright (c) 2025 Oval Tutu"
PRODUCT_COMPANY="Oval Tutu"
PRODUCT_WEBSITE="https://oval-tutu.com"
PRODUCT_UUID="3e64d17c-8797-4382-921f-cf488b22073f"

# Enable/disable build targets
TARGET_LINUX_APPIMAGE="true"
TARGET_LINUX_TARBALL="true"
TARGET_LOVE="true"
TARGET_LUAPAK="true"
TARGET_MACOS="true"
TARGET_WINDOWS_INSTALL="true"
TARGET_WINDOWS_SFX="false"
TARGET_WINDOWS_ZIP="true"
```

## GitHub Actions

The GitHub Actions workflow will automatically build and package the game for all the supported platforms that are enabled in `src/product.env` and upload them as assets to the GitHub releases page.

- Linux
  - AppImage
  - Tarball
- macOS
  - `.app` Bundle (*notarizing is not yet implemented*)
  - `.dmg` Disk Image (*notarizing is not yet implemented*)
- Windows (64-bit)
  - Installer (*NSIS installer, notarizing is not implemented*)
  - .exe (*self-extracting, notarizing is not implemented*)
  - .zip

### Development Builds

Development builds are triggered in two ways:
1. Manual trigger via GitHub Actions interface ("workflow_dispatch")
  - Go to "Actions" tab > "Build LÖVE" workflow > "Run workflow" button > "Run workflow"
2. Any push that isn't a version tag

The build process:
1. Creates a `.love` file from your game code
2. Packages platform-specific builds for enabled targets
3. Uploads artifacts to GitHub Actions

Artifacts produced (if enabled in `src/product.env`):
- `{PRODUCT_NAME}.love` - Base LÖVE game package
- `{PRODUCT_NAME}-installer.exe` - Windows installer
- `{PRODUCT_NAME}.exe` - Windows self-extracting executable
- `{PRODUCT_NAME}.zip` - Windows build
- `{PRODUCT_NAME}.app` - macOS application bundle
- `{PRODUCT_NAME}.dmg` - macOS disk image

Access the builds:
1. Go to your repository's Actions tab
2. Select the workflow run
3. Download artifacts from the "Artifacts" section
4. Extract the .zip files before use

**💡NOTE:** Artifacts are retained for 90 days by default.

### Release Builds

Make a new release by creating a version number git tag **without the `v` prefix**.

- **Create a new tag**: Use the following command to create a new tag.
  - *Replace `1.0.0` with your desired version number.*
```bash
git tag 1.0.0
```

- **Push the tag to GitHub**: Push the tag to the remote repository.
```bash
git push origin 1.0.0
```

- **GitHub Actions**: The GitHub workflow will automatically create a release and upload packages for all the supported platforms as assets.

## Publishing

On a Release Build (a tagged version), the GitHub Actions workflow will automatically publish the game artifacts for the enabled platforms to the GitHub releases page.
You can download the artifacts from the releases page and manually upload them to the appropriate stores.
But you can also automate this process for the following platforms:

### Itch.io

The GitHub Actions workflow will automatically publish the game artifacts for *enabled platforms* to Itch.io if `BUTLER_API_KEY` secret and `ITCH_USER` are set.
Get your API key from [Itch.io account](https://itch.io/user/settings/api-keys).
`ITCH_USER` from `src/product.env` will be used as the username, and `PRODUCT_NAME` from `src/product.env` (automatically converted to lowercase with spaces replaced with hyphens `-`) will be used as the game name.

For example this template project would attempt to publish to `ovaltutu/template`.

Not every artifact will be published to Itch.io, as some platforms are not supported, and some artifacts are unsuitable for distribution on Itch.io:

- `.love` files will be published to Itch.io as it is a requirement for LÖVE jams, is a convenient format for testing and can be hidden if required.
- Linux AppImage files will be published to Itch.io if `TARGET_LINUX_APPIMAGE` is enabled.
- macOS .dmg files will be published to Itch.io if `TARGET_MACOS` is enabled.
- Windows win64 self-extracting .exe files will be published (in a .zip) to Itch.io if `TARGET_WINDOWS_SFX` is enabled.


## Local GitHub Actions via act

**This is not required for the project to work.**

> Support for running GitHub Actions locally via `act` is mainly included to test the GitHub Actions workflow locally before pushing changes to the repository and accelerating the development process of the bundled actions.

In order to use the GitHub Actions locally, you'll need to install [act](https://nektosact.com/) and [Podman](https://podman.io/) or [Docker](https://www.docker.com/).

This template includes `.actrc` which will source local secrets and expose them as GitHub secrets to `act`.

The `.actrc` file configures how `act` runs GitHub Actions locally:

```plaintext
# Load GitHub secrets from this file
--secret-file=$HOME/.config/act/secrets

# Store build artifacts in the ./builds directory
--artifact-server-path=./builds

# Force container architecture to linux/amd64
--container-architecture=linux/amd64

# Disable automatic pulling of container images
--pull=false
```

Key configuration explained:

- `--secret-file` - Path to file containing GitHub secrets (API keys, signing keys etc.)
- `--artifact-server-path` - Local directory where build artifacts will be stored
- `--container-architecture` - Forces x86_64 container architecture for compatibility
- `--pull` - Prevents automatic downloading of container images on each run

Create the secrets file at `~/.config/act/secrets` with your GitHub repository secrets before running act.

### Running the GitHub Actions locally

- `act` will run all the GitHub Actions locally.
- `act -l` will list all the available GitHub Actions.
- `F<job>` will run a specific job.

#### macOS

To run jobs that runs-on: `macos-latest` on your Mac you'll need to use `act -P macos-latest=-self-hosted` which will run the job on your Mac instead of the GitHub runner. For example:
 - `act -j build-macos -P macos-latest=-self-hosted`

In order to run the macOS jobs you'll need to install the following:

- Install [Podman Desktop](https://podman-desktop.io/) or [Docker Desktop](https://www.docker.com/products/docker-desktop/).
- Install [Xcode](https://developer.apple.com/xcode/): `xcode-select --install`
- Install additional tools via [Homebrew](https://brew.sh/): `brew install act create-dmg tree`
