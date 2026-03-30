---
name: image-generation
description: Use this skill when generating images. TRIGGER when user asks to "generate image", "create image", "draw", "make picture", or needs to generate images programmatically via API.
version: 0.1.0
---

# Image Generation Skill

## Overview

Z.ai's `glm-image` API generates images from text prompts. OpenAI-compatible endpoint at `https://api.z.ai/api/paas/v4/images/generations`.

**Requirements:**
- API key in `Z_AI_API_KEY` environment variable
- Use `xh` (preferred) or `curl` with `Content-Type: application/json` header

## Quick Start

```bash
# Generate image (xh - recommended)
xh --ignore-stdin POST https://api.z.ai/api/paas/v4/images/generations \
  Authorization:"Bearer $Z_AI_API_KEY" \
  Content-Type:application/json \
  model=glm-image \
  prompt="A cute kitten on a sunny windowsill" \
  size=1280x1280

# Generate image (curl)
curl -s -X POST https://api.z.ai/api/paas/v4/images/generations \
  -H "Authorization: Bearer $Z_AI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "glm-image",
    "prompt": "A cute kitten on a sunny windowsill",
    "size": "1280x1280"
  }'
```

## Response Format

```json
{
  "created": 1774317025,
  "data": [{"url": "https://...watermark.png?UCloudPublicKey=..."}],
  "id": "...",
  "request_id": "..."
}
```

Image URL is temporary (expires after some time). Download immediately if persistence needed.

## Post-Generation Workflow

After receiving the image URL, always download the image to a local path (default `/tmp`).

```bash
# Download to /tmp, with a unique representitive name
curl -sL "$IMAGE_URL" -o /tmp/xxx.png
```

Then read the image using the `Read` tool, to confirm image correctness.

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `model` | string | Yes | Use `"glm-image"` |
| `prompt` | string | Yes | Text description of desired image |
| `size` | string | Yes | Image dimensions, e.g., `"1280x1280"` |

## Extract Image URL

```bash
# xh + jq
xh --ignore-stdin POST https://api.z.ai/api/paas/v4/images/generations \
  Authorization:"Bearer $Z_AI_API_KEY" \
  Content-Type:application/json \
  model=glm-image \
  prompt="..." \
  size=1280x1280 | jq -r '.data[0].url'

# Download directly
xh --ignore-stdin POST ... | jq -r '.data[0].url' | xargs curl -o image.png
```

## Error Handling

Common errors:
- **401 Unauthorized**: Invalid or missing API key
- **400 Bad Request**: Invalid parameters (check `size` format, prompt length)

Always check HTTP status code and response body for error details.

## Money Budget

Z.ai's `glm-image` is an expensive model with following budgets:

- Cost: 40 RMB
- Limit: 500 requests per-month

Each invocation to image models are precious and expensive. Keep in mind that each invocation consumes user's money for about 0.08 RMB.

**Constraints:**

- Do NOT re-run with exact same prompt - re-use the previous generated image URL.
- Do NOT send repetitive invocations of the image generation endpoint for debugging - use GET endpoints (e.g. listing models) to test connection instead.
