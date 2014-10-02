/**
 * @author fyang@cs.tufts.edu
 * @since 2014-Aug-19
 * This is the class to model a color scheme
 */
 
public class ColorScheme {
    /**
     * the colors in this color scheme
     * for convenience, these are not private, you can edit them directly
     */
    Color[] colors = null;

    /**
     * the distance matrix of this color scheme
     * for convenience, these are not private, you can visit them directly
     */
    float[][] distanceMatrix = null;

    /**
     * the color space this color scheme
     */
    private String space;

    /**
     * @param colors the colors in the color scheme
     * @param str the color space of this color scheme <p>
     * <b>!warning</b>: the color space of each color must match the str. otherwise, the program will exit (this is a big error)
     */
    public ColorScheme(Color[] colors, String str) {
        this.colors = colors;
        for (int i = 0; i < colors.length; i++)
            if (!str.equals(colors[i].getSpaceName())) {
                println("In class ColorScheme, the color space doesn't macth!");
                exit();
            }
        space = str;
    }

    /**
     * get the deep clone of this object
     * @override clone
     * @return the deep copy of this instance 
     */
    public ColorScheme clone() {
        Color[] colorss = new Color[schemeSize()];
        for (int i = 0; i < colors.length; i++) {
            colorss[i] = colors[i].clone();
        }
        return new ColorScheme(colorss, new String(space));
    }

    /**
     * compute the distance maxtrix of this color scheme
     * @return boolean return if succeed in computing 
     */
    public boolean computeDistance() {
        float[][] distanceMatrixTmp = new float[colors.length][colors.length];
        for (int i = 0; i < colors.length; i++) {
            String spaceNamei = colors[i].getSpaceName();
            for (int j = 0; j < colors.length; j++) {
                String spaceNamej = colors[j].getSpaceName();
                if (spaceNamei.equals(spaceNamej)) {
                    distanceMatrixTmp[i][j] = colors[i].distance(colors[j]);
                } else {
                    // you won't reach here
                    println("In class ColorScheme, function computeDistance, the space type doesn't match!");
                    return false;
                }
            }
        }
        distanceMatrix = distanceMatrixTmp;
        return true;
    }

    /**
     * print out a title and the distance matrix of this color scheme <p>
     * <b>!warning</b>: this medthod will call computeDistance first. you don't have to call computeDistance before you print. 
     */
    public void printDistance() {
        boolean flag = computeDistance();
        if (!flag) {
            return;
        }
        println("The distance matrix in " + colors[0].getSpaceName());

        for (int i = 0; i < colors.length; i++) {
            for (int j = 0; j < colors.length; j++) {
                print(distanceMatrix[i][j] + " \t\t");
            }
            println();
        }
    }

    /**
     * print out a title and the String representation of this color scheme (all colors) <p>
     */
    public void printColors() {
        println("The colors in " + space + " space: ");

        for (int i = 0; i < colors.length; i++) {
            println(i + " " + colors[i].toString() + " \t\t");
        }
    }

    /**
     * convert the whole color scheme to another color space
     * @param space the name of the target color space, in {RGB, CIELAB}<p>
     * <b>!warning</b>: the space and colors will change if you call this method directly. <p>
     * if you don't want to change the space and colors, you should call clone() first to get a copy
     */
    public void toSpace(String space) {
        if (space.equals("RGB")) {
            for (int i = 0; i < colors.length; i++) {
                colors[i].toRGB();
            }
            this.space = "RGB";
        } else if (space.equals("CIELAB")) {
            for (int i = 0; i < colors.length; i++) {
                colors[i].toCIELAB();
            }
            this.space = "CIELAB";
        } else {
            println("In class ColorScheme, function toSpace, don't know what is " + space);
        }
    }

    /**
     * get a certain color
     * @param index the index of the color space in this color scheme
     * @return the target Color<p>
     * the colors are not private, you can visit the color directly<p>
     * this method only check bounds for you<p>
     * this method will return null if the index is out of bounds
     */
    public Color getColor(int index) {
        if (index >= 0 && index <= colors.length - 1) {
            return colors[index];
        }
        println("In class ColorScheme, function getColor, find out of bounds!");
        return null;
    }

    /**
     * get a color channel of a certain color
     * @param index the index of the color space in this color scheme
     * @param channel the index of the channel
     * @return the value of the target channel<p>
     * the colors and channels are not private, you can visit the color directly <p>
     * this method only check bounds for you<p>
     * this method will return BADRETRUN if the index is out of bounds
     */
    public float getColorChannel(int index, int channel) {
        if (index >= 0 && index < colors.length) {
            return colors[index].getChannelValue(channel);
        }
        println("In class ColorScheme, function getColorChannel, find out of bounds!");
        return BADRETRUN;
    }

    /**
     * get the distance between two colors in this color scheme
     * @param i the index of the first color
     * @param j the index of the second color
     * @return the distance between two colors in this color scheme
     * this method will return BADRETRUN if an index is out of bounds<p>
     * the colors and channels are not private, you can visit the color directly and call distance() in class Color <p>
     * this method only check bounds for you <p>
     * <b>!warning</b>: this method will call computeDistance()
     * @see computeDistance()
     */
    public float getDistance(int i, int j) {
        boolean flag = computeDistance();
        if (flag) {
            if (i < colors.length && i >= 0 && j >= 0 && j < colors.length) {
                return distanceMatrix[i][j];
            } else {
                println("In class ColorScheme, function getDisatance, find out of bounds!");
                return BADRETRUN;
            }
        }
        return BADRETRUN;
    }

    /**
     * get the average and variance across all 8 colors in this color scheme
     * @return float[] float[0] is average, float[1] is standard deviation <p>
     * <b>!warning</b>: this method will call computeDistance()
     * @see computeDistance()
     */
    public float[] getAvgSd() {
        if (!(distanceMatrix == null)) {
            computeDistance();
        }
        float sum = 0;
        int count = 1;
        for (int i = 0; i < colors.length; i++) {
            for (int j = 0; j < i; j++) {
                sum += distanceMatrix[i][j];
                count++;
            }
        }

        float avg = sum / count;
        float[] array = new float[2];

        float sumvar = 0;
        for (int i = 0; i < colors.length; i++) {
            for (int j = 0; j < i; j++) {
                sumvar += sq(avg - distanceMatrix[i][j]);
            }
        }
        float sd = sqrt(sumvar / (count - 1));

        array[0] = avg;
        array[1] = sd;
        return array;
    }

    /**
     * draw this color scheme on screen<p>
     * <b>!warning</b>: this method will call computeDistance()
     * @see computeDistance()
     */
    public void display() {
        pushStyle();
        background(255, 255, 255);
        noStroke();

        // compute current distance matrix across all colors in this color scheme
        computeDistance();

        fill(0);
        text("Distance in " + space + " space", margin, iHeight - 0.1 * marginBottom);

        float[] avgSd = getAvgSd();
        text("Average: " + avgSd[0], marginLeft + 0.35 * iWidth, iHeight - 0.1 * marginBottom);
        text("Standard deviation: " + avgSd[1], marginLeft + 0.6 * iWidth, iHeight - 0.1 * marginBottom);

        // draw color values of all colors in this color scheme in current color space
        // Label: draw color values
        for (int i = 0; i < colors.length; i++) {
            Color c = colors[i];

            fill(textInTop);
            textAlign(CENTER);
            text(c.channels[0].toString(), (i + 0.5) * matrixWidth + marginLeft, marginLeft * 0.75);
            text(c.channels[1].toString(), (i + 0.5) * matrixWidth + marginLeft, marginLeft * 1.75);
            text(c.channels[2].toString(), (i + 0.5) * matrixWidth + marginLeft, marginLeft * 2.75);
        }

        // convert to RGB color space
        // if you want to see the RGB values, then put this line before Label: draw color values
        toSpace("RGB");

        // draw color blocks on diagonal
        for (int i = 0; i < colors.length; i++) {
            Color c = colors[i];
            fill(c.getChannelValue(0), c.getChannelValue(1), c.getChannelValue(2));
            rect(i * matrixWidth + marginLeft, i * matrixHeight + marginTop, matrixWidth, matrixHeight);
        }

        // draw color blocks in the top and left
        for (int i = 0; i < colors.length; i++) {
            Color c = colors[i];
            fill(getColorChannel(i, 0), getColorChannel(i, 1), getColorChannel(i, 2));
            rect(i * matrixWidth + marginLeft, marginTop - marginLeft, matrixWidth, marginLeft);
            rect(0, i * matrixHeight + marginTop, marginLeft, matrixHeight);
        }
        
        // draw horizontal and vertical lines
        for (int i = 0; i <= colors.length; i++) {
            stroke(1);
            line(marginLeft, marginTop + i * matrixHeight, iWidth - marginLeft , marginTop + i * matrixHeight);
            line(marginLeft + i * matrixWidth, 0, marginLeft + i * matrixWidth, iHeight - marginBottom);
        }

        // draw distance in each cell
        for (int i = 0; i < colors.length; i++) {
            for (int j = 0; j < colors.length; j++) {
                fill(textInDiag);
                textAlign(CENTER);
                text(nfc(distanceMatrix[i][j], 3), marginLeft + (i + 0.5) * matrixWidth, (j + 0.6) * matrixHeight + marginTop);
            }
        }
        popStyle();
    }

    /**
     * get the size of this color scheme
     * @return int the size of this color scheme (how many colors)
     */
    public int schemeSize() {
        return colors.length;
    }
}
