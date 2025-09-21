import { Plane, Facebook, Twitter, Instagram, Youtube } from "lucide-react";

export function Footer() {
  return (
    <footer className="bg-muted py-12 border-t border-border">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Company Info */}
          <div className="space-y-4">
            <div className="flex items-center space-x-2">
              <Plane className="h-6 w-6 text-primary" />
              <span className="text-lg">TravelPlan</span>
            </div>
            <p className="text-muted-foreground text-sm">
              전 세계 어디든 떠날 수 있도록 도와드리는 스마트한 여행 계획 플랫폼입니다.
            </p>
            <div className="flex space-x-4">
              <Facebook className="h-5 w-5 text-muted-foreground hover:text-primary cursor-pointer transition-colors" />
              <Twitter className="h-5 w-5 text-muted-foreground hover:text-primary cursor-pointer transition-colors" />
              <Instagram className="h-5 w-5 text-muted-foreground hover:text-primary cursor-pointer transition-colors" />
              <Youtube className="h-5 w-5 text-muted-foreground hover:text-primary cursor-pointer transition-colors" />
            </div>
          </div>

          {/* Company */}
          <div>
            <h4 className="mb-4">회사</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">회사 소개</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">채용 정보</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">뉴스룸</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">투자자 정보</a></li>
            </ul>
          </div>

          {/* Support */}
          <div>
            <h4 className="mb-4">고객 지원</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">도움말 센터</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">안전 정보</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">예약 취소</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">문의하기</a></li>
            </ul>
          </div>

          {/* Legal */}
          <div>
            <h4 className="mb-4">약관 및 정책</h4>
            <ul className="space-y-2 text-sm">
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">이용 약관</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">개인정보 처리방침</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">쿠키 정책</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-foreground transition-colors">여행 약관</a></li>
            </ul>
          </div>
        </div>

        <div className="border-t border-border mt-8 pt-8 text-center text-sm text-muted-foreground">
          <p>&copy; 2025 TravelPlan. All rights reserved.</p>
        </div>
      </div>
    </footer>
  );
}