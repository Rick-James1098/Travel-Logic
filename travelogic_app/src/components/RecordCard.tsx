import { MapPin, Car, Camera, Clock } from "lucide-react";
import { Card, CardContent } from "./ui/card";
import { Badge } from "./ui/badge";

export interface TransportDetails {
  transportType: 'airplane' | 'rental' | 'train' | 'bus' | 'other';
  // 비행기
  airline?: string;
  flightNumber?: string;
  departureTime?: string;
  arrivalTime?: string;
  reservationNumber?: string;
  boardingPass?: string;
  // 렌트카
  rentalCompany?: string;
  vehicle?: string;
  rentalPeriod?: string;
  voucher?: string;
  rentalDetails?: string;
  // 기차/버스
  trainName?: string;
  busName?: string;
  departure?: string;
  arrival?: string;
  seat?: string;
}

export interface AccommodationDetails {
  bookingSite?: string;
  bookingSiteLink?: string;
  address?: string;
  checkIn?: string;
  checkOut?: string;
}

export interface TravelRecord {
  id: string;
  type: 'destination' | 'transport' | 'activity';
  title: string;
  description: string;
  location: string;
  time: string;
  date: string;
  amount: number;
  image?: string;
  transportDetails?: TransportDetails;
  accommodationDetails?: AccommodationDetails;
}

interface RecordCardProps {
  record: TravelRecord;
}

const typeConfig = {
  destination: {
    icon: MapPin,
    label: '여행지',
    color: 'bg-blue-500'
  },
  transport: {
    icon: Car,
    label: '교통수단',
    color: 'bg-green-500'
  },
  activity: {
    icon: Camera,
    label: '액티비티',
    color: 'bg-purple-500'
  }
};

export function RecordCard({ record }: RecordCardProps) {
  const config = typeConfig[record.type];
  const Icon = config.icon;

  return (
    <Card className="mb-4 overflow-hidden">
      <CardContent className="p-0">
        <div className="flex">
          {/* Timeline indicator */}
          <div className="flex flex-col items-center pt-4 px-3">
            <div className={`w-8 h-8 rounded-full ${config.color} flex items-center justify-center`}>
              <Icon className="h-4 w-4 text-white" />
            </div>
            <div className="w-0.5 bg-border flex-1 mt-2"></div>
          </div>
          
          {/* Content */}
          <div className="flex-1 p-4">
            <div className="flex items-center justify-between mb-2">
              <Badge variant="outline" className="text-xs">
                {config.label}
              </Badge>
              <div className="flex items-center text-xs text-muted-foreground">
                <Clock className="h-3 w-3 mr-1" />
                {record.time}
              </div>
            </div>
            
            <h3 className="mb-1">{record.title}</h3>
            
            {record.location && (
              <div className="flex items-center text-sm text-muted-foreground mb-2">
                <MapPin className="h-3 w-3 mr-1" />
                {record.location}
              </div>
            )}
            
            {record.description && (
              <p className="text-sm text-muted-foreground leading-relaxed mb-2">
                {record.description}
              </p>
            )}

            {/* Transport Details */}
            {record.type === 'transport' && record.transportDetails && (
              <div className="text-xs text-muted-foreground mb-2 space-y-1">
                {record.transportDetails.transportType === 'airplane' && (
                  <>
                    {record.transportDetails.airline && (
                      <div>항공사: {record.transportDetails.airline}</div>
                    )}
                    {record.transportDetails.flightNumber && (
                      <div>항공편: {record.transportDetails.flightNumber}</div>
                    )}
                    {(record.transportDetails.departureTime || record.transportDetails.arrivalTime) && (
                      <div>
                        {record.transportDetails.departureTime} → {record.transportDetails.arrivalTime}
                      </div>
                    )}
                  </>
                )}
                {record.transportDetails.transportType === 'rental' && (
                  <>
                    {record.transportDetails.rentalCompany && (
                      <div>렌트사: {record.transportDetails.rentalCompany}</div>
                    )}
                    {record.transportDetails.vehicle && (
                      <div>차량: {record.transportDetails.vehicle}</div>
                    )}
                  </>
                )}
                {(record.transportDetails.transportType === 'train' || record.transportDetails.transportType === 'bus') && (
                  <>
                    {(record.transportDetails.trainName || record.transportDetails.busName) && (
                      <div>{record.transportDetails.trainName || record.transportDetails.busName}</div>
                    )}
                    {(record.transportDetails.departure && record.transportDetails.arrival) && (
                      <div>{record.transportDetails.departure} → {record.transportDetails.arrival}</div>
                    )}
                    {record.transportDetails.seat && (
                      <div>좌석: {record.transportDetails.seat}</div>
                    )}
                  </>
                )}
              </div>
            )}

            {/* Accommodation Details */}
            {record.type === 'destination' && record.accommodationDetails && (
              <div className="text-xs text-muted-foreground mb-2 space-y-1">
                {record.accommodationDetails.bookingSite && (
                  <div>예약: {record.accommodationDetails.bookingSite}</div>
                )}
                {record.accommodationDetails.address && (
                  <div>주소: {record.accommodationDetails.address}</div>
                )}
                {(record.accommodationDetails.checkIn || record.accommodationDetails.checkOut) && (
                  <div>
                    {record.accommodationDetails.checkIn} ~ {record.accommodationDetails.checkOut}
                  </div>
                )}
              </div>
            )}
            
            {record.amount > 0 && (
              <div className="text-sm">
                <span className="text-primary">
                  {record.amount.toLocaleString('ko-KR')}원
                </span>
              </div>
            )}
          </div>
        </div>
      </CardContent>
    </Card>
  );
}