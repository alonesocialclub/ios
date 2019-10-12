project:
	xcodegen generate
	bundle exec pod install

testflight:
	bundle exec fastlane beta --verbose
