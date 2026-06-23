# upcoming_upgrades.md - v4.0 Roadmap Design & Prototype 🚀🎙️🖼️

This document outlines the visual design, technical implementation strategy, and high-fidelity UI prototype mockup for the upcoming **v4.0 Multi-Modal & Audio Cockpit** upgrades.

---

## 🎨 Visual Design Strategy

To match the existing dark-mode, glassmorphic layout of **Kall AI**, the roadmap is designed as a persistent card.

### Sidebar Integration (Implemented)
By adding an expander panel directly inside the Streamlit sidebar, we ensure that:
1. **High Persistency**: The roadmap is visible to recruiters whether they are on the initial uploader screen (State 1) or inside the interactive dashboards cockpit (State 2).
2. **Context-Aware Styling**: Colored labels match the existing theme (Electric Blue, Cyan, Purple) to clearly distinguish developmental phases and statuses.

---

## 📸 High-Fidelity Roadmap Prototype

Here is a visual prototype mockup showing how the planned v4.0 product roadmap dashboard is laid out:

![v4.0 Roadmap Mockup](/Users/saurabhshidhore/.gemini/antigravity/brain/d59c6315-dffa-4575-8184-a51099694533/roadmap_mockup_1780944075286.png)

---

## 🛠️ Technical Implementation Architecture

### Phase 1: Direct Audio Upload & Live Transcription
* **Inputs**: In the `📄 Transcript Input` card, we will add an `📁 Upload Audio` tab alongside the text/pasted inputs. It will accept `.mp3`, `.wav`, and `.m4a` files.
* **Orchestration**: The python backend will invoke Google Gemini's file manager to upload files directly:
  ```python
  audio_file = client.files.upload(file=uploaded_audio_file)
  ```
  We will then pass the `audio_file` handle inside the `contents` payload to Gemini 1.5 Pro to request a structured Pydantic extraction.

### Phase 2: Whiteboard OCR & Slide Scanner
* **Inputs**: A secondary file uploader widget `🖼️ Upload Meeting Visuals (Slides/Whiteboards)` will be added.
* **Orchestration**: Uploaded image bytes will be passed as PIL Image objects to Claude 3.5 Sonnet or Gemini 1.5 Pro alongside the meeting transcript text, prompting:
  > *"Synthesize this whiteboard sketch/presentation slide with the spoken transcript to capture visual wireframe details, database schemas, and action owners discussed."*

### Phase 3: PWA Packaging
* **Configuration**: A `manifest.json` and a service worker script will be injected into Streamlit's custom HTML headers.
* **Layout Grid**: CSS media queries will be updated to collapse the current two-column uploader and multi-tab cockpit into a single, vertically stackable layout on mobile screen heights (<= 850px).
