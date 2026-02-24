/// Maps task/commitment titles to relevant emojis
///
/// This utility analyzes the title text and returns an appropriate emoji
/// based on keywords found in the title.
class EmojiMapper {
  /// Map of keywords to emojis
  /// The key is a list of related keywords, value is the emoji
  static const Map<List<String>, String> _keywordEmojiMap = {
    // Health & Fitness
    ['walk', 'walking', 'steps', 'stroll']: '👟',
    ['run', 'running', 'jog', 'jogging']: '🏃',
    ['exercise', 'workout', 'gym', 'fitness', 'training']: '💪',
    ['yoga', 'stretch', 'stretching']: '🧘',
    ['swim', 'swimming', 'pool']: '🏊',
    ['bike', 'cycling', 'bicycle']: '🚴',
    ['hike', 'hiking', 'mountain']: '🥾',

    // Mindfulness & Wellness
    ['meditate', 'meditation', 'mindful', 'mindfulness']: '🧘‍♂️',
    ['breathing', 'breath', 'breathe']: '🌬️',
    ['sleep', 'rest', 'nap']: '😴',
    ['water', 'hydrate', 'drink']: '💧',
    ['healthy', 'health', 'wellness']: '❤️',

    // Learning & Reading
    ['read', 'reading', 'book', 'books']: '📚',
    ['study', 'studying', 'learn', 'learning']: '📖',
    ['write', 'writing', 'journal', 'journaling']: '✍️',
    ['language', 'spanish', 'french', 'english', 'duolingo']: '🗣️',

    // Productivity & Work
    ['code', 'coding', 'programming', 'develop']: '💻',
    ['work', 'task', 'tasks', 'project']: '📋',
    ['email', 'emails', 'inbox']: '📧',
    ['meeting', 'call', 'calls']: '📞',
    ['plan', 'planning', 'organize']: '📅',

    // Creative
    ['draw', 'drawing', 'sketch', 'art']: '🎨',
    ['music', 'practice', 'instrument', 'piano', 'guitar']: '🎵',
    ['photo', 'photography', 'camera']: '📷',
    ['design', 'designing']: '🖌️',

    // Home & Lifestyle
    ['clean', 'cleaning', 'tidy']: '🧹',
    ['cook', 'cooking', 'meal', 'food']: '🍳',
    ['garden', 'gardening', 'plant', 'plants']: '🌱',
    ['laundry', 'clothes', 'wash']: '👕',

    // Social & Communication
    ['call', 'phone', 'family', 'friend', 'friends']: '📱',
    ['gratitude', 'grateful', 'thankful', 'thanks']: '🙏',
    ['smile', 'happy', 'positive']: '😊',

    // Finance
    ['save', 'saving', 'money', 'budget']: '💰',
    ['invest', 'investing', 'stocks']: '📈',

    // Spiritual
    ['pray', 'prayer', 'praying', 'church', 'worship']: '🙏',
    ['bible', 'scripture', 'devotion']: '📖',
  };

  /// Default emoji when no match is found
  static const String _defaultEmoji = '✨';

  /// Get an emoji based on the task title
  ///
  /// Analyzes the title for keywords and returns the most relevant emoji.
  /// Returns a default sparkle emoji if no keywords match.
  static String getEmoji(String title) {
    final lowerTitle = title.toLowerCase();

    for (final entry in _keywordEmojiMap.entries) {
      for (final keyword in entry.key) {
        if (lowerTitle.contains(keyword)) {
          return entry.value;
        }
      }
    }

    return _defaultEmoji;
  }

  /// Get emoji with fallback icon
  ///
  /// Returns both an emoji and a Flutter icon as fallback
  static ({String emoji, int iconCodePoint}) getEmojiWithIcon(String title) {
    final emoji = getEmoji(title);

    // Map emojis to Material Icons code points as fallback
    const emojiToIcon = {
      '👟': 0xe566, // Icons.directions_walk
      '🏃': 0xe566, // Icons.directions_run
      '💪': 0xe3e6, // Icons.fitness_center
      '🧘': 0xeb43, // Icons.self_improvement
      '📚': 0xe26f, // Icons.menu_book
      '💻': 0xe31e, // Icons.laptop
      '✍️': 0xe22b, // Icons.edit
      '🎨': 0xe40a, // Icons.palette
      '🎵': 0xe405, // Icons.music_note
      '😴': 0xef44, // Icons.bedtime
      '💧': 0xe798, // Icons.water_drop
      '🧹': 0xe16c, // Icons.cleaning_services
      '🍳': 0xe56a, // Icons.restaurant
      '🌱': 0xea35, // Icons.eco
      '✨': 0xe838, // Icons.star (default)
    };

    return (emoji: emoji, iconCodePoint: emojiToIcon[emoji] ?? 0xe838);
  }
}
