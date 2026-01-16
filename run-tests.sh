#!/usr/bin/env sh
firebase emulators:exec --import test-data 'xcodebuild -project mowine.xcodeproj -scheme "mowine" -testPlan allTests -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.0.1" test | xcpretty --report html --screenshots'
