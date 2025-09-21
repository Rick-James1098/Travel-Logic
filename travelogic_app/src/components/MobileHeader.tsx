import { Menu, Settings } from "lucide-react";
import { Button } from "./ui/button";

interface MobileHeaderProps {
  onMenuClick: () => void;
  onSettingsClick: () => void;
}

export function MobileHeader({ onMenuClick, onSettingsClick }: MobileHeaderProps) {
  const today = new Date().toLocaleDateString('ko-KR', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });

  return (
    <header className="sticky top-0 z-50 w-full bg-background/95 backdrop-blur supports-backdrop-blur:bg-background/60 border-b border-border">
      <div className="px-4 h-14 flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <Button variant="ghost" size="sm" onClick={onMenuClick}>
            <Menu className="h-4 w-4" />
          </Button>
          <div>
            <h1 className="text-lg">여행 기록</h1>
            <p className="text-xs text-muted-foreground">{today}</p>
          </div>
        </div>
        
        <Button variant="ghost" size="sm" onClick={onSettingsClick}>
          <Settings className="h-4 w-4" />
        </Button>
      </div>
    </header>
  );
}