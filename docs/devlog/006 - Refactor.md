# Refactor

I decided to refactor the lib to make it more flexible. At the moment, it was not possible to use queries without adding an identifier. And with the current implementation, it was not possible to add more of the XCTest APIs. 

## The new implementation

I decided since the beginning of the project to mimic the XCTest API, so I started to copy the classes and protocols that XCTests uses for UI tests. The Query class was able to call subqueries without specific identifiers, so I thought how I could make it work with a server-client architecture.

The solution for now it to keep the objects in the server and send identifiers to the client. The client will use the identifiers to call the methods in the server. This way, I'm able to use APIs that requires Elements as parameters, and the user can reuse or save queries and elements for later use.

## Challenges

Because now the elements and query lives in a cache on the server, but the identifiers (like pointers) are in the client, the memory management is a bit more complex. I had to add a `release` call when the client object dies, but I want to improve it a little in the future. At the moment it works fine, but I think I will create something similar with an `autorelease` pool to keep the references, and kill all after the test finish.

## Next steps

I believe that now I can implement almost all methods from the XCTest API. I will need to work a little on it, but with the exception of `addUIInterruptionMonitor` and `addUIInterruptionMonitorWithDescription`, I think I can implement all the methods. I have ideas on how I can implement the interruption monitors, but I will need to test it first.