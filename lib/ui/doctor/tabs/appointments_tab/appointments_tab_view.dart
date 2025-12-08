import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/view_model/slot_cubit.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/widgets/add_slot_view_widget.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/widgets/slot_widget.dart';
import 'package:crm_clinic/ui/receptionist/tabs/appointments_tab/widgets/filter_tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppointmentsTabView extends StatelessWidget {
  const AppointmentsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (context) => getIt<SlotCubit>()..getAllAppointments(),
      child: Scaffold(
        floatingActionButton: Builder(
          builder: (innerContext) {
            return FloatingActionButton.extended(
              onPressed: () async {
                final slotCubit = innerContext.read<SlotCubit>();
                AddSlotsDialog.showAddDialog(innerContext, slotCubit);
              },
              backgroundColor: theme.colorScheme.primary,
              icon: const Icon(Icons.add_circle_outline_rounded, size: 28),
              label: const Text(
                'إضافة موعد',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            );
          },
        ),
        body: BlocBuilder<SlotCubit, SlotState>(
          buildWhen: (previous, current) =>
              previous.getAllSlots != current.getAllSlots,
          builder: (context, state) {
            if (state.getAllSlots is BaseErrorState) {
              return Center(
                child: Text((state.getAllSlots as BaseErrorState).errorMessage),
              );
            }
            if (state.getAllSlots is BaseSuccessState<List<SlotModel>>) {
              final slots =
                  (state.getAllSlots as BaseSuccessState<List<SlotModel>>)
                      .data ??
                  [];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  FilterTabBarWidget(
                    onFilterChanged: (filter) =>
                        SlotCubit.get(context).filteredSlots(filter),
                  ),

                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 1.8,
                          ),
                      padding: const EdgeInsets.all(16),
                      itemCount: slots.length,
                      itemBuilder: (context, index) {
                        final slot = slots[index];
                        return SlotWidget(
                          slot: slot,
                          onDelete: () {
                            SlotCubit.get(context).removeSlot(slot.id ?? "");
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.primary,
              ),
            );
          },
        ),
      ),
    );
  }
}
