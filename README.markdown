# mounter

As `diskutil mount` can't unlock APFS encrypted volumes the way it (most of the time) can Core Storage ones.

# Usage

```sh
mounter apfs|cs VOLUME-UUID
```

# Build

```sh
xcodebuild
```

# Install

```sh
sudo cp build/Release/mounter /usr/local/bin
```
