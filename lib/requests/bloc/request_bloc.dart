import 'package:bloc/bloc.dart';
import 'package:synhub/requests/bloc/request_event.dart';
import 'package:synhub/requests/bloc/request_state.dart';

import '../services/request_service.dart';

class RequestBloc extends Bloc<RequestEvent, RequestState> {
  final RequestService requestService;

  RequestBloc({required this.requestService}): super (RequestInitial()) {
    on<LoadMemberRequestsEvent>(_onLoadMemberRequests);
    on<LoadRequestByTaskIdEvent>(_onLoadRequestByTaskId);
  }

  Future<void> _onLoadMemberRequests(
      LoadMemberRequestsEvent event,
      Emitter<RequestState> emit,
      ) async {
    emit(RequestLoading());
    try {
      final requests = await requestService.getMemberRequests();
      emit(MemberRequestsLoaded(requests));
    } catch (e) {
      emit(RequestError(e.toString()));
    }
  }

  Future<void> _onLoadRequestByTaskId(
      LoadRequestByTaskIdEvent event,
      Emitter<RequestState> emit,
      ) async {
    emit(RequestLoading());
    try {
      final request = await requestService.getRequestByTaskId(event.taskId);
      emit(RequestDetailLoaded(request));
    } catch (e) {
      emit(RequestError(e.toString()));
    }
  }

}