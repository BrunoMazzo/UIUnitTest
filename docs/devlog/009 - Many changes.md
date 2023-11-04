# Many changes

Well, its been some time since I wrote here. I was still working on the lib, but not writing my ideas or the progress. 

I was able to put the lib in "production" on my company, and it's working well. At the moment we have near 200 tests running on the project and it's helping us a lot. It highlighted some of the flaws of the lib, some I already fixed, and others I'm working on them.

## What changed

- Now we have a sync API, mimicking Apples original one.
- Now we have pre build servers for M1 and Intel macs.
- And finally we have support for parallel testing

### Sync API

The principal reason for it was that doing assertions on async code is very verbose. The default XCTAsserts methods don't support async, so every assertion was a lot of boiler plate. I first tried to create other asserts methods for it, but having the sync API was much better for usuability. Other advantage is that now the learning curve is even smaller. If you know how to test using Apple's API, you know how to test using this lib.

### Pre build servers

I don't intent to support intel macs for much longer, Apple is already trying to kill them, but Github Actions only supports them at the moment, so I needed to support it if I want to have free CI. It was good for some of my coworkers that still have intel macs too.

### Parallel testing

This was one of the main target I had since the beginning of the lib. I know of the challenges that I would have to overcome for it, but some ideas that I had while doing other features made it possible. By accident, the reliability of the server got improved because of it, so it is a win-win.

The main problem with the lib is that UI tests are slower than normal Unit tests, so having the parallel option was always a must for me.

## What is next

Now it is time to improve the documentation and start to share the lib around. I know that some of my ideas are not really popular, but it can be a good tool for some people.