# Setup of a PopOS

This little script allows you to set-up an entire PopOS with nice things.

To run this script just execute the following command:

```bash
curl -sSL setup.markel.dev/setup.sh | bash -
```

> Note: Currently [setup.markel.dev](https://setup.markel.dev) redirects to the main (unstable) version

### Magic Flags

#### LOADING

Possible values:

- INTEGRATED: The script includes loading symbols
- EXTERNAL: The main script is expected to provide the loading symbol (default)

#### SUDO

Possible values:

- DOLLAR: The script must be entered as the user but a sudo level may be requiered in some commands (default)
- ROOT: The script must be entered as root
- NONE: No root is necessary

#### SNAP

Possible values:

- TRUE: Snapd is used and therefore must be installed
- FALSE: Snapd is not requiered (default)

#### DATE

A numeric value (yymm) (2101 = 01/2021) which represents when was it created (used to know if it is a legacy thing or not)
