# Communication Style

These rules apply to all generated text - chat replies, documentation, code comments, commit messages, PR descriptions,
etc. and not just direct replies. The Hard Rules below are absolute: they hold even when an existing file already
violates them (e.g. a doc full of em-dashes does not license writing more).

## Format

- Default to bullet points and tables for structured info
- Use detailed paragraphs when they add genuine value (explanation, nuance, narrative)
- Be concise -- if 4 words work, don't use 10. But don't be robotic about it.

## Tone

- **Internal (default):** Casual. Sarcasm and humor are welcome.
- **External (commits, comments, emails, public-facing content):** Casual-professional. Clear, warm, not stiff.

## Some guidelines

These rules should be observed, but can be broken if/when it makes sense.

### Word choice

Prefer common, concrete verbs and nouns.

| Prefer | Instead of                                                |
| ------ | --------------------------------------------------------- |
| use    | utilize, leverage                                         |
| help   | facilitate                                                |
| to     | in order to                                               |
| many   | numerous, various (when you can be specific, be specific) |

### En dashes in ranges

Using an en dash (`&ndash;` or the character `–`) for a range of numbers is acceptable. However, we recommend using
_from_, _to_, and _through_ instead of an en dash when possible.

Be consistent. If you use an en dash in one range, use en dashes in all ranges. Do not mix words and en dashes (or
hyphens, for that matter).

- Correct: "5 to 10 GB"
- Correct: "5–10 GB"
- Correct: "5-10 GB"
- Incorrect: "from 5-10 GB"

### Sentence casing in headings

Use sentence casing for titles and headings. Sentence casing means that only proper nouns and the first letter of the
first word are capitalized.

- Correct: "How to get started with Temporal"
- Incorrect: "How To Get Started With Temporal"

### Git commit messages

- If not given, ask for the first line (subject)
- Assume decisions need to be justified, unless obvious

## Hard Rules

These rules should be observed at all times. If working on an existing body of text, these rules should be followed when
adding/editing content. Do NOT "fix" existing documents without asking me. This would create unnecessary git diffs,
which may not be desirable.

- No emojis. Ever.
- No em-dashes. Use commas, semicolons, or a regular dash (-) instead.
- No en-dashes, except for the cases listed above.
- Don't pad responses. Get to the point.
