import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:spacelh/utils/utils.dart';

import '../../core/command.dart';
import '../../main.dart';
import '../spaceship/small_enemy_spaceship01.dart';
import 'bullet_01.dart';
import 'bullet_02.dart';
import 'bullet_03.dart';
import 'bullet_04.dart';

/// Simple enum which will hold enumerated names for all our [Bullet]-derived
/// child classes
///
/// As you add moreBullet implementation you will add a name hereso that we
/// can then easly create bullets using the [BulletFactory]
/// The steps are as follows:
///  - extend the Bullet class with a new Bullet implementation
///  - add a new enumeration entry
///  - add a new switch case to the [BulletFactory] to create this new [Bullet]
///    instance when the enumeration entry is provided.
enum BulletEnum { bullet04, bullet03, bullet02, bullet01 }

/// Bullet class is a [PositionComponent] so we get the angle and position of the
/// element.
///
/// This is an abstract class which needs to be extended to use Bullets.
/// The most important game methods come from [PositionComponent] and are the
/// update(), onLoad(), amd render() methods that need to be overridden to
/// drive the behaviour of your Bullet on screen.
///
/// You should also overide the abstract methods such as onCreate(),
/// onDestroy(), and onHit()
///
abstract class Bullet extends SpriteAnimationComponent with HasGameRef<MyGame>, CollisionCallbacks {
  static const double defaultSpeed = 25.00;
  static const int defaultDamage = 1;
  static const int defaultHealth = 1;
  static final Vector2 defaulSize = Vector2.all(1.0);

  var spriteSize = Vector2(64.0, 64.0);
  late SpriteSheet spriteSheet;

  late final SpriteAnimation animationBullet;
  late SpriteAnimationComponent component1;

  // velocity vector for the bullet.
  late Vector2 velocity;

  // speed of the bullet
  late double speed;

  // health of the bullet
  late int? health;

  // damage that the bullet does
  late int? damage;

  //
  // default constructor with default values
  Bullet(Vector2 position, Vector2 velocity)
      : velocity = velocity.normalized(),
        speed = defaultSpeed,
        health = defaultHealth,
        damage = defaultDamage,
        super(
          size: defaulSize,
          position: position,
          anchor: Anchor.center,
        );

  //
  // named constructor
  Bullet.fullInit(Vector2 position, Vector2 velocity, {Vector2? size, double? speed, int? health, int? damage})
      : velocity = velocity.normalized(),
        speed = speed ?? defaultSpeed,
        health = health ?? defaultHealth,
        damage = damage ?? defaultDamage,
        super(
          size: size,
          position: position,
          anchor: Anchor.center,
        );

  //
  // empty class name constructor
  Bullet.classname();

  ///////////////////////////////////////////////////////
  // getters
  //
  int? get getDamage {
    return damage;
  }

  int? get getHealth {
    return health;
  }

  ////////////////////////////////////////////////////////
  // Overrides
  //
  @override
  void update(double dt) {
    _onOutOfBounds(position);
  }

  ////////////////////////////////////////////////////////
  // business methods
  //

  //
  // Called when the Bullet has been created.
  void onCreate() {
    // to improve accurace of collision detection we make the hitbox
    // about 4 times larger for the bullets.
  }

  //
  // Called when the bullet is being destroyed.
  void onDestroy();

  //
  // Called when the Bullet has been hit. The ‘other’ is what the bullet hit, or was hit by.
  // void onHit(Collidable other);

  ////////////////////////////////////////////////////////////
  // Helper methods
  //

  void _onOutOfBounds(Vector2 position) {
    if (Utils.isPositionOutOfBounds(gameRef.size, position)) {
      BulletDestroyCommand(this).addToController(gameRef.controller);
      //FlameAudio.audioCache.play('missile_hit.wav');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (other is ScreenHitbox) {
      print("enemy ScreenHitbox");
    } else if (other is SmallEnemySpaceShip01) {
      EnemyCollisionCommand(other, this).addToController(gameRef.controller);
      print("bullet enemy hit SpaceShip");
    }
  }
}

/// This is a Factory Method Design pattern example implementation for Bullets
/// in our game.
///
/// The class will return an instance of the specific bullet aksed for based on
/// a valid bullet choice.
class BulletFactory {
  /// private constructor to prevent instantiation
  BulletFactory._();

  /// main factory method to create instaces of Bullet children
  static Bullet create(BulletBuildContext context) {
    Bullet result;

    /// collect all the Bullet definitions here
    switch (context.bulletType) {
      case BulletEnum.bullet02:
        {
          if (context.speed != BulletBuildContext.defaultSpeed) {
            result = Bullet02.fullInit(context.position, context.velocity, context.size, context.speed, context.health, context.damage);
          } else {
            result = Bullet02(context.position, context.velocity);
          }
        }
        break;

      case BulletEnum.bullet01:
        {
          if (context.speed != BulletBuildContext.defaultSpeed) {
            result = Bullet01.fullInit(context.position, context.velocity, context.size, context.speed, context.health, context.damage);
          } else {
            result = Bullet01(context.position, context.velocity);
          }
        }
        break;
      case BulletEnum.bullet03:
        {
          if (context.speed != BulletBuildContext.defaultSpeed) {
            result = Bullet03.fullInit(context.position, context.velocity, context.size, context.speed, context.health, context.damage);
          } else {
            result = Bullet03(context.position, context.velocity);
          }
        }
        break;
      case BulletEnum.bullet04:
        {
          if (context.speed != BulletBuildContext.defaultSpeed) {
            result = Bullet04.fullInit(context.position, context.velocity, context.size, context.speed, context.health, context.damage);
          } else {
            result = Bullet04(context.position, context.velocity);
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
/// Bullet instace through the Factory method using the [BulletFactory]
///
/// We have a number of default values here as well in case callers do not
/// define all the entries.
class BulletBuildContext {
  static const double defaultSpeed = 0.0;
  static const int defaultHealth = 1;
  static const int defaultDamage = 1;
  static final Vector2 deaultVelocity = Vector2.zero();
  static final Vector2 deaultPosition = Vector2(-1, -1);
  static final Vector2 defaultSize = Vector2.zero();
  static final BulletEnum defaultBulletType = BulletEnum.values[0];

  double speed = defaultSpeed;
  Vector2 velocity = deaultVelocity;
  Vector2 position = deaultPosition;
  Vector2 size = defaultSize;
  int health = defaultHealth;
  int damage = defaultDamage;
  BulletEnum bulletType = defaultBulletType;

  BulletBuildContext();
}
