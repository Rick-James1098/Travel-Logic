import 'package:flutter/material.dart';
import '../models/travel_record.dart';

class DetailedAddRecordModal extends StatefulWidget {
  final VoidCallback onClose;
  final Function(TravelRecord) onSave;
  final TravelRecord? recordToEdit;

  const DetailedAddRecordModal({
    super.key,
    required this.onClose,
    required this.onSave,
    this.recordToEdit,
  });

  @override
  State<DetailedAddRecordModal> createState() => _DetailedAddRecordModalState();
}

class _DetailedAddRecordModalState extends State<DetailedAddRecordModal> {
  TravelRecordType _selectedType = TravelRecordType.destination;
  TransportType _selectedTransportType = TransportType.airplane;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _amountController = TextEditingController();
  TimeOfDay? _selectedTime;

  // Transport details controllers
  final _airlineController = TextEditingController();
  final _flightNumberController = TextEditingController();
  final _reservationNumberController = TextEditingController();
  final _rentalCompanyController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _rentalPeriodController = TextEditingController();
  final _voucherController = TextEditingController();
  final _rentalDetailsController = TextEditingController();
  final _trainNameController = TextEditingController();
  final _busNameController = TextEditingController();
  final _departureController = TextEditingController();
  final _arrivalController = TextEditingController();
  final _seatController = TextEditingController();
  TimeOfDay? _departureTime;
  TimeOfDay? _arrivalTime;

  // Accommodation details controllers
  final _bookingSiteController = TextEditingController();
  final _bookingSiteLinkController = TextEditingController();
  final _addressController = TextEditingController();
  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  late final bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.recordToEdit != null;

    // 수정 모드일 경우, 폼 필드를 기존 데이터로 채우는 로직
    if (_isEditing) {
      final record = widget.recordToEdit!;

      // --- 1. 공통 정보 채우기 ---
      _selectedType = record.type;
      _titleController.text = record.title;
      _descriptionController.text = record.description;
      _locationController.text = record.location;
      _amountController.text = record.amount.toString();

      // 시간 파싱 (HH:mm 형식)
      if (record.time.isNotEmpty) {
        final timeParts = record.time.split(':');
        if (timeParts.length == 2) {
          _selectedTime = TimeOfDay(
            hour: int.tryParse(timeParts[0]) ?? 0,
            minute: int.tryParse(timeParts[1]) ?? 0,
          );
        }
      }

      // --- 2. 교통수단 상세 정보 채우기 ---
      if (record.transportDetails != null) {
        final details = record.transportDetails!;
        _selectedTransportType = details.transportType;

        // 항공편
        _airlineController.text = details.airline ?? '';
        _flightNumberController.text = details.flightNumber ?? '';
        _reservationNumberController.text = details.reservationNumber ?? '';

        // 렌트카
        _rentalCompanyController.text = details.rentalCompany ?? '';
        _vehicleController.text = details.vehicle ?? '';
        _rentalPeriodController.text = details.rentalPeriod ?? '';
        _voucherController.text = details.voucher ?? '';
        _rentalDetailsController.text = details.rentalDetails ?? '';

        // 기차/버스
        _trainNameController.text = details.trainName ?? '';
        _busNameController.text = details.busName ?? '';
        _departureController.text = details.departure ?? '';
        _arrivalController.text = details.arrival ?? '';
        _seatController.text = details.seat ?? '';

        // 출발/도착 시간 파싱
        if (details.departureTime != null) {
          final timeParts = details.departureTime!.split(':');
          if (timeParts.length == 2) {
            _departureTime = TimeOfDay(hour: int.tryParse(timeParts[0]) ?? 0, minute: int.tryParse(timeParts[1]) ?? 0);
          }
        }
        if (details.arrivalTime != null) {
          final timeParts = details.arrivalTime!.split(':');
          if (timeParts.length == 2) {
            _arrivalTime = TimeOfDay(hour: int.tryParse(timeParts[0]) ?? 0, minute: int.tryParse(timeParts[1]) ?? 0);
          }
        }
      }

      // --- 3. 숙소 상세 정보 채우기 ---
      if (record.accommodationDetails != null) {
        final details = record.accommodationDetails!;
        _bookingSiteController.text = details.bookingSite ?? '';
        _bookingSiteLinkController.text = details.bookingSiteLink ?? '';
        _addressController.text = details.address ?? '';

        // 체크인/체크아웃 날짜 파싱
        if (details.checkIn != null) {
          _checkInDate = DateTime.tryParse(details.checkIn!);
        }
        if (details.checkOut != null) {
          _checkOutDate = DateTime.tryParse(details.checkOut!);
        }
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _amountController.dispose();
    _airlineController.dispose();
    _flightNumberController.dispose();
    _reservationNumberController.dispose();
    _rentalCompanyController.dispose();
    _vehicleController.dispose();
    _rentalPeriodController.dispose();
    _voucherController.dispose();
    _rentalDetailsController.dispose();
    _trainNameController.dispose();
    _busNameController.dispose();
    _departureController.dispose();
    _arrivalController.dispose();
    _seatController.dispose();
    _bookingSiteController.dispose();
    _bookingSiteLinkController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleController.text.trim().isEmpty || _selectedTime == null) {
      return;
    }

    final timeString = '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}';
    final currentDate = DateTime.now().toIso8601String().split('T')[0];

    TransportDetails? transportDetails;
    if (_selectedType == TravelRecordType.transport) {
      transportDetails = TransportDetails(
        transportType: _selectedTransportType,
        airline: _airlineController.text.isNotEmpty ? _airlineController.text : null,
        flightNumber: _flightNumberController.text.isNotEmpty ? _flightNumberController.text : null,
        departureTime: _departureTime != null ? '${_departureTime!.hour.toString().padLeft(2, '0')}:${_departureTime!.minute.toString().padLeft(2, '0')}' : null,
        arrivalTime: _arrivalTime != null ? '${_arrivalTime!.hour.toString().padLeft(2, '0')}:${_arrivalTime!.minute.toString().padLeft(2, '0')}' : null,
        reservationNumber: _reservationNumberController.text.isNotEmpty ? _reservationNumberController.text : null,
        rentalCompany: _rentalCompanyController.text.isNotEmpty ? _rentalCompanyController.text : null,
        vehicle: _vehicleController.text.isNotEmpty ? _vehicleController.text : null,
        rentalPeriod: _rentalPeriodController.text.isNotEmpty ? _rentalPeriodController.text : null,
        voucher: _voucherController.text.isNotEmpty ? _voucherController.text : null,
        rentalDetails: _rentalDetailsController.text.isNotEmpty ? _rentalDetailsController.text : null,
        trainName: _trainNameController.text.isNotEmpty ? _trainNameController.text : null,
        busName: _busNameController.text.isNotEmpty ? _busNameController.text : null,
        departure: _departureController.text.isNotEmpty ? _departureController.text : null,
        arrival: _arrivalController.text.isNotEmpty ? _arrivalController.text : null,
        seat: _seatController.text.isNotEmpty ? _seatController.text : null,
      );
    }

    AccommodationDetails? accommodationDetails;
    if (_selectedType == TravelRecordType.destination) {
      accommodationDetails = AccommodationDetails(
        bookingSite: _bookingSiteController.text.isNotEmpty ? _bookingSiteController.text : null,
        bookingSiteLink: _bookingSiteLinkController.text.isNotEmpty ? _bookingSiteLinkController.text : null,
        address: _addressController.text.isNotEmpty ? _addressController.text : null,
        checkIn: _checkInDate?.toIso8601String().split('T')[0],
        checkOut: _checkOutDate?.toIso8601String().split('T')[0],
      );
    }

    final record = TravelRecord(
      id: _isEditing ? widget.recordToEdit!.id : '',
      type: _selectedType,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      location: _locationController.text.trim(),
      time: timeString,
      date: _isEditing ? widget.recordToEdit!.date : currentDate,
      amount: int.tryParse(_amountController.text) ?? 0,
      transportDetails: transportDetails,
      accommodationDetails: accommodationDetails,
    );

    widget.onSave(record);
    widget.onClose();
  }

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _selectedTime = time;
      });
    }
  }

  void _selectDepartureTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _departureTime = time;
      });
    }
  }

  void _selectArrivalTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        _arrivalTime = time;
      });
    }
  }

  void _selectCheckInDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _checkInDate = date;
      });
    }
  }

  void _selectCheckOutDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: _checkInDate ?? DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _checkOutDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Material(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    _isEditing ? '기록 수정' : '새 기록 추가',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
          
                  if (!_isEditing) ...[
                    const Text(
                      '기록 유형',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: TravelRecordType.values.map((type) {
                        final isSelected = _selectedType == type;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedType = type);
                            },
                            child: Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceVariant,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    _getTypeIcon(type),
                                    color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                                    size: 20,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    type.label,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
          
                  
          
                  // Transport Type Selection
                  if (_selectedType == TravelRecordType.transport) ...[
                    const Text(
                      '교통수단 유형',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TransportType>(
                      value: _selectedTransportType,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: TransportType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Row(
                            children: [
                              Icon(_getTransportIcon(type), size: 16),
                              const SizedBox(width: 8),
                              Text(type.label),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedTransportType = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
          
                  // Title
                  const Text(
                    '제목 *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      hintText: '예: 경복궁 방문',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
          
                  // Time
                  const Text(
                    '시간 *',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedTime != null
                                ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                                : '시간 선택',
                            style: TextStyle(
                              color: _selectedTime != null
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
          
                  // Location
                  const Text(
                    '위치',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: '예: 서울특별시 종로구',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
          
                  // Amount
                  const Text(
                    '비용',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
          
                  // Type-specific fields
                  if (_selectedType == TravelRecordType.transport)
                    _buildTransportFields(),
          
                  if (_selectedType == TravelRecordType.destination)
                    _buildAccommodationFields(),
          
                  // if (_selectedType == TravelRecordType.activity)
                  //   _buildActivityFields(),
          
                  // Description
                  const Text(
                    '메모',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descriptionController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: '여행 기록에 대한 메모를 입력하세요...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 24),
          
                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onClose,
                          child: const Text('취소'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: _titleController.text.trim().isNotEmpty && _selectedTime != null
                              ? _handleSave
                              : null,
                          child: Text(_isEditing ? '수정 완료' : '저장'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransportFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '교통수단 상세 정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        
        if (_selectedTransportType == TransportType.airplane) ...[
          TextField(
            controller: _airlineController,
            decoration: const InputDecoration(
              labelText: '항공사',
              hintText: '예: 대한항공',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _flightNumberController,
            decoration: const InputDecoration(
              labelText: '항공편 명',
              hintText: '예: KE123',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDepartureTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('출발 시간', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(_departureTime != null 
                          ? '${_departureTime!.hour.toString().padLeft(2, '0')}:${_departureTime!.minute.toString().padLeft(2, '0')}'
                          : '시간 선택'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectArrivalTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도착 시간', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(_arrivalTime != null 
                          ? '${_arrivalTime!.hour.toString().padLeft(2, '0')}:${_arrivalTime!.minute.toString().padLeft(2, '0')}'
                          : '시간 선택'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reservationNumberController,
            decoration: const InputDecoration(
              labelText: '예약 번호',
              hintText: '예: ABC123DEF',
              border: OutlineInputBorder(),
            ),
          ),
        ],

        if (_selectedTransportType == TransportType.rental) ...[
          TextField(
            controller: _rentalCompanyController,
            decoration: const InputDecoration(
              labelText: '렌트카 회사',
              hintText: '예: 허츠, 롯데렌터카',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _vehicleController,
            decoration: const InputDecoration(
              labelText: '차량',
              hintText: '예: 현대 아반떼',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rentalPeriodController,
            decoration: const InputDecoration(
              labelText: '렌트 기간',
              hintText: '예: 2025-01-19 ~ 2025-01-21',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reservationNumberController,
            decoration: const InputDecoration(
              labelText: '예약 번호',
              hintText: '예: R123456789',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _voucherController,
            decoration: const InputDecoration(
              labelText: '바우처',
              hintText: '바우처 정보',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _rentalDetailsController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: '예약 내용',
              hintText: '추가 예약 정보를 입력하세요...',
              border: OutlineInputBorder(),
            ),
          ),
        ],

        if (_selectedTransportType == TransportType.train || _selectedTransportType == TransportType.bus) ...[
          TextField(
            controller: _selectedTransportType == TransportType.train ? _trainNameController : _busNameController,
            decoration: InputDecoration(
              labelText: _selectedTransportType == TransportType.train ? '열차명' : '버스명',
              hintText: _selectedTransportType == TransportType.train ? '예: KTX 123' : '예: 고속버스 123',
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _departureController,
                  decoration: const InputDecoration(
                    labelText: '출발',
                    hintText: '출발지',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _arrivalController,
                  decoration: const InputDecoration(
                    labelText: '도착',
                    hintText: '도착지',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: _selectDepartureTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('출발 시간', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(_departureTime != null 
                          ? '${_departureTime!.hour.toString().padLeft(2, '0')}:${_departureTime!.minute.toString().padLeft(2, '0')}'
                          : '시간 선택'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _selectArrivalTime,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('도착 시간', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                        Text(_arrivalTime != null 
                          ? '${_arrivalTime!.hour.toString().padLeft(2, '0')}:${_arrivalTime!.minute.toString().padLeft(2, '0')}'
                          : '시간 선택'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _seatController,
            decoration: const InputDecoration(
              labelText: '좌석',
              hintText: '예: 1A, 15B',
              border: OutlineInputBorder(),
            ),
          ),
        ],

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAccommodationFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '숙소 상세 정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        
        TextField(
          controller: _bookingSiteController,
          decoration: const InputDecoration(
            labelText: '예약 사이트',
            hintText: '예: 호텔스닷컴, 아고다',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        
        TextField(
          controller: _bookingSiteLinkController,
          decoration: const InputDecoration(
            labelText: '예약 사이트 링크 (선택사항)',
            hintText: 'https://...',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        
        TextField(
          controller: _addressController,
          decoration: const InputDecoration(
            labelText: '주소',
            hintText: '숙소 주소를 입력하세요',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _selectCheckInDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('체크인', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text(_checkInDate != null 
                        ? '${_checkInDate!.year}-${_checkInDate!.month.toString().padLeft(2, '0')}-${_checkInDate!.day.toString().padLeft(2, '0')}'
                        : '날짜 선택'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _selectCheckOutDate,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('체크아웃', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                      Text(_checkOutDate != null 
                        ? '${_checkOutDate!.year}-${_checkOutDate!.month.toString().padLeft(2, '0')}-${_checkOutDate!.day.toString().padLeft(2, '0')}'
                        : '날짜 선택'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  //
  // Widget _buildActivityFields() {
  //   return Column(
  //     crossAxisAlignment : CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         '내용',
  //         style: TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //         ),
  //       ),
  //       const SizedBox(height: 16,),
  //       TextField(
  //         controller: _descriptionController,
  //         maxLines: 3,
  //         decoration: const InputDecoration(
  //           hintText: '어떤 활동을 하셨나요?',
  //           border: OutlineInputBorder(),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  IconData _getTypeIcon(TravelRecordType type) {
    switch (type) {
      case TravelRecordType.destination:
        return Icons.location_on;
      case TravelRecordType.transport:
        return Icons.directions_car;
      case TravelRecordType.activity:
        return Icons.camera_alt;
    }
  }

  IconData _getTransportIcon(TransportType type) {
    switch (type) {
      case TransportType.airplane:
        return Icons.flight;
      case TransportType.rental:
        return Icons.car_rental;
      case TransportType.train:
        return Icons.train;
      case TransportType.bus:
        return Icons.directions_bus;
      case TransportType.other:
        return Icons.directions_car;
    }
  }
}