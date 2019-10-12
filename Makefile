project:
	xcodegen generate
	bundle exec pod install

beta:
	bundle exec fastlane beta --verbose
