import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

import 'bullet.dart';

/// constructor. It is set with a damage of 1 which is the lowest damage and
/// with health of 1 which means that it will be destroyed on impact since it
/// is also the lowest health you can have.
///
class Bullet01 extends Bullet {
  static const double defaultSpeed = 350.00;
  static final Vector2 defaultSize = Vector2.all(16.00);
  // color of the bullet
  static final _paint = Paint()..color = Colors.green;

  Bullet01(Vector2 position, Vector2 velocity)
      : super.fullInit(position, velocity, size: defaultSize, speed: defaultSpeed, health: Bullet.defaultHealth, damage: Bullet.defaultDamage);

  //
  // named constructor
  Bullet01.fullInit(Vector2 position, Vector2 velocity, Vector2? size, double? speed, int? health, int? damage)
      : super.fullInit(position, velocity, size: size, speed: speed, health: health, damage: damage);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // _velocity is a unit vector so we need to make it account for the actual
    // speed.

    spriteSize = Vector2(32.0, 128.0);
    spriteSheet = SpriteSheet(
      image: await gameRef.images.load('bullet01.png'),
      srcSize: Vector2(16.0, 64.0),
    );

    animationBullet = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 3);

    component1 = SpriteAnimationComponent(
      animation: animationBullet,
      //scale: Vector2(0.4, 0.4),
      //position: Vector2(160, -5),
      size: spriteSize,
      angle: -pi / 2,
    );

    add(component1);
    add(RectangleHitbox(size: size));
    print("FastBullet onLoad called: speed: $speed");
    velocity = (velocity)..scaleTo(speed);
    anchor = Anchor.center;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    //canvas.drawRect(size.toRect(), _paint);
    //renderHitboxes(canvas);
  }

  @override
  void update(double dt) {
    position.add(velocity * dt);
    super.update(dt);
  }

  @override
  void onCreate() {
    super.onCreate();
    print("FastBullet onCreate called");
  }

  @override
  void onDestroy() {
    print("FastBullet onDestroy called");
  }

// @override
// void onHit(Collidable other) {
//   print("FastBullet onHit called");
// }
}
