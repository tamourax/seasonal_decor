# Release Checklist — seasonal_decor

## Pre-release

- [ ] `dart analyze --fatal-infos` passes with zero findings
- [ ] `flutter test --exclude-tags golden` passes (all unit + widget tests)
- [ ] `flutter test --tags golden` passes (visual regression)
- [ ] `flutter test test/performance_optimizations_test.dart` passes (budget checks)
- [ ] Bump version in `pubspec.yaml`
- [ ] Update `CHANGELOG.md`
- [ ] Verify example app runs cleanly: `cd example && flutter run`

## Publish

- [ ] `flutter pub publish --dry-run` succeeds
- [ ] `flutter pub publish`
- [ ] Tag release: `git tag v<version>`
- [ ] Push tag: `git push origin v<version>`
