import 'package:rxdart/rxdart.dart';

import 'headphones_base.dart';
import 'headphones_data_objects.dart';

/// Headphones that never have any data
class HeadphonesMockNever extends HeadphonesBase {
  @override
  String? get alias => null;

  @override
  ValueStream<HeadphonesBatteryData> get batteryData =>
      NeverStream<HeadphonesBatteryData>().shareValue();

  @override
  ValueStream<HeadphonesAncMode> get ancMode =>
      NeverStream<HeadphonesAncMode>().shareValue();

  @override
  Future<void> setAncMode(HeadphonesAncMode mode) async {}

  @override
  ValueStream<HeadphonesAncType> get ancType =>
      NeverStream<HeadphonesAncType>().shareValue();

  @override
  Future<void> setAncType(HeadphonesAncType type) async {}

  @override
  ValueStream<HeadphonesEqMode> get eqMode =>
      NeverStream<HeadphonesEqMode>().shareValue();

  @override
  Future<void> setEqMode(HeadphonesEqMode mode) async {}

  @override
  ValueStream<bool> get autoPause => NeverStream<bool>().shareValue();

  @override
  Future<void> setAutoPause(bool enabled) async {}

  @override
  ValueStream<bool> get dualConnect => NeverStream<bool>().shareValue();

  @override
  Future<void> setDualConnect(bool enabled) async {}

  ValueStream<bool> get slide => NeverStream<bool>().shareValue();

  @override
  Future<void> setSlide(bool enabled) async {}

  @override
  ValueStream<bool> get ldacState => NeverStream<bool>().shareValue();

  @override
  Future<void> setLdacState(bool enabled) async {}

  @override
  ValueStream<bool> get voiceMode => NeverStream<bool>().shareValue();

  @override
  Future<void> setVoiceMode(bool enabled) async {}

  @override
  ValueStream<HeadphonesGestureSettings> get gestureSettings =>
      NeverStream<HeadphonesGestureSettings>().shareValue();

  @override
  Future<void> setGestureSettings(HeadphonesGestureSettings settings) async {}
}

/// Pretty faked headphones that emit some different fake values over time
class HeadphonesMockPrettyFake extends HeadphonesBase {
  final _batteryData = BehaviorSubject<HeadphonesBatteryData>();
  final _ancMode = BehaviorSubject<HeadphonesAncMode>();
  final _ancType = BehaviorSubject<HeadphonesAncType>();
  final _eqMode = BehaviorSubject<HeadphonesEqMode>();
  final _autoPause = BehaviorSubject<bool>();
  final _slide = BehaviorSubject<bool>();
  final _ldacState = BehaviorSubject<bool>();
  final _dualConnect = BehaviorSubject<bool>();
  final _voiceMode = BehaviorSubject<bool>();
  final _gestureSettings = BehaviorSubject<HeadphonesGestureSettings>();

  HeadphonesMockPrettyFake() {
    Stream.periodic(
      const Duration(seconds: 1),
      (i) => HeadphonesBatteryData(
        ((i * 1.0 - 100).abs() % 100).round(),
        ((i * 1.1 - 100).abs() % 100).round(),
        ((i * 0.7 - 100).abs() % 100).round(),
        i % 35 < 10,
        (i + 6) % 35 < 10,
        i % 15 < 10,
      ),
    ).listen(_batteryData.add);
    _batteryData.add(HeadphonesBatteryData(100, 100, 100, true, true, true));
    _ancMode.add(HeadphonesAncMode.off);
    _ancType.add(HeadphonesAncType.dynamic);
    _eqMode.add(HeadphonesEqMode.nothing);
    _autoPause.add(false);
    _slide.add(false);
    _ldacState.add(false);
    _ldacState.add(false);
    _voiceMode.add(false);
    _gestureSettings.add(
      const HeadphonesGestureSettings(
        doubleTapLeft: HeadphonesGestureDoubleTap.playPause,
        doubleTapRight: HeadphonesGestureDoubleTap.next,
        tripleTapLeft: HeadphonesGestureTripleTap.nothing,
        tripleTapRight: HeadphonesGestureTripleTap.previous,
        holdBoth: HeadphonesGestureHold.cycleAnc,
        holdBothToggledAncModes: {
          HeadphonesAncMode.noiseCancel,
          HeadphonesAncMode.awareness
        },
      ),
    );
  }

  @override
  String? get alias => "Freebuds 6i"; //todo здесь указывается имя устройства

  @override
  ValueStream<HeadphonesBatteryData> get batteryData => _batteryData.stream;

  @override
  ValueStream<HeadphonesAncMode> get ancMode => _ancMode.stream;

  @override
  Future<void> setAncMode(HeadphonesAncMode mode) async => _ancMode.add(mode);

  @override
  ValueStream<HeadphonesAncType> get ancType => _ancType.stream;

  @override
  Future<void> setAncType(HeadphonesAncType type) async => _ancType.add(type);

  @override
  ValueStream<HeadphonesEqMode> get eqMode => _eqMode.stream;

  @override
  Future<void> setEqMode(HeadphonesEqMode mode) async => _eqMode.add(mode);

  @override
  ValueStream<bool> get autoPause => _autoPause.stream;

  @override
  Future<void> setAutoPause(bool enabled) async => _autoPause.add(enabled);

  @override
  ValueStream<bool> get dualConnect => _dualConnect.stream;

  @override
  Future<void> setDualConnect(bool enabled) async => _dualConnect.add(enabled);

  @override
  ValueStream<bool> get slide => _slide.stream;

  @override
  Future<void> setSlide(bool enabled) async => _slide.add(enabled);

  @override
  ValueStream<bool> get ldacState => _ldacState.stream;

  @override
  Future<void> setLdacState(bool enabled) async => _ldacState.add(enabled);

  @override
  ValueStream<bool> get voiceMode => _voiceMode.stream;

  @override
  Future<void> setVoiceMode(bool enabled) async => _voiceMode.add(enabled);

  @override
  ValueStream<HeadphonesGestureSettings> get gestureSettings =>
      _gestureSettings.stream;

  @override
  Future<void> setGestureSettings(HeadphonesGestureSettings settings) async =>
      _gestureSettings.add(
        _gestureSettings.value.copyWith(
          doubleTapLeft: settings.doubleTapLeft,
          doubleTapRight: settings.doubleTapRight,
          tripleTapLeft: settings.tripleTapLeft,
          tripleTapRight: settings.tripleTapRight,
          holdBoth: settings.holdBoth,
          holdBothToggledAncModes: settings.holdBothToggledAncModes,
        ),
      );
}
