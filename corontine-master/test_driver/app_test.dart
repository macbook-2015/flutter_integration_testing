import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
  loginTest() {
    test('Login Test', () async {
      final emailField = find.byValueKey('LoginEmail');
      await driver.tap(emailField);
      await driver.enterText('hamza.mateen@venturedive.com');
      final userNameField = find.byValueKey('LoginUsername');
      await driver.tap(userNameField);
      await driver.enterText('Hamza123');
      await driver.tap(find.byValueKey('LoginButton'));
    });
  }

  logoutTest() {
    test('Logout Test', () async {
      await driver.tap(find.byTooltip('Logout'));
      await driver.tap(find.byValueKey('Logout_Yes'));
    });
  }

  openDrawer() {
    test('Open Drawer', () async {
      await driver.tap(find.byValueKey('DrawerIcon'));
    });
  }

  closeDrawer() {
    test('Close Drawer', () async {
      await driver.scroll(find.byType('Drawer'), -300.0, 0.0,
          const Duration(milliseconds: 300));
    });
  }

  registrationTest() {
    test('Registration Test', () async {
      final nameField = find.byValueKey('RegName');
      await driver.tap(nameField);
      await driver.enterText('Hamza Abdul Mateen');
      final emailField = find.byValueKey('RegEmail');
      await driver.tap(emailField);
      await driver.enterText('hamza.mateen@venturedive.com');
      final userNameField = find.byValueKey('RegUsername');
      await driver.tap(userNameField);
      await driver.enterText('Hamza123');
      await driver.tap(find.byValueKey('CreateUserButton'));
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('OKButton'));
      });
      final codeField = find.byValueKey('RegCode');
      await driver.tap(codeField);
      await driver.enterText('123456');
      await driver.tap(find.byValueKey('RegisterButton'));
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('OKButton'));
      });
    });
  }

  suggestions() {
    test('Open Suggestions', () async {
      await driver.tap(find.text('SUGGESTIONS'));
    });
    test('Write Suggestion Title and Content', () async {
      await driver.tap(find.byValueKey('SuggestionTitle'));
      await driver.enterText('Data Presentation');
      await driver.tap(find.byValueKey('SuggestionContent'));
      await driver.enterText(
          'I believe that if you present the data in a better way, it would be easier for users to read it. Digits are not visible for old age people.');
      await driver.tap(find.text('SUGGEST NOW!'));
      await driver.runUnsynchronized(() async {
        await driver.tap(find.byValueKey('OKButton'));
      });
    });
  }

  Future<void> delay(int seconds) async {
    await Future<void>.delayed(Duration(seconds: seconds));
  }

  group('Testing App Performance Tests', () {
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('Swipe to Register Tab', () async {
      await driver.scroll(find.byType('TabBarView'), -300.0, 0.0,
          const Duration(milliseconds: 300));
    });
    registrationTest();
    loginTest();
    openDrawer();
    closeDrawer();
    openDrawer();
    suggestions();
    openDrawer();
    test('Open Country Wise Stats', () async {
      await driver.tap(find.text('COUNTRY WISE STATS'));
    });
    test('Open Close Country Cards', () async {
      for (int i = 0; i < 10; i++) {
        await driver.tap(find.byValueKey('Open$i'));
        await driver.tap(find.byValueKey('Close$i'));
      }
      final listFinder = find.byValueKey('CountriesList');
      final itemFinder = find.text('Pakistan');
      await driver.runUnsynchronized(() async {
        await driver.traceAction(() async {
          await driver.scrollUntilVisible(listFinder, itemFinder,
              dyScroll: -300);
        });
        await driver.tap(find.text('Pakistan'));
      });
      delay(3);
      await driver.tap(find.pageBack());
      await driver.tap(find.pageBack());
    });

    logoutTest();
    // test('Close Country Wise Stats', () async {
    //   await driver.tap(find.byType('Icon'));
    // });
    // test('Close Suggestions', () async {
    //   await driver.tap(find.pageBack());
    // });

    // test('Scrolling test', () async {
    //   final listFinder = find.byValueKey('CountriesList');

    //   final scrollingTimeline = await driver.traceAction(() async {
    //     await driver.scroll(listFinder, 0, -9000, Duration(seconds: 1));
    //     await driver.scroll(listFinder, 0, 10000, Duration(seconds: 1));
    //   });

    //   final scrollingSummary = TimelineSummary.summarize(scrollingTimeline);
    //   await scrollingSummary.writeSummaryToFile('scrolling', pretty: true);
    //   await scrollingSummary.writeTimelineToFile('scrolling', pretty: true);
    // });

    // test('Horizontal Scrolling test', () async {
    //   final listFinder = find.byValueKey('RestaurantList');
    //   final itemFinder = find.byValueKey('RestaurantItem7');

    //   final scrollingTimeline = await driver.traceAction(() async {
    //     await driver.scrollUntilVisible(listFinder, itemFinder, dxScroll: -400);
    //   });

    //   final scrollingSummary = TimelineSummary.summarize(scrollingTimeline);
    //   await scrollingSummary.writeSummaryToFile('scrolling', pretty: true);
    //   await scrollingSummary.writeTimelineToFile('scrolling', pretty: true);
    // });

    // test('Search Bar', () async {
    //   final searchBar = find.byType('TextField');
    //   await driver.tap(searchBar);
    //   await driver.enterText('Hello world');
    //   await driver.waitFor(find.text('Hello world'));
    // });

    // test('Weather Navigation', () async {
    //   await driver.tap(find.byValueKey('Nav'));
    // });

    // test('Weather Reload', () async {
    //   await driver.tap(find.byValueKey('Refresh'));
    // });
    // test('Favorites operations test', () async {
    //   final operationsTimeline = await driver.traceAction(() async {
    //     final iconKeys = [
    //       'icon_0',
    //       'icon_1',
    //       'icon_2',
    //     ];

    //     for (var icon in iconKeys) {
    //       await driver.tap(find.byValueKey(icon));
    //       await driver.waitFor(find.text('Added to favorites.'));
    //     }

    //     await driver.tap(find.text('Favorites'));

    //     final removeIconKeys = [
    //       'remove_icon_0',
    //       'remove_icon_1',
    //       'remove_icon_2',
    //     ];

    //     for (final iconKey in removeIconKeys) {
    //       await driver.tap(find.byValueKey(iconKey));
    //       await driver.waitFor(find.text('Removed from favorites.'));
    //     }
    //   });

    //   final operationsSummary = TimelineSummary.summarize(operationsTimeline);
    //   await operationsSummary.writeSummaryToFile('favorites_operations',
    //       pretty: true);
    //   await operationsSummary.writeTimelineToFile('favorites_operations',
    //       pretty: true);
    // });
  });
}
