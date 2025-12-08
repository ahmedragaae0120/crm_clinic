import 'dart:async';
import 'dart:developer';

import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/core/result.dart';
import 'package:crm_clinic/core/services/firebase_manager.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:crm_clinic/domain/use_cases/doctor/add_available_slots_for_doctor_usecase.dart';
import 'package:crm_clinic/domain/use_cases/doctor/get_all_slots_usecase.dart';
import 'package:crm_clinic/domain/use_cases/doctor/remove_slot_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_filter_popup_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'slot_state.dart';

@injectable
class SlotCubit extends Cubit<SlotState> {
  @factoryMethod
  SlotCubit(
    this._getAllSlotsUsecase,
    this._addSlotsForDoctorUsecase,
    this._removeSlotUsecase,
  ) : super(SlotState());

  @override
  Future<void> close() {
    _slotsSubscription?.cancel();
    return super.close();
  }

  final GetAllSlotsUsecase _getAllSlotsUsecase;
  final AddSlotsForDoctorUsecase _addSlotsForDoctorUsecase;
  final RemoveSlotUseCase _removeSlotUsecase;

  final User? _user = getIt<FirebaseManager>().currentUser;

  static SlotCubit get(context) => BlocProvider.of(context);

  FilterByDate filteredSlotType = FilterByDate.today;

  StreamSubscription? _slotsSubscription;

  void filteredSlots(FilterByDate filter) {
    filteredSlotType = filter;
    emit(state.copyWith());
    log('Filtering slots with filter: $filter');

    final mainList = state.slotsList ?? [];
    log('Main list contains ${mainList.length} slots');
    if (filter == FilterByDate.all) {
      emit(state.copyWith(getAllSlots: BaseSuccessState(mainList)));
      return;
    }
    final now = DateTime.now();
    final filteredList = mainList.where((slot) {
      final slotDate = slot.startTime ?? DateTime.now();
      switch (filter) {
        case FilterByDate.today:
          return slotDate.year == now.year &&
              slotDate.month == now.month &&
              slotDate.day == now.day;
        case FilterByDate.thisWeek:
          return slotDate.isAfter(
                now.subtract(Duration(days: now.weekday - 1)),
              ) &&
              slotDate.isBefore(now.add(Duration(days: 7 - now.weekday)));
        case FilterByDate.thisMonth:
          return slotDate.year == now.year && slotDate.month == now.month;
        default:
          return true; // For 'all'.tr();, no filtering
      }
    }).toList();
    if (isClosed) return;

    emit(state.copyWith(getAllSlots: BaseSuccessState(filteredList)));
  }

  void getAllAppointments() {
    _slotsSubscription?.cancel();
    _slotsSubscription = _getAllSlotsUsecase
        .call(doctorId: _user?.uid ?? "")
        .listen((event) {
          switch (event) {
            case Success():
              if (isClosed) return;

              emit(
                state.copyWith(
                  getAllSlots: BaseSuccessState(event.data ?? []),
                  slotsList: event.data ?? [],
                ),
              );

              filteredSlots(filteredSlotType);

              break;
            case Error():
              emit(
                state.copyWith(
                  getAllSlots: BaseErrorState(
                    event.exception.toString(),
                    event.exception,
                  ),
                ),
              );
          }
        });
  }

  void removeSlot(String slotId) async {
    final result = await _removeSlotUsecase.call(
      slotId: slotId,
      doctorId: _user?.uid ?? "",
    );
    switch (result) {
      case Success():
        if (isClosed) return;

        emit(state.copyWith(cancelAppointments: BaseSuccessState(null)));
        break;
      case Error():
        if (isClosed) return;
        emit(
          state.copyWith(
            cancelAppointments: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
    }
  }

  void addSlot(DateTime slot) async {
    emit(state.copyWith(addSlot: BaseLoadingState()));
    final result = await _addSlotsForDoctorUsecase.call(
      doctorId: _user?.uid ?? "",
      slot: slot,
    );

    switch (result) {
      case Success():
        if (isClosed) return;
        emit(state.copyWith(addSlot: BaseSuccessState(null)));
        break;
      case Error():
        emit(
          state.copyWith(
            addSlot: BaseErrorState(
              result.exception.toString(),
              result.exception,
            ),
          ),
        );
    }
  }
}
