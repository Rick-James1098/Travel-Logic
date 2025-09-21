import { useState } from "react";
import { MobileHeader } from "./components/MobileHeader";
import { FilteredTimeline } from "./components/FilteredTimeline";
import { BottomNavigation } from "./components/BottomNavigation";
import { FloatingActionButton } from "./components/FloatingActionButton";
import { DetailedAddRecordModal } from "./components/DetailedAddRecordModal";
import { TravelListSidebar } from "./components/TravelListSidebar";
import { TravelRecord } from "./components/RecordCard";

export default function App() {
  const [activeTab, setActiveTab] = useState<
    "all" | "destination" | "transport" | "activity"
  >("all");
  const [isAddModalOpen, setIsAddModalOpen] = useState(false);
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [records, setRecords] = useState<TravelRecord[]>([
    {
      id: "1",
      type: "destination",
      title: "경복궁 방문",
      description:
        "조선 왕조의 정궁인 경복궁을 둘러보며 한국의 전통 문화를 체험했습니다. 근정전과 경회루가 특히 인상적이었어요.",
      location: "서울특별시 종로구",
      time: "09:30",
      date: "2025-01-19",
      amount: 3000,
    },
    {
      id: "2",
      type: "transport",
      title: "지하철 3호선",
      description:
        "경복궁역에서 안국역까지 지하철을 이용했습니다.",
      location: "경복궁역 → 안국역",
      time: "11:00",
      date: "2025-01-19",
      amount: 1600,
    },
    {
      id: "3",
      type: "activity",
      title: "북촌 한옥마을 탐방",
      description:
        "전통 한옥들이 잘 보존된 북촌 한옥마을을 걸으며 사진을 찍었습니다. 좁은 골목길 사이로 보이는 한옥들이 아름다웠어요.",
      location: "서울특별시 종로구 북촌로",
      time: "11:30",
      date: "2025-01-19",
      amount: 0,
    },
    {
      id: "4",
      type: "destination",
      title: "인사동 쇼핑",
      description:
        "전통 공예품과 차를 파는 상점들을 둘러보며 기념품을 구입했습니다.",
      location: "서울특별시 종로구 인사동",
      time: "14:00",
      date: "2025-01-19",
      amount: 25000,
    },
  ]);

  const handleAddRecord = (
    newRecord: Omit<TravelRecord, "id">,
  ) => {
    const record: TravelRecord = {
      ...newRecord,
      id: Date.now().toString(),
    };
    setRecords((prev) => [...prev, record]);
  };

  const renderTabContent = () => {
    const filterType =
      activeTab === "all" ? undefined : activeTab;
    return (
      <FilteredTimeline
        records={records}
        filterType={filterType}
      />
    );
  };

  const handleSettingsClick = () => {
    setIsSettingsOpen(true);
    // 설정 모달이나 페이지를 여는 로직을 추가할 수 있습니다
  };

  return (
    <div className="h-screen flex flex-col bg-background max-w-md mx-auto relative">
      <MobileHeader
        onMenuClick={() => setIsSidebarOpen(true)}
        onSettingsClick={handleSettingsClick}
      />

      <main className="flex-1 overflow-hidden">
        {renderTabContent()}
      </main>

      <FloatingActionButton
        onClick={() => setIsAddModalOpen(true)}
      />

      <BottomNavigation
        activeTab={activeTab}
        onTabChange={setActiveTab}
      />

      <TravelListSidebar
        isOpen={isSidebarOpen}
        onClose={() => setIsSidebarOpen(false)}
      />

      <DetailedAddRecordModal
        isOpen={isAddModalOpen}
        onClose={() => setIsAddModalOpen(false)}
        onSave={handleAddRecord}
      />

      {/* Settings Modal Placeholder */}
      {isSettingsOpen && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
          <div className="bg-background rounded-lg p-6 max-w-sm mx-4">
            <h3 className="mb-4 text-center">설정</h3>
            <p className="text-sm text-muted-foreground mb-6 text-center">
              설정 기능은 곧 업데이트될 예정입니다.
            </p>
            <div className="flex justify-center">
              <button
                onClick={() => setIsSettingsOpen(false)}
                className="bg-primary text-primary-foreground rounded-md py-2 px-6"
              >
                닫기
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}