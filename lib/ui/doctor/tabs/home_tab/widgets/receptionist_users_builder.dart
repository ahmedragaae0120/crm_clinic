import 'package:crm_clinic/core/utils/base_state.dart';
import 'package:crm_clinic/data/model/user_model.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/view_model/home_cubit.dart';
import 'package:crm_clinic/ui/doctor/tabs/home_tab/widgets/receptionist_users_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ReceptionistUsersBuilder extends StatelessWidget {
  const ReceptionistUsersBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state.getAllReceptionist is BaseErrorState) {
          return SliverToBoxAdapter(
            child: Center(
              child: Text(
                (state.getAllReceptionist as BaseErrorState).errorMessage,
              ),
            ),
          );
        }
        if (state.getAllReceptionist is BaseSuccessState<List<UserModel>>) {
          final receptionists =
              (state.getAllReceptionist as BaseSuccessState<List<UserModel>>)
                  .data ??
              [];
          if (receptionists.isEmpty) {
            // return const SliverToBoxAdapter(
            //   child: Center(
            //     child: Text(
            //       "No Receptionist Found",
            //       style: TextStyle(color: Colors.red),
            //     ),
            //   ),
            // );
          }
          return SliverToBoxAdapter(
            child: Skeletonizer(
              enabled: true,
              effect: const ShimmerEffect(
                baseColor: Color(0xFFEAEAEA),
                highlightColor: Colors.white,
              ),
              child: Column(
                children: List.generate(
                  4,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const CircleAvatar(radius: 24),
                        title: Container(
                          height: 12,
                          width: 100,
                          color: Colors.white,
                        ),
                        subtitle: Container(
                          height: 12,
                          width: 60,
                          color: Colors.white,
                        ),
                        trailing: const Icon(Icons.more_vert),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );

          // SliverList.builder(
          //   itemCount: receptionists.length,
          //   itemBuilder: (context, index) {
          //     return ReceptionistUsersWidget(
          //       receptionist: receptionists[index],
          //     );
          //   },
          // );
        }
        return SliverToBoxAdapter(
          child: Column(
            children: List.generate(
              4,
              (index) => const Skeletonizer(
                enabled: true,
                effect: ShimmerEffect(),
                child: ReceptionistUsersWidget(receptionist: UserModel()),
              ),
            ),
          ),
        );
      },
    );
  }
}
