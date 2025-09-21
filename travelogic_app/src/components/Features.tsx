import { MapPin, Calendar, Compass, Shield } from "lucide-react";
import { Card, CardContent } from "./ui/card";

const features = [
  {
    icon: MapPin,
    title: "맞춤형 여행 계획",
    description: "AI가 당신의 취향과 예산에 맞는 완벽한 여행 일정을 추천해드립니다."
  },
  {
    icon: Calendar,
    title: "일정 관리",
    description: "간편한 드래그 앤 드롭으로 여행 일정을 자유롭게 편집하고 관리하세요."
  },
  {
    icon: Compass,
    title: "현지 가이드",
    description: "숨겨진 명소부터 현지인만 아는 맛집까지, 특별한 경험을 제공합니다."
  },
  {
    icon: Shield,
    title: "안전한 예약",
    description: "신뢰할 수 있는 파트너들과 함께 안전하고 간편한 예약 서비스를 제공합니다."
  }
];

export function Features() {
  return (
    <section className="py-16">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl mb-4">왜 TravelPlan인가요?</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            더 스마트하고 편리한 여행 계획으로 완벽한 여행을 만들어보세요
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {features.map((feature, index) => (
            <Card key={index} className="text-center hover:shadow-md transition-shadow duration-300">
              <CardContent className="p-6">
                <div className="w-12 h-12 bg-primary/10 rounded-lg flex items-center justify-center mx-auto mb-4">
                  <feature.icon className="h-6 w-6 text-primary" />
                </div>
                <h3 className="mb-2">{feature.title}</h3>
                <p className="text-muted-foreground text-sm leading-relaxed">
                  {feature.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}