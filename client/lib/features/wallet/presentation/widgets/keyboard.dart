import 'package:flutter/material.dart';

import 'package:client/core/utils/extension.dart';

typedef KeyboardTapCallback = void Function(String text);

class NumericKeyboard extends StatelessWidget {
  const NumericKeyboard({
    super.key,
    required this.onKeyboardTap,
    this.textStyle = const TextStyle(color: Colors.black),
    this.rightButtonFn,
    this.rightButtonLongPressFn,
    this.rightIcon,
    this.leftButtonFn,
    this.leftIcon,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  final TextStyle textStyle;
  final Widget? rightIcon;
  final Function()? rightButtonFn;
  final Function()? rightButtonLongPressFn;
  final Widget? leftIcon;
  final Function()? leftButtonFn;
  final KeyboardTapCallback onKeyboardTap;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _calcButton('1'),
              _calcButton('2'),
              _calcButton('3'),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _calcButton('4'),
              _calcButton('5'),
              _calcButton('6'),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              _calcButton('7'),
              _calcButton('8'),
              _calcButton('9'),
            ],
          ),
          ButtonBar(
            alignment: mainAxisAlignment,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius.circular(45),
                onTap: leftButtonFn,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: context.theme.colorScheme.secondary,
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              _calcButton('0'),
              InkWell(
                borderRadius: BorderRadius.circular(45),
                onTap: rightButtonFn,
                onLongPress: rightButtonLongPressFn,
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: context.theme.colorScheme.secondary,
                  child: const Icon(
                    Icons.backspace,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _calcButton(String value) {
    return InkWell(
      borderRadius: BorderRadius.circular(45),
      onTap: () => onKeyboardTap(value),
      child: CircleAvatar(
        radius: 45,
        child: Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
