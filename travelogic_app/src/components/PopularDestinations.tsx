import { Card, CardContent } from "./ui/card";
import { Badge } from "./ui/badge";
import { ImageWithFallback } from "./figma/ImageWithFallback";

const destinations = [
  {
    id: 1,
    name: "발리, 인도네시아",
    image: "https://images.unsplash.com/photo-1632752369128-c763fffbc924?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHx0cmF2ZWwlMjBkZXN0aW5hdGlvbiUyMGJlYWNofGVufDF8fHx8MTc1ODIxNTM2OHww&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    price: "₩899,000",
    duration: "5박 6일",
    tags: ["해변", "휴양", "문화"]
  },
  {
    id: 2,
    name: "스위스 알프스",
    image: "https://images.unsplash.com/photo-1647291718042-676c0428fc25?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxtb3VudGFpbiUyMGxhbmRzY2FwZSUyMHRyYXZlbHxlbnwxfHx8fDE3NTgyNzA3OTJ8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    price: "₩1,599,000",
    duration: "7박 8일",
    tags: ["산", "자연", "액티비티"]
  },
  {
    id: 3,
    name: "도쿄, 일본",
    image: "https://images.unsplash.com/photo-1742516014153-6cae2ae4a6a2?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxjaXR5JTIwc2t5bGluZSUyMHRyYXZlbHxlbnwxfHx8fDE3NTgyMjcwMDB8MA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    price: "₩699,000",
    duration: "4박 5일",
    tags: ["도시", "문화", "음식"]
  },
  {
    id: 4,
    name: "캐나다 로키산맥",
    image: "https://images.unsplash.com/photo-1739647136850-0fac0a9b571d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxmb3Jlc3QlMjBuYXR1cmUlMjB0cmF2ZWx8ZW58MXx8fHwxNzU4MjA3MDQ0fDA&ixlib=rb-4.1.0&q=80&w=1080&utm_source=figma&utm_medium=referral",
    price: "₩1,299,000",
    duration: "6박 7일",
    tags: ["자연", "트레킹", "캠핑"]
  }
];

export function PopularDestinations() {
  return (
    <section className="py-16 bg-muted/30">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center mb-12">
          <h2 className="text-3xl md:text-4xl mb-4">인기 여행지</h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            전 세계 여행자들이 사랑하는 인기 있는 여행지를 확인해보세요
          </p>
        </div>

        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
          {destinations.map((destination) => (
            <Card key={destination.id} className="group overflow-hidden hover:shadow-lg transition-shadow duration-300 cursor-pointer">
              <div className="relative aspect-[4/3] overflow-hidden">
                <ImageWithFallback
                  src={destination.image}
                  alt={destination.name}
                  className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
                />
                <div className="absolute top-4 right-4">
                  <Badge variant="secondary" className="bg-white/90 text-foreground">
                    {destination.duration}
                  </Badge>
                </div>
              </div>
              
              <CardContent className="p-6">
                <h3 className="mb-2">{destination.name}</h3>
                <div className="flex flex-wrap gap-1 mb-3">
                  {destination.tags.map((tag) => (
                    <Badge key={tag} variant="outline" className="text-xs">
                      {tag}
                    </Badge>
                  ))}
                </div>
                <div className="flex items-center justify-between">
                  <span className="text-primary">부터 {destination.price}</span>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </div>
    </section>
  );
}