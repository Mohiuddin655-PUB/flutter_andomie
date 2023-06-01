part of '../widgets.dart';

class TabLayout extends YMRView<TabLayoutController> {
  final TabController tabController;
  final ViewPagerController? pagerController;

  final double? tabMargin;
  final double? tabMarginStart, tabMarginEnd, tabMarginTop, tabMarginBottom;
  final double? tabMarginHorizontal, tabMarginVertical;

  final double? tabPadding;
  final double? tabPaddingStart, tabPaddingEnd, tabPaddingTop, tabPaddingBottom;
  final double? tabPaddingHorizontal, tabPaddingVertical;

  final List<TabItem>? tabs;

  final double? tabIconSize;
  final ValueState<double>? tabIconSizeState;
  final Color? tabIconTint;
  final double? tabIconSpace;
  final ValueState<Color>? tabIconTintState;

  final Color? tabContentColor;
  final ValueState<Color>? tabContentColorState;
  final double? tabTitleSize;
  final ValueState<double>? tabTitleSizeState;
  final FontWeight? tabTitleWeight;
  final ValueState<FontWeight>? tabTitleWeightState;

  final Decoration? tabIndicator;
  final Color? tabIndicatorColor;
  final bool? tabIndicatorFullWidth;
  final double? tabIndicatorHeight;

  final bool? tabInlineLabel;
  final TabMode? tabMode;

  final bool Function(bool selected)? onVisibleIconWhenTabSelected;
  final bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  const TabLayout({
    super.key,
    super.controller,
    super.flex,
    super.activated,
    super.enabled,
    super.visibility,
    super.dimensionRatio,
    super.width,
    super.widthMax,
    super.widthMin,
    super.height,
    super.heightMax,
    super.heightMin,
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.borderSize,
    super.borderHorizontal,
    super.borderVertical,
    super.borderTop,
    super.borderBottom,
    super.borderStart,
    super.borderEnd,
    super.borderRadius,
    super.borderRadiusBL,
    super.borderRadiusBR,
    super.borderRadiusTL,
    super.borderRadiusTR,
    super.shadow,
    super.shadowBlurRadius,
    super.shadowSpreadRadius,
    super.shadowHorizontal,
    super.shadowVertical,
    super.shadowStart,
    super.shadowEnd,
    super.shadowTop,
    super.shadowBottom,
    super.background,
    super.foreground,
    super.borderColor,
    super.shadowColor,
    super.gravity,
    super.transformGravity,
    super.backgroundBlendMode,
    super.foregroundBlendMode,
    super.backgroundImage,
    super.foregroundImage,
    super.backgroundGradient,
    super.foregroundGradient,
    super.borderGradient,
    super.transform,
    super.shadowBlurStyle,
    super.clipBehavior,
    super.position,
    super.positionType,
    super.shadowType,
    super.shape,
    required this.tabController,
    this.pagerController,
    this.tabs,
    this.tabIconSize,
    this.tabIconSizeState,
    this.tabIconSpace,
    this.tabIconTint,
    this.tabIconTintState,
    this.tabContentColor,
    this.tabContentColorState,
    this.tabTitleSize,
    this.tabTitleSizeState,
    this.tabTitleWeight,
    this.tabTitleWeightState,
    this.tabIndicator,
    this.tabIndicatorColor,
    this.tabIndicatorFullWidth,
    this.tabIndicatorHeight,
    this.tabInlineLabel,
    this.tabMargin,
    this.tabMarginStart,
    this.tabMarginEnd,
    this.tabMarginTop,
    this.tabMarginBottom,
    this.tabMarginHorizontal,
    this.tabMarginVertical,
    this.tabPadding,
    this.tabPaddingStart,
    this.tabPaddingEnd,
    this.tabPaddingTop,
    this.tabPaddingBottom,
    this.tabPaddingHorizontal,
    this.tabPaddingVertical,
    this.tabMode,
    this.onVisibleIconWhenTabSelected,
    this.onVisibleTitleWhenTabSelected,
  });

  @override
  TabLayoutController initController() {
    return TabLayoutController();
  }

  @override
  void initialization(TabLayoutController controller) {
    tabController.addListener(controller.onNotify);
    controller.pagerController.setOnPageChangeListener((index) {
      tabController.animateTo(index);
    });
  }

  @override
  TabLayoutController attachController(TabLayoutController controller) {
    return controller.fromView(
      this,
      pagerController: pagerController,
      items: tabs,
      tabContentColor: tabContentColor,
      tabContentColorState: tabContentColorState,
      tabIconSize: tabIconSize,
      tabIconSizeState: tabIconSizeState,
      tabIconSpace: tabIconSpace,
      tabIconTint: tabIconTint,
      tabIconTintState: tabIconTintState,
      tabIndicator: tabIndicator,
      tabIndicatorColor: tabIndicatorColor,
      tabIndicatorFullWidth: tabIndicatorFullWidth,
      tabIndicatorHeight: tabIndicatorHeight,
      tabInlineLabel: tabInlineLabel,
      tabMargin: tabMargin,
      tabMarginStart: tabMarginStart,
      tabMarginEnd: tabMarginEnd,
      tabMarginTop: tabMarginTop,
      tabMarginBottom: tabMarginBottom,
      tabMarginHorizontal: tabMarginHorizontal,
      tabMarginVertical: tabMarginVertical,
      tabPadding: tabPadding,
      tabPaddingStart: tabPaddingStart,
      tabPaddingEnd: tabPaddingEnd,
      tabPaddingTop: tabPaddingTop,
      tabPaddingBottom: tabPaddingBottom,
      tabPaddingHorizontal: tabPaddingHorizontal,
      tabPaddingVertical: tabPaddingVertical,
      tabMode: tabMode,
      tabTitleSize: tabTitleSize,
      tabTitleSizeState: tabTitleSizeState,
      tabTitleWeight: tabTitleWeight,
      tabTitleWeightState: tabTitleWeightState,
      onVisibleIconWhenTabSelected: onVisibleIconWhenTabSelected,
      onVisibleTitleWhenTabSelected: onVisibleTitleWhenTabSelected,
    );
  }

  @override
  Widget? attach(BuildContext context, TabLayoutController controller) {
    return TabBar(
      automaticIndicatorColorAdjustment: true,
      controller: tabController,
      dividerColor: null,
      enableFeedback: null,
      indicator: controller.tabIndicator,
      indicatorColor: controller.tabIndicatorColor,
      indicatorPadding: EdgeInsets.zero,
      indicatorSize: controller.tabIndicatorFullWidth
          ? TabBarIndicatorSize.tab
          : TabBarIndicatorSize.label,
      indicatorWeight: controller.tabIndicatorHeight,
      isScrollable: controller.tabMode == TabMode.scrollable,
      key: key,
      labelPadding: controller.tabMode == TabMode.scrollable
          ? EdgeInsets.only(
              left: controller.tabMarginStart,
              right: controller.tabMarginEnd,
              top: controller.tabMarginTop,
              bottom: controller.tabMarginBottom,
            )
          : null,
      onTap: (index) => controller.pagerController.pager.jumpToPage(index),
      overlayColor: null,
      padding: null,
      physics: null,
      splashBorderRadius: null,
      splashFactory: null,
      tabs: controller.items.map((e) {
        return TabView(
          activated: e.index == tabController.index,
          contentColor: controller.tabContentColor,
          contentColorState: controller.tabContentColorState,
          marginVertical: controller.tabMode == TabMode.scrollable
              ? null
              : controller.tabMarginVertical,
          padding: controller.tabPadding,
          paddingStart: controller.tabPaddingStart,
          paddingEnd: controller.tabPaddingEnd,
          paddingTop: controller.tabPaddingTop,
          paddingBottom: controller.tabPaddingBottom,
          paddingHorizontal: controller.tabPaddingHorizontal,
          paddingVertical: controller.tabPaddingVertical,
          icon: e.icon,
          iconState: e.iconState,
          iconSize: controller.tabIconSize,
          iconSizeState: controller.tabIconSizeState,
          iconSpace: controller.tabIconSpace,
          iconTint: controller.tabIconTint,
          iconTintState: controller.tabIconTintState,
          inline: controller.tabInlineLabel,
          title: e.title,
          titleState: e.titleState,
          titleSize: controller.tabTitleSize,
          titleSizeState: controller.tabTitleSizeState,
          titleWeight: controller.tabTitleWeight,
          titleWeightState: controller.tabTitleWeightState,
          onVisibleIconWhenTabSelected: controller.onVisibleIconWhenTabSelected,
          onVisibleTitleWhenTabSelected:
              controller.onVisibleTitleWhenTabSelected,
        );
      }).toList(),
    );
  }
}

class TabLayoutController extends ViewController {
  ViewPagerController pagerController = ViewPagerController();

  List<TabItem> items = [];

  double tabMargin = 0;
  double? _tabMarginStart, _tabMarginEnd, _tabMarginTop, _tabMarginBottom;
  double? tabMarginHorizontal, tabMarginVertical;

  double tabPadding = 0;
  double? tabPaddingStart, tabPaddingEnd, tabPaddingTop, tabPaddingBottom;
  double? tabPaddingHorizontal, tabPaddingVertical;

  double? tabIconSize;
  ValueState<double>? tabIconSizeState;
  double? tabIconSpace;
  Color? _tabIconTint;
  ValueState<Color>? _tabIconTintState;

  Color? tabContentColor;
  ValueState<Color>? tabContentColorState;

  double tabTitleSize = 12;
  ValueState<double>? tabTitleSizeState;
  FontWeight? tabTitleWeight;
  ValueState<FontWeight>? tabTitleWeightState;

  Decoration? tabIndicator;
  Color? tabIndicatorColor;
  bool tabIndicatorFullWidth = false;
  double tabIndicatorHeight = 2;

  bool tabInlineLabel = false;
  TabMode? tabMode;

  bool Function(bool selected)? onVisibleIconWhenTabSelected;
  bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  Color? get tabIconTint => _tabIconTint ?? tabContentColor;

  ValueState<Color>? get tabIconTintState =>
      _tabIconTintState ?? tabContentColorState;

  @override
  TabLayoutController fromView(
    YMRView<ViewController> view, {
    ViewPagerController? pagerController,
    List<TabItem>? items,
    double? tabIconSize,
    ValueState<double>? tabIconSizeState,
    double? tabIconSpace,
    Color? tabIconTint,
    ValueState<Color>? tabIconTintState,
    double? tabMargin,
    double? tabMarginStart,
    double? tabMarginEnd,
    double? tabMarginTop,
    double? tabMarginBottom,
    double? tabMarginHorizontal,
    double? tabMarginVertical,
    double? tabPadding,
    double? tabPaddingStart,
    double? tabPaddingEnd,
    double? tabPaddingTop,
    double? tabPaddingBottom,
    double? tabPaddingHorizontal,
    double? tabPaddingVertical,
    Color? tabContentColor,
    ValueState<Color>? tabContentColorState,
    double? tabTitleSize,
    ValueState<double>? tabTitleSizeState,
    FontWeight? tabTitleWeight,
    ValueState<FontWeight>? tabTitleWeightState,
    Decoration? tabIndicator,
    Color? tabIndicatorColor,
    bool? tabIndicatorFullWidth,
    double? tabIndicatorHeight,
    bool? tabInlineLabel,
    TabMode? tabMode,
    bool Function(bool selected)? onVisibleIconWhenTabSelected,
    bool Function(bool selected)? onVisibleTitleWhenTabSelected,
  }) {
    super.fromView(view);
    this.pagerController = pagerController ?? ViewPagerController();
    this.items = items ?? [];

    //TAB ICON PROPERTIES
    this.tabIconSize = tabIconSize;
    this.tabIconSizeState = tabIconSizeState;
    this.tabIconSpace = tabIconSpace;
    _tabIconTint = tabIconTint;
    _tabIconTintState = tabIconTintState;

    // TAB MARGIN PROPERTIES
    this.tabMargin = tabMargin ?? 0;
    _tabMarginStart = tabMarginStart;
    _tabMarginEnd = tabMarginEnd;
    _tabMarginTop = tabMarginTop;
    _tabMarginBottom = tabMarginBottom;
    this.tabMarginHorizontal = tabMarginHorizontal;
    this.tabMarginVertical = tabMarginVertical;

    // TAB PADDING PROPERTIES
    this.tabPadding = tabPadding ?? 0;
    this.tabPaddingStart = tabPaddingStart;
    this.tabPaddingEnd = tabPaddingEnd;
    this.tabPaddingTop = tabPaddingTop;
    this.tabPaddingBottom = tabPaddingBottom;
    this.tabPaddingHorizontal = tabPaddingHorizontal;
    this.tabPaddingVertical = tabPaddingVertical;

    // TAB TITLE PROPERTIES
    this.tabContentColor = tabContentColor;
    this.tabContentColorState = tabContentColorState;
    this.tabTitleSize = tabTitleSize ?? 12;
    this.tabTitleSizeState = tabTitleSizeState;
    this.tabTitleWeight = tabTitleWeight;
    this.tabTitleWeightState = tabTitleWeightState;

    // TAB INDICATOR PROPERTIES
    this.tabIndicator = tabIndicator;
    this.tabIndicatorColor = tabIndicatorColor;
    this.tabIndicatorFullWidth = tabIndicatorFullWidth ?? false;
    this.tabIndicatorHeight = tabIndicatorHeight ?? 2;

    // TAB OTHER PROPERTIES
    this.tabMode = tabMode;
    this.tabInlineLabel = tabInlineLabel ?? false;
    this.onVisibleIconWhenTabSelected = onVisibleIconWhenTabSelected;
    this.onVisibleTitleWhenTabSelected = onVisibleTitleWhenTabSelected;
    return this;
  }

  double get tabMarginStart {
    return _tabMarginStart ?? tabMarginHorizontal ?? tabMargin;
  }

  double get tabMarginEnd {
    return _tabMarginEnd ?? tabMarginHorizontal ?? tabMargin;
  }

  double get tabMarginTop {
    return _tabMarginTop ?? tabMarginVertical ?? tabMargin;
  }

  double get tabMarginBottom {
    return _tabMarginBottom ?? tabMarginVertical ?? tabMargin;
  }
}

class TabItem {
  final int index;
  final String title;
  final ValueState<String>? titleState;
  final dynamic icon;
  final ValueState<dynamic>? iconState;

  const TabItem({
    required this.index,
    this.icon,
    this.iconState,
    this.title = "",
    this.titleState,
  });
}

enum TabIndicatorGravity {
  bottom,
  center,
  top,
  stretch,
}

enum TabIndicatorAnimationMode {
  linear,
  elastic,
  fade,
}

enum TabMode {
  scrollable,
  fixed,
  auto,
}

enum TabGravity {
  fill,
  center,
  start,
}
