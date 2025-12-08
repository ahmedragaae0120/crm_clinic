import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/core/utils/toast_message.dart';
import 'package:crm_clinic/data/model/doctor/slot_model.dart';
import 'package:crm_clinic/ui/doctor/tabs/appointments_tab/view_model/slot_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SlotWidget extends StatelessWidget {
  final SlotModel slot;
  final void Function() onDelete;
  const SlotWidget({super.key, required this.slot, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailable = slot.status == 'available';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isAvailable
            ? Colors.green.withValues(alpha: 0.5)
            : Colors.redAccent.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAvailable ? Colors.green : Colors.redAccent,
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(1, 2)),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          print('Tapped on slot: ${slot.id}');
        },
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_filled_rounded,
                    size: 28,
                    color: isAvailable ? Colors.green : Colors.redAccent,
                  ),
                  const SizedBox(height: 8),
                  FittedBox(
                    child: Text(
                      _formatTime(slot.startTime),
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isAvailable
                            ? Colors.green[800]
                            : Colors.red[700],
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slot.status ?? '',
                    style: TextStyle(
                      color: isAvailable ? Colors.green[700] : Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            BlocListener<SlotCubit, SlotState>(
              listenWhen: (previous, current) =>
                  previous.cancelAppointments != current.cancelAppointments,
              listener: (context, state) {
                if (state.cancelAppointments is BaseSuccessState<void>) {
                  toastMessage(
                    message: 'تم حذف الموعد بنجاح',
                    tybeMessage: TybeMessage.positive,
                  );
                } else if (state.cancelAppointments is BaseErrorState) {
                  toastMessage(
                    message: (state.cancelAppointments as BaseErrorState)
                        .errorMessage,
                    tybeMessage: TybeMessage.positive,
                  );
                }
              },
              child: Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.redAccent,
                  iconSize: 20,
                  onPressed: () {
                    onDelete.call();
                    print('Delete slot: ${slot.id}');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime? time) {
  if (time == null) return '---';
  return DateFormat('EEEE, dd MMM yyyy • hh:mm a', 'en').format(time);
}
