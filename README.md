# `qlmka`: A macOS Quick Look plugin to display Matroska `.mka` covers

This plugin adds support for showing thumbnails of Matroska `.mka` files in macOS Finder.
It uses a [custom Matroska parser](https://github.com/remko/go-mkvparse) for efficient scanning.

## Installation

1. Download and unpack the correct binary for your OS from the [Releases page](https://github.com/remko/qlmka/releases)
2. Move the `MKA.qlgenerator` package to `~/Library/QuickLook`. In Finder, use Cmd+Shift+G to enter
  the target path if necessary.
3. Restart Finder: Ctrl-Option-clicking the Finder icon in the dock, and choose 'Relaunch'.

## Development

Build the plugin:

    make

Install the plugin:

    make install

Test the plugin:

    make test-thumbnail-jpg
    make test-thumbnail-png
