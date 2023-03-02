import 'dart:async';
import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';

void main() {
  final game = MyGame();
  runApp(GameWidget(game: game));
}

class MyGame extends FlameGame
    with HasTappables, HasHoverables {

  late Artboard myArtboard;
  @override
  FutureOr<void> onLoad() async{
    myArtboard = await loadArtboard(RiveFile.asset('assets/new_file.riv'));
    final myController = StateMachineController.fromArtboard(myArtboard, 'Button');
    myArtboard.addController(myController!);

    add(
        MyRiveComponent(
            artboard: myArtboard,
            controller: myController,
            fit: BoxFit.fill,
            useArtboardSize: false
        )
          ..position=size/2
    );

    return super.onLoad();
  }
}


class MyRiveComponent extends RiveComponent with Tappable,Hoverable,GestureHitboxes{
  final StateMachineController controller;

  MyRiveComponent({
    required super.artboard,
    required this.controller,
    super.fit,
    super.useArtboardSize
  });

  late SMIBool hover;
  @override
  Future<void> onLoad() {
    anchor=Anchor.center;
    size=Vector2.all(300);

    add(RectangleHitbox());

    hover= controller.findInput<bool>('Hover') as SMIBool;

    return super.onLoad();
  }

  @override
  bool onHoverEnter(PointerHoverInfo info) {
    hover.value=true;
    info.handled = true;
    return true;
  }

  @override
  bool onHoverLeave(PointerHoverInfo info) {
    hover.value=false;
    return true;
  }
}