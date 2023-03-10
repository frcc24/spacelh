import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';

import 'core/command.dart';
import 'core/controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  // await Flame.fullScreen();
  // await Flame.setLandscape();
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends FlameGame with HasDraggables, HasTappables, HasCollisionDetection {
  @override

  /// use this flag to put the project into debug mode which will show hitboxes
  bool debugMode = false;

  final parallaxImages = [
    //ParallaxImageData('big_stars.png'),
    ParallaxImageData('small_stars.png'),
    ParallaxImageData('stars1.png'),
    ParallaxImageData('stars2.png'),
    ParallaxImageData('big_stars.png'),
  ];

  /// controller used to coordinate all game actions
  late final Controller controller;

  // /// timer used to notify the controller about the passage of time
  // late TimerComponent controllerTimer;

  //
  // angle of the ship being displayed on canvas
  final TextPaint shipAngleTextPaint = TextPaint();

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    /// initialize resources
    ///
    loadResources();

    final parallax = await loadParallaxComponent(
      parallaxImages,

      repeat: ImageRepeat.repeat,
      baseVelocity: Vector2(0, -25),

      //layerDelta: Vector2(20, 0),
      velocityMultiplierDelta: Vector2(1, 1.8),
    );
    add(parallax);

    /// Add a controller
    ///
    /// this will load the level JSON Data for all the levels whch will be stored
    /// in Controller state data
    controller = Controller();
    add(controller);

    // /// add a timer which will notify the controller of the passage of time
    // ///
    // controllerTimer = TimerComponent(
    //     period: 1,
    //     repeat: true,
    //     onTick: () {
    //       controller.timerNotification();
    //     });

    /// note that we use 'await' which will wait to load the data before any
    /// of the other code continues thsi way we know that out Controller's state
    /// data is correct.
    await controller.init();

    /// Other book-keeping
    ///
    /// we add the timer to the game object tree
    // add(controllerTimer);
  }

  @override
  void update(double dt) {
    //
    //  show the angle of the player
    // debugPrint("current player angle: ${controller.getSpaceship().angle}");
    // debugPrint("<main update> number of children: ${children.length}");
    super.update(dt);
  }

  @override
  //
  //
  // We will handle the tap action by the user to shoot a bullet
  // each time the user taps and lifts their finger
  void onTapUp(int pointerId, TapUpInfo info) {
    UserTapUpCommand(controller.getSpaceship()).addToController(controller);
    super.onTapUp(pointerId, info);
  }

  ///
  /// Helper Methods
  ///
  ///

  void loadResources() async {
    /// cache any needed resources
    ///
    // await images.load('boom.png');
  }
}
