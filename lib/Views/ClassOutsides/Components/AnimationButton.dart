
import 'package:flutter/cupertino.dart';
import 'package:rive/rive.dart';

class AnimationButton extends StatelessWidget {
  const AnimationButton(
      {
        super.key,
        required RiveAnimationController animationController, required this.press,
      }): _animationController = animationController;

  final RiveAnimationController _animationController;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: SizedBox(
          height: 64,
          width: 260,
          child: Stack(children: [
            RiveAnimation.asset(
              "assets/Rive_Animation/button.riv",
              controllers: [
                _animationController,
              ],
            ),
            const Positioned.fill(
              top: 8,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.arrow_right),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    "Login this NOW ",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ])),
    );
  }
}
