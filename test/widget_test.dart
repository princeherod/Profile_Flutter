import 'package:flutter_test/flutter_test.dart';
import 'package:alegria_lab3/main.dart';

void main() {
  testWidgets('Auth page renders login and registration toggle', (WidgetTester tester) async {
    await tester.pumpWidget(const LoginRegisterApp());

    // Verify initial Login state
    expect(find.text('Login'), findsWidgets);
    expect(find.text('Welcome Back!'), findsOneWidget);
    expect(find.text('No account yet? Register'), findsOneWidget);

    // Tap to switch to Register
    await tester.tap(find.text('No account yet? Register'));
    await tester.pump();

    // Verify Register state
    expect(find.text('Register'), findsWidgets);
    expect(find.text('Create an Account'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Confirm Password'), findsOneWidget);
  });
}
