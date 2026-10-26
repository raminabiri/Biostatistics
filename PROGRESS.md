# PROGRESS

## Done
- 2026-10-21: Reviewed chatgpt.odt + gemini.odt. Decided: Persian, GitHub, RTL, Persian terms, step-by-step exercises + solutions.
- 2026-10-26: Architecture final: 13 phases (0–12), M01–M82 + P01–P05; 7 folders per module (lessons, data, spss, prism, r, python, excel). Course is GENERAL biostat/medical (not microbiology-only). See SYLLABUS.md.
- 2026-10-26: **Phase 0 (M01–M04) COMPLETE.** Writing rules in memory (course-writing-standards): no proofs, many graded exercises (levels 1–3) with hidden solutions, verified references incl. Persian/English videos.
  - Totals: 18 lessons, 60 worked examples, 207 lesson exercises, 33 review questions, 7 shared practice exercises per module in all 5 tracks (+ R/Python bonus in M03).
  - Each module: README, lessons/, data/ (+codebook), 5 track READMEs, R + Python scripts, SPSS .sps, Excel practice + solutions .xlsx, review.md, references.md.
  - M01: upgraded (graded exercises, refs, Excel). M02 math prerequisites. M03 sampling & study design (frame with ready random column `u` so all tools give identical answers). M04 cleaning (messy registry, protocol P1–P11, cleaning log, merge/append/aggregate).
  - Verification: all R and Python scripts run (R 4.6.1, pandas 2.3.3), answers identical across both. All Excel solution workbooks recalculated in LibreOffice headless and checked against expected values (0 mismatches). No broken internal links.
  - Glossary extended (M01–M04). Root README, tracks/*.md and SYLLABUS status updated. Prism coverage for M03 set to ◐.

## Next steps
- User: run SPSS .sps files (M01–M04) on real SPSS; check Prism 10/11 menu names; watch Persian Aparat videos before recommending (content not verifiable by me).
- Phase 1 (M05–M08: descriptive statistics & visualization) when the user asks. Keep: same module template, same 5 tracks, graded exercises, verified references, varied medical domains.
- Decide license (proposed CC BY-SA 4.0 content + MIT code).
- Optional: translate PROGRESS.md to Persian (offered, no answer yet).

## Bugs / issues / caveats
- SPSS syntax is UNTESTED (no SPSS/PSPP here; PSPP install needs sudo).
- Prism steps written from knowledge of Prism 9/10 and the Prism 11 online guide; not run in the app.
- Excel: use RANK (not RANK.EQ) and avoid newer functions without _xlfn prefix when generating xlsx with openpyxl (they show #NAME?).
- Excel COUNTIF/PivotTable are case-insensitive (M04 ع۱ shows 7 sex spellings in Excel vs 11 in R/Python/SPSS); documented in the Excel guide.
- pandas 3 is current (docs 3.1); scripts tested on 2.3 — only cosmetic difference noted (str vs object dtype).
- Build scripts for xlsx were in the session scratchpad (not in repo); to regenerate, rewrite from the solutions sheets.
