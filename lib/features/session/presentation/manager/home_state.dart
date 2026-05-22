import 'package:crowdvise/features/session/domain/models/panel_size.dart';

class HomeState {
  PanelSize? selectedPanelSize;
  final List<PanelSize> panelSize = [
    PanelSize(value: '10', title: 'Quick', estimatedTime: '~2 min'),
    PanelSize(value: '25', title: 'Standard', estimatedTime: '~3 min'),
    PanelSize(value: '50', title: 'Deep', estimatedTime: '~10 min'),
  ];
}
