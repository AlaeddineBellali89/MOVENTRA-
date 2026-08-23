import 'package:flutter_test/flutter_test.dart';
import 'package:moventra/main.dart';

void main() {
  testWidgets('MOVENTRA shell renders core navigation', (tester) async {
    await tester.pumpWidget(const MoventraApp());
    await tester.pumpAndSettle();

    expect(find.text('MOVENTRA'), findsOneWidget);
    expect(find.text('Today'), findsWidgets);
    expect(find.text('Workout'), findsWidgets);
    expect(find.text('Progress'), findsWidgets);
  });
}
