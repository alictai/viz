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
  
  int[] get_freqs(Range range, String gender) {
    int[] total = new int[NUM_WORDS];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_WORDS; j++) {
        if (gender.equals("female")) {
          total[j] += girls[i].word_freqs[j];
        } else if (gender.equals("male")) {
          total[j] += boys[i].word_freqs[j];
        } else {
          total[j] += girls[i].word_freqs[j];
          total[j] += boys[i].word_freqs[j];
        }
      }
    }
    
    return total;
  }
  
  int[] get_bar_stats(int word, Range range, String gender) {
     int[] age_intervals = new int[5];
     int[] toret = new int[5];
     int freq_range = range.high - range.low;
     
     int index = 0;
     for(int i = 0; j < range.high; i+=freq_range/5) {
         age_intervals[index] = i;
         index++;
     }
     
     for (int i = range.low; i < range.high; i++) {
        if (gender.equals("female")) {
          total[j] += girls[i].word_freqs[j];
        } else if (gender.equals("male")) {
          total[j] += boys[i].word_freqs[j];
        } else {
          total[j] += girls[i].word_freqs[j];
          total[j] += boys[i].word_freqs[j];
        }
      }
    }
  }
  
}
