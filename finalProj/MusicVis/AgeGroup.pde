class AgeGroup {
  final int NUM_QS = 20;
  final int NUM_WORDS = 82;
  boolean contains_data;
  int[]   word_freqs;    //size 80, each index = same word
  float[] total_q_score; 
  int[]   num_per_q; //if performance issues, fix this first
  
  AgeGroup() {
     word_freqs    = new int[NUM_WORDS];
     
     total_q_score   = new float[NUM_QS];
     
     num_per_q = new int[NUM_QS];
     
     contains_data = false; //handle this differently?
  }
  
  
}
