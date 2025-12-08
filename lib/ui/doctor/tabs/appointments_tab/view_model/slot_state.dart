part of 'slot_cubit.dart';

class SlotState {
  BaseState? getAllSlots;
  BaseState? addSlot;
  BaseState? updateAppointments;
  BaseState? cancelAppointments;
  List<SlotModel>? slotsList;
  SlotState({
    this.getAllSlots,
    this.addSlot,
    this.updateAppointments,
    this.cancelAppointments,
    this.slotsList,
  });

  SlotState copyWith({
    BaseState? getAllSlots,
    BaseState? addSlot,
    BaseState? updateAppointments,
    BaseState? cancelAppointments,
    List<SlotModel>? slotsList,
  }) {
    return SlotState(
      getAllSlots: getAllSlots ?? this.getAllSlots,
      addSlot: addSlot ?? this.addSlot,
      updateAppointments: updateAppointments ?? this.updateAppointments,
      cancelAppointments: cancelAppointments ?? this.cancelAppointments,
      slotsList: slotsList ?? this.slotsList,
    );
  }
}
