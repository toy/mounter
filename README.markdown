# apfs-mounter

As `diskutil mount` can't unlock APFS encrypted volumes the way it can Core Storage ones.

# Usage

```sh
apfs-mounter VOLUME-UUID
```

# Build

```sh
xcodebuild
```

# Install

```sh
sudo cp build/Release/apfs-mounter /usr/local/bin
```
