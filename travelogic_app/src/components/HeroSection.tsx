import { Search, MapPin, Calendar, Users } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Card } from "./ui/card";

export function HeroSection() {
  return (
    <section 
      className="relative h-[600px] flex items-center justify-center bg-cover bg-center bg-no-repeat"
      style={{
        backgroundImage: `linear-gradient(rgba(0, 0, 0, 0.4), rgba(0, 0, 0, 0.4)), url('https://images.unsplash.com/photo-1650869187977-fb5410fe454e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBoZXJvJTIwYmFja2dyb3VuZHxlbnwxfHx8fDE3NTgyOTg4NDB8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral')`
      }}
    >
      <div className="text-center text-white max-w-4xl px-4">
        <h1 className="text-4xl md:text-6xl mb-4">
          완벽한 여행을 계획하세요
        </h1>
        <p className="text-lg md:text-xl mb-8 opacity-90">
          전 세계 어디든 떠날 준비가 되셨나요? 꿈꾸던 여행을 현실로 만들어보세요.
        </p>

        {/* Search Card */}
        <Card className="bg-white/95 backdrop-blur-sm p-6 max-w-4xl mx-auto">
          <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
            {/* Destination */}
            <div className="space-y-2">
              <label className="text-sm text-muted-foreground flex items-center gap-2">
                <MapPin className="h-4 w-4" />
                여행지
              </label>
              <Input placeholder="어디로 떠나시나요?" className="bg-input-background" />
            </div>

            {/* Check-in */}
            <div className="space-y-2">
              <label className="text-sm text-muted-foreground flex items-center gap-2">
                <Calendar className="h-4 w-4" />
                출발일
              </label>
              <Input type="date" className="bg-input-background" />
            </div>

            {/* Check-out */}
            <div className="space-y-2">
              <label className="text-sm text-muted-foreground flex items-center gap-2">
                <Calendar className="h-4 w-4" />
                도착일
              </label>
              <Input type="date" className="bg-input-background" />
            </div>

            {/* Guests */}
            <div className="space-y-2">
              <label className="text-sm text-muted-foreground flex items-center gap-2">
                <Users className="h-4 w-4" />
                인원
              </label>
              <Input placeholder="2명" className="bg-input-background" />
            </div>
          </div>

          <Button className="w-full mt-6" size="lg">
            <Search className="h-4 w-4 mr-2" />
            여행 검색하기
          </Button>
        </Card>
      </div>
    </section>
  );
}