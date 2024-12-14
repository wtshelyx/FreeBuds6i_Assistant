class OtterConst {
  static const String name = 'HUAWEI Freebuds 6i';

  @Deprecated("This seems to not work... use [btDevNameRegex] instead")
  static final btMacRegex = RegExp(r'..:..:..:..:..:..', caseSensitive: false);

  // Copied straight from decompiled app
  static final btDevNameRegex =
      RegExp(r'^(?=(HUAWEI FreeBuds 6i))', caseSensitive: true);
}
