import 'package:flutter/material.dart';
import '../models/travel_record.dart'; // 실제 프로젝트의 모델 경로에 맞게 수정해주세요.
import 'package:intl/intl.dart';

class RecordCard extends StatelessWidget {
  final TravelRecord record;
  final VoidCallback onTap;      // ✨ 1. 카드 클릭 시 호출될 콜백 함수
  final VoidCallback onDelete;   // ✨ 2. 삭제 버튼 클릭 시 호출될 콜백 함수

  const RecordCard({
    super.key,
    required this.record,
    required this.onTap,      // ✨ 3. 생성자에서 콜백 함수들을 필수로 받도록 수정
    required this.onDelete,
  });

  // _getTypeIcon, _getTypeColor, _buildTransportDetails,
  // _buildAccommodationDetails, _buildDetailRow 메서드는 기존과 동일합니다.
  // (아래에 전체 코드가 포함되어 있으니 복사해서 사용하시면 됩니다.)

  IconData _getTypeIcon() {
    switch (record.type) {
      case TravelRecordType.destination:
        return Icons.location_on;
      case TravelRecordType.transport:
        return Icons.directions_car;
      case TravelRecordType.activity:
        return Icons.camera_alt;
    }
  }

  Color _getTypeColor(BuildContext context) {
    switch (record.type) {
      case TravelRecordType.destination:
        return Colors.blue;
      case TravelRecordType.transport:
        return Colors.green;
      case TravelRecordType.activity:
        return Colors.purple;
    }
  }

  Widget _buildTransportDetails(BuildContext context, TransportDetails details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.transportType == TransportType.airplane) ...[
            if (details.airline != null) _buildDetailRow('항공사', details.airline!),
            if (details.flightNumber != null) _buildDetailRow('항공편', details.flightNumber!),
            if (details.departureTime != null && details.arrivalTime != null)
              _buildDetailRow('시간', '${details.departureTime} → ${details.arrivalTime}'),
            if (details.reservationNumber != null) _buildDetailRow('예약번호', details.reservationNumber!),
          ],
          if (details.transportType == TransportType.rental) ...[
            if (details.rentalCompany != null) _buildDetailRow('렌트사', details.rentalCompany!),
            if (details.vehicle != null) _buildDetailRow('차량', details.vehicle!),
            if (details.rentalPeriod != null) _buildDetailRow('기간', details.rentalPeriod!),
          ],
          if (details.transportType == TransportType.train || details.transportType == TransportType.bus) ...[
            if (details.trainName != null || details.busName != null)
              _buildDetailRow('차량', details.trainName ?? details.busName!),
            if (details.departure != null && details.arrival != null)
              _buildDetailRow('구간', '${details.departure} → ${details.arrival}'),
            if (details.seat != null) _buildDetailRow('좌석', details.seat!),
          ],
        ],
      ),
    );
  }

  Widget _buildAccommodationDetails(BuildContext context, AccommodationDetails details) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (details.bookingSite != null) _buildDetailRow('예약사이트', details.bookingSite!),
          if (details.address != null) _buildDetailRow('주소', details.address!),
          if (details.checkIn != null && details.checkOut != null)
            _buildDetailRow('기간', '${details.checkIn} ~ ${details.checkOut}'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 12)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _getTypeColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator (기존과 동일)
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: typeColor,
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                width: 2,
                height: 80, // 이 부분은 카드 높이에 따라 동적으로 조절할 수 있습니다.
                color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Content
          Expanded(
            // ✨ 4. Stack을 사용해 카드 위에 삭제 버튼을 띄웁니다.
            child: Stack(
              children: [
                // ✨ 5. InkWell로 감싸서 카드 전체에 탭 효과와 onTap 콜백을 적용합니다.
                InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header (기존과 동일)
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: typeColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Icon(_getTypeIcon(), color: typeColor, size: 16),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                record.title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ),
                            Text(
                              record.time,
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),

                        // Location (기존과 동일)
                        if (record.location.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.place, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              const SizedBox(width: 4),
                              Text(
                                record.location,
                                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                        ],

                        // Description (기존과 동일)
                        if (record.description.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            record.description,
                            style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                          ),
                        ],

                        // Transport Details (기존과 동일)
                        if (record.type == TravelRecordType.transport && record.transportDetails != null) ...[
                          const SizedBox(height: 8),
                          _buildTransportDetails(context, record.transportDetails!),
                        ],

                        // Accommodation Details (기존과 동일)
                        if (record.type == TravelRecordType.destination && record.accommodationDetails != null) ...[
                          const SizedBox(height: 8),
                          _buildAccommodationDetails(context, record.accommodationDetails!),
                        ],

                        // Amount (기존과 동일)
                        if (record.amount > 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            '${NumberFormat('#,###').format(record.amount)}원',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],

                        // ✨ 삭제 버튼 공간 확보를 위한 여백 추가
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // ✨ 6. Positioned 위젯으로 삭제 버튼을 오른쪽 아래에 배치합니다.
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: IconButton(
                    icon: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error.withOpacity(0.7)),
                    onPressed: onDelete,
                    tooltip: '삭제',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}