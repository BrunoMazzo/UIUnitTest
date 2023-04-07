# Future

## I'm frustrated

To be honest, I'm a bit frustrated, I didn't develop for some weeks now because of it. There is a very strong opinion on iOS development that UI should not be tested, or that you should try to remove all the logic from it, so that you don't need to test it. I don't agree with that. Everyone agrees that you should test all your public methods when developing a new class, and you shouldn't test your private ones, the UI is the real `public` interface of your app, and all the architectures that try to move logic away from it, are the private part of the code. From the user interface, it doesn't matter if you are using MVC, MVP, MVVM, Viper, Composable Architecture, Clean Architecture, or any other architecture, it only matter if the UI is working as expected.

I don't know if anyone will ever use this lib. But I will try to make what I think is right, and try to change that opinion. Other language thinks different, so I hope that one day, iOS will also think different.

## Problems with the lib

Ok, after that vent, let's go back to what I need to do.

I don't know the best way forward. Currently the libs has some limitations:
- It would not work on a real device, because it uses a pre build simulator .app
  - It would be possible if I move back to run the server project using xcodebuild
- It doesn't work on Intel Macs because of the pre build simulator .app
  - It would be possible if I move back to run the server project using xcodebuild
- It would not work on parallel tests, because it uses a single port
  - I can't think of a way to randomize the port, because the client needs to know the port to connect to the server
  - If I introduce another server, it may be possible, but I'm still not sure if it would work well
- It requires some setup before running the tests
  - At the moment that is the reason for the Xcode plugin, but it would not work if the simulator is not running
  - It will always require some setup, but I would like to make it as easy as possible to use.
- I need a better app to test my lib against it.
  - I'm thinking about writing a simple to do list using SwiftUI, and try to move the coverage close to 100% using my lib, as an example of how to use it.

## Next steps

I will move back to run the server project using xcodebuild. It would make it possible to work on intel macs, and in the future, on real devices. I will focus now on the CLI, and try to make it as easy as possible to use. The plugin will probably be deprecated.