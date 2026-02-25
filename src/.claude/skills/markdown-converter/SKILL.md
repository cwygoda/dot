---
name: markdown-converter
description: Convert documents and files to Markdown using markitdown. Use when converting PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx, .xls), HTML, CSV, JSON, XML, images (with EXIF/OCR), audio (with transcription), ZIP archives, YouTube URLs, or EPubs to Markdown format for LLM processing or text analysis.
---

# Markdown Converter

Convert files to Markdown using `uvx markitdown` — no installation required.

**Important:** markitdown requires optional dependency groups per file type. Use `'markitdown[all]'` for full support, or pick a specific group to keep it lean.

## Dependency Groups

| File Type | Group |
| --------- | ----- |
| PDF | `pdf` |
| Word (.docx) | `docx` |
| PowerPoint (.pptx) | `pptx` |
| Excel (.xlsx) | `xlsx` |
| Excel (.xls) | `xls` |
| Outlook (.msg) | `outlook` |
| Audio transcription | `audio-transcription` |
| YouTube transcription | `youtube-transcription` |
| Azure Doc Intelligence | `az-doc-intel` |
| Everything | `all` |

## Basic Usage

```bash
# Convert to stdout (use the matching dependency group)
uvx 'markitdown[pdf]' input.pdf

# Save to file
uvx 'markitdown[pdf]' input.pdf -o output.md
uvx 'markitdown[docx]' input.docx > output.md

# All formats at once (heavier, but convenient)
uvx 'markitdown[all]' input.pdf -o output.md

# From stdin
cat input.pdf | uvx 'markitdown[pdf]'
```

## Supported Formats

- **Documents**: PDF, Word (.docx), PowerPoint (.pptx), Excel (.xlsx, .xls)
- **Web/Data**: HTML, CSV, JSON, XML
- **Media**: Images (EXIF + OCR), Audio (EXIF + transcription)
- **Other**: ZIP (iterates contents), YouTube URLs, EPub

## Options

```bash
-o OUTPUT      # Output file
-x EXTENSION   # Hint file extension (for stdin)
-m MIME_TYPE   # Hint MIME type
-c CHARSET     # Hint charset (e.g., UTF-8)
-d             # Use Azure Document Intelligence
-e ENDPOINT    # Document Intelligence endpoint
--use-plugins  # Enable 3rd-party plugins
--list-plugins # Show installed plugins
```

## Examples

```bash
# Convert Word document
uvx 'markitdown[docx]' report.docx -o report.md

# Convert Excel spreadsheet
uvx 'markitdown[xlsx]' data.xlsx > data.md

# Convert PowerPoint presentation
uvx 'markitdown[pptx]' slides.pptx -o slides.md

# Convert with file type hint (for stdin)
cat document | uvx 'markitdown[pdf]' -x .pdf > output.md

# Use Azure Document Intelligence for better PDF extraction
uvx 'markitdown[az-doc-intel]' scan.pdf -d -e "https://your-resource.cognitiveservices.azure.com/"
```

## Notes

- Output preserves document structure: headings, tables, lists, links
- First run caches dependencies per group; subsequent runs are faster
- For complex PDFs with poor extraction, use `-d` with Azure Document Intelligence
- HTML, CSV, JSON, XML work with the base package (no extra group needed)
