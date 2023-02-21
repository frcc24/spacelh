import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:spacelh/components/spaceship/spaceship.dart';
import 'package:spacelh/core/command.dart';

import '../../utils/utils.dart';
import '../bullets/bullet.dart';

/// This class creates a fast bullet implementation of the [Bullet] contract and
/// renders the bullet as a simple green square.
/// Speed has been defaulted to 150 p/s but can be changed through the
/// constructor. It is set with a damage of 1 which is the lowest damage and
/// with health of 1 which means that it will be destroyed on impact since it
/// is also the lowest health you can have.
///
class SmallEnemySpaceShip01 extends SpaceShip with CollisionCallbacks {
  static const double defaultSpeed = 100.00;
  static final Vector2 defaultSize = Vector2.all(2.00);
  // color of the bullet
  static final _paint = Paint()..color = Colors.green;
  final spriteSize = Vector2(64.0, 92.0);
  late SpriteSheet spriteSheet;

  late final SpriteAnimation animationLeft;
  late final SpriteAnimation animationIdle;
  late final SpriteAnimation animationright;

  late SpriteAnimationComponent spaceShipComponent;

  SmallEnemySpaceShip01(Vector2 resolutionMultiplier, JoystickComponent? joystick)
      : super.fullInit(resolutionMultiplier, joystick,
            size: defaultSize, speed: defaultSpeed, health: SpaceShip.defaultHealth, damage: SpaceShip.defaultDamage);

  //
  // named constructor
  SmallEnemySpaceShip01.fullInit(Vector2 resolutionMultiplier, JoystickComponent? joystick, Vector2? size, double? speed, int? health, int? damage)
      : super.fullInit(resolutionMultiplier, joystick, size: size, speed: speed, health: health, damage: damage);

  @override
  Future<void> onLoad() async {
    super.onLoad();
    //
    // we adjust the ship size based on resolution multipier
    size = Utils.vector2Multiply(size, gameRef.controller.getResoltionMultiplier);
    size.y = size.x;
    //
    // ship png comes from Kenny
    // spriteAnimation = await gameRef.loadSprite('starship.png');
    //final size = Vector2.all(64.0);

    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('sml_en_ship_01.png'),
      srcSize: Vector2(28.0, 20.0),
    );

    // animationLeft = spriteSheet.createAnimation(row: 0, stepTime: 0.01, from: 0, to: 1);
    animationIdle = spriteSheet.createAnimation(row: 0, stepTime: 0.01, from: 0, to: 1);
    // animationright = spriteSheet.createAnimation(row: 0, stepTime: 0.01, to: 4, from: 3);

    spaceShipComponent = SpriteAnimationComponent(
      animation: animationIdle,
      //scale: Vector2(0.4, 0.4),
      //position: Vector2(160, -5),
      size: spriteSize,
    );

    velocity = Vector2(0, 200);

    add(RectangleHitbox());
    add(spaceShipComponent);

    position = Vector2(gameRef.size.x / 2, gameRef.size.y - gameRef.size.y + 20);
    debugPrint('player position: $position');
    muzzleComponent.position.x = size.x / 2;
    muzzleComponent.position.y = size.y / 10;

    add(muzzleComponent);
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (position.y >= gameRef.size.y) {
      position.y = 0;
    }
    // position.add(velocity * dt);
    if (dt % 2 == 0) {
      velocity.add(-Utils.generateRandomDirection() * 10);
    } else {
      velocity.add(Utils.generateRandomDirection() * 10);
    }
    if (position.x <= 0 || position.x >= gameRef.size.x - 50) {
      velocity.x = -velocity.x;
    } else if (position.y <= 0 || position.y >= gameRef.size.y) {
      velocity.y = -velocity.y;
    }

    position.add(velocity * dt);
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
      print("enemy ScreenHitbox");
    } else if (other is SpaceShip) {
      PlayerCollisionCommand(other, other).addToController(gameRef.controller);
      print("enemy hit SpaceShip");
    }
  }
//   print("SimpleSpaceShip onHit called");
// }
}
