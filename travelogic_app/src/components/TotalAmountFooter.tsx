import { TravelRecord } from "./RecordCard";

interface TotalAmountFooterProps {
  records: TravelRecord[];
  filterType?: 'destination' | 'transport' | 'activity';
}

const getFilterLabel = (filterType?: 'destination' | 'transport' | 'activity') => {
  switch (filterType) {
    case 'destination':
      return '숙소';
    case 'transport':
      return '교통수단';
    case 'activity':
      return '액티비티';
    default:
      return '전체';
  }
};

export function TotalAmountFooter({ records, filterType }: TotalAmountFooterProps) {
  // Filter records by type if filterType is provided
  const filteredRecords = filterType 
    ? records.filter(record => record.type === filterType)
    : records;

  // Calculate total amount
  const totalAmount = filteredRecords.reduce((sum, record) => sum + record.amount, 0);

  if (totalAmount === 0) {
    return null;
  }

  return (
    <div className="sticky bottom-0 bg-background/95 backdrop-blur border-t border-border p-4">
      <div className="flex items-center justify-between">
        <span className="text-sm text-muted-foreground">
          {getFilterLabel(filterType)} 총 지출
        </span>
        <span className="text-lg text-primary">
          {totalAmount.toLocaleString('ko-KR')}원
        </span>
      </div>
    </div>
  );
}