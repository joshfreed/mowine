#!/usr/bin/env sh
firebase emulators:exec --import test-data 'xcodebuild -project mowine.xcodeproj -scheme "mowine" -testPlan allTests -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 15 Pro,OS=17.0" test | xcpretty --report html --screenshots'
