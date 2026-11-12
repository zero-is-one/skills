---
name: explain-back
description: When invoked, interpret a request, do limited read-only research, and recommend a plan without producing the requested deliverable or carrying out the task. Use when the user asks for an explain-back before execution.
metadata:
  short-description: Explain intent and recommend a plan
---

# Explain Back

Treat this skill as a planning-only mode. Its purpose is to help the user confirm the intended work before the task is performed.

When this skill applies:

1. Read the request and relevant conversation context to determine the user's intended outcome, scope, and constraints.
2. Do focused, read-only research only as needed to understand the request and recommend a sound approach. For repository work, inspect applicable project instructions and the minimum relevant files or documentation. For current or uncertain claims, consult authoritative sources when available. Do not imply that you researched something you could not access.
3. Treat any concrete task or deliverable requested in the same message as the subject to explain, not as authorization to produce it. This boundary applies even when the task is purely analytical and would not require changing files. Do not complete the requested analysis, comparison, report, ranking, estimate, draft, code, or other end product. Research must stop short of doing the task itself.
4. Use the research to recommend what should be done, in a practical order, including important dependencies or likely deliverables. Keep findings limited to context needed to explain the scope; do not reveal the requested deliverable's substantive results.
5. Resolve ambiguity with the best reasonable assumption supported by context and research. State material assumptions plainly so the user can correct them. Never ask open or follow-up questions. If an important fact remains unknown, state the assumption and how it affects the recommendation.
6. After explaining the request and recommending a plan, stop. Do not change files, write or modify code, run tests, or carry out external actions. The user can correct assumptions or ask for the task to be performed in a later message.

Keep the response concise and specific. Prefer this shape:

**My understanding:** …

**What I found:** … (include only useful context, not the requested deliverable's findings)

**What I think should be done:** …

**Assumptions:** … (include material assumptions; do not include questions)

Do not mention this skill or narrate the process followed. Do not add meta disclaimers about not changing files, running tests, or carrying out the request. Present the understanding, useful context, recommendation, and material assumptions directly. Mention a limitation only when it is substantively relevant to the recommendation, and phrase it as a fact or assumption rather than a disclaimer.

Do not invent requirements, expand scope, or present an inference as a fact. If research does not change or strengthen the recommendation, keep the findings brief.
