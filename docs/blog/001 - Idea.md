# The idea

I have used many testing frameworks, not only for iOS, but also for other platforms. The one that I enjoyed a lot was [React Testing Library](https://testing-library.com/docs/react-testing-library/intro). Having the hability to test your UI was a game changer for me. It made it possible for me to really implement things as a black box, and gave me a lot of confidence when refactoring.

In iOS, I was always a big fan of [KIF](https://github.com/kif-framework/KIF). It enabled me to do something similar to what I was doing with React Testing Library. I was able to test my UI, and I was able to do it in a way that I could refactor my code without breaking my tests. To be honest, I was using KIF in a way a little different than the library was build for. I used to create many functions that would clean all the View hierarchy, and then I would create the view hierarchy that I wanted to test, usually just adding the view I was testing. This was I was able to do Unit test in the UI. 

I really believe that many of the "architectures" that exist in iOS are just a way to make possible to test your code. I think that the main reason why we have so many architectures is because we don't have a good way to test our code. I think that if we had a good way, we would think way different about architectures. We you use the architecture to fix more bigger problems, like the complexity of the code, the maintainability, the scalability, etc...

When Apple released [UI Tests](https://developer.apple.com/documentation/xctest/user_interface_tests), I really hoped that it would enable us to do easy UI Tests. But the way it was build forced us to run the whole application, instead of just the piece that we want to test. This made it impossible to do Unit Tests in the UI. I had seen many teams that create a lot of complexity to be able to mock the dependencies, to be able to use Apple UI Tests, and I think it is so sad to create so much accidental complexity just to be able to test your code.

Apple UI Tests is not like the React testing library, it is more similar with [Appium](https://appium.io) or others tools for End to end testing. It is a great tool, but don't allow us to do the more important thing, **unit test the UI**.

Kif is a great tool, but it has its limitations. This was when I had my idea:
```
Would it be possible to use the same technique that Appium or Maestro uses while I'm running an Unit test?
```

## Proof of concept

I went to see how Maestro works, and for my surprise it was way simple than I expected. Maestro basically runs a UI Test using Apple framework, and then start a server to receive commands and execute them using XCTest API. 

To test if my idea was going to be possible I basically create two projects, one was going to be the server and the other the unit test. I selected a simulator, started the server and ran the unit test. In my surprise, my server was able to read the UI and execute XCTest commands from the unit test. My idea was possible.