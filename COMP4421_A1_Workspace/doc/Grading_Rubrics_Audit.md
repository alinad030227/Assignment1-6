# HKUST COMP 4421 (Fall 2026) Assignment 1: Grading Rubrics Audit & Defense Report

- **Student Name:** Lin Anfan (Norman)
- **Student ID:** `<SID>`
- **Major:** BSc in Mathematics (Computer Science Track)
- **Target Grade:** 100 / 100 (Full Marks, A+ Standard)

---

## 1. 評分維度全景對照與防禦審查矩陣

| 題號與分值 | 官方核心考點與潛在扣分陷阱 | 項目實作防禦策略與學術證明落實機制 | 審查判定 |
| :--- | :--- | :--- | :---: |
| **Problem 1**<br>(10 pts) | 1. 飽和加法漏算截斷，將 $C \ge 32$ 誤保留。<br>2. 差分影像遺漏未改變像素統計 ($D=0$)。<br>3. 總像素測度不守恆。 | 1. 顯式定義截斷映射 $\mathcal{T}(r) = \min(r+6, 31)$，推導 $r \in \{25, 27, 29, 31\}$ 全部並入強度級 31，累積計數為 $250+150+100+100=600$。<br>2. 嚴格按符號空間劃分變亮 ($D=+5, n=150$)、變暗 ($D=-4, n=90$)、不變 ($D=0, n=1760$)。<br>3. 驗算總測度守恆式：$150 + 90 + 1760 = 2000 = 40 \times 50$。 | **10 / 10**<br>(PASS) |
| **Problem 2**<br>(15 pts) | 1. $m$-鄰接空集條件判定不嚴謹，誤選長度為 3 的路徑。<br>2. 針對 $V=\{2, 3\}$ 胡亂尋路或假定起點有路徑。<br>3. 距離測度僅給數值，缺乏幾何範數等距拓撲分析。 | 1. 展開候選對角躍遷 $(3, 6) \to (4, 5)$ 的公共 4-鄰域 $\{(3, 5), (4, 6)\}$，因其像素值均在 $V$ 中而證偽 $m$-鄰接，證明最短 $m$-路徑退化為長度 4 的 4-路徑。<br>2. 直接利用集合論公理：$\mathbf{M}(p)=0 \notin V=\{2, 3\}$，定理性斷言任何路徑均不存在 (Path does not exist)。<br>3. 從 $\ell_1$ 範數菱形等距線（累積軸向投影）與 $\ell_\infty$ 範數正方形等距線（對角代價等於軸向代價）深刻剖析逆轉機理。 | **15 / 15**<br>(PASS) |
| **Problem 3**<br>(25 pts) | 1. 誤認原圖直方圖相同則濾波後必相同。<br>2. 混淆有效濾波（Valid）尺寸與邊界保持尺寸。<br>3. 手算 $8 \times 8$ 直方圖時頻數遺漏或未展示局部求和。 | 1. 第一句給出定論「NO」，並指出直方圖是一階邊際統計量，完全丟失空間自相關資訊，而空間濾波是局部空間幾何算子。<br>2. 推導無填充有效維度 $(10-3+1) \times (10-3+1) = 8 \times 8$；維持尺寸需上下左右各補 1 列零填充。<br>3. 手算展示每行展開：A 輸出包含純 $0$ (24) 與純 $1$ (24) 及邊界過渡 $3/9$ (8), $6/9$ (8)；B 輸出僅有 $3/9$ (32) 與 $6/9$ (32)，兩者總數均為 64。 | **25 / 25**<br>(PASS) |
| **Problem 4**<br>(15 pts) | 1. 仿射變換方程未解耦，消元過程混亂。<br>2. 新點前向映射向量乘法計算失誤。<br>3. 共線退化僅口頭說明，缺乏線性代數嚴密證明。 | 1. 構造 $3 \times 3$ 設計矩陣 $\mathbf{X}$，計算行列式 $\det(\mathbf{X})=4 \neq 0$ 證明滿秩唯一性，高斯消元求得 $\mathbf{A} = \begin{bmatrix} 1 & 1 & 2 \\ -1 & 1 & 3 \\ 0 & 0 & 1 \end{bmatrix}$。<br>2. 齊次矩陣乘法嚴謹展開：$(2, 4) \to (8, 5)$。<br>3. 線性代數證明：三點共線等價於列向量線性相關 $\alpha \mathbf{c}_1 + \beta \mathbf{c}_2 + \gamma \mathbf{c}_3 = \mathbf{0}$，導致 $\det(\mathbf{X})=0$ 且 $\operatorname{rank}(\mathbf{X}) \le 2 < 3$，自由度退化出現無窮多解。 | **15 / 15**<br>(PASS) |
| **Problem 5**<br>(15 pts) | 1. 遺漏 $(L-1)\operatorname{CDF}$ 中間實數值直接寫整數。<br>2. 直方圖重分佈映射關係混亂，總數不守恆。<br>3. 均勻性分析流於表面，未指出離散階梯算子本質。 | 1. 嚴格列出 8 級全流程三線表，完整展示 $p_r(r_k)$、$\operatorname{CDF}(r_k)$、$7 \times \operatorname{CDF}(r_k)$ 實數值與 $\operatorname{round}(\cdot)$ 結果。<br>2. 標註空值強度級 $s=3$ ($n_s=0$) 與多對一合併級 $s=7$ ($n_s=40+20=60$)，總數守恆 $\sum n_s = 600$。<br>3. 明確裁定「Not perfectly uniform」，對比連續積分變換與離散整數環階梯非降函數之差異。 | **15 / 15**<br>(PASS) |
| **Problem 6**<br>(20 pts) | 1. 違規調用 `imfilter`、`conv2` 等內建濾波函數（直接 0 分）。<br>2. 修改了 `Coding zone` 以外的骨架代碼。<br>3. 書面解答中漏寫浮水印位平面編號。 | 1. 手寫零填充（$p=1$）與雙層嵌套循環 Frobenius 矩陣內積卷積，徹底杜絕任何內建濾波庫函數。<br>2. 嚴格在 `% your code here` 區域內填碼，其餘骨架原汁原味保持不變。<br>3. 匯出 3 張合規 PNG 圖像，並在 PDF 報告與代碼中以獨立加粗邊框明確宣告：「The hidden watermark is embedded in Bit Plane 1 (Least Significant Bit, LSB)」。 | **20 / 20**<br>(PASS) |
| **Documentation & Release**<br>(Quality) | 1. 格式凌亂、排版跨頁截斷。<br>2. Zip 內存在巢狀資料夾或包含 macOS/Windows 垃圾快取。<br>3. 未落實大綱要求的 AI 使用聲明。 | 1. IEEE/ACM 出版級單欄 LaTeX 排版，三線表無垂直線，圖文並茂。<br>2. 實施純淨性防禦協定，生成扁平化 Zip 封包，解壓後 5 個核心檔案平鋪於根目錄，無任何垃圾檔案。<br>3. 附錄 B 嚴格遵照 Syllabus 政策載入完整的《Generative AI Acknowledgment Statement》。 | **Full Marks**<br>(PASS) |

---

## 2. 交付資產清單校驗

- **`<SID>.zip` 壓縮檔案內部拓撲（Strict Flat Root）：**
  1. `Assignment1_<SID>.pdf`（書面推導與實驗報告完整解答）
  2. `problem6.m`（MATLAB 實現腳本）
  3. `sharpened_K4.png`（4-鄰域拉普拉斯銳化圖）
  4. `sharpened_K8.png`（8-鄰域拉普拉斯銳化圖）
  5. `hidden_watermark.png`（從 Bit Plane 1 抽取的二值浮水印圖）
