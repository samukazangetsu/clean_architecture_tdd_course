import 'package:clean_architecture_tdd_course/features/number_trivia/presentation/widgets/widgets_import.dart';
import 'package:clean_architecture_tdd_course/injection_container.dart'
    as dependencyInjection;
import 'package:clean_architecture_tdd_course/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.init();

  testWidgets(
    "Deve apresentar o componente [MessageDisplay] quando abrir o app e o usuário não digitar nada",
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(MessageDisplay), findsOneWidget);
    },
  );

  testWidgets(
    "Deve retornar um componente [TriviaDisplay] ao clicar no botão de pesquisar curiosidade aleatória",
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('get_random_button')));
      await tester.pumpAndSettle();

      expect(find.byType(TriviaDisplay), findsOneWidget);
    },
  );

  testWidgets(
    'Deve retornar um componente [TriviaDisplay] contendo o texto [123] ao digitar 123 e clicar no botão de pesquisar',
    (WidgetTester tester) async {
      await tester.pumpWidget(MyApp());
      await tester.pumpAndSettle();

      final campoDeTexto = find.byType(TextField);
      expect(campoDeTexto, findsOneWidget);

      await tester.enterText(
        campoDeTexto,
        '123',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('search_button')));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TriviaDisplay, '123'), findsOneWidget);
    },
  );
}
