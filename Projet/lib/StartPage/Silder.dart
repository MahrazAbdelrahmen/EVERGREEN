
import 'package:flutter/material.dart';
typedef SetVolumeFunction = Future<void> Function(double volume);
class SilderMusic extends StatefulWidget {
  const SilderMusic({super.key, required this.value, required this.changeVolume});
  final double value;
  final SetVolumeFunction changeVolume;
  @override
  State<SilderMusic> createState() => _SilderMusicState();
}

class _SilderMusicState extends State<SilderMusic> {
  late double _value = widget.value;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23,
      decoration: BoxDecoration(
        boxShadow:  [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.8),
            spreadRadius: 0,
            blurRadius: 0,
            offset: const Offset(0, 5), // changes position of shadow
          ),
        ],
        border: Border.all(
          color: Colors.white, //                   <--- border color
          width: 3.0,
        ),
        color: Colors.lightBlueAccent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 15),
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 15,
            rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
            inactiveTrackColor: Colors.lightBlueAccent,
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 0.0,
            ),
            overlayShape: const RoundSliderOverlayShape(
              overlayRadius: 0.0,
            ),
          ),
          child: Slider(
            value: _value,
            onChanged: (double value) {
              setState(() => _value = value);
              widget.changeVolume(value);
            },
            activeColor: const Color.fromRGBO(255, 210, 23, 1),
            max: 1,
            min: 0,
          ),
        ),
      ),
    );
  }
}
