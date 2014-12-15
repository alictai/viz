class UserData {
  final int MAXAGE = 95;
  final int NUM_QS = 19;
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
  
  int[] get_bar_stats(int word_index, String gender) {
     int[] toret = new int[MAXAGE];
     
     //just for testing
     gender = "both";
     
     for (int i = 0; i < MAXAGE; i++) {
        if (gender.equals("female")) {
          toret[i] = girls[i].word_freqs[word_index];
        } else if (gender.equals("male")) {
          toret[i] = boys[i].word_freqs[word_index];
        } else {
          toret[i] += girls[i].word_freqs[word_index];
          toret[i] += boys[i].word_freqs[word_index];
        }
        print(toret[i], "\n");
      }
      
      return toret;
   }
  
  float[][] get_qs_avg(Range range, String gender) {
    float[][] total = new float[NUM_QS][range.high-range.low];
    for (int i = range.low; i < range.high; i++) {
      for (int j = 0; j < NUM_QS; j++) {
        if (gender.equals("female")) {
          if(girls[i].num_per_q[j] == 0) {
            total[j][i] = 0;
          } else {
            total[j][i] = girls[i].total_q_score[j]/girls[i].num_per_q[j];
          }
        } else if (gender.equals("male")) {
          if(boys[i].num_per_q[j] == 0) {
            total[j][i] = 0;
          } else {
            total[j][i] = boys[i].total_q_score[j]/boys[i].num_per_q[j];
          }
        } else {
          if(girls[i].num_per_q[j] == 0) {
            total[j][i] = 0;
          } else {
            total[j][i] = girls[i].total_q_score[j]/girls[i].num_per_q[j];
          }

          if(boys[i].num_per_q[j] == 0) {
            total[j][i] += 0;
          } else {
            total[j][i] += boys[i].total_q_score[j]/boys[i].num_per_q[j];
          }
          total[j][i] = total[j][i]/2;
        }
        //printArray(girls[i].num_per_q);
      }
    }
    
    return total;
  }
}
