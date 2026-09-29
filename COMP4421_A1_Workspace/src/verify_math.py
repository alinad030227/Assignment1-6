# ==============================================================================
# HKUST COMP4421 (Fall 2026) - Assignment 1 Cross-Verification Engine
# Mathematical Verification for Problems 1, 2, 3, 4, and 5
# ==============================================================================
from collections import deque

def verify_problem_1():
    print("=" * 75)
    print("  Problem 1: Image Arithmetic and Histograms Verification")
    print("=" * 75)
    M, N = 40, 50
    total_pixels = M * N
    A_val = 6
    hist_B = {0: 100, 2: 150, 5: 250, 10: 300, 15: 300, 20: 300, 25: 250, 27: 150, 29: 100, 31: 100}
    
    hist_C = {}
    for r_B, count in sorted(hist_B.items()):
        val_C = min(r_B + A_val, 31)
        hist_C[val_C] = hist_C.get(val_C, 0) + count
        
    print("[Part (a) Saturated Addition Non-Zero Histogram]")
    for val_C in sorted(hist_C.keys()):
        print(f"  Intensity {val_C:2d}: Count = {hist_C[val_C]:4d} (p = {hist_C[val_C]/total_pixels:.4f})")
    assert sum(hist_C.values()) == total_pixels, "Total count conservation failed!"

    diff_events = { -4: 90, 0: total_pixels - 240, 5: 150 }
    print("\n[Part (b) Signed Difference Histogram]")
    for d, cnt in sorted(diff_events.items()):
        state = "Brighter" if d > 0 else ("Darker" if d < 0 else "Unchanged")
        print(f"  Bin {d:+2d}: Count = {cnt:4d} ({state})")
    print("=" * 75 + "\n")


def verify_problem_2():
    print("=" * 75)
    print("  Problem 2: Pixel Adjacency, Digital Paths, and Distance Metrics")
    print("=" * 75)
    grid = [
        [1, 2, 0, 3, 2, 1],
        [0, 2, 3, 0, 1, 1],
        [1, 0, 2, 1, 2, 0],
        [2, 2, 3, 0, 1, 0],
        [3, 1, 2, 2, 2, 2],
        [1, 0, 1, 3, 2, 2]
    ]
    R, C = len(grid), len(grid[0])
    p_1b, q_1b = (3, 6), (6, 5)
    p = (p_1b[0] - 1, p_1b[1] - 1)
    q = (q_1b[0] - 1, q_1b[1] - 1)
    
    def bfs_path(adj_type, V):
        if grid[p[0]][p[1]] not in V or grid[q[0]][q[1]] not in V:
            return None
        queue = deque([[p]])
        visited = {p}
        while queue:
            path = queue.popleft()
            curr = path[-1]
            r, c = curr
            if curr == q:
                return path
            neighbors = []
            if adj_type == '4':
                candidates = [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]
                for nr, nc in candidates:
                    if 0 <= nr < R and 0 <= nc < C and grid[nr][nc] in V:
                        neighbors.append((nr, nc))
            elif adj_type == '8':
                for dr in [-1, 0, 1]:
                    for dc in [-1, 0, 1]:
                        if dr == 0 and dc == 0: continue
                        nr, nc = r + dr, c + dc
                        if 0 <= nr < R and 0 <= nc < C and grid[nr][nc] in V:
                            neighbors.append((nr, nc))
            elif adj_type == 'm':
                for nr, nc in [(r-1, c), (r+1, c), (r, c-1), (r, c+1)]:
                    if 0 <= nr < R and 0 <= nc < C and grid[nr][nc] in V:
                        neighbors.append((nr, nc))
                for dr, dc in [(-1, -1), (-1, 1), (1, -1), (1, 1)]:
                    nr, nc = r + dr, c + dc
                    if 0 <= nr < R and 0 <= nc < C and grid[nr][nc] in V:
                        p1_in_V = (0 <= r < R and 0 <= nc < C and grid[r][nc] in V)
                        p2_in_V = (0 <= nr < R and 0 <= c < C and grid[nr][c] in V)
                        if (not p1_in_V) and (not p2_in_V):
                            neighbors.append((nr, nc))
            for nxt in neighbors:
                if nxt not in visited:
                    visited.add(nxt)
                    queue.append(path + [nxt])
        return None

    V_a = {0, 1, 2}
    print("[Part (a) Shortest Paths for V = {0, 1, 2}]")
    print(f"  * 4-path length: {len(bfs_path('4', V_a)) - 1}")
    print(f"  * 8-path length: {len(bfs_path('8', V_a)) - 1}")
    print(f"  * m-path length: {len(bfs_path('m', V_a)) - 1}")

    r_pt, a_pt, b_pt = (1, 1), (1, 6), (4, 4)
    d4_ra = abs(r_pt[0] - a_pt[0]) + abs(r_pt[1] - a_pt[1])
    d8_ra = max(abs(r_pt[0] - a_pt[0]), abs(r_pt[1] - a_pt[1]))
    d4_rb = abs(r_pt[0] - b_pt[0]) + abs(r_pt[1] - b_pt[1])
    d8_rb = max(abs(r_pt[0] - b_pt[0]), abs(r_pt[1] - b_pt[1]))
    print(f"\n[Part (c) Distances] D4(r,a)={d4_ra}, D8(r,a)={d8_ra} | D4(r,b)={d4_rb}, D8(r,b)={d8_rb}")
    print("=" * 75 + "\n")


def verify_problem_3():
    print("=" * 75)
    print("  Problem 3: Spatial Filtering and Histogram Information Verification")
    print("=" * 75)
    M, N = 10, 10
    img_A = [[0 if c < 5 else 1 for c in range(N)] for r in range(M)]
    img_B = [[c % 2 for c in range(N)] for r in range(M)]
    
    H_out, W_out = M - 3 + 1, N - 3 + 1
    out_A = [[sum(img_A[r+dr][c+dc] for dr in range(3) for dc in range(3)) for c in range(W_out)] for r in range(H_out)]
    out_B = [[sum(img_B[r+dr][c+dc] for dr in range(3) for dc in range(3)) for c in range(W_out)] for r in range(H_out)]
    
    hist_A = {}
    hist_B = {}
    for r in range(8):
        for c in range(8):
            hist_A[out_A[r][c]] = hist_A.get(out_A[r][c], 0) + 1
            hist_B[out_B[r][c]] = hist_B.get(out_B[r][c], 0) + 1

    print("[Part (c) Filtered Image A Non-Zero Bins]")
    for k in sorted(hist_A.keys()):
        print(f"  Intensity {k}/9: Count = {hist_A[k]} ({hist_A[k]/64.0*100:.2f}%)")

    print("\n[Part (c) Filtered Image B Non-Zero Bins]")
    for k in sorted(hist_B.keys()):
        print(f"  Intensity {k}/9: Count = {hist_B[k]} ({hist_B[k]/64.0*100:.2f}%)")
    print("=" * 75 + "\n")


def verify_problem_4():
    print("=" * 75)
    print("  Problem 4: Recovering an Affine Transformation Verification")
    print("=" * 75)
    det_X = 1 * (1*1 - 1*3) - 1 * (3*1 - 1*1) + 1 * (3*3 - 1*1)
    print(f"Design Matrix X Determinant = {det_X} (Non-zero confirms non-collinearity -> [PASS])")
    assert det_X == 4, "Determinant mismatch!"

    a11 = (6 - 4) // (3 - 1)
    a12 = (6 - 4) // (3 - 1)
    a13 = 4 - a11 - a12

    a21 = (1 - 3) // (3 - 1)
    a22 = (5 - 3) // (3 - 1)
    a23 = 3 - a21 - a22

    print(f"Recovered Matrix Parameters: a11={a11}, a12={a12}, a13={a13}, a21={a21}, a22={a22}, a23={a23}")
    nx, ny = 2, 4
    trans_x = a11 * nx + a12 * ny + a13
    trans_y = a21 * nx + a22 * ny + a23
    print(f"Transformed Point (2, 4) -> ({trans_x}, {trans_y})")
    assert (trans_x, trans_y) == (8, 5), "Mapping mismatch!"
    print("=" * 75 + "\n")


def verify_problem_5():
    print("=" * 75)
    print("  Problem 5: Discrete Histogram Equalization Verification")
    print("=" * 75)
    M, N = 30, 20
    total_pixels = M * N # 600
    L = 8
    scale = L - 1 # 7
    
    input_counts = [30, 60, 90, 150, 120, 90, 40, 20]
    assert sum(input_counts) == total_pixels, "Input counts do not sum to 600!"
    
    cdf = 0.0
    mapping_pipeline = []
    equalized_hist = {s: 0 for s in range(L)}
    
    print("\n[Part (a) Histogram Equalization Pipeline Steps]")
    print(f"{'r_k':>4} | {'n_k':>5} | {'p_r(r_k)':>10} | {'CDF':>10} | {'CDF * 7':>10} | {'Round (s_k)':>12}")
    print("-" * 62)
    
    for r_k, n_k in enumerate(input_counts):
        p_r = n_k / total_pixels
        cdf += p_r
        scaled = cdf * scale
        s_k = round(scaled)
        mapping_pipeline.append((r_k, n_k, p_r, cdf, scaled, s_k))
        equalized_hist[s_k] += n_k
        print(f"{r_k:4d} | {n_k:5d} | {p_r:10.4f} | {cdf:10.4f} | {scaled:10.4f} | {s_k:12d}")
        
    print("\n[Part (b) Complete Equalized Histogram]")
    print(f"{'s_k':>4} | {'Count (n_s)':>12} | {'Probability p_s':>16} | {'Source Levels (r_k)':>22}")
    print("-" * 60)
    for s_k in range(L):
        cnt = equalized_hist[s_k]
        prob = cnt / total_pixels
        src_levels = [str(r) for r, _, _, _, _, s in mapping_pipeline if s == s_k]
        src_str = "{" + ", ".join(src_levels) + "}" if src_levels else "None (Empty)"
        print(f"{s_k:4d} | {cnt:12d} | {prob:16.4f} | {src_str:>22}")
        
    total_eq = sum(equalized_hist.values())
    print(f"\nMeasure Conservation Check: Sum(n_s) = {total_eq} (Target: {total_pixels}) -> [PASS]")
    assert total_eq == total_pixels, "Equalized histogram total count mismatch!"
    
    print("\n[Part (c) Non-Uniformity & Degeneracy Analysis]")
    print("  * Is resulting histogram perfectly uniform? -> NO")
    print("  * Co-mapped levels (Many-to-One): r_6 and r_7 both map to s = 7.")
    print("  * Empty intensity bins: s = 3 has 0 pixels.")
    print("=" * 75 + "\n")

if __name__ == "__main__":
    verify_problem_1()
    verify_problem_2()
    verify_problem_3()
    verify_problem_4()
    verify_problem_5()
