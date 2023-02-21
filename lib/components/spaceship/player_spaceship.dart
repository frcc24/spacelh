import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacelh/components/spaceship/spaceship.dart';

import '../../utils/utils.dart';
import '../bullets/bullet.dart';

/// This class creates a fast bullet implementation of the [Bullet] contract and
/// renders the bullet as a simple green square.
/// Speed has been defaulted to 150 p/s but can be changed through the
/// constructor. It is set with a damage of 1 which is the lowest damage and
/// with health of 1 which means that it will be destroyed on impact since it
/// is also the lowest health you can have.
///
class PlayerSpaceShip extends SpaceShip with CollisionCallbacks {
  static const double defaultSpeed = 300.00;
  static final Vector2 defaultSize = Vector2.all(2.00);
  // color of the bullet
  static final _paint = Paint()..color = Colors.green;
  final spriteSize = Vector2(64.0, 92.0);
  late SpriteSheet spriteSheet;

  late final SpriteAnimation animationLeft;
  late final SpriteAnimation animationIdle;
  late final SpriteAnimation animationright;

  late SpriteAnimationComponent component1;

  PlayerSpaceShip(Vector2 resolutionMultiplier, JoystickComponent joystick)
      : super.fullInit(resolutionMultiplier, joystick,
            size: defaultSize, speed: defaultSpeed, health: SpaceShip.defaultHealth, damage: SpaceShip.defaultDamage);

  //
  // named constructor
  PlayerSpaceShip.fullInit(Vector2 resolutionMultiplier, JoystickComponent joystick, Vector2? size, double? speed, int? health, int? damage)
      : super.fullInit(resolutionMultiplier, joystick, size: size, speed: speed, health: health, damage: damage);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    // we adjust the ship size based on resolution multipier
    size = Utils.vector2Multiply(size, gameRef.controller.getResoltionMultiplier);
    size.y = size.x;
    debugPrint("<SimpleSpaceShip> <onLoad> size: $size, multiplier: ${gameRef.controller.getResoltionMultiplier}");
    //
    // ship png comes from Kenny
    // spriteAnimation = await gameRef.loadSprite('starship.png');
    //final size = Vector2.all(64.0);

    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('ship.png'),
      srcSize: Vector2(16.0, 24.0),
    );

    animationLeft = spriteSheet.createAnimation(row: 0, stepTime: 0.01, from: 0, to: 1);
    animationIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.01, from: 2, to: 3);
    animationright = spriteSheet.createAnimation(row: 0, stepTime: 0.01, to: 4, from: 3);

    component1 = SpriteAnimationComponent(
      animation: animationIdle,
      //scale: Vector2(0.4, 0.4),
      //position: Vector2(160, -5),
      size: spriteSize,
    );

    add(component1);
    add(RectangleHitbox());

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - 200);
    debugPrint('player position: $position');
    muzzleComponent.position.x = size.x / 2;
    muzzleComponent.position.y = size.y / 10;

    add(muzzleComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick!.delta.isZero()) {
      getNextPosition().add(joystick!.relativeDelta * maxSpeed * dt);
      // angle = (_joystick.delta.screenAngle());
      component1.animation = animationIdle;
    }

    if (joystick!.direction == JoystickDirection.right ||
        joystick!.direction == JoystickDirection.downRight ||
        joystick!.direction == JoystickDirection.upRight) {
      component1.animation = animationright;
    } else if (joystick!.direction == JoystickDirection.left ||
        joystick!.direction == JoystickDirection.downLeft ||
        joystick!.direction == JoystickDirection.upLeft) {
      component1.animation = animationLeft;
    } else {
      component1.animation = animationIdle;
    }
  }

  @override
  void onCreate() {
    super.onCreate();
    print("SimpleSpaceShip onCreate called");
  }

  @override
  void onDestroy() {
    print("SimpleSpaceShip onDestroy called");
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      print("hit ScreenHitbox");
    } else if (other is SpaceShip) {
      print("hit SpaceShip");
    }
  }
}
