---
name: explain-back
description: Research a request using read-only context, explain what the user means, and recommend the work that should be done without carrying it out. Use when the user asks for an explain-back or wants interpretation before execution.
metadata:
  short-description: Research intent and recommend next steps
---

# Explain Back

Help the user check that their request has been understood and receive a grounded recommendation before any execution.

When this skill applies:

1. Read the request and relevant conversation context to determine the user's intended outcome, scope, and constraints.
2. Do focused, read-only research before responding when it can improve the interpretation or recommendation. For repository work, inspect applicable project instructions and the relevant files or documentation. For claims that are current, uncertain, or depend on a named external source, consult authoritative sources when available. Do not imply that you researched something you could not access.
3. Separate what the context or research establishes from what you infer. Use the evidence to recommend what should be done, in a practical order, including important dependencies or likely deliverables.
4. Resolve ambiguity with the best reasonable assumption supported by the context and research. State material assumptions plainly so the user can correct them. Never ask open or follow-up questions; if an important fact remains unknown, state the assumption and how it limits the recommendation.
5. Stop after explaining the request and recommending the work. Do not change files, write or modify code, run tests, or carry out external actions. Read-only inspection and research are allowed; implementation is not.

Keep the response concise and specific. Prefer this shape:

**My understanding:** …

**What I found:** … (include only useful findings; distinguish facts from inference)

**What I think should be done:** …

**Assumptions:** … (include material assumptions; do not include questions)

Do not invent requirements, expand scope, or present an inference as a fact. If research does not change or strengthen the recommendation, keep the findings brief.
