import { useState } from "react";
import { MapPin, Car, Camera, X, Plane, CarFront, Train, Bus, FileText } from "lucide-react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Textarea } from "./ui/textarea";
import { Label } from "./ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { TravelRecord, TransportDetails, AccommodationDetails } from "./RecordCard";

interface DetailedAddRecordModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (record: Omit<TravelRecord, 'id'>) => void;
}

const recordTypes = [
  { id: 'destination', label: '숙소', icon: MapPin, color: 'bg-blue-500' },
  { id: 'transport', label: '교통수단', icon: Car, color: 'bg-green-500' },
  { id: 'activity', label: '액티비티', icon: Camera, color: 'bg-purple-500' }
];

const transportTypes = [
  { id: 'airplane', label: '비행기', icon: Plane },
  { id: 'rental', label: '렌트카', icon: CarFront },
  { id: 'train', label: '기차', icon: Train },
  { id: 'bus', label: '버스', icon: Bus },
  { id: 'other', label: '기타', icon: Car }
];

export function DetailedAddRecordModal({ isOpen, onClose, onSave }: DetailedAddRecordModalProps) {
  const [selectedType, setSelectedType] = useState<'destination' | 'transport' | 'activity'>('destination');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [location, setLocation] = useState('');
  const [time, setTime] = useState('');
  const [amount, setAmount] = useState('');

  // Transport details
  const [transportType, setTransportType] = useState<'airplane' | 'rental' | 'train' | 'bus' | 'other'>('airplane');
  const [transportDetails, setTransportDetails] = useState<Partial<TransportDetails>>({});

  // Accommodation details
  const [accommodationDetails, setAccommodationDetails] = useState<Partial<AccommodationDetails>>({});

  const handleSave = () => {
    if (!title.trim() || !time) return;

    const currentDate = new Date().toISOString().split('T')[0];
    
    const record: Omit<TravelRecord, 'id'> = {
      type: selectedType,
      title: title.trim(),
      description: description.trim(),
      location: location.trim(),
      time,
      date: currentDate,
      amount: amount ? parseInt(amount) : 0
    };

    if (selectedType === 'transport') {
      record.transportDetails = {
        transportType,
        ...transportDetails
      };
    }

    if (selectedType === 'destination') {
      record.accommodationDetails = accommodationDetails;
    }

    onSave(record);

    // Reset form
    setTitle('');
    setDescription('');
    setLocation('');
    setTime('');
    setAmount('');
    setTransportDetails({});
    setAccommodationDetails({});
    setSelectedType('destination');
    onClose();
  };

  const updateTransportDetail = (key: keyof TransportDetails, value: string) => {
    setTransportDetails(prev => ({ ...prev, [key]: value }));
  };

  const updateAccommodationDetail = (key: keyof AccommodationDetails, value: string) => {
    setAccommodationDetails(prev => ({ ...prev, [key]: value }));
  };

  const renderTransportFields = () => {
    switch (transportType) {
      case 'airplane':
        return (
          <div className="space-y-4">
            <div>
              <Label htmlFor="airline">항공사</Label>
              <Input
                id="airline"
                value={transportDetails.airline || ''}
                onChange={(e) => updateTransportDetail('airline', e.target.value)}
                placeholder="예: 대한항공"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="flightNumber">항공편 명</Label>
              <Input
                id="flightNumber"
                value={transportDetails.flightNumber || ''}
                onChange={(e) => updateTransportDetail('flightNumber', e.target.value)}
                placeholder="예: KE123"
                className="mt-1"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="departureTime">출발 시간</Label>
                <Input
                  id="departureTime"
                  type="time"
                  value={transportDetails.departureTime || ''}
                  onChange={(e) => updateTransportDetail('departureTime', e.target.value)}
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="arrivalTime">도착 시간</Label>
                <Input
                  id="arrivalTime"
                  type="time"
                  value={transportDetails.arrivalTime || ''}
                  onChange={(e) => updateTransportDetail('arrivalTime', e.target.value)}
                  className="mt-1"
                />
              </div>
            </div>
            <div>
              <Label htmlFor="reservationNumber">예약 번호</Label>
              <Input
                id="reservationNumber"
                value={transportDetails.reservationNumber || ''}
                onChange={(e) => updateTransportDetail('reservationNumber', e.target.value)}
                placeholder="예: ABC123DEF"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="boardingPass">온라인 탑승권 파일 (선택사항)</Label>
              <Input
                id="boardingPass"
                type="file"
                onChange={(e) => updateTransportDetail('boardingPass', e.target.files?.[0]?.name || '')}
                className="mt-1"
                accept=".pdf,.jpg,.jpeg,.png"
              />
            </div>
          </div>
        );

      case 'rental':
        return (
          <div className="space-y-4">
            <div>
              <Label htmlFor="rentalCompany">렌트카 회사</Label>
              <Input
                id="rentalCompany"
                value={transportDetails.rentalCompany || ''}
                onChange={(e) => updateTransportDetail('rentalCompany', e.target.value)}
                placeholder="예: 허츠, 롯데렌터카"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="vehicle">차량</Label>
              <Input
                id="vehicle"
                value={transportDetails.vehicle || ''}
                onChange={(e) => updateTransportDetail('vehicle', e.target.value)}
                placeholder="예: 현대 아반떼"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="rentalPeriod">렌트 기간</Label>
              <Input
                id="rentalPeriod"
                value={transportDetails.rentalPeriod || ''}
                onChange={(e) => updateTransportDetail('rentalPeriod', e.target.value)}
                placeholder="예: 2025-01-19 ~ 2025-01-21"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="reservationNumber">예약 번호</Label>
              <Input
                id="reservationNumber"
                value={transportDetails.reservationNumber || ''}
                onChange={(e) => updateTransportDetail('reservationNumber', e.target.value)}
                placeholder="예: R123456789"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="voucher">바우처</Label>
              <Input
                id="voucher"
                value={transportDetails.voucher || ''}
                onChange={(e) => updateTransportDetail('voucher', e.target.value)}
                placeholder="바우처 정보"
                className="mt-1"
              />
            </div>
            <div>
              <Label htmlFor="rentalDetails">예약 내용</Label>
              <Textarea
                id="rentalDetails"
                value={transportDetails.rentalDetails || ''}
                onChange={(e) => updateTransportDetail('rentalDetails', e.target.value)}
                placeholder="추가 예약 정보를 입력하세요..."
                className="mt-1"
              />
            </div>
          </div>
        );

      case 'train':
      case 'bus':
        return (
          <div className="space-y-4">
            <div>
              <Label htmlFor="trainName">{transportType === 'train' ? '열차명' : '버스명'}</Label>
              <Input
                id="trainName"
                value={transportType === 'train' ? transportDetails.trainName || '' : transportDetails.busName || ''}
                onChange={(e) => updateTransportDetail(transportType === 'train' ? 'trainName' : 'busName', e.target.value)}
                placeholder={transportType === 'train' ? "예: KTX 123" : "예: 고속버스 123"}
                className="mt-1"
              />
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="departure">출발</Label>
                <Input
                  id="departure"
                  value={transportDetails.departure || ''}
                  onChange={(e) => updateTransportDetail('departure', e.target.value)}
                  placeholder="출발지"
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="arrival">도착</Label>
                <Input
                  id="arrival"
                  value={transportDetails.arrival || ''}
                  onChange={(e) => updateTransportDetail('arrival', e.target.value)}
                  placeholder="도착지"
                  className="mt-1"
                />
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <Label htmlFor="departureTime">출발 시간</Label>
                <Input
                  id="departureTime"
                  type="time"
                  value={transportDetails.departureTime || ''}
                  onChange={(e) => updateTransportDetail('departureTime', e.target.value)}
                  className="mt-1"
                />
              </div>
              <div>
                <Label htmlFor="arrivalTime">도착 시간</Label>
                <Input
                  id="arrivalTime"
                  type="time"
                  value={transportDetails.arrivalTime || ''}
                  onChange={(e) => updateTransportDetail('arrivalTime', e.target.value)}
                  className="mt-1"
                />
              </div>
            </div>
            <div>
              <Label htmlFor="seat">좌석</Label>
              <Input
                id="seat"
                value={transportDetails.seat || ''}
                onChange={(e) => updateTransportDetail('seat', e.target.value)}
                placeholder="예: 1A, 15B"
                className="mt-1"
              />
            </div>
          </div>
        );

      case 'other':
        return (
          <div>
            <Label htmlFor="otherDetails">교통수단 상세 정보</Label>
            <Textarea
              id="otherDetails"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="교통수단에 대한 상세 정보를 입력하세요..."
              className="mt-1"
            />
          </div>
        );

      default:
        return null;
    }
  };

  const renderAccommodationFields = () => {
    return (
      <div className="space-y-4">
        <div>
          <Label htmlFor="bookingSite">예약 사이트</Label>
          <Input
            id="bookingSite"
            value={accommodationDetails.bookingSite || ''}
            onChange={(e) => updateAccommodationDetail('bookingSite', e.target.value)}
            placeholder="예: 호텔스닷컴, 아고다"
            className="mt-1"
          />
        </div>
        <div>
          <Label htmlFor="bookingSiteLink">예약 사이트 링크 (선택사항)</Label>
          <Input
            id="bookingSiteLink"
            type="url"
            value={accommodationDetails.bookingSiteLink || ''}
            onChange={(e) => updateAccommodationDetail('bookingSiteLink', e.target.value)}
            placeholder="https://..."
            className="mt-1"
          />
        </div>
        <div>
          <Label htmlFor="address">주소</Label>
          <Input
            id="address"
            value={accommodationDetails.address || ''}
            onChange={(e) => updateAccommodationDetail('address', e.target.value)}
            placeholder="숙소 주소를 입력하세요"
            className="mt-1"
          />
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <Label htmlFor="checkIn">체크인</Label>
            <Input
              id="checkIn"
              type="date"
              value={accommodationDetails.checkIn || ''}
              onChange={(e) => updateAccommodationDetail('checkIn', e.target.value)}
              className="mt-1"
            />
          </div>
          <div>
            <Label htmlFor="checkOut">체크아웃</Label>
            <Input
              id="checkOut"
              type="date"
              value={accommodationDetails.checkOut || ''}
              onChange={(e) => updateAccommodationDetail('checkOut', e.target.value)}
              className="mt-1"
            />
          </div>
        </div>
      </div>
    );
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-lg max-h-[90vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle>새 기록 추가</DialogTitle>
        </DialogHeader>

        <div className="space-y-6">
          {/* Type Selection */}
          <div>
            <Label>기록 유형</Label>
            <div className="grid grid-cols-3 gap-2 mt-2">
              {recordTypes.map((type) => {
                const Icon = type.icon;
                return (
                  <Button
                    key={type.id}
                    variant={selectedType === type.id ? "default" : "outline"}
                    className="h-16 flex-col"
                    onClick={() => setSelectedType(type.id as any)}
                  >
                    <Icon className="h-4 w-4 mb-1" />
                    <span className="text-xs">{type.label}</span>
                  </Button>
                );
              })}
            </div>
          </div>

          {/* Transport Type Selection */}
          {selectedType === 'transport' && (
            <div>
              <Label>교통수단 유형</Label>
              <Select value={transportType} onValueChange={(value: any) => setTransportType(value)}>
                <SelectTrigger className="mt-2">
                  <SelectValue placeholder="교통수단을 선택하세요" />
                </SelectTrigger>
                <SelectContent>
                  {transportTypes.map((type) => {
                    const Icon = type.icon;
                    return (
                      <SelectItem key={type.id} value={type.id}>
                        <div className="flex items-center">
                          <Icon className="h-4 w-4 mr-2" />
                          {type.label}
                        </div>
                      </SelectItem>
                    );
                  })}
                </SelectContent>
              </Select>
            </div>
          )}

          {/* Title */}
          <div>
            <Label htmlFor="title">제목 *</Label>
            <Input
              id="title"
              value={title}
              onChange={(e) => setTitle(e.target.value)}
              placeholder="예: 경복궁 방문"
              className="mt-1"
            />
          </div>

          {/* Time */}
          <div>
            <Label htmlFor="time">시간 *</Label>
            <Input
              id="time"
              type="time"
              value={time}
              onChange={(e) => setTime(e.target.value)}
              className="mt-1"
            />
          </div>

          {/* Location */}
          <div>
            <Label htmlFor="location">위치</Label>
            <Input
              id="location"
              value={location}
              onChange={(e) => setLocation(e.target.value)}
              placeholder="예: 서울특별시 종로구"
              className="mt-1"
            />
          </div>

          {/* Amount */}
          <div>
            <Label htmlFor="amount">금액 (원)</Label>
            <Input
              id="amount"
              type="number"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              placeholder="예: 50000"
              className="mt-1"
            />
          </div>

          {/* Type-specific fields */}
          {selectedType === 'transport' && (
            <div>
              <Label className="text-base">교통수단 상세 정보</Label>
              <div className="mt-3 p-4 border rounded-lg">
                {renderTransportFields()}
              </div>
            </div>
          )}

          {selectedType === 'destination' && (
            <div>
              <Label className="text-base">숙소 상세 정보</Label>
              <div className="mt-3 p-4 border rounded-lg">
                {renderAccommodationFields()}
              </div>
            </div>
          )}

          {/* Description/Memo */}
          <div>
            <Label htmlFor="description">메모</Label>
            <Textarea
              id="description"
              value={description}
              onChange={(e) => setDescription(e.target.value)}
              placeholder="여행 기록에 대한 메모를 입력하세요..."
              className="mt-1 min-h-20"
            />
          </div>

          {/* Actions */}
          <div className="flex gap-2 pt-4">
            <Button variant="outline" className="flex-1" onClick={onClose}>
              취소
            </Button>
            <Button 
              className="flex-1" 
              onClick={handleSave}
              disabled={!title.trim() || !time}
            >
              저장
            </Button>
          </div>
        </div>
      </DialogContent>
    </Dialog>
  );
}