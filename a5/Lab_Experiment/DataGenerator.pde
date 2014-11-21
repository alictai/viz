class Data {
    class DataPoint {
        private float value = -1;
        private boolean marked = false;

        DataPoint(float f, boolean m) {
            this.value = f;
            this.marked = m;
        }

        boolean isMarked() {
            return marked;
        }

        void setMark(boolean b) {
            this.marked = b;
        }

        float getValue() {
            return this.value;
        }
        
    }
   
   private DataPoint[] data = null;
   
   int getLength() {
       return data.length;
   }
   
   float getVal(int i) {
       return data[i].getValue();
   }
   
   boolean isMarked(int i) {
       return data[i].isMarked();
   }

    Data() {
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];
        
        int marked1 = int(random(10));
        int marked2 = int(random(10));
        
        while (marked2 == marked1) {
          marked2 = int(random(10));
        }
        
        for (int i = 0; i < NUM; i++) {
          data[i] = new DataPoint(int(random(100)), (marked1==i)||(marked2==i));
        }
    }
    
        /**
         ** finish this: the rest methods and variables you may want to use
         ** 
         **/
}
