import 'dart:typed_data';

import 'package:enough_mail/src/util/stack_list.dart';

import 'imap_response_line.dart';

class ImapResponse {
  List<ImapResponseLine> lines = <ImapResponseLine>[];
  bool get isSimple => (lines.length == 1);
  ImapResponseLine get first => lines.first;
  String _parseText;
  String get parseText => _getParseText();
  set parseText(String text) => _parseText = text;
  static const List<String> _knownParenthizesDataItems = [
    'BODY',
    'BODYSTRUCTURE',
    'ENVELOPE',
    'FETCH',
    'FLAGS'
  ];

  void add(ImapResponseLine line) {
    lines.add(line);
  }

  String _getParseText() {
    if (_parseText == null) {
      if (isSimple) {
        _parseText = first.line;
      } else {
        var buffer = StringBuffer();
        for (var line in lines) {
          buffer.write(line.line);
        }
        _parseText = buffer.toString();
      }
    }
    return _parseText;
  }

  ImapValueIterator iterate() {
    var root = ImapValue(null, true);
    var current = root;
    var nextLineIsValueOnly = false;
    var parentheses = StackList<ParenthizedListType>();

    for (var line in lines) {
      if (nextLineIsValueOnly) {
        var child = ImapValue(line.line);
        child.data = line.rawData;
        current.addChild(child);
      } else {
        // iterate through each value:
        var isInValue = false;
        String separatorChar;
        var text = line.line;
        int startIndex;
        for (var charIndex = 0; charIndex < text.length; charIndex++) {
          var char = text[charIndex];
          if (isInValue) {
            if (char == '[' && separatorChar == ' ') {
              // this can be for example:
              // BODY[]
              // BODY[HEADER]
              // but also:
              // BODY[HEADER.FIELDS (REFERENCES)]
              // BODY[HEADER.FIELDS.NOT (REFERENCES)]
              // --> read on until closing "]"
              separatorChar = ']';
            } else if (char == separatorChar) {
              // end of current word:
              if (separatorChar == ']') {
                // also include the closing ']' into the value:
                charIndex++;
              }
              var valueText = text.substring(startIndex, charIndex);
              current.addChild(ImapValue(valueText));
              isInValue = false;
            } else if (parentheses.isNotEmpty &&
                separatorChar == ' ' &&
                char == ')') {
              var valueText = text.substring(startIndex, charIndex);
              current.addChild(ImapValue(valueText));
              isInValue = false;
              parentheses.pop();
              current = current.parent;
            }
          } else if (char == '"') {
            separatorChar = char;
            startIndex = charIndex + 1;
            isInValue = true;
          } else if (char == '(') {
            var lastSibling =
                current.hasChildren ? current.children.last : null;
            ImapValue next;
            if (lastSibling != null &&
                _knownParenthizesDataItems.contains(lastSibling.value)) {
              lastSibling.children ??= <ImapValue>[];
              next = lastSibling;
              parentheses.put(ParenthizedListType.sibling);
            } else {
              next = ImapValue(null, true);
              current.addChild(next);
              parentheses.put(ParenthizedListType.child);
            }
            current = next;
          } else if (char == ')') {
            var lastType = parentheses.pop();
            if (current.parent != null) {
              current = current.parent;
            } else {
              print(
                  'Warning: no parent for closing parentheses, last parentheses type $lastType');
            }
          } else if (char != ' ') {
            isInValue = true;
            separatorChar = ' ';
            startIndex = charIndex;
          }
        }
        if (isInValue) {
          isInValue = false;
          var valueText = text.substring(startIndex);
          current.addChild(ImapValue(valueText));
        }
      }
      nextLineIsValueOnly = line.isWithLiteral;
    }
    if (parentheses.isNotEmpty) {
      print('Warning - some parentheses have not been closed: $parentheses');
      print(lines.toString());
    }
    return ImapValueIterator(root.children);
  }

  @override
  String toString() {
    var buffer = StringBuffer();
    for (var line in lines) {
      buffer.write(line.rawLine);
      buffer.write('\n');
    }
    return buffer.toString();
  }
}

class ImapValueIterator {
  final List<ImapValue> values;
  int _currentIndex = 0;
  ImapValue get current => values[_currentIndex];

  ImapValueIterator(this.values);

  bool next() {
    if (_currentIndex < values.length - 1) {
      _currentIndex++;
      return true;
    }
    return false;
  }
}

enum ParenthizedListType { child, sibling }

class ImapValue {
  ImapValue parent;
  String value;
  Uint8List data;
  List<ImapValue> children;
  ImapValue(this.value, [bool hasChildren = false]) {
    if (hasChildren) {
      children = <ImapValue>[];
    }
  }

  bool get hasChildren => children?.isNotEmpty ?? false;

  void addChild(ImapValue child) {
    children ??= <ImapValue>[];
    child.parent = this;
    children.add(child);
  }

  @override
  String toString() {
    return (value ?? '<null>') + (children != null ? children.toString() : '');
  }
}
