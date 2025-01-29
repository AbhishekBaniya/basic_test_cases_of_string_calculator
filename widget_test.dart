// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sendmoney/main.dart';

/*void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget( MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}*/

void main() {
  late StringCalculator calculator;
  setUp(() => calculator = StringCalculator());
  test('returns 0 for an empty string', () =>
    expect(calculator.add(""), equals(0)));
  test('returns the number itself if only one number is provided', () {
    expect(calculator.add("1"), equals(1));
    expect(calculator.add("5"), equals(5));
  });
  test('adds two numbers separated by a comma', () {
    expect(calculator.add("1,2"), equals(3));
    expect(calculator.add("10,20"), equals(30));
  });
  test('handles new lines as valid delimiters', () {
    expect(calculator.add("1\n2,3"), equals(6));
    expect(calculator.add("4\n5\n6"), equals(15));
  });
  test('supports custom single-character delimiters', () {
    expect(calculator.add("//;\n1;2"), equals(3));
    expect(calculator.add("//#\n2#3#4"), equals(9));
  });
  test('supports custom multi-character delimiters', () {
    expect(calculator.add("//[***]\n1***2***3"), equals(6));
    expect(calculator.add("//[##]\n4##5##6"), equals(15));
  });
  test('supports multiple custom delimiters', () {
    expect(calculator.add("//[*][%]\n1*2%3"), equals(6));
    expect(calculator.add("//[;][!!]\n4;5!!6"), equals(15));
  });
  test('throws an exception for negative numbers', () {
    expect(() => calculator.add("1,-2,3"), throwsA(isA<Exception>()));
    expect(() => calculator.add("//;\n-1;2;-3"), throwsA(isA<Exception>()));
  });
  test('ignores numbers greater than 1000', () {
    expect(calculator.add("2,1001"), equals(2));
    expect(calculator.add("1000,1001,3"), equals(1003));
  });
}