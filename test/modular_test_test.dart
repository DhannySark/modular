import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app/app_module.dart';
import 'app/modules/home/home_module.dart';
import 'app/modules/home/home_widget.dart';
import 'app/modules/product/product_module.dart';
import 'app/shared/ILocalRepository.dart';
import 'app/shared/local_mock.dart';

main() {
  group("change bind", () {
    AppModule app = AppModule();
    setUp(() {
      initModule(AppModule(), changeBinds: [
        Bind<ILocalStorage>((i) => LocalMock()),
      ]);
    });
    test('ILocalStorage is a LocalMock', () {
      expect(Modular.get<ILocalStorage>(), isA<LocalMock>());
    });
    tearDown(() {
      Modular.removeModule(app);
    });
  });
  group("navigation test", () {
    AppModule app = AppModule();
    HomeModule home = HomeModule();
    ProductModule product = ProductModule();
    setUp(() {
      initModule(app, initialModule: true);
      initModules([home, product]);
    });
    testWidgets('on pushNamed modify actualRoute ', (WidgetTester tester) async{
      await tester.pumpWidget(buildTestableWidget(HomeWidget()));
      Modular.to.pushNamed('/prod');
      expect(Modular.actualRoute, '/prod');
    });
    tearDown(() {
      Modular.removeModule(product);
      Modular.removeModule(home);
      Modular.removeModule(app);
    });
  });
  group("arguments test", (){
    AppModule app = AppModule();
    HomeModule home = HomeModule();
    setUpAll(() {
      initModule(app, initialModule: true);
    });
    testWidgets("Arguments Page id", (WidgetTester tester) async{
      await tester.pumpWidget(buildTestableWidget(ArgumentsPage(id: 10,)));
      final titleFinder = find.text("10");
      expect(titleFinder, findsOneWidget);
    });
    testWidgets("Modular Arguments Page id", (WidgetTester tester) async{
      Modular.arguments(data: 10);
      await tester.pumpWidget(buildTestableWidget(ModularArgumentsPage()));
      final titleFinder = find.text("10");
      expect(titleFinder, findsOneWidget);
    });
    tearDownAll(() {
      Modular.removeModule(home);
      Modular.removeModule(app);
    });
  });
}
