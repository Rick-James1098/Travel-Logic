import 'package:flutter/material.dart';

// 나중에 테마 관리를 위해 enum을 사용할 수 있습니다.
enum ThemeSetting { light, dark, system }

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotificationsEnabled = true;
  ThemeSetting _currentTheme = ThemeSetting.system;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        // IndexedStack 내에서 사용될 경우 뒤로가기 버튼이 자동으로 생기지 않으므로,
        // Navigator.canPop(context)를 확인하여 뒤로 갈 수 있을 때만 버튼을 표시합니다.
        automaticallyImplyLeading: Navigator.canPop(context),
      ),
      body: ListView(
        children: [
          _buildSectionHeader('알림'),
          SwitchListTile(
            title: const Text('푸시 알림'),
            value: _pushNotificationsEnabled,
            onChanged: (bool value) {
              setState(() {
                _pushNotificationsEnabled = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('푸시 알림이 ${value ? "활성화되었습니다" : "비활성화되었습니다"}.')),
              );
            },
          ),
          const Divider(),
          _buildSectionHeader('화면 및 표시 설정'),
          RadioListTile<ThemeSetting>(
            title: const Text('라이트 모드'),
            value: ThemeSetting.light,
            groupValue: _currentTheme,
            onChanged: (ThemeSetting? value) {
              setState(() {
                _currentTheme = value!;
              });
              // TODO: 실제 테마 변경 로직 추가
            },
          ),
          RadioListTile<ThemeSetting>(
            title: const Text('다크 모드'),
            value: ThemeSetting.dark,
            groupValue: _currentTheme,
            onChanged: (ThemeSetting? value) {
              setState(() {
                _currentTheme = value!;
              });
              // TODO: 실제 테마 변경 로직 추가
            },
          ),
          RadioListTile<ThemeSetting>(
            title: const Text('시스템 설정'),
            value: ThemeSetting.system,
            groupValue: _currentTheme,
            onChanged: (ThemeSetting? value) {
              setState(() {
                _currentTheme = value!;
              });
              // TODO: 실제 테마 변경 로직 추가
            },
          ),
          const Divider(),
          _buildSectionHeader('정보'),
          ListTile(
            title: const Text('앱 버전'),
            trailing: const Text('0.3.3'),
            onTap: () {}, // 아무 동작 없음
          ),
          ListTile(
            title: const Text('서비스 이용약관'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 이용약관 페이지로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('서비스 이용약관 페이지는 준비 중입니다.')),
              );
            },
          ),
          ListTile(
            title: const Text('개인정보 처리방침'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: 개인정보 처리방침 페이지로 이동
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('개인정보 처리방침 페이지는 준비 중입니다.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
