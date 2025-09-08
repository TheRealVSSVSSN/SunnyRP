# AGENTS.md

## Purpose  
Provide detailed documentation for this resource’s codebase. The agent will scan all files in this folder and produce a comprehensive Markdown document explaining the structure and functionality of the resource.

## Setup and Context  
- **Repository Access:** If the resource’s code is not already loaded, clone the repository or fetch the latest code. Navigate into this resource’s directory before analysis. Ensure all files in this folder (and its subfolders) are accessible.  
- **Included Files:** Document **all files** in this resource (source code, configuration, JSON, etc.). Include client-side, server-side, and shared files (if applicable). Only ignore files or subfolders if explicitly instructed in the prompt (e.g. skip cache folders or specific file patterns if the user says so).  
- **Environment:** You may run basic commands (like listing directory contents) to gather file names. However, focus on reading and analyzing file content rather than executing the code (unless needed for understanding). Do not modify any code; this task is read-only documentation.

## Documentation Output Format  
Produce a Markdown (`.md`) file that contains:  

- **Title and Overview:** Begin with a heading that includes the resource name and the word "Documentation". (For example: `# ResourceName Documentation`.) In a short overview paragraph, summarize the purpose of this resource (what functionality or feature it provides in the project) if it can be determined from context.  

- **Table of Contents:** After the overview, include a **Table of Contents** listing each file (and subfolder) in this resource. This should be an ordered or bullet list with links (where possible) to the sections for each file. Use the file names (and paths for files in subfolders) as the link text. This allows easy navigation within the documentation.  

- **Per-File Documentation:** For each file in the resource, include a subsection describing that file:
  - Use a **second-level heading** (e.g. `## filename.ext`) or third-level if an overview section is already a second-level. If the file is in a subfolder, you can prefix the heading with the subfolder name (e.g. `## subfolder/filename.ext`) for clarity. 
  - In the description, explain **in detail what the code does**. Describe the file’s role in the resource and the project. Summarize the functionality of major functions, classes, or sections in the file:
    - *For example:* If the file defines several functions, list each function (by name) and explain its purpose. If it’s a configuration file, describe what settings it contains. If it’s a data file, describe the structure of the data.
  - **Do NOT copy code** directly from the file. Instead, **explain the logic and behavior** in plain language. You may reference identifiers (like function names, constants, or config keys) to make the explanation clear, and you can include very small pseudocode snippets or signatures *only if absolutely necessary* to illustrate a point. The focus should be on **what** the code does, not the exact syntax.
  - Keep paragraphs concise. Use bullet points or step-by-step explanations for complex processes or sequences of actions within the code. This will improve readability.
  - **Inter-file and Inter-resource relations:** If this file calls functions from another file, triggers events, or relies on data from elsewhere, mention these interactions. For example, “This file triggers the event `X` which is handled in the **AnotherResource** resource,” or “It uses utility functions from `utils.lua` in the same resource.” This helps understand dependencies and integration points.
  - If the file defines any API endpoints, commands, or interfacing hooks, document what they are and how they are intended to be used.
  - If relevant, note any important **algorithms or logic** the file implements (e.g. pathfinding, authentication flow), describing how it works at a high level.
  - For **configuration or JSON files**, describe the configuration options and their effects. For example, list config keys and what each controls.
  - For **script files**, describe the runtime behavior: e.g., “On server start, this script does X. When a player triggers Y, it does Z,” etc.
  
- **Subfolder Structure:** If this resource contains subdirectories (for example `client/` and `server/` folders or others), reflect that structure:
  - Still list all files in the Table of Contents (perhaps grouped by folder).
  - In the documentation sections, you may group files by subfolder using sub-headings or simply include the subfolder name in the file’s section heading. Ensure it’s clear which files are client-side vs server-side (if applicable).
  
- **Examples and Blocks:** You generally should **not** include large code blocks since we avoid copying code. However, you can use **formatted examples** for clarity when needed:
  - e.g., a short snippet to show a function signature or a critical line (redacted of specifics) for explanation. Mark such snippets as code (using backticks) if included.
  - Use *italic* or **bold** text to emphasize key parts of the explanation if necessary (for instance, to highlight an important function name or a configuration term).
  
- **Conclusion:** After documenting all files, if appropriate, add a brief conclusion or summary of how these pieces work together in the resource. This can reinforce the overall functionality of the resource (e.g., “In summary, this resource handles all vehicle spawning logic and coordinates with the economy and inventory systems to deduct costs and grant ownership to players.”). If the documentation became very long, a short recap helps the reader.
  
- **Internal Links:** Within the document, feel free to use internal links for easier navigation (for example, link references to a function defined in another file’s section). This is optional but can be helpful in a large document.
  
## Execution Guidelines  
- **Order of Execution:** First, list the file structure, then proceed to document each file one by one. Finish documenting one file completely (with its own section) before moving to the next file.
- **Verification:** After generating the documentation, quickly verify that every file from the folder is documented and that the Table of Contents links correspond to each file’s section.
- **Accuracy and Detail:** Ensure that descriptions are accurate to the code’s behavior. If the code is complex, break down the logic into simpler terms or step-by-step descriptions. The goal is that a developer reading this can understand the intent of the code without reading it directly.
- **Neutral Tone:** Write the documentation objectively and informatively. Do not include speculative remarks about why something was coded a certain way — focus on what it does.
- **Generality:** Describe the logic in a way that is not tied to a specific programming language’s syntax. For instance, instead of saying “uses JavaScript promises,” you might say “performs an asynchronous call.” This ensures the documentation is conceptually transferable to other languages or contexts, without explicitly instructing to use any particular language.
- **Time Management:** If the agent is operating under execution time limits (e.g., ~30 minutes per session), plan the work accordingly. Aim to complete scanning and analysis of files by around the 25-minute mark, then use the remaining time to write and format the markdown output. If the documentation is incomplete when time is nearly up, prioritize summarizing remaining content rather than stopping mid-way.  

_With these instructions, the agent should be able to generate a complete and detailed documentation markdown file for this resource. Save the output as `ResourceName_Documentation.md` (or a similarly appropriate filename) in the desired location. Review the output for completeness and clarity before considering the task done._