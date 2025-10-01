// lib/widgets/record_detail_modal.dart (수정된 파일)

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/travel_record.dart';
import './detailed_add_record_modal.dart';

class RecordDetailModal extends StatefulWidget {
  final TravelRecord initialRecord;
  final VoidCallback onClose;
  final Function(TravelRecord) onRecordUpdated;

  const RecordDetailModal({
    super.key,
    required this.initialRecord,
    required this.onClose,
    required this.onRecordUpdated,
  });

  @override
  State<RecordDetailModal> createState() => _RecordDetailModalState();
}

class _RecordDetailModalState extends State<RecordDetailModal> {
  late TravelRecord _currentRecord;
  final currencyFormat = NumberFormat.currency(locale: 'ko_KR', symbol: '₩');

  @override
  void initState() {
    super.initState();
    _currentRecord = widget.initialRecord;
  }

  // --- ⬇️ 이 함수가 수정되었습니다 ⬇️ ---
  void _showEditModal() {
    // ❗ 문제의 원인이었던 `widget.onClose()` 코드를 여기서 제거합니다.
    // 이제 상세 모달을 미리 닫지 않습니다.

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) { // context 이름 충돌을 피하기 위해 dialogContext로 변경
        return DetailedAddRecordModal(
          recordToEdit: _currentRecord,
          onClose: () => Navigator.of(dialogContext).pop(),
          tripPlanId: _currentRecord.tripPlanId,
          onSave: (updatedRecord) {
            // 1. 메인 리스트의 데이터를 업데이트합니다. (가장 중요)
            widget.onRecordUpdated(updatedRecord);

            // 2. 수정이 완료되었으니, 열려있던 상세 정보 모달도 닫아줍니다.
            widget.onClose();

            // 참고: DetailedAddRecordModal의 onSave 콜백 이후 onClose가 자동으로
            // 호출되어 수정 모달은 스스로 닫힙니다.
          },
        );
      },
    );
  }
  // --- ⬆️ 여기까지 수정되었습니다 ⬆️ ---


  // URL 링크를 여는 함수 (변경 없음)
  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('링크를 열 수 없습니다: $urlString')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 이 아래의 UI 코드는 변경된 부분이 없습니다.
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _currentRecord.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_note),
                  onPressed: _showEditModal,
                  tooltip: '수정하기',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onClose,
                  tooltip: '닫기',
                ),
              ],
            ),
            const Divider(height: 24),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  _buildInfoRow(
                    icon: Icons.calendar_today,
                    label: '${_currentRecord.date} / ${_currentRecord.time}',
                  ),
                  if (_currentRecord.location.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.place_outlined,
                      label: _currentRecord.location,
                    ),
                  if (_currentRecord.amount > 0)
                    _buildInfoRow(
                      icon: Icons.receipt_long_outlined,
                      label: '비용: ${currencyFormat.format(_currentRecord.amount)}',
                    ),
                  const SizedBox(height: 16),
                  _buildTypeSpecificDetails(),
                  if (_currentRecord.description.isNotEmpty) ...[
                    const Text(
                      '📝 메모',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _currentRecord.description,
                        style: const TextStyle(fontSize: 15, height: 1.5),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ... 이하 헬퍼 함수들은 모두 동일합니다 ...
  Widget _buildTypeSpecificDetails() {
    if (_currentRecord.type == TravelRecordType.transport && _currentRecord.transportDetails != null) {
      return _buildTransportDetails(_currentRecord.transportDetails!);
    }
    if (_currentRecord.type == TravelRecordType.destination && _currentRecord.accommodationDetails != null) {
      return _buildAccommodationDetails(_currentRecord.accommodationDetails!);
    }
    return const SizedBox.shrink();
  }

  Widget _buildTransportDetails(TransportDetails details) {
    final transportType = details.transportType;
    String title = '';
    switch (transportType) {
      case TransportType.airplane: title = '✈️ 항공편 정보'; break;
      case TransportType.rental: title = '🚗 렌트카 정보'; break;
      case TransportType.train: title = '🚆 기차 정보'; break;
      case TransportType.bus: title = '🚌 버스 정보'; break;
      case TransportType.other: title = '기타 교통 정보'; break;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (details.airline != null) _buildDetailRow('항공사', details.airline!),
        if (details.flightNumber != null) _buildDetailRow('항공편', details.flightNumber!),
        if (details.rentalCompany != null) _buildDetailRow('렌트카 회사', details.rentalCompany!),
        if (details.vehicle != null) _buildDetailRow('차량', details.vehicle!),
        if (details.trainName != null) _buildDetailRow('열차명', details.trainName!),
        if (details.busName != null) _buildDetailRow('버스명', details.busName!),
        if (details.departure != null && details.arrival != null) _buildDetailRow('구간', '${details.departure} → ${details.arrival!}'),
        if (details.departureTime != null && details.arrivalTime != null) _buildDetailRow('시간', '${details.departureTime} ~ ${details.arrivalTime!}'),
        if (details.seat != null) _buildDetailRow('좌석', details.seat!),
        if (details.reservationNumber != null) _buildDetailRow('예약번호', details.reservationNumber!),
        if (details.rentalPeriod != null) _buildDetailRow('렌트 기간', details.rentalPeriod!),
        if (details.voucher != null) _buildDetailRow('바우처', details.voucher!),
        if (details.rentalDetails != null) _buildDetailRow('예약 내용', details.rentalDetails!),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAccommodationDetails(AccommodationDetails details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🏠 숙소 정보', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (details.bookingSite != null) _buildDetailRow('예약 사이트', details.bookingSite!),
        if (details.bookingSiteLink != null) _buildLinkRow('예약 링크', details.bookingSiteLink!),
        if (details.address != null) _buildDetailRow('주소', details.address!),
        if (details.checkIn != null && details.checkOut != null) _buildDetailRow('숙박 기간', '${details.checkIn} ~ ${details.checkOut!}'),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildInfoRow({required IconData icon, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildLinkRow(String label, String url) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(
            child: InkWell(
              onTap: () => _launchUrl(url),
              child: Text(url, style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}