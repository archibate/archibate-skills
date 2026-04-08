---
name: jina-ai
description: Web reading, search, academic research, NLP, screenshots, and PDF extraction via Jina AI mcporter calls. TRIGGER when need to read a URL, search the web, find academic papers (arXiv/SSRN), classify text, rerank documents, deduplicate content, capture screenshots, or extract PDF figures.
---

# Jina AI

Call Jina MCP tools via `mcporter` (Bash) for web content extraction, search, academic research, embeddings-based NLP, and visual capture.

**MCP Server URL**: `https://mcp.jina.ai/v1`

## Setup

Register jina in mcporter config (one-time, uses `$JINA_API_KEY` from env):

```bash
npx -y mcporter config add jina --url https://mcp.jina.ai/v1 \
  --header "Authorization=Bearer $JINA_API_KEY" --scope home
```

## Web Reading

### read_url
Extract web page content as clean markdown. Supports single URL or array of URLs.
- `url` (required): URL string or array of URLs
- `withAllLinks`: extract all hyperlinks as structured data
- `withAllImages`: extract all images as structured data

```bash
npx -y mcporter call jina.read_url url:"https://example.com"
npx -y mcporter call jina.read_url url:"https://example.com" withAllLinks:true
```

### parallel_read_url
Read up to 5 URLs in parallel for batch extraction.
- `urls` (required): array of `{url, withAllLinks?, withAllImages?}` objects
- `timeout`: milliseconds (default 30000)

```bash
npx -y mcporter call jina.parallel_read_url --args '{"urls": [{"url": "https://a.com"}, {"url": "https://b.com"}]}'
```

## Web Search

### search_web
Search the web for current information. Supports single query or array of queries for parallel search.
- `query` (required): search terms (string or array)
- `num`: max results 1-100 (default 30)
- `tbs`: time filter — `qdr:h` (hour), `qdr:d` (day), `qdr:w` (week), `qdr:m` (month), `qdr:y` (year)
- `gl`: country code (e.g. `cn`)
- `hl`: language code (e.g. `zh-cn`)
- `location`: location string (e.g. `Shanghai`)

```bash
npx -y mcporter call jina.search_web query:"search terms" num:10
npx -y mcporter call jina.search_web query:"A股量化" gl:cn hl:zh-cn
npx -y mcporter call jina.search_web query:"recent news" tbs:qdr:w
```

### parallel_search_web
Run up to 5 web searches in parallel for broader coverage.
- `searches` (required): array of `{query, num?, tbs?, gl?, hl?, location?}`
- `timeout`: milliseconds (default 30000)

```bash
npx -y mcporter call jina.parallel_search_web --args '{"searches": [{"query": "topic A"}, {"query": "topic B", "num": 5}]}'
```

### search_images
Search for images across the web (like Google Images). Returns base64 JPEG by default.
- `query` (required): image search terms
- `return_url`: set `true` to get URLs instead of base64
- `tbs`, `gl`, `hl`, `location`: same as `search_web`

```bash
npx -y mcporter call jina.search_images query:"neural network diagram"
npx -y mcporter call jina.search_images query:"logo" return_url:true
```

## Academic Research

### search_arxiv
Search arXiv for academic papers in STEM fields.
- `query` (required): search terms, author names, or topics (string or array)
- `num`: max results 1-100 (default 30)
- `tbs`: time filter

```bash
npx -y mcporter call jina.search_arxiv query:"transformer attention" num:10
npx -y mcporter call jina.search_arxiv query:"reinforcement learning" tbs:qdr:m
```

### parallel_search_arxiv
Run up to 5 arXiv searches in parallel for comprehensive coverage.
- `searches` (required): array of `{query, num?, tbs?}`
- `timeout`: milliseconds (default 30000)

```bash
npx -y mcporter call jina.parallel_search_arxiv --args '{"searches": [{"query": "topic A"}, {"query": "topic B"}]}'
```

### search_ssrn
Search SSRN for social science, economics, law, finance papers.
- `query` (required): search terms (string or array)
- `num`: max results 1-100 (default 30)
- `tbs`: time filter

```bash
npx -y mcporter call jina.search_ssrn query:"market microstructure" num:10
```

### parallel_search_ssrn
Run up to 5 SSRN searches in parallel.
- `searches` (required): array of `{query, num?, tbs?}`
- `timeout`: milliseconds (default 30000)

```bash
npx -y mcporter call jina.parallel_search_ssrn --args '{"searches": [{"query": "topic A"}, {"query": "topic B"}]}'
```

### search_bibtex
Search DBLP + Semantic Scholar, return BibTeX citations.
- `query` (required): paper title, topic, or keywords
- `author`: filter by author name
- `year`: minimum publication year
- `num`: max results 1-50 (default 10)

```bash
npx -y mcporter call jina.search_bibtex query:"attention is all you need"
npx -y mcporter call jina.search_bibtex query:"deep learning" author:Hinton year:2020 num:5
```

## PDF & Screenshots

### extract_pdf
Extract figures, tables, and equations from PDFs using layout detection.
- `id`: arXiv paper ID (e.g. `2301.12345`)
- `url`: direct PDF URL
- `type`: filter by `figure`, `table`, `equation` (comma-separated)
- `max_edge`: max image edge size in px (default 1024)

```bash
npx -y mcporter call jina.extract_pdf id:2301.12345
npx -y mcporter call jina.extract_pdf url:"https://example.com/paper.pdf" type:figure
```

### capture_screenshot_url
Capture web page screenshots as base64 JPEG.
- `url` (required): page URL
- `firstScreenOnly`: `true` for viewport only (faster), `false` for full page
- `return_url`: `true` to get URL instead of base64

```bash
npx -y mcporter call jina.capture_screenshot_url url:"https://example.com"
npx -y mcporter call jina.capture_screenshot_url url:"https://example.com" firstScreenOnly:true
```

## NLP & Embeddings

### classify_text
Classify texts into user-defined labels using Jina embeddings.
- `texts` (required): array of strings to classify
- `labels` (required): array of label strings
- `model`: embedding model (default `jina-embeddings-v5-text-small`)

```bash
npx -y mcporter call jina.classify_text --args '{"texts": ["great product", "terrible"], "labels": ["positive", "negative", "neutral"]}'
```

### sort_by_relevance
Rerank documents by relevance to a query using Jina Reranker.
- `query` (required): the query to rank against
- `documents` (required): array of document texts
- `top_n`: max results to return

```bash
npx -y mcporter call jina.sort_by_relevance --args '{"query": "machine learning", "documents": ["doc1 text", "doc2 text"], "top_n": 5}'
```

### deduplicate_strings
Select top-k semantically unique strings from a list.
- `strings` (required): array of strings
- `k`: number to return (auto-optimized if omitted)

```bash
npx -y mcporter call jina.deduplicate_strings --args '{"strings": ["hello world", "hi world", "goodbye"]}'
```

### deduplicate_images
Select top-k visually unique images using CLIP v2 embeddings.
- `images` (required): array of image URLs or base64 strings
- `k`: number to return (auto-optimized if omitted)

```bash
npx -y mcporter call jina.deduplicate_images --args '{"images": ["https://a.com/1.jpg", "https://a.com/2.jpg"]}'
```

### expand_query
Rewrite a search query into multiple expanded variants for deeper research.
- `query` (required): the query to expand

```bash
npx -y mcporter call jina.expand_query query:"machine learning optimization"
```

## Utility

### primer
Get current session context (time, location, network) for localized responses. No parameters.

```bash
npx -y mcporter call jina.primer
```

### guess_datetime_url
Guess when a web page was last updated/published.
- `url` (required): page URL

```bash
npx -y mcporter call jina.guess_datetime_url url:"https://example.com/article"
```

### search_jina_blog
Search Jina AI's official blog and news.
- `query` (required): search terms (string or array)
- `num`: max results 1-100 (default 30)
- `tbs`: time filter

```bash
npx -y mcporter call jina.search_jina_blog query:"embeddings" num:10
```

### show_api_key
Show the current Jina API key for this session. No parameters.

```bash
npx -y mcporter call jina.show_api_key
```

## Tool Selection Guide

| Scenario | Tool |
|---|---|
| Read a single web page | `read_url` |
| Read multiple pages at once | `parallel_read_url` |
| General web search | `search_web` |
| Multi-angle deep research | `expand_query` → `parallel_search_web` |
| Find images | `search_images` |
| Find STEM papers | `search_arxiv` |
| Find social science / finance papers | `search_ssrn` |
| Get BibTeX citations | `search_bibtex` |
| Extract figures from a paper | `extract_pdf` |
| Visual inspection of a page | `capture_screenshot_url` |
| Categorize text into labels | `classify_text` |
| Rank documents by relevance | `sort_by_relevance` |
| Remove duplicate content | `deduplicate_strings` / `deduplicate_images` |

## Tips

- Use `expand_query` before `parallel_search_web` or `parallel_search_arxiv` to generate diverse queries for thorough research.
- Parallel variants accept up to 5 items — use them for batch work.
- Set `tbs:qdr:w` to restrict results to the past week for time-sensitive queries.
- For A-share / Chinese market research, set `gl:cn hl:zh-cn` on search tools.
- Use `--output json` on any call to get raw JSON for programmatic processing.
- Use `--output markdown` for human-readable output.
