class TextParser {
  static List<SpanText> parse(String paragraph) {
    if (paragraph.isEmpty) return [];
    if (!paragraph.startsWith("<p>")) {
      paragraph = "<p>$paragraph";
    }
    if (!paragraph.endsWith("</p>")) {
      paragraph = "$paragraph</p>";
    }
    List<SpanText> texts = [];

    // Regex to extract everything inside <p> and spans within <p>
    RegExp pTagExp = RegExp(r'<p[^>]*>(.*?)</p>', dotAll: true);
    RegExp spanTagExp = RegExp(r'<(\w+)[^>]*>(.*?)</\1>', dotAll: true);

    // Helper function to recursively extract nested spans
    List<SpanText> parseSpans(String text, List<String> tags) {
      List<SpanText> texts = [];

      Iterable<RegExpMatch> spanMatches = spanTagExp.allMatches(text);

      int lastIndex = 0;

      for (var spanMatch in spanMatches) {
        String spanText = spanMatch.group(2)!;
        String spanType = spanMatch.group(1)!;
        int spanStart = spanMatch.start;
        int spanEnd = spanMatch.end;

        // Add any normal text between last index and span start
        if (spanStart > lastIndex) {
          String normalText = text.substring(lastIndex, spanStart);
          if (normalText.isNotEmpty) {
            texts.add(NormalText(text: normalText));
          }
        }

        // Parse nested spans recursively
        List<String> nestedTags = [...tags, spanType];
        var nestedElements = parseSpans(spanText, nestedTags);
        if (nestedElements.isEmpty) {
          texts.add(SpannedText(text: spanText, types: nestedTags));
        } else {
          texts.addAll(nestedElements);
        }

        lastIndex = spanEnd;
      }

      // Add any remaining normal text after the last span
      if (lastIndex < text.length) {
        String remainingText = text.substring(lastIndex);
        if (remainingText.isNotEmpty) {
          if (tags.isNotEmpty) {
            texts.add(SpannedText(
              text: remainingText,
              types: tags,
            ));
          } else {
            texts.add(NormalText(text: remainingText));
          }
        }
      }

      return texts;
    }

    // Find the content inside <p> tags
    Iterable<RegExpMatch> pMatches = pTagExp.allMatches(paragraph);

    for (var pMatch in pMatches) {
      String pContent = pMatch.group(1)!; // Get the inner content of <p>

      // Parse content, starting with no parent tags
      texts.addAll(parseSpans(pContent, []));
    }

    return texts;
  }
}

abstract class SpanText {
  final String text;

  const SpanText({
    required this.text,
  });

  @override
  String toString() => '$SpanText(text: $text)';
}

class NormalText extends SpanText {
  const NormalText({
    required super.text,
  });

  @override
  String toString() => '$NormalText(text: $text)';
}

class SpannedText extends SpanText {
  final List<String> types;

  const SpannedText({
    required super.text,
    required this.types,
  });

  @override
  String toString() {
    return '$SpannedText(text: $text, types: $types)';
  }
}

void main() {
  String normalText =
      "My name is Mr. X. I'm <CUSTOM_TAG_1><CUSTOM_TAG_2>24</CUSTOM_TAG_2></CUSTOM_TAG_1> old.";
  List<SpanText> parsedText = TextParser.parse(normalText);
  print(
      parsedText); // OUTPUT: [NormalText(text: My name is Mr. X. I'm ), SpannedText(text: 24, types: [CUSTOM_TAG_1, CUSTOM_TAG_2]), NormalText(text:  old.)]
}
