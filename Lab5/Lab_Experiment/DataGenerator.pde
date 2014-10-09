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

    Data() {
        // NUM is a global varibale in support.pde
        data = new DataPoint[NUM];

        /**
         ** finish this: how to generate a dataset and mark two of the datapoints
         ** 
         **/
    }
    
        /**
         ** finish this: the rest methods and variables you may want to use
         ** 
         **/
}
