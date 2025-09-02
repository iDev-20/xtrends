import 'package:flutter/material.dart';

class DashboardMetricGridView extends StatelessWidget {
  const DashboardMetricGridView(
      {super.key, required this.children, this.padding, this.physics});

  final List<Widget> children;
  final EdgeInsets? padding;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      padding: padding,
      physics: physics ?? const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 20,
      children: children,
    );
  }
}
