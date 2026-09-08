import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:granary/widgets/common.dart';

/// Opens a dialog shaped like the app's edit dialogs and returns its result.
Future<bool?> _showTestDialog(WidgetTester tester,
    {required Widget Function(BuildContext) content}) async {
  bool? result;
  await tester.pumpWidget(MaterialApp(
    home: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              result = await showDialog<bool>(
                context: context,
                builder: (context) => SubmitOnEnter(
                  onSubmit: () => Navigator.pop(context, true),
                  child: AlertDialog(
                    content: SizedBox(width: 300, child: content(context)),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Save')),
                    ],
                  ),
                ),
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    ),
  ));
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  testWidgets('Enter in a text field saves the dialog', (tester) async {
    final controller = TextEditingController();
    await _showTestDialog(tester,
        content: (_) => DialogField(controller, 'Name', autofocus: true));

    await tester.enterText(find.byType(TextField), 'Groceries');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing,
        reason: 'Enter should close the dialog the same as clicking Save');
    expect(controller.text, 'Groceries');
  });

  testWidgets('Enter still saves after tabbing off the text field onto a '
      'dropdown', (tester) async {
    final controller = TextEditingController();
    await _showTestDialog(tester,
        content: (_) => Column(mainAxisSize: MainAxisSize.min, children: [
              DialogField(controller, 'Name', autofocus: true),
              DropdownButtonFormField<int>(
                initialValue: 1,
                items: const [
                  DropdownMenuItem(value: 1, child: Text('One')),
                  DropdownMenuItem(value: 2, child: Text('Two')),
                ],
                onChanged: (_) {},
              ),
            ]));

    // Move focus off the text field and onto the dropdown.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing,
        reason: 'Enter should save even when focus is on a dropdown');
  });
}
