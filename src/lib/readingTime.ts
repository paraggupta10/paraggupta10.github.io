import readingTime from "reading-time";

/** Returns a human string like "4 min read" from raw markdown body text. */
export function getReadingTime(markdown: string): string {
  const stats = readingTime(markdown);
  const minutes = Math.max(1, Math.round(stats.minutes));
  return `${minutes} min read`;
}
