import 'package:flutter_test/flutter_test.dart';
import 'package:elingk/main.dart';

void main() {
  testWidgets('eLingk app renders', (WidgetTester tester) async {
    await tester.pumpWidget(const ELingkApp());

    expect(find.text('eLingk'), findsOneWidget);
    expect(find.text('Buat Pengaduan'), findsOneWidget);
  });
}
