---
name: deep-research
description: Use this skill when the user's prompt requires (1) researching a topic across multiple sources, comparing options or alternatives, analyzing trends or history, understanding markets or industries, or reviewing literature or studies and (2) synthesizing that research into a comprehensive, narrative report. If you're planning to search the web or internal knowledge bases, consider using this skill. This skill coordinates research subagents, so use it only when the subagent tool is available; otherwise, research the question directly.
---

# Coordinating Deep Research

## Your Role

You are acting as the **coordinator**. Your job is to analyze the user's question, delegate only the work that benefits from delegation, and manage output files. You may research directly when the question is narrow or when delegated agents lack the tools needed for local sources. Use the smallest workflow that answers the question. Read researcher.md and report-writer.md when you delegate those roles; do not read them as a substitute for doing direct research.

As you work, use the todo tool to keep the user informed of your plan and progress. For clarity, don't reference subagents in those items. For example, you might say "Conduct research" instead of "Spawn research subagents".

## Process

1. [If necessary] Ask the user follow up questions
2. Choose a title for this research and create its directories
3. Decide whether delegation earns its overhead
4. Gather research with the smallest suitable workflow
5. [If absolutely necessary] Conduct one additional round of research
6. Synthesize the report directly or spawn one report writer
7. Check the report artifact and deliver it

### 1. [If necessary] Ask the user follow up questions

Read the user's question and consider if there are any missing or ambiguous details that need to be clarified. Some examples include:
- Ambiguous terminology — Acronyms, jargon, or terms with multiple meanings across different fields
- Implicit geographic or jurisdictional context — Questions where the answer varies significantly by region but no region is specified
- Ambiguous entities — Company names, product names, or proper nouns that refer to multiple distinct entities

In order to avoid creating unnecessary friction with the user, follow ups should only be asked when they would meaningfully impact how research is conducted.

If you determine that you do need to ask follow up questions, ask them directly in your reply and stop until the user answers.

### 2. Choose a title for this research and create its directories

First choose a title for this research. It names the folder that will hold this request's research notes and is also the filename of the report the user receives, where it is shown as the report's title, so make it a short, specific title for this research in the user's language and in sentence case: 3 to 6 words and under 50 characters (count them, and drop words rather than exceed either limit), using only letters, numbers and single spaces. Keep accented and non-Latin letters exactly as the user's language writes them (for example é, ñ, ü, 日本語) rather than converting them to plain ASCII, and use no hyphens, underscores, apostrophes or other punctuation. For example, a question about how the EU AI Act affects startups could use "EU AI Act startup obligations".

This research's folders go in the same directory you used for research earlier in this conversation, or, if this is the first research request here, in your current working directory (not /tmp or an uploads folder). Before settling on the title, recall the titles of any research reports you have already delivered earlier in this conversation, and, if a research_notes/ folder already exists in that directory, list it — each folder inside it holds the notes behind a report of the same name in reports/, possibly from an earlier conversation. Then pick the case that fits:
- New topic: choose a fresh title.
- Returning to, extending or updating an earlier topic: choose a title that still names the topic and says what this request adds or changes (for example "EU AI Act startup penalties", not just "Penalties"), or, if nothing distinguishes it from the earlier request, the earlier title with the next number added, dropping a word first if that would exceed the limits above (for example "EU AI Act startup obligations 2"). Note the path of the most recent earlier report on that topic and of its notes folder: you will pass them to the report writer in step 6 as background to build on. If that report or its notes folder is no longer on disk, pass on only what remains and research whatever is missing.
- The user asks for earlier research to be redone independently: choose a title as in the previous case, but do not pass the earlier material on.

In every case the title must differ from every report delivered earlier in this conversation and from every folder you see, so that this request's notes and report never mix with or replace an earlier one's. Never rename, move or write into an earlier request's folder.

Then create the folders research_notes/{research title}/ and reports/ in that directory. Quote these paths in shell commands, since the title contains spaces, and note the directory's absolute path — you will give the subagents absolute paths into these folders, and they will store their files there.

### 3. Decompose the user's query to determine subagent count

In order to effectively spawn and task subagents, determine if and how the user's question can be decomposed into independent subtopics. These subtopics should be mutually exclusive and collectively exhaustive. For each subtopic, then consider if the research requires (or would benefit from) multiple independent points of view.

| Researchers | Decomposition Strategy | Example |
|-------------|------------------------|---------|
| 1 | No meaningful decomposition — single factual question | "Who won the 2024 Super Bowl?" |
| 3 | Few natural angles or perspectives on a focused topic | "Effects of temperature on salmon migration" → (1) biological mechanisms, (2) observed population data, (3) climate projections |
| 4 | Distinct facets or evaluation criteria | "Compare CRM platforms for small businesses" → (1) pricing models, (2) feature comparison, (3) integrations ecosystem, (4) user reviews/sentiment |
| 5 | Multiple independent entities, regions, or domains | "AI regulation landscape" → (1) US federal, (2) EU/GDPR-AI Act, (3) China, (4) UK, (5) industry self-regulation |
| 6+ | Large enumerable set requiring systematic coverage | "Electric vehicle adoption rates by US state" → researchers assigned to regional clusters |

Choose the smallest suitable workflow:

- Use direct research for a narrow question, a short source comparison, or local analysis that needs shell, directory, or session access unavailable to the researcher role.
- Use one researcher for one focused external or source-reading brief.
- Use two or three researchers only when the question has independent facets that need parallel evidence.
- Use a report writer only when the research produces multiple substantial notes or the user asks for a comprehensive report.

Do not fan out by default. If earlier research exists, re-check only what the new request adds.

### 4. Spawn research subagents (in parallel)

For each subtopic and independent point of view determined above, spawn one research subagent using the builtin `researcher` agent.

To spawn all research subagents in parallel in pi, write one ```js workflow block in your reply and call subagent({ workflow: true, ... }) in the same reply, with one `runs.all` entry per researcher. Set each entry's `output` to that researcher's notes path — the runtime persists the researcher's final response to that exact file, so the researcher never needs to write files itself. Launching is async by default: after you launch, end your turn; pi wakes you when all researchers finish. Do not poll, sleep, or call bg_wait.

Ensure that you provide **extremely clear, specific** instructions to each research subagent. Be sure to propagate constraints of the original question to the research subagent (e.g., temporal, geographical). In the template below, replace {path_to_skill} with this skill's base directory (the directory this SKILL.md was loaded from), {absolute path of your working directory} with the path you noted in step 2, {research title} with the title you chose in step 2, and {topic} with a short slug for the subtopic. Follow the exact format provided below:

```js workflow
const notes = "{absolute path of your working directory}/research_notes/{research title}";
const results = await runs.all([
  {
    key: "{topic-slug}",
    agent: "researcher",
    context: "fresh",
    output: `${notes}/{topic}.md`,
    outputMode: "file-only",
    task: `Research {specific narrow topic}.

Objective: {clear description of what's covered in the desired output}

Key questions:
- {Specific question 1}
- {Specific question 2}

Suggested sources:
- {Types of source to prioritize}

Constraints:
- {Any bounds from the initial user query, including temporal or geographic}

Your final response is saved verbatim as your research notes, so end it with the complete notes document.

**As a first step, you must read {path_to_skill}/references/researcher.md for instructions on how to conduct research.**`
  }
  // one entry per researcher, all in this same runs.all call
]);
return results.map(r => r.output);
```

Make each researcher's prompt distinct by subtopic, evidence, and decision — do not clone one prompt with only the topic name swapped.

Example of a good, clear, detailed prompt for a research subagent (the `task` value for one runs.all entry):

> Research the semiconductor supply chain crisis and its current status as of 2026.
>
> Objective: Compile a dense report of the facts, covering the current situation, ongoing solutions, and future outlook, with specific timelines and quantitative data where available.
>
> Key questions:
>  - What are current bottlenecks?
>  - What are the projected capacity increases from new fab construction?
>  - What are geopolitical factors affecting supply chains?
>  - When do experts predict supply will meet demand?
>
> Suggested sources:
> - Recent quarterly reports from major chip manufacturers like TSMC, Samsung, and Intel, found on investor relations pages or through the SEC EDGAR database
> - Industry reports from SEMI, Gartner, and IDC that provide market analysis and forecasts
> - Government responses, including US CHIPS Act implementation progress at commerce.gov, EU Chips Act at ec.europa.eu, and similar initiatives in Japan, South Korea, and Taiwan through their respective government portals
>
> Constraints:
> - Must reflect current state as of 2026 with prior issues clearly noted as such
>
> Your final response is saved verbatim as your research notes, so end it with the complete notes document.
>
> **As a first step, you must read {path_to_skill}/references/researcher.md for instructions on how to conduct research.**

### 5. [If absolutely necessary] Conduct one additional round of research

Based on the task summaries returned by the research subagents, determine if there are any critical gaps that would make the report incomplete. If deemed absolutely necessary, spawn researchers in parallel to close those gaps, using the same workflow form as step 4. Spawning additional researchers in this step delays delivery of the report to the user, leading to a much worse experience, so this must be used with extreme care.

**This step can only be followed once** - after the researchers finish, move immediately to Step 6, regardless of what results you get back. If you kick off any more research, you will hit timeouts or rate limits, meaning the user will never get an answer to their query. **To help yourself remember this, you should always output "After these researchers finish, I will move directly to coordinating the report writer" when choosing to kick off additional research.**

### 6. Spawn report writer subagent

After research is done, spawn a single report writer subagent with a direct subagent call (async by default; end your turn after launching and pi wakes you when it finishes). Use the builtin `worker` agent and fill in the placeholders as in step 4. For {the user's original question}, state the question this report must answer in full — if this request returns to or extends earlier research, that is the earlier question as amended by this request (for example "How does the EU AI Act affect startups, including penalties?"), not just the follow-up message. On the line for earlier research, give the absolute paths of the earlier report and notes folder you noted in step 2, or write "none" if you noted nothing to build on or the user asked for an independent redo. Follow the exact format provided below:

```
subagent({
  agent: "worker",
  async: true,
  cwd: "{absolute path of your working directory}",
  context: "fresh",
  output: "{absolute path of your working directory}/reports/{research title}.md",
  outputMode: "file-only",
  task: `Read the notes in {absolute path of your working directory}/research_notes/{research title}/ and synthesize into a research report that answers: {the user's original question}.

Earlier research in this conversation to build on: {absolute paths of the earlier report and notes folder from step 2, or "none"}

Return the complete report. The output field above writes it to the exact report path.

**As a first step, you must read {path_to_skill}/references/report-writer.md for instructions on how to write your research report.**`
})
```

### 7. Deliver report to user

After the report writer is done, verify the report exists at `reports/{research title}.md`. Read the finalized report before delivery. If the artifact is missing, report the exact failure and keep the workflow incomplete. Send the user a brief summary with the absolute report path. Do not paste the whole report into the conversation.
