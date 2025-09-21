import { Menu, Plane, User } from "lucide-react";
import { Button } from "./ui/button";

export function Header() {
  return (
    <header className="w-full bg-background border-b border-border">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex items-center justify-between h-16">
          {/* Logo */}
          <div className="flex items-center space-x-2">
            <Plane className="h-8 w-8 text-primary" />
            <span className="text-xl font-semibold text-foreground">TravelPlan</span>
          </div>

          {/* Navigation */}
          <nav className="hidden md:flex items-center space-x-8">
            <a href="#" className="text-muted-foreground hover:text-foreground transition-colors">
              여행지
            </a>
            <a href="#" className="text-muted-foreground hover:text-foreground transition-colors">
              숙박
            </a>
            <a href="#" className="text-muted-foreground hover:text-foreground transition-colors">
              액티비티
            </a>
            <a href="#" className="text-muted-foreground hover:text-foreground transition-colors">
              내 여행
            </a>
          </nav>

          {/* User Actions */}
          <div className="flex items-center space-x-4">
            <Button variant="ghost" size="sm" className="hidden md:flex">
              로그인
            </Button>
            <Button size="sm">
              회원가입
            </Button>
            <Button variant="ghost" size="icon" className="md:hidden">
              <Menu className="h-5 w-5" />
            </Button>
          </div>
        </div>
      </div>
    </header>
  );
}