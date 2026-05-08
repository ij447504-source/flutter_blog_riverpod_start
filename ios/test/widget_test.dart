import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_blog/main.dart';

void main() {
  testWidgets('renders the blog app', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pump();

    expect(find.byType(MyApp), findsOneWidget);
  });
}
