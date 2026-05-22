import 'package:crowdvise/core/presentation/manager/custom_provider.dart';
import 'package:crowdvise/features/session/domain/models/panel_size.dart';
import 'package:crowdvise/features/session/presentation/manager/home_state.dart';

class HomeProvider extends CustomProvider {
  final state = HomeState();

  void selectPanelSize(PanelSize panelSize) {
    state.selectedPanelSize = panelSize;
    notifyListeners();
  }
  
}