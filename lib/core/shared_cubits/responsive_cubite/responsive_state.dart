part of 'responsive_cubit.dart';

@immutable
abstract class ResponsiveState {}
class ResponsiveInitial extends ResponsiveState {}
class InitResponsiveState extends ResponsiveState {}
class CloseSideMenuState extends ResponsiveState {}
class ToggleFullScreenState extends ResponsiveState {}
class ChangeTree extends ResponsiveState {}
class ChangeShowButton extends ResponsiveState {
  final bool showButton;
  ChangeShowButton({required this.showButton});
}
class ChangeShowBottomTab extends ResponsiveState {
  final bool showBottomTab;
  ChangeShowBottomTab({required this.showBottomTab});
}
