import 'package:crowdvise/core/domain/api_response/api_result.dart';
import 'package:crowdvise/core/domain/use_case/use_case.dart';
import 'package:crowdvise/features/history/domain/models/history_model.dart';
import 'package:crowdvise/features/history/domain/repository/history_repository.dart';

class GetHistoryUsecase implements UseCase<HistoryModel, void> {
  late final HistoryRepository repository;

  GetHistoryUsecase(this.repository);

  @override
  Future<ApiResult<HistoryModel>> invoke() {
    return repository.getHistory();
  }

  @override
  void get param => throw UnimplementedError();
}
