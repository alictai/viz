class Rectangle { // model dragging area
    PVector p1 = null;
    PVector p2 = null;

    Rectangle(float x1_, float y1_, float x2_, float y2_) {
        float x1 = x1_ < x2_ ? x1_ : x2_;
        float x2 = x1_ >= x2_ ? x1_ : x2_;
        float y1 = y1_ < y2_ ? y1_ : y2_;
        float y2 = y1_ >= y2_ ? y1_ : y2_;
        p1 = new PVector(x1, y1);
        p2 = new PVector(x2, y2);
    }
}
