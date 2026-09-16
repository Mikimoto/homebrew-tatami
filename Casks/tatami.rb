cask "tatami" do
  # 兩段式 version：產出檔名是 tatami-<版本>-<短sha>.dmg，光靠版本號組不出下載
  # 連結。version.csv.first/second 就是 Homebrew 給這種檔名的機制。兩個值都由
  # 上游的 Scripts/release.sh 跑完之後直接印在螢幕上。
  version "0.1.0,39a5088"
  sha256 "b50901ab0b318c77d9136f1f5e090469d7742a3659eb6eecf5cc5533eb2798c2"

  url "https://github.com/Mikimoto/tatami/releases/download/v#{version.csv.first}/tatami-#{version.csv.first}-#{version.csv.second}.dmg"
  name "tatami"
  desc "Window manager with a layout per space, a grid panel, and drag snapping"
  homepage "https://github.com/Mikimoto/tatami"

  # 刻意沒有 `livecheck do`。**這不等於沒有 livecheck**——Homebrew 會從上面那個
  # GitHub release url 推一個預設策略，而它只吐得出 `0.1.0`、認不得兩段式
  # version。後果是 `brew audit --online` 必定報一筆
  # 「Version '0.1.0,39a5088' differs from '0.1.0' retrieved by livecheck」，
  # 對的版本也一樣報。那是已知的假陽性，不是待修：要它閉嘴就得寫一個把短 sha
  # 也組進去的自訂 strategy，而那正是「多一個會壞掉的活動零件」——維護者就是
  # 上游本人，release.sh 跑完直接把該換的兩個值印在螢幕上。
  # 所以驗這個 cask 用 `brew audit --cask mikimoto/tatami/tatami`（不帶 --online）。
  # 要先 tap 起來——Homebrew 7 起 `brew audit <路徑>` 已停用，只吃名字。
  depends_on macos: :sonoma

  app "Tatami.app"
  # CLI 與 .app 是**同一個執行檔**，所以 binary 指進 bundle：一個產物、一個版本、
  # 永遠同步。裸打 `tatami` 印用法字串而不是開第二個選單列圖示——那件事由
  # LaunchContext 判斷（看 __CFBundleIdentifier 等不等於自己的 bundle id）。
  binary "#{appdir}/Tatami.app/Contents/MacOS/Tatami", target: "tatami"

  zap trash: "~/.config/tatami"

  caveats do
    <<~EOS
      tatami 需要「輔助使用」權限才能移動視窗：

        系統設定 → 隱私權與安全性 → 輔助使用 → 打開 Tatami

      撥開之後要重開一次 app——TCC 不會套用到已經在跑的行程。

      設定住在 ~/.config/tatami/。範本在
      https://github.com/Mikimoto/tatami/blob/dev/examples/layout.json
    EOS
  end
end
