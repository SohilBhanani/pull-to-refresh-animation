import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<Demo> createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  late double _pulledExtent;

  SMINumber? _pull;
  String message = '';

  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'cardio_state',
      onStateChange: _onStateChange,
    );
    artboard.addController(controller!);

    _pull = controller.findInput<double>('pull') as SMINumber;
    _pull!.value = 1;
  }

  void _onStateChange(
    String stateMachineName,
    String stateName,
  ) =>
      setState(
          () => message = 'State changed in $stateMachineName to $stateName');

  void _setValue(double value) => _pull!.value = value;

  Widget buildRefreshWidget(
      BuildContext context,
      RefreshIndicatorMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent) {
    _pulledExtent = pulledExtent;
    _pull == null ? null : _setValue(_pulledExtent);
    return RiveAnimation.asset(
      "assets/cardio.riv",
      alignment: Alignment.center,
      // animation: "idle",
      fit: BoxFit.cover,
      onInit: _onRiveInit,
      // controllers: [this],
      // controller: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            CupertinoSliverNavigationBar(
              backgroundColor: const Color(0xff2699fb),
              middle: const SizedBox(),
              largeTitle: IconButton(
                color: Colors.white,
                alignment: Alignment.centerLeft,
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
              previousPageTitle: 'Cupertino',
            ),
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 90.0,
              refreshIndicatorExtent: 90.0,
              builder: buildRefreshWidget,
              onRefresh: () {
                return Future<void>.delayed(const Duration(seconds: 6));
              },
            ),
            SliverSafeArea(
              top: false,
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ListTile(
                      title: Text('Index $index'),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
