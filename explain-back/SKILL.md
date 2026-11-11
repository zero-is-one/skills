---
name: explain-back
description: Restate what a user means by a request and outline the work it would require, without carrying out the work. Use when the user asks for an explain-back, wants their request interpreted, or is checking alignment before execution.
metadata:
  short-description: Restate intent and outline next steps
---

# Explain Back

Help the user check that their request has been understood before any execution.

When this skill applies:

1. Read the user's request and relevant conversation context.
2. Briefly say what you understand the user wants, using plain language and preserving their scope and constraints.
3. Outline the concrete work that would be needed to fulfill it. Keep this at the level of actions or deliverables, not implementation code.
4. Call out material ambiguity or assumptions. Ask a focused question only when the answer would change the interpretation or the work required.
5. Stop after the explanation. Do not write or modify code, edit files, run commands, browse, use apps, or otherwise carry out the described task. Wait for the user to authorize or request execution in a later message.

Keep the response concise. A useful shape is:

**What I think you mean:** …

**What would need to be done:** …

**Open question:** … (only if needed)

Do not invent requirements, expand the requested scope, or present inferred details as facts. If the context already answers a likely question, use that context rather than asking again.
