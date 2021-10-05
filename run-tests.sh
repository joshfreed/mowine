#!/usr/bin/env sh
firebase emulators:exec 'xcodebuild -project mowine.xcodeproj -scheme "mowine" -testPlan allTests -sdk iphonesimulator -destination "platform=iOS Simulator,name=iPhone 12 Pro,OS=15.0" test | xcpretty --report html --screenshots'
