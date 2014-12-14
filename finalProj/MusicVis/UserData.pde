class UserData {
  final int MAXAGE = 95;
  final int NUM_QS = 20;
  final int NUM_WORDS = 82;
  
  AgeGroup[] boys;
  AgeGroup[] girls;
  
  
  UserData() {
    boys = new AgeGroup[MAXAGE];
    girls = new AgeGroup[MAXAGE];
    
    for (int i = 0; i < MAXAGE; i++) {
      girls[i] = new AgeGroup();
      boys[i] = new AgeGroup();
    }
  }
  
  int[] get_girl_freqs(Range range) {
    int[] total = new int[NUM_WORDS];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_WORDS; j++) {
        total[j] += girls[i].word_freqs[j];
      }
    }
    
    return total;
  }
  
  int[] get_boy_freqs(Range range) {
    int[] total = new int[NUM_WORDS];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_WORDS; j++) {
        total[j] += boys[i].word_freqs[j];
      }
    }
    
    return total;
  }
  
  int[] get_both_freqs(Range range) {
    int[] total = new int[NUM_WORDS];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_WORDS; j++) {
        total[j] += girls[i].word_freqs[j];
        total[j] += boys[i].word_freqs[j];
      }
    }
    
    return total;
  }
  
}
