# CI & Github actions

I started working on how CI would run the lib. It is to validate that the lib can be used in a CI environment. If it was not possible, most of the value of the lib would be lost. I started with Github actions, because it is free and I wanted to learn more about it. But I found some problems

## Challenges

The first challenge was to run the simulator before the build. Using the plugin, it runs before the App itself is built. So it is before Xcode opens the simulator. Luckily, `simctl` has a status command that can be used to check if the simulator is running, boot the device and wait for it to be ready.

The second challenge was a required configuration that I had to use. The default github action to run a test uses a `-sdk iphonesimulator`, but it doesn't work because we need to build the plugin and the CLI using macos sdk. I will need to document this later.

The last challenge was that the lib currently only works with M1. It is a consequence of zipping only the results of a build, instead of the full project and building in the user machine. Unfortunately, Github actions does not support M1 yet. I was able to make it run on my machine using the `ci.sh` script, and I don't see why it would not work on CI. I had to self host my machine so I could test it. I could rollback to use the full project and build it in the CI, but I don't want to do it because it would be slower. In theory, next Xcode will only work on M1, so I think it is better to not worry about it and wait for github to add M1 support.