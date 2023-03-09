# Initial API design

## Before it

I studied how Maestro was starting the server, and I got some ideas from it. At the moment I just changed to be more lightweight, but I want to test more and see if it is stable enough.

## The API

Until now, the code was just a quick implementation, just to validate the idea and test it. Now I want to start implementing something more "Production ready". 

I need to cover most of the XCTest API, but it will be a long time, so I will start with the basics:
- Tap
- Enter text
- Exists
- Basic query matching

Initially I will probably allow matching with the identifier. After I am able to run all the cases, in most of the components, I can move to more complexes cases like scrolling and matching by accessibility labels.

To be honest, my knowledge about XCTest is not that good, so it will be a learning process for me. I think it may be a good idea to mimic the XCElement API, but I'm not sure if I like it.

### Return values

I need a way structure to return the values from the server. And errors have to be handled otherwise the server will stop. Most methods of XCElement doesn't throw errors, they just raise issues. So I will need a way to handle these type of errors.