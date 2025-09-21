import { RecordCard, TravelRecord } from "./RecordCard";

interface TimelineProps {
  records: TravelRecord[];
}

export function Timeline({ records }: TimelineProps) {
  // Sort records by date and time
  const sortedRecords = [...records].sort((a, b) => {
    const dateA = new Date(`${a.date}T${a.time}`);
    const dateB = new Date(`${b.date}T${b.time}`);
    return dateB.getTime() - dateA.getTime(); // Most recent first
  });

  if (sortedRecords.length === 0) {
    return (
      <div className="flex-1 flex items-center justify-center p-8">
        <div className="text-center">
          <div className="w-16 h-16 bg-muted rounded-full flex items-center justify-center mx-auto mb-4">
            <svg className="w-8 h-8 text-muted-foreground" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M12 4v16m8-8H4" />
            </svg>
          </div>
          <h3 className="mb-2">아직 기록이 없습니다</h3>
          <p className="text-sm text-muted-foreground mb-4">
            + 버튼을 눌러 첫 번째 여행 기록을 추가해보세요
          </p>
        </div>
      </div>
    );
  }

  // Group records by date
  const groupedRecords = sortedRecords.reduce((groups, record) => {
    const date = record.date;
    if (!groups[date]) {
      groups[date] = [];
    }
    groups[date].push(record);
    return groups;
  }, {} as Record<string, TravelRecord[]>);

  return (
    <div className="flex-1 overflow-y-auto">
      <div className="p-4 space-y-6">
        {Object.entries(groupedRecords).map(([date, dayRecords]) => (
          <div key={date}>
            {/* Date Header */}
            <div className="sticky top-0 bg-background/95 backdrop-blur py-2 mb-4">
              <h2 className="text-sm text-muted-foreground">
                {new Date(date).toLocaleDateString('ko-KR', {
                  month: 'long',
                  day: 'numeric',
                  weekday: 'short'
                })}
              </h2>
            </div>
            
            {/* Records for this date */}
            <div className="space-y-0">
              {dayRecords.map((record, index) => (
                <div key={record.id} className="relative">
                  <RecordCard record={record} />
                  {/* Remove the last timeline connector */}
                  {index === dayRecords.length - 1 && (
                    <div className="absolute left-6 -bottom-2 w-0.5 h-2 bg-background"></div>
                  )}
                </div>
              ))}
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}