import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dating_app/core/network/socket/socket_events.dart';
import 'package:dating_app/core/network/socket/socket_service.dart';
import 'package:dating_app/features/user/features/home/models/home_response_model.dart';
import 'package:dating_app/features/user/features/home/repository/home_repo.dart';
import 'package:dating_app/features/user/models/employee_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository homeRepository;
  final SocketService socketService;
  StreamSubscription? _listSubscription;
  StreamSubscription? _statusSubscription;

  HomeBloc({required this.homeRepository, required this.socketService})
    : super(LoadingState()) {
    on<ConnectSocket>(_onConnectSocket);
    on<SocketMessage>(_onSocketOnMessage);
    on<StatusUpdate>(_onStatusUpdate);
    on<FetchMoreEmployee>(_onFetchMore);
    on<DisconnectSocket>(_onDisconnectSocket);
    on<ResetHome>(_onResetHome);
    on<Filter>(_onFilter);

    _setupListeners();
  }

  void _setupListeners() {
    _listSubscription = socketService.employeeStream.listen((data) {
      add(SocketMessage(data));
    });

    _statusSubscription = socketService.statusStream.listen((data) {
      add(StatusUpdate(data));
    });
  }

  Future<void> _onConnectSocket(
    ConnectSocket event,
    Emitter<HomeState> emit,
  ) async {
    await socketService.connect(userId: event.userId);

    if (socketService.isConnected) {
      socketService.emit(SocketEvents.getNormalEmployees, {
        'limit': 20,
        'offset': 0,
      });
    }

    socketService.onConnect((_) {
      socketService.emit(SocketEvents.getNormalEmployees, {
        'limit': 20,
        'offset': 0,
      });
    });
  }

  Future<void> _onStatusUpdate(
    StatusUpdate event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final data = state as HomeLoaded;
      final update = event.data;
      final currentList = List<EmployeeModel>.from(
        data.responseModel.employees,
      );

      final index = currentList.indexWhere((e) => e.empId == update.employeeId);

      if (index != -1) {
        // Update known employee status without removing from list.
        currentList[index] = currentList[index].copyWith(status: update.status);
      } else if (update.employee != null) {
        // New employee appeared in realtime.
        currentList.insert(
          0,
          update.employee!.copyWith(status: update.status),
        );
      } else {
        // Status update arrived without employee data — re-request the list.
        socketService.emit(SocketEvents.getNormalEmployees, {
          'limit': 20,
          'offset': 0,
        });
        return;
      }

      const statusPriority = <String, int>{
        'online': 0,
        'busy': 1,
        'offline': 2,
      };

      currentList.sort((a, b) {
        final aRank = statusPriority[a.status ?? 'offline'] ?? 2;
        final bRank = statusPriority[b.status ?? 'offline'] ?? 2;
        return aRank.compareTo(bRank);
      });

      emit(
        HomeLoaded(
          HomeResponseModel(
            hasMore: data.responseModel.hasMore,
            employees: currentList,
          ),
        ),
      );
    }
  }

  void _onSocketOnMessage(SocketMessage event, Emitter<HomeState> emit) {
    final incomingData = event.data;

    if (state is HomeLoaded) {
      final currentData = state as HomeLoaded;
      final currentList = List<EmployeeModel>.from(
        currentData.responseModel.employees,
      );

      for (var newEmployee in incomingData.employees) {
        final index = currentList.indexWhere(
          (e) => e.empId == newEmployee.empId,
        );
        if (index != -1) {
          currentList[index] = newEmployee;
        } else {
          currentList.add(newEmployee);
        }
      }

      final updatedResponse = HomeResponseModel(
        hasMore: incomingData.hasMore,
        employees: currentList,
      );
      emit(HomeLoaded(updatedResponse));
    } else {
      emit(HomeLoaded(incomingData));
    }
  }

  Future<void> _onFetchMore(
    FetchMoreEmployee event,
    Emitter<HomeState> emit,
  ) async {
    if (state is HomeLoaded) {
      final currentList = (state as HomeLoaded).responseModel.employees;

      socketService.emit(SocketEvents.getNormalEmployees, {
        'limit': 20,
        'offset': currentList.length,
      });
    }
  }

  Future<void> _onFilter(Filter event, Emitter<HomeState> emit) async {
    emit(LoadingState());
    socketService.emit(SocketEvents.getNormalEmployees, {
      'language': event.language,

      'limit': 20,
      'offset': 0,
    });
  }

  Future<void> _onDisconnectSocket(
    DisconnectSocket event,
    Emitter<HomeState> emit,
  ) async {
    await socketService.disconnect();
  }

  void _onResetHome(ResetHome event, Emitter<HomeState> emit) {
    emit(LoadingState());
  }

  @override
  Future<void> close() {
    _listSubscription?.cancel();
    _statusSubscription?.cancel();
    socketService.disconnect();
    return super.close();
  }
}
