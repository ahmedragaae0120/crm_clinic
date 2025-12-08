import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:crm_clinic/ui/receptionist/tabs/receptionist_dashboard_tab/widgets/patient_filter_popup_button.dart';

class FilterTabBarWidget extends StatefulWidget {
  final void Function(FilterByDate filter)? onFilterChanged;

  const FilterTabBarWidget({super.key, this.onFilterChanged});

  @override
  State<FilterTabBarWidget> createState() => _FilterTabBarWidgetState();
}

class _FilterTabBarWidgetState extends State<FilterTabBarWidget>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  final List<FilterByDate> tabOrder = [
    FilterByDate.today,
    FilterByDate.thisWeek,
    FilterByDate.thisMonth,
    FilterByDate.all,
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filter = tabOrder[tabController.index];
      widget.onFilterChanged?.call(filter);
      // AppointmentsCubit.get(context).filteredAppointments(filter);
    });
    tabController.addListener(() {
      if (tabController.indexIsChanging == false) {
        log('Tab Index: ${tabController.index}');
        final filter = tabOrder[tabController.index];
        log('Selected Tab: ${filter.key}');
        widget.onFilterChanged?.call(filter);
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        TabBar(
          controller: tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.center,
          labelPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ), // 🔹 المسافة بين التابات
          indicator: BoxDecoration(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(tabController.index == 0 ? 30 : 0),
              right: Radius.circular(tabController.index == 3 ? 30 : 0),
            ),
            color: theme.colorScheme.primary,
            shape: BoxShape.rectangle,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey,
          physics: const BouncingScrollPhysics(),

          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          dividerColor: Colors.transparent, // يشيل الخط الأسود

          unselectedLabelStyle: const TextStyle(fontSize: 14),

          tabs: [
            Tab(text: FilterByDate.today.value),
            Tab(text: FilterByDate.thisWeek.value),
            Tab(text: FilterByDate.thisMonth.value),
            Tab(text: FilterByDate.all.value),
          ],
        ),
      ],
    );
  }
}
