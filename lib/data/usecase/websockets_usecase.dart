import 'package:smart_mobile_app/domain/repository/AuthRepositories.dart';
import 'package:smart_mobile_app/domain/repository/task_repository.dart';

class ListenWebSocket {
  final AuthRepository repository;
  final TaskRepository taskRepository;
  ListenWebSocket(this.repository, this.taskRepository);


}
