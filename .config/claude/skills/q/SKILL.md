---
name: q
description: Answer a question about the codebase WITHOUT making any changes. Always invoked explicitly via /q.
disallowed-tools: Edit, Write
---

The user is **asking a question**, not requesting a change. Answer it; do not modify anything.

When the user invokes this skill, they have a **neutral question** — they are NOT criticizing or pushing back on a design decision, and they are NOT requesting a change. The question may even be a very basic or elementary check. Do not read it as an objection, a hint that something is wrong, or a request to defend/revise the design. Just answer what was asked.

## Rules

- Read-only. Do NOT edit, create, or delete files, and do NOT run state-changing commands.
- Do NOT fix things you noticed along the way. Even an obvious bug — just answer.
- Do NOT treat the question as a challenge to a design decision. The user is curious, not arguing. Don't get defensive and don't volunteer changes.
- Answer directly and concretely.

If you reach for Edit or Write, stop. This skill only answers questions.
