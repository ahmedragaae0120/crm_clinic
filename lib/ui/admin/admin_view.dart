import 'package:crm_clinic/core/utils/layout_builder.dart';
import 'package:crm_clinic/ui/admin/layout/desktop/admin_desktop_body.dart';
import 'package:crm_clinic/ui/admin/layout/mobile/admin_mobile_body.dart';
import 'package:flutter/material.dart';

class AdminView extends StatelessWidget {
  const AdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      mobileLayout: (context) => const AdminMobileBody(),
      tabletLayout: (context) => const AdminMobileBody(),
      desktopLayout: (context) => const AdminDesktopBody(),
    );
  }
}
