import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Lab_ColorScheme_pureLab extends PApplet {


/**
 * @author fyang@cs.tufts.edu
 * @since 2014-Aug-19
 * This is the entry of your color scheme
 */

 int margin = 20, marginLeft = 20, marginRight = 20, marginTop = 80, marginBottom = 20;

/**
 * the number of colors in your color scheme
 */
int numberOfColor = 8;

/**
 * the display size of your matrix
 */
int matrixWidth = 70, matrixHeight = 60;

int iWidth = numberOfColor * matrixWidth + marginLeft+ marginRight ;
int iHeight = numberOfColor * matrixHeight + marginTop + marginBottom;

/**
 * an importnt constant in helping detect unexcepted cases
 */
final int BADRETRUN = MIN_INT;

/**
 * change these two colors for needs
 */
int textInTop = color(0);
int textInDiag = color(0);

/**
 * your color scheme
 */
ColorScheme cs = null;

public void setup(){
    size(iWidth, iHeight);
    textAlign(LEFT);
    textSize(11);
    frame.setTitle("COMP150VIZ, Lab4 ColorScheme");
    example();
}

public void example(){
    // how to initialize a color scheme   
    Color[] colorsrr = new Color[numberOfColor];
    colorsrr[0] = new Color("RGB", 213,62,79);
    colorsrr[1] = new Color("RGB", 244,109,67);
    colorsrr[2] = new Color("RGB", 253,174,97);
    colorsrr[3] = new Color("RGB", 254,224,139);
    colorsrr[4] = new Color("RGB", 230,245,152);
    colorsrr[5] = new Color("RGB", 171,221,164);
    colorsrr[6] = new Color("RGB", 102,194,165);
    colorsrr[7] = new Color("RGB", 50,136,189);
   
    cs = new ColorScheme(colorsrr, "RGB");
    
    // print the distance matrix in current color space
    cs.printDistance();
    
    // convert the current color scheme to the other color space
    cs.toSpace("CIELAB");
    // print the string representation for a single color
    println(cs.colors[0].toString());
    println();
    // print the distance matrix
    cs.printDistance();
    println();
    
    // how to get a color in color scheme
    Color c = cs.getColor(0);
    // or
    c = cs.colors[0]; 
    println("1. " + c.toString());
  
    // how to get a channel value of a color
    println("2. " + cs.getColorChannel(0, 0));
    // or
    println("2. " + cs.colors[0].channels[0]);
    println();

    // how to get the distance between two colors in current color space  
    println("3. " + cs.getDistance(0, 1));
    // or
    println("3. " + cs.getColor(0).distance(cs.getColor(1)));
    println();
          
    // how to increase/decrease the value in a color channel
    boolean flag = cs.getColor(0).increaseChannel(0, 1); 
    println("4. " + flag + " in changing the channel"); // if flag == false, fail in increasing the value
    // do not recommend, you have to check the bound yourself
    cs.colors[0].channels[0].value += 1; 
    // or 
    cs.getColor(0).channels[0].value += -1;
    println();
    
    // convert the whole color scheme to another color space
    cs.toSpace("RGB");
    cs.printColors();
    println();

    // convert the whole color scheme to another color space
    cs.toSpace("CIELAB");
    cs.printColors();
    println();

    // draw on the screen
    cs.display();
}

/**
 * @author fyang@cs.tufts.edu
 * @since 2014-Aug-19
 * This is the class for colors and their behaviors <p>
 */
public class Color {
    /**
     * the name of the color space, either "RGB" or "CIELAB"
     */
    private String space = null;

    /**
     * the color channels of this color, including three channels <p>
     * for convenience, the channels are not private. you can edit these out of this class <p>
     * there is method to edit these channels and detect if you are out of color space.<p>
     * see below
     */
    ColorChannel[] channels = null;

    /**
     * @param spaceName the name of color space, either "RGB" or "CIELAB"
     * @param v1 the value of the first channel of this color, "RGB" between 0~255, "CIELAB" between 0~100
     * @param v2 the value of the second channel of this color, "RGB" between 0~255, "CIELAB" between -86.185~98.254
     * @param v3 the value of the third channel of this color, "RGB" between 0~255, "CIELAB" between -107.863~94.482<p>
     * when the values are out of the color space, the method will print out a warning. But the new instance is empty.<p>
     * when the color space name doesn't match, the medthod will print out a warning. The new instance is empty.
     */
    public Color(String spaceName, float v1, float v2, float v3) {
        if (spaceName.equals("RGB")) {
            if (v1 > 255 || v1 < 0 || v2 > 255 || v2 < 0 || v3 > 255 || v3 < 0) {
                println("In class color, find out of bounds when making the RGB color." +
                    " v1 = " + v1 + ", v2 = " + v2 + ", v3 = " + v3);
                return;
            }
            channels = new ColorChannel[3];
            channels[0] = new ColorChannel("R", v1);
            channels[1] = new ColorChannel("G", v2);
            channels[2] = new ColorChannel("B", v3);
            space = spaceName;
        } else if (spaceName.equals("CIELAB")) {
            if (v1 - 100 > 0 || v1 < 0 || v2 - 98.254f > 0 || v2 + 86.185f < 0 || v3 - 94.482f > 0 || v3 + 107.863f < 0) {
                println("In class color, find out of bounds when making CIELAB." +
                    " v1 = " + v1 + ", v2 = " + v2 + ", v3 = " + v3);
                return;
            }
            channels = new ColorChannel[3];
            channels[0] = new ColorChannel("L", v1);
            channels[1] = new ColorChannel("a", v2);
            channels[2] = new ColorChannel("b", v3);
            space = spaceName;
        } else {
            println("In class Color, don't know what is " + spaceName);
        }
    }

    /**
     * deep clone this instance
     * @return a deep copy of this instance
     */
    public Color clone() {
       if(channels == null || space == null){
            println("In class Color, function clone, the color is not initialized!");
            return null;
        }
        return new Color(space, channels[0].getValue(), channels[1].getValue(), channels[2].getValue());
    }

    /**
     * get the responding color in RGB color space<p>
     * this color doesn't change<p>
     * @return get this color in RGB color space <p> no matter what's color space this color is in.
     */
    public Color getRGBColor() {
        if(channels == null || space == null){
            println("In class Color, function getRGB, the color is not initialized!");
            return null;
        }
        Color c = this.clone();
        c.toRGB();
        return c;
    }

    /**
     * get the responding color in CIELAB color space<p>
     * this color doesn't change<p>
     * @return get this color in CIELAB color space <p> no matter what's color space this color is in.
     */
    public Color getCIELABColor() {
        if(channels == null || space == null){
            println("In class Color, function getCIELAB, the color is not initialized!");
            return null;
        }
        Color c = this.clone();
        c.toCIELAB();
        return c;
    }

    /**
     * convert this color to RGB color space <p>
     * <b>!warning</b>: the color space and the values of color channels of this color will change after calling this method<p>
     * <b>!warning</b>: if a result color channel is out of range(<0 or >255), the method will automatically set the color channel to 0 or 255<p>
     * see code and comment below if you want to change.
     */
    public void toRGB() {
        if(channels == null || space == null){
            println("In class Color, function toRGB, the color is not initialized!");
            return;
        }
        if (space.equals("RGB")) {
            return;
        } else if (space.equals("CIELAB")) {
            // from LAB to XYZ color space
            float X, Y, Z, L, a, b, R, G, B;
            float ref_X = 95.047f, ref_Y = 100.000f, ref_Z = 108.883f;
            L = channels[0].getValue();
            a = channels[1].getValue();
            b = channels[2].getValue();

            Y = (L + 16.0f) / 116.0f;
            X = a / 500.0f + Y;
            Z = Y - b / 200.0f;

            if (pow(Y, 3) > 0.008856f) {
                Y = pow(Y, 3);
            } else {
                Y = (Y - 16.0f / 116.0f) / 7.787f;
            }
            if (pow(X, 3) > 0.008856f) {
                X = pow(X, 3);
            } else {
                X = (X - 16.0f / 116.0f) / 7.787f;
            }
            if (pow(Z, 3) > 0.008856f) {
                Z = pow(Z, 3);
            } else {
                Z = (Z - 16.0f / 116.0f) / 7.787f;
            }

            X = ref_X * X;
            Y = ref_Y * Y;
            Z = ref_Z * Z;

            // from XYZ to RGB
            X = X / 100.0f; //X from 0 to  95.047      (Observer = 2\u00b0, Illuminant = D65)
            Y = Y / 100.0f; //Y from 0 to 100.000
            Z = Z / 100.0f; //Z from 0 to 108.883

            R = X * 3.2406f + Y * -1.5372f + Z * -0.4986f;
            G = X * -0.9689f + Y * 1.8758f + Z * 0.0415f;
            B = X * 0.0557f + Y * -0.2040f + Z * 1.0570f;

            if (R > 0.0031308f) {
                R = 1.055f * (pow(R, (1.0f / 2.4f))) - 0.055f;
            } else {
                R = 12.92f * R;
            }
            if (G > 0.0031308f) {
                G = 1.055f * (pow(G, (1.0f / 2.4f))) - 0.055f;
            } else {
                G = 12.92f * G;
            }
            if (B > 0.0031308f) {
                B = 1.055f * (pow(B, (1.0f / 2.4f))) - 0.055f;
            } else {
                B = 12.92f * B;
            }


            R = rangeRGB(R * 255.0f);
            G = rangeRGB(G * 255.0f);
            B = rangeRGB(B * 255.0f);

            /*
             * the using of rangeRGB will set the value which <0 (or >255) to 0 (or 255) respectively.
             * you can use the int() code instead if you want to detect when it is out of bounds.
             */

            /*
              R = (R * 255.0);
              G = (G * 255.0);
              B = (B * 255.0);
             */
            space = "RGB";
            channels[0] = new ColorChannel("R", R);
            channels[1] = new ColorChannel("G", G);
            channels[2] = new ColorChannel("B", B);
        }
    }

    /**
     * set a value which is out of 0-255 to (0 or 255)
     * private method, you can't see this method in the javadoc ;)
     */
    private float rangeRGB(float n) {
        if (n <= 255 && n >= 0)
            return n;
        if (n > 255) {
            println("a color channel is out of RGB space");
            return 255;
        } else {
            println("a color channel is out of RGB space");
            return 0;
        }
    }

    /**
     * convert this color to be the color in the CIELAB color space <p>
     * <b>!warning</b>: the color space and the values of color channels of this color will change after calling this method<p>
     * <b>!warning</b>: assume white D65
     */
    public void toCIELAB() {
        if(channels == null || space == null){
            println("In class Color, function toCIELAB, the color is not initialized!");
            return;
        }
        if (space == "CIELAB") {
            return;
        } else if (space == "RGB") {
            // RGB to XYZ
            float r, g, b, X, Y, Z, fx, fy, fz;
            float Ls, as, bs;
            float eps = 0.008856f;

            float ref_X = 95.047f; // reference white D65
            float ref_Y = 100.000f;
            float ref_Z = 108.883f;
            // D50 = {96.4212, 100.0, 82.5188};
            // D55 = {95.6797, 100.0, 92.1481};
            // D65 = {95.0429, 100.0, 108.8900};
            // D75 = {94.9722, 100.0, 122.6394};
            // RGB to XYZ
            r = channels[0].getValue() / 255.0f; //R 0..1
            g = channels[1].getValue() / 255.0f; //G 0..1
            b = channels[2].getValue() / 255.0f; //B 0..1

            // assuming sRGB (D65)
            if (r <= 0.04045f) {
                r = r / 12.92f;
            } else {
                r = pow((r + 0.055f) / 1.055f, 2.4f);
            }

            if (g <= 0.04045f) {
                g = g / 12.92f;
            } else {
                g = pow((g + 0.055f) / 1.055f, 2.4f);
            }

            if (b <= 0.04045f) {
                b = b / 12.92f;
            } else {
                b = pow((b + 0.055f) / 1.055f, 2.4f);
            }

            r = r * 100;
            g = g * 100;
            b = b * 100;

            //Observer. = 2\u00b0, Illuminant = D65
            X = 0.4124f * r + 0.3576f * g + 0.1805f * b;
            Y = 0.2126f * r + 0.7152f * g + 0.0722f * b;
            Z = 0.0193f * r + 0.1192f * g + 0.9505f * b;

            // XYZ to Lab
            X = X / ref_X;
            Y = Y / ref_Y;
            Z = Z / ref_Z;

            if (X > eps) {
                fx = pow(X, 1 / 3.0f);
            } else {
                fx = (7.787f * X) + (16.0f / 116.0f);
            }

            if (Y > eps) {
                fy = pow(Y, 1 / 3.0f);
            } else {
                fy = (7.787f * Y + 16.0f / 116.0f);
            }

            if (Z > eps) {
                fz = pow(Z, 1 / 3.0f);
            } else {
                fz = (7.787f * Z + 16.0f / 116.0f);
            }

            Ls = (116.0f * fy) - 16.0f;
            as = 500.0f * (fx - fy);
            bs = 200.0f * (fy - fz);

            space = "CIELAB";
            channels[0] = new ColorChannel("L", Ls);
            channels[1] = new ColorChannel("a", as);
            channels[2] = new ColorChannel("b", bs);
        }
    }

    /**
     * @return String the name of current color space
     */
    public String getSpaceName() {
        if(channels == null || space == null){
            println("In class Color, function getSpaceName, the color is not initialized!");
            return null;
        }
        return space;
    }

    /**
     * get the distance between this instance and another color
     * @param c another Color
     * @return distance between two colors, in two decimals format
     * <b>!warning</b>: the color space of two colors has to match with each other. <p>
     * <p>when the name of color space doesn't match, the method will print a warning message and return "BADRETRUN" <p>
     * <p>when the colors haven't been initialzed, the method will print a warning message and return "BADRETRUN"
     */
    public float distance(Color c) {
        String spaceName = c.getSpaceName();
        if (spaceName != null && c.channels != null && channels != null && space.equals(spaceName)) {
            float distance = dist(channels[0].getValue(), channels[1].getValue(), channels[2].getValue(),
                c.channels[0].getValue(), c.channels[1].getValue(), c.channels[2].getValue());
            return distance;
        } else if (c.channels == null || channels == null || spaceName == null) {
            println("In class Color, function distance, the colors are not initialized!");
            return BADRETRUN;
        } else {
            println("In class Color, function distance, the type of color space doesn't macth!");
            return BADRETRUN;
        }
    }

    /**
     * increase a channel of this color by some amount of value
     * @param channelIndex the index of the color channel you want to increase, in {0, 1, 2}
     * @param value the value you want to add, can be negative
     * @return boolean if your increase touch the bounds
     * when the index is not in {0, 1, 2}, the method will print out a warning method and return false <p>
     * when the result touch the bounds of the color space, the method will print out a warning method and return false. <b> the value won't be added to the channel.</b> <p>
     * <b>!warning</b>: for convenience, I don't set the channels to be private (you can't directly edit the channels). you can avoid using the method. <p>
     * however, if you edit the channels directly, please make sure you are not out of color space. 
     */
    public boolean increaseChannel(int channelIndex, int value) {
        if(channels == null || space == null){
            println("In class Color, function increaseChannel, the colors are not initialized!");
            return false;
        }
        if (channelIndex >= 0 && channelIndex < 3) {
            float preValue = channels[channelIndex].getValue();
            if (space.equals("RGB")) {
                if (preValue + value <= 255 && preValue + value >= 0) {
                    channels[channelIndex] = new ColorChannel(channels[channelIndex].getName(),
                        channels[channelIndex].getValue() + value);
                    return true;
                } else {
                    println("In class Color, function increaseChannel, touch the bounds of RGB space.");
                    return false;
                }
            } else if (space.equals("CIELAB")) {
                preValue = channels[channelIndex].getValue();
                if (channelIndex == 0) {
                    if (preValue + value >= 0 && preValue + value <= 100) {
                        channels[channelIndex] = new ColorChannel(channels[channelIndex].getName(),
                            channels[channelIndex].getValue() + value);
                        return true;
                    } else {
                        println("In class Color, function increaseChannel, touch the bounds of CIELAB space.");
                        return false;
                    }
                }
                if (channelIndex == 1) {
                    if (preValue + value >= -86.185f && preValue + value <= 98.254f) {
                        channels[channelIndex] = new ColorChannel(channels[channelIndex].getName(),
                            channels[channelIndex].getValue() + value);
                        return true;
                    } else {
                        println("In class Color, function increaseChannel, touch the bounds of CIELAB space.");
                        return false;
                    }
                }
                if (channelIndex == 2) {
                    if (preValue + value >= -107.863f && preValue + value <= 94.482f) {
                        channels[channelIndex] = new ColorChannel(channels[channelIndex].getName(),
                            channels[channelIndex].getValue() + value);
                        return true;
                    } else {
                        println("In class Color, function increaseChannel, touch the bounds of CIELAB space.");
                        return false;
                    }
                }
                println("In class Color, function increaseChannel, find incorrect parameters!");
                return false;
            }
        }
        println("In class Color, function increaseChannel, find incorrect parameters!");
        return false;
    }
    /**
     * get the value of a channel of this color
     * @param index the index of the color channel you want to increase, in {0, 1, 2}
     * @return the value of the channel
     * when the index is not in {0, 1, 2}, the method will print out a warning method and return "BADRETURN" <p>
     */
   public float getChannelValue(int index) {
        if(channels == null || space == null){
            println("In class Color, function getChannelValue, the color is not initialized!");
            return BADRETRUN;
        }
        if (index < channels.length && index >= 0) {
            return channels[index].getValue();
        }
        println("In class Color, function getChannelValue, find out of bounds!");
        return BADRETRUN;

    }    

    /**
     * get the string represention of a channel of this color
     * @override toString()
     * @return the string represention
     */

    public String toString() {
        if(channels == null || space == null){
            println("In class Color, function toString, the color is not initialized!");
            return null;
        }
        return channels[0].getName() + " = " + channels[0].getValue() + ", " + channels[1].getName() + " = " + channels[1].getValue() + ", " + channels[2].getName() + " = " + channels[2].getValue();
    }
}
/**
 * @author fyang@cs.tufts.edu
 * @since 2014-Aug-19
 * This is the class to model a color channel.
 */
public class ColorChannel{
      /**
       * the color space which this channel is in
       */
      private String name = null;

      /**
       * for convenience, this value is float private. you can edit this value out of this class. <p>
       * but you'd better detect if you are out of space!<p>
       * the increaseChannel() in class Color could edit the value of a channel and detect bounds.
       */
      float value = MIN_FLOAT;

      /**
       * @param str the name of this channel, in {R, G, B} or {L, a, b}. I don't detect the unexcepted input here.
       * @param v the value of this channel. I don't detect the unexcepted input here.<p>
       * I detect in the class Color
       */
      public ColorChannel(String str, float v){
          name = str;
          value = v;        
      }
      
      /**
       * get the value of this channel <p>
       * you can use channel.value instead
       * @return the value of this channel
       */
      public float getValue(){
          return value;
      }

      /**
       * get the name of this channel
       * @return the name of this channel
       */
      public String getName(){
          return name;
      }

      /** 
       * get the string representation of this channel
       * @return the string of this channel
       */
      public String toString(){
         return name + " = " + nfc(value, 2);
      }
 }
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
        text("Distance in " + space + " space", margin, iHeight - 0.1f * marginBottom);

        float[] avgSd = getAvgSd();
        text("Average: " + avgSd[0], marginLeft + 0.35f * iWidth, iHeight - 0.1f * marginBottom);
        text("Standard deviation: " + avgSd[1], marginLeft + 0.6f * iWidth, iHeight - 0.1f * marginBottom);

        // draw color values of all colors in this color scheme in current color space
        for (int i = 0; i < colors.length; i++) {
            Color c = colors[i];

            fill(textInTop);
            textAlign(CENTER);
            text(c.channels[0].toString(), (i + 0.5f) * matrixWidth + marginLeft, marginLeft * 0.75f);
            text(c.channels[1].toString(), (i + 0.5f) * matrixWidth + marginLeft, marginLeft * 1.75f);
            text(c.channels[2].toString(), (i + 0.5f) * matrixWidth + marginLeft, marginLeft * 2.75f);
        }

        // convert to RGB color space
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
                text(nfc(distanceMatrix[i][j], 3), marginLeft + (i + 0.5f) * matrixWidth, (j + 0.6f) * matrixHeight + marginTop);
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
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Lab_ColorScheme_pureLab" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
