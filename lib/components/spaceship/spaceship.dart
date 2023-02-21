import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:spacelh/components/spaceship/player_spaceship.dart';
import 'package:spacelh/main.dart';

import '../../utils/utils.dart';
import '../bullets/bullet.dart';

/// Simple enum which will hold enumerated names for all our [SpaceShip]-derived
/// child classes
///
/// As you add more [SpaceShip]] implementations you will add a name here so
/// that we can then easily create different types of player spaceships u
/// using the [SpaceShipFactory]
/// The steps are as follows:
///  - extend the SpaceShip class with a new SpaceShip implementation
///  - add a new enumeration entry
///  - add a new switch case to the [SpaceShipFactory] to create this
///    new [SpaceShip] instance when the enumeration entry is provided.
enum SpaceShipEnum { playerSpaceShip, enemyShip }

abstract class SpaceShip extends SpriteAnimationComponent with HasGameRef<MyGame> {
// default values
  static const double defaultSpeed = 100.00;
  static const double defaultMaxSpeed = 300.00;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;
  static final defaultSize = Vector2.all(5.0);

// velocity vector for the asteroid.
  late Vector2 velocity;

// speed of the asteroid
  late double speed;

// health of the asteroid
  late int? health;

// damage that the asteroid does
  late int? damage;

// resolution multiplier
  late final Vector2 resolutionMultiplier;

  /// Pixels/s
  late final double maxSpeed = defaultMaxSpeed;

  /// current bullet type
  final BulletEnum currBulletType = BulletEnum.fastBullet;

  /// Single pixel at the location of the tip of the spaceship
  /// We use it to quickly calculate the position of the rotated nose of the
  /// ship so we can get the position of where the bullets are shooting from.
  /// We make it transparent so it is not visible at all.
  static final _paint = Paint()..color = Colors.transparent;

  /// Muzzle pixel for shooting
  final RectangleComponent muzzleComponent = RectangleComponent(size: Vector2(1, 1), paint: _paint);

  late final JoystickComponent? joystick;

//
// default constructor with default values
  SpaceShip(Vector2 resolutionMultiplier, JoystickComponent? joystick)
      : health = defaultHealth,
        damage = defaultDamage,
        resolutionMultiplier = resolutionMultiplier,
        joystick = joystick,
        super(
          size: defaultSize,
          anchor: Anchor.center,
        );

//
// named constructor
  SpaceShip.fullInit(Vector2 resolutionMultiplier, JoystickComponent? joystick, {Vector2? size, double? speed, int? health, int? damage})
      : resolutionMultiplier = resolutionMultiplier,
        joystick = joystick,
        speed = speed ?? defaultSpeed,
        health = health ?? defaultHealth,
        damage = damage ?? defaultDamage,
        super(
          size: size,
          anchor: Anchor.center,
        );

/////////////////////////////////////////////////////
// getters

  BulletEnum get getBulletType {
    return currBulletType;
  }

  RectangleComponent get getMuzzleComponent {
    return muzzleComponent;
  }

///////////////////////////////////////////////////////
  /// Business methods
  ///
  ///

//
// Called when the Player has been created.
  void onCreate() {
    anchor = Anchor.center;
    size = Vector2.all(60.0);
    // addHitbox(HitboxRectangle());
  }

//
// Called when the bullet is being destroyed.
  void onDestroy();

//
// Called when the Bullet has been hit. The ‘other’ is what the bullet hit, or was hit by.
// void onHit(Collidable other);

  /// Wrap the posittion getter so that any position that is out side of the
  /// screen gets wrapped around
  ///
  Vector2 getNextPosition() {
    return Utils.wrapPosition(gameRef.size, position);
  }
}

/// This is a Factory Method Design pattern example implementation for SpaceShips
/// in our game.
///
/// The class will return an instance of the specific player asked for based on
/// a valid enum choice.
class SpaceShipFactory {
  /// private constructor to prevent instantiation
  SpaceShipFactory._();

  /// main factory method to create instaces of Bullet children
  static PlayerSpaceShip create(PlayerBuildContext context) {
    PlayerSpaceShip result;

    /// collect all the Bullet definitions here
    switch (context.spaceShipType) {
      case SpaceShipEnum.playerSpaceShip:
        {
          if (context.speed != PlayerBuildContext.defaultSpeed) {
            result = PlayerSpaceShip.fullInit(context.multiplier, context.joystick, context.size, context.speed, context.health, context.damage);
          } else {
            result = PlayerSpaceShip(context.position, context.joystick);
          }
        }
        break;
      case SpaceShipEnum.enemyShip:
        {
          if (context.speed != PlayerBuildContext.defaultSpeed) {
            result = PlayerSpaceShip.fullInit(context.multiplier, context.joystick, context.size, context.speed, context.health, context.damage);
          } else {
            result = PlayerSpaceShip(context.position, context.joystick);
          }
        }
        break;
    }

    ///
    /// trigger any necessary behavior *before* the instance is handed to the
    /// caller.
    result.onCreate();

    return result;
  }
}

/// This is a simple data holder for the context data wehen we create a new
/// Asteroid instace through the Factory method using the [AsteroidFactory]
///
/// We have a number of default values here as well in case callers do not
/// define all the entries.
class PlayerBuildContext {
  static const double defaultSpeed = 0.0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 deaultVelocity = Vector2.zero();
  static final Vector2 deaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final SpaceShipEnum defaultSpaceShipType = SpaceShipEnum.values[0];
  static final Vector2 defaultMultiplier = Vector2.all(1.0);

  /// helper method for parsing out strings into corresponding enum values
  ///
  static SpaceShipEnum spaceShipFromString(String value) {
    debugPrint('${SpaceShipEnum.values}');
    return SpaceShipEnum.values.firstWhere((e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  }

  double speed = defaultSpeed;
  Vector2 velocity = deaultVelocity;
  Vector2 position = deaultPosition;
  Vector2 size = defaultSize;
  int health = defaultHealth;
  int damage = defaultDamage;
  Vector2 multiplier = defaultMultiplier;
  SpaceShipEnum spaceShipType = defaultSpaceShipType;
  late JoystickComponent joystick;

  PlayerBuildContext();

  @override

  /// We are defining our own stringify method so that we can see our
  /// values when debugging.
  ///
  String toString() {
    return 'name: $spaceShipType , speed: $speed , position: $position , velocity: $velocity, multiplier: $multiplier';
  }
}
