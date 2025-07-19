# Long time no see

A lot happened and I was not really working on the lib for some time. But this time helped me rethink some of the design decisions and move foward with some of the challenges that I faced with the lib.

A lot of things changed on iOS too. A new Swift version, a new testing framework. Concurrency is now a big thing and a lot of changes are needed to address it.

## Swift 6.0

With the new concurrency model, many changes were required to avoid potential data races. These changes highlighted one problem of the Sync API and I got very close to completly remove it.

## Swift testing

The new testing framework has many new behaviours that were nice, but conflict with the UIUnitTest assumptions. UIUnitTest shares the current UI, so they cannot run in parallel in the same simulator. The Sync API was deadlocking the main thread and failing some tests. I started working on some changes to address these problems, and I think I got to an OK solution. And now all the tests on XCTest have a Swift-Testing copy.

## NeoVim

This is more a personal change, but I decided to start learn Vim/NewVim. But iOS was really not friendly with it. Luckly I found one plugin recently that was a game changer, and now I'm really trying to do all the development of the lib on it. But it definitly reduced my speed, and I still going to be slower for some time, until I get used with the new tooling.

# Changes

- The Sync API will be kept as experimental. It is working on XCTests and Swift-Testing but it required some changes that were not 'nice' to say the least. I will still keep testing it, but I should change the documentation to give more space to the Async API
- The Async API was changed to match the Sync one. All the methods were the same now, the only difference it that they are `async throws`, but the use properties, subscripts and all match one to one with Apples APIs.
- Swift-Testing are in experimental phase, but the lib supports it. There is some `traits` that I need to dive deeper to understand, but it should work in other projects.
