// lib/pages/record_detail_page.dart (새 파일)

import 'package:flutter/material.dart';
import '../models/travel_record.dart';
import '../widgets/detailed_add_record_modal.dart';

class RecordDetailPage extends StatefulWidget {
  final TravelRecord record;

  const RecordDetailPage({super.key, required this.record});

  @override
  State<RecordDetailPage> createState() => _RecordDetailPageState();
}

class _RecordDetailPageState extends State<RecordDetailPage> {
  // 수정 시 화면을 다시 그리기 위해 state 변수로 관리
  late TravelRecord _currentRecord;

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.record;
  }

  // 수정 모달을 여는 함수
  void _showEditModal() {
    showDialog(
      context: context,
      barrierDismissible: false, // 모달 밖 클릭 시 닫히지 않도록 설정
      builder: (context) {
        return DetailedAddRecordModal(
          recordToEdit: _currentRecord, // 수정할 레코드 전달
          onClose: () => Navigator.of(context).pop(),
          onSave: (updatedRecord) {
            // 모달에서 저장 시, 상세 페이지의 상태를 업데이트
            setState(() {
              _currentRecord = updatedRecord;
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 뒤로가기 버튼을 눌렀을 때, 수정된 데이터를 메인 리스트 페이지로 전달
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(_currentRecord),
        ),
        title: Text(_currentRecord.title),
        actions: [
          // 수정 버튼
          IconButton(
            icon: const Icon(Icons.edit_note),
            onPressed: _showEditModal,
            tooltip: '수정하기',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 여기에 상세 페이지 UI를 자유롭게 구성하세요.
          // 예시:
          Text(
            _currentRecord.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text('${_currentRecord.date} / ${_currentRecord.time}'),
            ],
          ),
          const SizedBox(height: 8),
          if (_currentRecord.location.isNotEmpty)
            Row(
              children: [
                const Icon(Icons.place_outlined, size: 16),
                const SizedBox(width: 8),
                Text(_currentRecord.location),
              ],
            ),
          const Divider(height: 32),
          Text(
            _currentRecord.description,
            style: const TextStyle(fontSize: 16, height: 1.5),
          ),
          // ... 기타 상세 정보 표시 ...
        ],
      ),
    );
  }
}