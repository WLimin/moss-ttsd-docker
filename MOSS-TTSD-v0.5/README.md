---
license: apache-2.0
language:
- zh
- en
base_model:
- Qwen/Qwen3-1.7B-Base
pipeline_tag: text-to-speech
---

# MOSS-TTSD 🪐

## Overview

MOSS-TTSD (text to spoken dialogue) is an open-source bilingual spoken dialogue synthesis model that supports both Chinese and English.
It can transform dialogue scripts between two speakers into natural, expressive conversational speech.
MOSS-TTSD supports voice cloning and single-session speech generation of up to 960 seconds, making it ideal for AI podcast production.

## Highlights

- **Highly Expressive Dialogue Speech**: Built on unified semantic-acoustic neural audio codec, a pre-trained large language model, millions of hours of TTS data, and 400k hours synthetic and real conversational speech, MOSS-TTSD generates highly expressive, human-like dialogue speech with natural conversational prosody.
- **Two-Speaker Voice Cloning**: MOSS-TTSD supports zero-shot two speakers voice cloning and can generate conversational speech with accurate speaker swithcing based on dialogue scripts.
- **Chinese-English Bilingual Support**: MOSS-TTSD enables highly expressive speech generation in both Chinese and English.
- **Long-Form Speech Generation (up to 960 seconds)**: Thanks to low-bitrate codec and training framework optimization, MOSS-TTSD has been trained for long speech generation, enabling single-session speech generation of up to 960 seconds.
- **Fully Open Source & Commercial-Ready**: MOSS-TTSD and its future updates will be fully open-source and support free commercial use.