import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  TextSpan _link(String text, [String? url]) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () =>
            launchUrlString(url ?? text, mode: LaunchMode.externalApplication),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final t = Theme.of(context);
    final tt = t.textTheme;
    return Scaffold(
      backgroundColor: t.colorScheme.background,
      appBar: AppBar(title: Text(l.pageAboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutHello,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.pageAboutMeBio,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutMeAnyQuestions,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutMeOpenSource,
                    style: tt.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutNotice,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.pageAboutNoticeText,
                    style: tt.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutMentions,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.pageAboutMentionsTheLastGimbus,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutMentionsHuawei,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutMentionsForum,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutMentionsOpenAI,
                    style: tt.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutTech,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.pageAboutTechAndroid,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutTechFlutter,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.pageAboutTechWireshark,
                    style: tt.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.privacyPolicy,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l.privacyPolicyTextF,
                    style: tt.bodyLarge,
                  ),
                  Text(
                    l.privacyPolicyTextS,
                    style: tt.bodyLarge,
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutLinks,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: tt.bodyLarge,
                      children: [
                        _link(l.pageAboutLinkMy, "https://github.com/wtshelyx/FreeBuds6i_Assistant"),
                        const TextSpan(text: "\n"),
                        _link(l.pageAboutLinkFreebuddy, "https://github.com/TheLastGimbus/FreeBuddy"),
                        const TextSpan(text: "\n"),
                        _link(l.pageAboutLinkTheLastGimbus, "https://discord.gg/fYS98UE5Cu"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.pageAboutDonate,
                    style: tt.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: tt.bodyLarge,
                      children: [
                        const TextSpan(text: "Если вдруг вы безумно благодарны моей работе... 🥺\nВТБ - "),
                        _link("2200 2480 6643 0264"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () =>
                Navigator.of(context).pushNamed('/settings/about/licenses'),
            child: Text(l.pageAboutOpenSourceLicensesBtn),
          ),
        ],
      ),
    );
  }
}
