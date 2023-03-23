# Test Coverage

I wanted to add a coverage badge to the project, and to start working on tests to check our current implementation. But some challenges appeared.

## Challenges

The lib work as a client-server architecture. So both need to be tested, and both need to work together to garantee that the lib works as expected. 

One option would be to test the client and the server separately, but the whole philosophy of the lib is to make UI tests more blackbox and easier to implement, so I decided it would be better to test the whole lib together. But how?

The problem is that I need to run both server and client at the same time, get the coverage from both, merged it and then create the reports. 

At the moment, I'm running both tests in the same shell script, but I'm not sure if it is the best way to do it. I will need to research more about it.

Other thing that I notice is that the coverage is not 100% accurate. I know that Xcode has problems with coverage for local packages, but I'm not sure if it is the problem. I will need to investigate more about it.