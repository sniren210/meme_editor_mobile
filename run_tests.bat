@echo off
echo Running Meme Editor Mobile Tests
echo =================================

echo 1. Running Unit Tests...
flutter test test/

echo 2. Running Widget Tests...
flutter test test/features/presentation/

echo 3. Generating Coverage Report...
flutter test --coverage

echo 4. Running Integration Tests (requires device/emulator)...
echo Make sure you have a device connected or emulator running
echo To run integration tests manually, use:
echo flutter test integration_test/

echo Test run completed!
echo Coverage report available at: coverage/lcov.info
