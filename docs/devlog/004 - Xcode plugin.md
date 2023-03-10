# Xcode plugin

I experimented with a Xcode plugin to make the integration easier. I had never done a Xcode plugin before, so it was a good opportunity to learn. Basically I added the plugin as part of the Swift package, so the user can just install the package and the plugin will be available to use during the build. The plugin basically only calls the command line, to install the server and run it. 

It still have many problems, it only work if the simulator is already open, and only work with only one simulator is open. I will try to fix these issues later, for now it good enough for me to try use in projects and makes more sense to focus in lib API.