import { Plus } from "lucide-react";
import { Button } from "./ui/button";

interface FloatingActionButtonProps {
  onClick: () => void;
}

export function FloatingActionButton({ onClick }: FloatingActionButtonProps) {
  return (
    <Button
      onClick={onClick}
      size="lg"
      className="fixed bottom-20 right-4 w-14 h-14 rounded-full shadow-lg z-40"
    >
      <Plus className="h-6 w-6" />
    </Button>
  );
}