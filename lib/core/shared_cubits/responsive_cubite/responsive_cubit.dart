import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'responsive_state.dart';

class ResponsiveCubit extends Cubit<ResponsiveState> {
  ResponsiveCubit() : super(ResponsiveInitial());
  bool isFullScreen = false;
  bool showButton = true;
  bool showBottomTab = true;
  double width = 0.0;

  /// show menu
  bool sideMenuIsOpen = true;
  bool showMainMenu = true;
  bool showCustomerAndSaleMenu = false;
  bool showAccountAdminMenu = false;

  void changeTree() {
    showMainMenu = !showMainMenu;
    showCustomerAndSaleMenu = false;
    showAccountAdminMenu = false;
    emit(ChangeTree());
  }

  void changeToSalesTree() {
    showMainMenu = false;
    showAccountAdminMenu = false;
    showCustomerAndSaleMenu = !showCustomerAndSaleMenu;
    emit(ChangeTree());
  }

  void changeToAccountsAdminTree() {
    showMainMenu = false;
    showCustomerAndSaleMenu = false;
    showAccountAdminMenu = !showAccountAdminMenu;
    emit(ChangeTree());
  }

  double getWidth(
    BuildContext context, {
    double? ratioMobile, // ratio to get width for mobile only
    double? ratioDesktop, // ratio to get width for Desktop only
    double? ratioDesktopOpenSideMenu, // ratio to get width for Desktop only
    double? ratioTablet, // ratio to get width for Tablet only
  }) {
    // Listen to locale change to rebuild when language changes
    // width will return after calculate
    double widthOfRatioItem = 0.0;

    // width Screen Now
    final double widthScreenNow = sideMenuIsOpen
        ? MediaQuery.of(context).size.width -
            (MediaQuery.of(context).size.width * 0.18)
        : MediaQuery.of(context).size.width;

    // check if isMobile && isTablet && isDesktop
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width < 1200 &&
        MediaQuery.of(context).size.width > 600;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1200;

    /// calculate width
    if (isMobile) {
      widthOfRatioItem = widthScreenNow * (ratioMobile ?? 0.0);
    } else if (isTablet) {
      widthOfRatioItem = widthScreenNow * (ratioTablet ?? 0.0);
    } else if (isDesktop) {
      widthOfRatioItem = widthScreenNow *
          (sideMenuIsOpen
              ? (ratioDesktopOpenSideMenu ?? ratioDesktop ?? 0.0)
              : (ratioDesktop ?? 0.0));
    }
    return widthOfRatioItem;
  }

  double getHeight(
    BuildContext context, {
    double? ratioMobile, // ratio to get height for mobile only
    double? ratioDesktop, // ratio to get height for Desktop only
    double? ratioTablet, // ratio to get height for Tablet only
    double? ratioTabletPortrait, // ratio to get height for Tablet only
  }) {
    // height will return after calculate
    double heightOfRatioItem = 0.0;
    // height Screen Now
    final double heightScreenNow = MediaQuery.of(context).size.height;

    // check if isMobile && isTablet && isDesktop
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final bool isTablet = MediaQuery.of(context).size.width < 1200 &&
        MediaQuery.of(context).size.width > 600;
    final bool isDesktop = MediaQuery.of(context).size.width >= 1200;

    /// calculate height
    if (isMobile) {
      heightOfRatioItem = heightScreenNow * (ratioMobile ?? 0.0);
    } else if (isTablet) {
      if (MediaQuery.of(context).orientation == Orientation.portrait) {
        heightOfRatioItem = heightScreenNow * (ratioTabletPortrait ?? 0.0);
      } else {
        heightOfRatioItem = heightScreenNow * (ratioTablet ?? 0.0);
      }
    } else if (isDesktop) {
      heightOfRatioItem = heightScreenNow * (ratioDesktop ?? 0.0);
    }
    return heightOfRatioItem;
  }

  bool isMobile(BuildContext context) {
    // Listen to locale change to rebuild when language changes
    width = MediaQuery.of(context).size.width;
    return MediaQuery.of(context).size.width < 600;
  }

  bool isTablet(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return MediaQuery.of(context).size.width < 1200 &&
        MediaQuery.of(context).size.width > 600;
  }

  bool isDesktop(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1200 && sideMenuIsOpen) {
      width = MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * 0.18);
    } else {
      width = MediaQuery.of(context).size.width;
    }
    return MediaQuery.of(context).size.width >= 1200;
  }

  bool isPortrait(BuildContext context) =>
      MediaQuery.of(context).orientation == Orientation.portrait;

  initResponsive(BuildContext context) {
    if (MediaQuery.of(context).size.width >= 1200) {
      width = MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * 0.18);
    } else {
      width = MediaQuery.of(context).size.width;
    }
    emit(InitResponsiveState());
  }

  closeSideMenu(BuildContext context) {
    sideMenuIsOpen = !sideMenuIsOpen;
    if (MediaQuery.of(context).size.width >= 1200 && sideMenuIsOpen) {
      width = MediaQuery.of(context).size.width -
          (MediaQuery.of(context).size.width * 0.18);
    } else {
      width = MediaQuery.of(context).size.width;
    }
    emit(CloseSideMenuState());
  }

  changeShowButton() {
    showButton = !showButton;
    emit(ChangeShowButton(showButton: showButton));
  }

  changeShowBottomTab() {
    showBottomTab = !showBottomTab;
    emit(ChangeShowBottomTab(showBottomTab: showBottomTab));
  }
}
