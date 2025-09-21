import { useState } from "react";
import { MapPin, Car, Camera, X } from "lucide-react";
import { Dialog, DialogContent, DialogHeader, DialogTitle } from "./ui/dialog";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Textarea } from "./ui/textarea";
import { Label } from "./ui/label";
import { TravelRecord } from "./RecordCard";

interface AddRecordModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (record: Omit<TravelRecord, 'id'>) => void;
}

const recordTypes = [
  { id: 'destination', label: '여행지', icon: MapPin, color: 'bg-blue-500' },
  { id: 'transport', label: '교통수단', icon: Car, color: 'bg-green-500' },
  { id: 'activity', label: '액티비티', icon: Camera, color: 'bg-purple-500' }
];

export function AddRecordModal({ isOpen, onClose, onSave }: AddRecordModalProps) {
  const [selectedType, setSelectedType] = useState<'destination' | 'transport' | 'activity'>('destination');
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [location, setLocation] = useState('');
  const [time, setTime] = useState('');
  const [amount, setAmount] = useState('');

  const handleSave = () => {
    if (!title.trim() || !time) return;

    const currentDate = new Date().toISOString().split('T')[0];
    
    onSave({
      type: selectedType,
      title: title.trim(),
      description: description.trim(),
      location: location.trim(),
      time,
      date: currentDate,
      amount: amount ? parseInt(amount) : 0
    });

    // Reset form
    setTitle('');
    setDescription('');
    setLocation('');
    setTime('');
    setAmount('');
    setSelectedType('destination');
    onClose();
  };

  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <DialogContent className="max-w-sm mx-auto">
        <DialogHeader>
          <DialogTitle>새 기록 추가</DialogTitle>
        </DialogHeader>

        <div className="space-y-4">
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

          {/* Description */}
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