import 'package:crm_clinic/core/Di/di.dart';
import 'package:crm_clinic/core/animations/screen_title_animation.dart';
import 'package:crm_clinic/core/reusable_comp/search_widget.dart';
import 'package:crm_clinic/core/utils/string_manager.dart';
import 'package:crm_clinic/domain/use_cases/doctor/add_available_slots_for_doctor_usecase.dart';
import 'package:crm_clinic/domain/use_cases/doctor/get_available_slots_for_doctor_usecase.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/view_model/receptionist_dashboard_cubit.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_filter_popup_button.dart';
import 'package:crm_clinic/core/utils/config.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_listview.dart';
import 'package:flutter/material.dart';

class ReceptionistDashboard extends StatelessWidget {
  const ReceptionistDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = ReceptionistDashboardCubit.get(context);
    Config().init(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 20,
            children: [
              Config.spaceSmall,

              ElevatedButton(
                onPressed: () {
                  final add = getIt<AddAvailableSlotsForDoctorUsecase>();
                  final get = getIt<GetAvailableSlotsForDoctorUsecase>();
                  get.call(doctorId: "iUjf0yXCIPXNFNVn01gfu4jGR093");
                  add.call(
                    doctorId: "iUjf0yXCIPXNFNVn01gfu4jGR093",
                    slots: [
                      DateTime.now().add(const Duration(days: 5, hours: 9)),
                      DateTime.now().add(const Duration(days: 6, hours: 10)),
                      DateTime.now().add(const Duration(days: 1, hours: 12)),
                      DateTime.now().add(const Duration(days: 1, hours: 15)),
                      DateTime.now().add(const Duration(days: 5, hours: 12)),
                      DateTime.now().add(const Duration(days: 3, hours: 12)),
                      DateTime.now().add(const Duration(days: 8, hours: 12)),
                    ],
                  );
                },
                child: const Text(
                  " Add Avalibale appointment to doctor ali test",
                ),
              ),
              Center(
                child: ScreenTitleAnimation(
                  title: AppStrings.welcomeReceptionistDashboard,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SearchWidget(onSearch: cubit.searchPatients),
                  PatientFilterPopupButton(cubit: cubit),
                ],
              ),
              const PatientListView(),
            ],
          ),
        ),
      ),
    );
  }
}
