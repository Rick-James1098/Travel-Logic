import { X, MapPin, Calendar } from "lucide-react";
import { Button } from "./ui/button";
import { Card, CardContent } from "./ui/card";
import { Badge } from "./ui/badge";

interface TravelListSidebarProps {
  isOpen: boolean;
  onClose: () => void;
}

// Mock travel data - 실제로는 props나 context에서 받아올 수 있습니다
const travels = [
  {
    id: '1',
    title: '서울 도심 여행',
    date: '2025-01-19',
    duration: '1일',
    recordCount: 4,
    locations: ['경복궁', '북촌 한옥마을', '인사동']
  },
  {
    id: '2',
    title: '부산 해안 여행',
    date: '2025-01-15 - 2025-01-17',
    duration: '3일',
    recordCount: 12,
    locations: ['해운대', '감천문화마을', '광안리']
  },
  {
    id: '3',
    title: '제주도 자연 여행',
    date: '2025-01-10 - 2025-01-14',
    duration: '5일',
    recordCount: 18,
    locations: ['성산일출봉', '한라산', '우도']
  }
];

export function TravelListSidebar({ isOpen, onClose }: TravelListSidebarProps) {
  if (!isOpen) return null;

  return (
    <>
      {/* Backdrop */}
      <div 
        className="fixed inset-0 bg-black/50 z-40" 
        onClick={onClose}
      />
      
      {/* Sidebar */}
      <div className={`fixed left-0 top-0 h-full w-80 bg-background z-50 transform transition-transform duration-300 ${
        isOpen ? 'translate-x-0' : '-translate-x-full'
      } border-r border-border`}>
        <div className="flex flex-col h-full">
          {/* Header */}
          <div className="flex items-center justify-between p-4 border-b border-border">
            <h2 className="text-lg">내 여행 목록</h2>
            <Button variant="ghost" size="sm" onClick={onClose}>
              <X className="h-4 w-4" />
            </Button>
          </div>

          {/* Travel List */}
          <div className="flex-1 overflow-y-auto p-4 space-y-4">
            {travels.map((travel) => (
              <Card key={travel.id} className="cursor-pointer hover:shadow-md transition-shadow">
                <CardContent className="p-4">
                  <div className="flex items-start justify-between mb-2">
                    <h3 className="flex-1">{travel.title}</h3>
                    <Badge variant="outline" className="text-xs">
                      {travel.duration}
                    </Badge>
                  </div>
                  
                  <div className="flex items-center text-sm text-muted-foreground mb-2">
                    <Calendar className="h-3 w-3 mr-1" />
                    {travel.date}
                  </div>
                  
                  <div className="flex items-center text-sm text-muted-foreground mb-3">
                    <MapPin className="h-3 w-3 mr-1" />
                    {travel.locations.join(', ')}
                  </div>
                  
                  <div className="text-xs text-muted-foreground">
                    총 {travel.recordCount}개 기록
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>

          {/* Footer */}
          <div className="p-4 border-t border-border">
            <Button className="w-full">
              새 여행 시작하기
            </Button>
          </div>
        </div>
      </div>
    </>
  );
}