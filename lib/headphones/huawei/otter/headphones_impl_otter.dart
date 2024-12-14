import 'dart:async';
import 'dart:typed_data';

import 'package:rxdart/rxdart.dart';
import 'package:stream_channel/stream_channel.dart';

import '../../../logger.dart';
import '../../headphones_base.dart';
import '../../headphones_data_objects.dart';
import '../mbb.dart';

class HeadphonesImplOtter extends HeadphonesBase {
  final StreamChannel<Uint8List> connection;

  final _batteryStreamCtrl = BehaviorSubject<HeadphonesBatteryData>();
  final _ancStreamCtrl = BehaviorSubject<HeadphonesAncMode>();
  final _ancTypeStreamCtrl = BehaviorSubject<HeadphonesAncType>();
  final _eqModeStreamCtrl = BehaviorSubject<HeadphonesEqMode>();
  final _autoPauseStreamCtrl = BehaviorSubject<bool>();
  final _slideStreamCtrl = BehaviorSubject<bool>();
  final _dualConnectStreamCtrl = BehaviorSubject<bool>();
  final _ldacStateStreamCtrl = BehaviorSubject<bool>();
  final _voiceModeStreamCtrl = BehaviorSubject<bool>();
  final _gestureSettingsStreamCtrl =
      BehaviorSubject<HeadphonesGestureSettings>();

  /// This watches if we are still missing any info and re-requests it
  late StreamSubscription _watchdogStreamSub;

  HeadphonesImplOtter(this.connection, [this.alias]) {
    connection.stream.listen((event) {
      List<MbbCommand>? commands;
      try {
        commands = MbbCommand.fromPayload(event);
      } catch (e, s) {
        logg.e("mbb parsing error", error: e, stackTrace: s);
      }
      for (final cmd in commands ?? <MbbCommand>[]) {
        // FILTER THE SHIT OUT
        if (!(cmd.serviceId == 10 && cmd.commandId == 13)) {
          logg.t("📥 Received mbb cmd: $cmd");
        }
        try {
          _evalMbbCommand(cmd);
        } on RangeError catch (e, s) {
          logg.e('Error while parsing mbb cmd - (probably missing bytes)',
              error: e, stackTrace: s);
        }
      }
    }, onDone: () async {
      _batteryStreamCtrl.close();
      _ancStreamCtrl.close();
      _ancTypeStreamCtrl.close();
      _eqModeStreamCtrl.close();
      _autoPauseStreamCtrl.close();
      _dualConnectStreamCtrl.close();
      _ldacStateStreamCtrl.close();
      _slideStreamCtrl.close();
      _voiceModeStreamCtrl.close();
      _gestureSettingsStreamCtrl.close();
      _watchdogStreamSub.cancel();
    });
    _initRequestInfo();
    _watchdogStreamSub =
        Stream.periodic(const Duration(seconds: 3)).listen((_) {
      if ([
        batteryData.valueOrNull,
        ancMode.valueOrNull,
        ancType.valueOrNull,
        eqMode.valueOrNull,
        autoPause.valueOrNull,
        dualConnect.valueOrNull,
        ldacState.valueOrNull,
        slide.valueOrNull,
        voiceMode.valueOrNull,
        gestureSettings.valueOrNull?.doubleTapLeft,
        gestureSettings.valueOrNull?.doubleTapRight,
        gestureSettings.valueOrNull?.tripleTapLeft,
        gestureSettings.valueOrNull?.tripleTapRight,
        gestureSettings.valueOrNull?.holdBothToggledAncModes,
      ].any((e) => e == null)) {
        _initRequestInfo();
      }
    });
  }

  void _evalMbbCommand(MbbCommand cmd) {
    final lastGestures = _gestureSettingsStreamCtrl.valueOrNull ??
        const HeadphonesGestureSettings();
    if (cmd.serviceId == 43 && cmd.commandId == 42 && cmd.args.containsKey(1)) {
      late HeadphonesAncMode newMode;
      late HeadphonesAncType newType;
      // TODO: Add some constants for this globally
      // because 0 1 and 2 seem to be constant bytes representing the modes;
      if (cmd.args[1]![1] == 1) {
        newMode = HeadphonesAncMode.noiseCancel;
        if (cmd.args[1]![0] == 3) {
          newType = HeadphonesAncType.dynamic;
        } else if (cmd.args[1]![0] == 2) {
          newType = HeadphonesAncType.ultra;
        } else if (cmd.args[1]![0] == 1) {
          newType = HeadphonesAncType.cozy;
        } else if (cmd.args[1]![0] == 0) {
          newType = HeadphonesAncType.general;
        }
      } else if (cmd.args[1]![1] == 0) {
        newMode = HeadphonesAncMode.off;
      } else if (cmd.args[1]![1] == 2) {
        newMode = HeadphonesAncMode.awareness;
        if (cmd.args[1]![0] == 1){
          _voiceModeStreamCtrl.add(true);
        } else {
          _voiceModeStreamCtrl.add(false);
        }
      } else {
        logg.e("Unknown ANC mode: ${cmd.args[1]}");
        return;
      }
      _ancStreamCtrl.add(newMode);
      _ancTypeStreamCtrl.add(newType);
    } else if (cmd.serviceId == 43 && cmd.commandId == 74 && cmd.args.containsKey(2)) {
      late HeadphonesEqMode newEqMode;
      if (cmd.args[2]![0] == 1) {
        newEqMode = HeadphonesEqMode.nothing;
      } else if (cmd.args[2]![0] == 2) {
        newEqMode = HeadphonesEqMode.bass;
      } else if (cmd.args[2]![0] == 3) {
        newEqMode = HeadphonesEqMode.treble;
      } else if (cmd.args[2]![0] == 9) {
        newEqMode = HeadphonesEqMode.voice;
      } else {
        logg.e("Unknown EQ mode: ${cmd.args[1]}");
        return;
      }
      _eqModeStreamCtrl.add(newEqMode);
    } else if (cmd.serviceId == 1 &&
        (cmd.commandId == 39 || cmd.commandId == 8) &&
        cmd.args.length >= 3) {
      final level = cmd.args[2];
      final status = cmd.args[3];
      if (level == null || status == null) {
        logg.e("Battery data is missing level or status");
        return;
      }
      _batteryStreamCtrl.add(HeadphonesBatteryData(
        level[0] == 0 ? null : level[0],
        level[1] == 0 ? null : level[1],
        level[2] == 0 ? null : level[2],
        status[0] == 1,
        status[1] == 1,
        status[2] == 1,
      ));
    } else if (cmd.serviceId == 43 &&
        cmd.commandId == 17 &&
        cmd.args.containsKey(1)) {
      _autoPauseStreamCtrl.add(cmd.args[1]![0] == 1);
    } else if (cmd.serviceId == 43 &&
        cmd.commandId == 31 &&
        cmd.args.containsKey(1)) {
      _slideStreamCtrl.add(cmd.args[1]![0] == 0);
    } else if (cmd.serviceId == 43 &&
        cmd.commandId == 47 &&
        cmd.args.containsKey(1)) {
      _dualConnectStreamCtrl.add(cmd.args[1]![0] == 1);
    } else if (cmd.serviceId == 43 &&
        cmd.commandId == 163 &&
        cmd.args.containsKey(1)) {
      _ldacStateStreamCtrl.add(cmd.args[2]![0] == 1);
    } else if (cmd.serviceId == 1 && cmd.commandId == 32) {
      _gestureSettingsStreamCtrl.add(
        lastGestures.copyWith(
          doubleTapLeft: cmd.args[1] != null
              ? HeadphonesGestureDoubleTap.fromMbbValue(cmd.args[1]![0])
              : lastGestures.doubleTapLeft,
          doubleTapRight: cmd.args[2] != null
              ? HeadphonesGestureDoubleTap.fromMbbValue(cmd.args[2]![0])
              : lastGestures.doubleTapRight,
        ),
      );
    } else if (cmd.serviceId == 1 && cmd.commandId == 38) {
      _gestureSettingsStreamCtrl.add(
        lastGestures.copyWith(
          tripleTapLeft: cmd.args[1] != null
              ? HeadphonesGestureTripleTap.fromMbbValue(cmd.args[1]![0])
              : lastGestures.tripleTapLeft,
          tripleTapRight: cmd.args[2] != null
              ? HeadphonesGestureTripleTap.fromMbbValue(cmd.args[2]![0])
              : lastGestures.tripleTapRight,
        ),
      );
    } else if ((cmd.serviceId == 43 && cmd.commandId == 23)) {
      _gestureSettingsStreamCtrl.add(
        lastGestures.copyWith(
          holdBoth: (cmd.args[1] != null)
              ? HeadphonesGestureHold.fromMbbValue(cmd.args[1]![0])
              : lastGestures.holdBoth,
        ),
      );
    } else if (cmd.serviceId == 43 && cmd.commandId == 25) {
      _gestureSettingsStreamCtrl.add(
        lastGestures.copyWith(
          holdBothToggledAncModes: (cmd.args[1] != null)
              ? gestureHoldFromMbbValue(cmd.args[1]![0])
              : lastGestures.holdBothToggledAncModes,
        ),
      );
    }
  }

  Future<void> _initRequestInfo() async {
    await _sendMbb(MbbCommand.requestBattery);
    await _sendMbb(MbbCommand.requestAnc);
    await _sendMbb(MbbCommand.requestEq);
    await _sendMbb(MbbCommand.requestAutoPause);
    await _sendMbb(MbbCommand.requestDualConnect);
    await _sendMbb(MbbCommand.requestLdacState);
    await _sendMbb(MbbCommand.requestSlide);
    await _sendMbb(MbbCommand.requestGestureDoubleTap);
    await _sendMbb(MbbCommand.requestGestureTripleTap);
    await _sendMbb(MbbCommand.requestGestureHold);
    await _sendMbb(MbbCommand.requestGestureHoldToggledAncModes);
  }

  // TODO: some .flush() for this
  Future<void> _sendMbb(MbbCommand comm) async {
    logg.t("⬆ Sending mbb cmd: $comm");
    connection.sink.add(comm.toPayload());
  }

  @override
  final String? alias;

  @override
  ValueStream<HeadphonesBatteryData> get batteryData =>
      _batteryStreamCtrl.stream;

  @override
  ValueStream<HeadphonesAncMode> get ancMode => _ancStreamCtrl.stream;

  @override
  Future<void> setAncMode(HeadphonesAncMode mode) async {
    late MbbCommand comm;
    switch (mode) {
      case HeadphonesAncMode.noiseCancel:
        comm = MbbCommand.ancNoiseCancel;
        break;
      case HeadphonesAncMode.off:
        comm = MbbCommand.ancOff;
        break;
      case HeadphonesAncMode.awareness:
        comm = MbbCommand.ancAware;
        break;
    }
    await _sendMbb(comm);
  }

  @override
  ValueStream<HeadphonesAncType> get ancType => _ancTypeStreamCtrl.stream;

  @override
  Future<void> setAncType(HeadphonesAncType type) async {
    late MbbCommand comm;
    switch (type) {
      case HeadphonesAncType.dynamic:
        comm = MbbCommand.ancDynamic;
        break;
      case HeadphonesAncType.cozy:
        comm = MbbCommand.ancCozy;
        break;
      case HeadphonesAncType.general:
        comm = MbbCommand.ancGeneral;
        break;
      case HeadphonesAncType.ultra:
        comm = MbbCommand.ancUltra;
        break;
    }
    await _sendMbb(comm);
  }

  @override
  ValueStream<HeadphonesEqMode> get eqMode => _eqModeStreamCtrl.stream;

  @override
  Future<void> setEqMode(HeadphonesEqMode mode) async {
    late MbbCommand comm;
    switch (mode) {
      case HeadphonesEqMode.nothing:
        comm = MbbCommand.eqNothing;
        break;
      case HeadphonesEqMode.bass:
        comm = MbbCommand.eqBass;
        break;
      case HeadphonesEqMode.treble:
        comm = MbbCommand.eqTreble;
        break;
      case HeadphonesEqMode.voice:
        comm = MbbCommand.eqVoice;
        break;
    }
    await _sendMbb(comm);
  }

  @override
  ValueStream<bool> get autoPause => _autoPauseStreamCtrl.stream;

  @override
  Future<void> setAutoPause(bool enabled) async {
    await _sendMbb(enabled ? MbbCommand.autoPauseOn : MbbCommand.autoPauseOff);
    await _sendMbb(MbbCommand.requestAutoPause);
  }

  @override
  ValueStream<bool> get dualConnect => _dualConnectStreamCtrl.stream;

  @override
  Future<void> setDualConnect(bool enabled) async {
    await _sendMbb(enabled ? MbbCommand.dualConnectOn : MbbCommand.dualConnectOff);
    await _sendMbb(MbbCommand.requestDualConnect);
  }

  @override
  ValueStream<bool> get slide => _slideStreamCtrl.stream;

  @override
  Future<void> setSlide(bool enabled) async {
    await _sendMbb(enabled ? MbbCommand.slideOn : MbbCommand.slideOff);
    await _sendMbb(MbbCommand.requestSlide);
  }

  @override
  ValueStream<bool> get ldacState => _ldacStateStreamCtrl.stream;

  @override
  Future<void> setLdacState(bool enabled) async {
    await _sendMbb(enabled ? MbbCommand.ldacOn : MbbCommand.ldacOff);
    await _sendMbb(MbbCommand.requestLdacState);
  }

  @override
  ValueStream<bool> get voiceMode => _voiceModeStreamCtrl.stream;

  @override
  Future<void> setVoiceMode(bool enabled) async {
    await _sendMbb(enabled ? MbbCommand.voiceModeOn : MbbCommand.voiceModeOff);
    await _sendMbb(MbbCommand.requestAnc);
  }

  @override
  ValueStream<HeadphonesGestureSettings> get gestureSettings =>
      _gestureSettingsStreamCtrl.stream;

  /// This function welcomes you to send [settings] object with null values -
  /// it will only send headphones commands for non-null values, so we don't
  /// waste time 👍
  @override
  Future<void> setGestureSettings(HeadphonesGestureSettings settings) async {
    // double tap
    if (settings.doubleTapLeft != null) {
      await _sendMbb(MbbCommand.gestureDoubleTapLeft(settings.doubleTapLeft!));
    }
    if (settings.doubleTapRight != null) {
      await _sendMbb(
          MbbCommand.gestureDoubleTapRight(settings.doubleTapRight!));
    }
    if (settings.doubleTapLeft != null || settings.doubleTapRight != null) {
      await _sendMbb(MbbCommand.requestGestureDoubleTap);
    }
    // triple tap
    if (settings.tripleTapLeft != null) {
      await _sendMbb(MbbCommand.gestureTripleTapLeft(settings.tripleTapLeft!));
    }
    if (settings.tripleTapRight != null) {
      await _sendMbb(
          MbbCommand.gestureTripleTapRight(settings.tripleTapRight!));
    }
    if (settings.tripleTapLeft != null || settings.tripleTapRight != null) {
      await _sendMbb(MbbCommand.requestGestureTripleTap);
    }
    // hold
    if (settings.holdBoth != null) {
      await _sendMbb(MbbCommand.gestureHold(settings.holdBoth!));
      await _sendMbb(MbbCommand.requestGestureHold);
    }
    if (settings.holdBothToggledAncModes != null) {
      await _sendMbb(MbbCommand.gestureHoldToggledAncModes(
          settings.holdBothToggledAncModes!));
      await _sendMbb(MbbCommand.requestGestureHoldToggledAncModes);
    }
  }
}
