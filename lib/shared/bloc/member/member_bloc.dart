import 'dart:convert';
import 'package:bloc/bloc.dart';
import '../../models/member.dart';
import '../../services/member_service.dart';
import 'member_event.dart';
import 'member_state.dart';

class MemberBloc extends Bloc<MemberEvent, MemberState> {
  final MemberService memberService;

  MemberBloc({required this.memberService}) : super(MemberInitial()) {
    on<FetchMemberDetailsEvent>(_onFetchMemberDetails);
  }

  Future<void> _onFetchMemberDetails(
      FetchMemberDetailsEvent event,
      Emitter<MemberState> emit,
      ) async {
    emit(MemberLoading());
    try {
      final response = await memberService.getMemberDetails();

      if (response.statusCode == 200) {
        final member = Member.fromJson(json.decode(response.body));
        emit(MemberLoaded(member));
      } else {
        emit(MemberError('Failed to load member details'));
      }
    } catch (e) {
      emit(MemberError('Error: $e'));
    }
  }
}