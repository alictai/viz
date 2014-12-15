class Cloud {
  boolean active;
  
  float x_coord;
  float y_coord;
  float hgt;
  float wid; 
  
  WordCram wc;
  UserData data;
  int freq_range;
  int prev_freq_range = 0;
  String gender = "female";
  
  String[] words = {"Uninspired","Sophisticated","Aggressive","Edgy","Sociable","Laid back","Wholesome",
    "Uplifting","Intriguing","Legendary","Free","Thoughtful","Outspoken","Serious","Good lyrics",
    "Unattractive","Confident","Old","Youthful","Boring","Current","Colourful","Stylish","Cheap",
    "Irrelevant","Heartfelt","Calm","Pioneer","Outgoing","Inspiring","Beautiful","Fun","Authentic",
    "Credible","Way out","Cool","Catchy","Sensitive","Mainstream","Superficial","Annoying","Dark",
    "Passionate","Not authentic","Good Lyrics","Background","Timeless","Depressing","Original",
    "Talented","Worldly","Distinctive","Approachable","Genius","Trendsetter","Noisy","Upbeat",
    "Relatable","Energetic","Exciting","Emotional","Nostalgic","None of these","Progressive","Sexy",
    "Over","Rebellious","Fake","Cheesy","Popular","Superstar","Relaxed","Intrusive","Unoriginal",
    "Dated","Iconic","Unapproachable","Classic","Playful","Arrogant","Warm","Soulful"};
  
  Cloud(WordCram w, UserData d) {
    wc = w;
    data = d;
  }
  
  int[] get_freqs(Range range, String gen) {
    int[] freqs = data.get_freqs(range, gender);
    gender = gen;
    
    freq_range = max(freqs) - min(freqs);
    
    return freqs;
  }
  
  void set_weights(WordCram w, int[] freqs) {
    wc = w;
    //wc.withColors(color(134, 56, 57), color(32, 68, 110), color(187, 5, 100));
    
    Word[] wordArray = new Word[words.length];
    for (int i = 0; i < words.length; i++) {
      wordArray[i] = new Word(words[i], freqs[i]);
      if (freqs[i] < freq_range/3) {
        wordArray[i].setProperty("value", "low");
      } else if (freqs[i] > 2*freq_range/3) {
        wordArray[i].setProperty("value", "high");
      } else {
        wordArray[i].setProperty("value", "medium");
      }
    }
    
    wc.fromWords(wordArray);
    wc.withColorer( new WordColorer() {
      public int colorFor(Word w) {
         if (w.getProperty("value") == "low") {
           return color(134, 56, 57);
         } else if (w.getProperty("value") == "medium") {
           return color(32, 68, 110);
         } else if (w.getProperty("value") == "high") {
           return color(187, 5, 100);
         }
         
         return 0;
      } 
    });
  }
  
  void draw_cloud() {
      if (freq_range != 0) {
          wc.drawAll();
          if (wc.hasMore()) {
            print("drawing more\n");
             wc.drawNext();
          }
          prev_freq_range = freq_range;
      }
      
  }
  
  boolean freq_changed() {
    if (freq_range == prev_freq_range) {
      return false;
    } else {
      return true;
    }
  }
  
  //code below for generating bar graphs
  
  void check_click() {
    Word clicked = wc.getWordAt(mouseX, mouseY);
    
    if (clicked == null) {
      print("no word clicked\n");
    } else {
      print(clicked, "\n");
      String[] split_line = splitTokens(clicked.toString(), " ");
      String word = split_line[0];
      int index = get_word_index(word);
      int[] bar_stats = data.get_bar_stats(index, gender);
      
    }
  }
  
  int get_word_index(String w) {
      for (int i = 0; i < words.length; i++) {
        if (w.equals(words[i])) {
          return i;
        }
      }
      return -1;
  }
}
