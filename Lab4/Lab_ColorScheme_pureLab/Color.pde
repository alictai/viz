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
            if (v1 - 100 > 0 || v1 < 0 || v2 - 98.254 > 0 || v2 + 86.185 < 0 || v3 - 94.482 > 0 || v3 + 107.863 < 0) {
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
            float ref_X = 95.047, ref_Y = 100.000, ref_Z = 108.883;
            L = channels[0].getValue();
            a = channels[1].getValue();
            b = channels[2].getValue();

            Y = (L + 16.0) / 116.0;
            X = a / 500.0 + Y;
            Z = Y - b / 200.0;

            if (pow(Y, 3) > 0.008856) {
                Y = pow(Y, 3);
            } else {
                Y = (Y - 16.0 / 116.0) / 7.787;
            }
            if (pow(X, 3) > 0.008856) {
                X = pow(X, 3);
            } else {
                X = (X - 16.0 / 116.0) / 7.787;
            }
            if (pow(Z, 3) > 0.008856) {
                Z = pow(Z, 3);
            } else {
                Z = (Z - 16.0 / 116.0) / 7.787;
            }

            X = ref_X * X;
            Y = ref_Y * Y;
            Z = ref_Z * Z;

            // from XYZ to RGB
            X = X / 100.0; //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
            Y = Y / 100.0; //Y from 0 to 100.000
            Z = Z / 100.0; //Z from 0 to 108.883

            R = X * 3.2406 + Y * -1.5372 + Z * -0.4986;
            G = X * -0.9689 + Y * 1.8758 + Z * 0.0415;
            B = X * 0.0557 + Y * -0.2040 + Z * 1.0570;

            if (R > 0.0031308) {
                R = 1.055 * (pow(R, (1.0 / 2.4))) - 0.055;
            } else {
                R = 12.92 * R;
            }
            if (G > 0.0031308) {
                G = 1.055 * (pow(G, (1.0 / 2.4))) - 0.055;
            } else {
                G = 12.92 * G;
            }
            if (B > 0.0031308) {
                B = 1.055 * (pow(B, (1.0 / 2.4))) - 0.055;
            } else {
                B = 12.92 * B;
            }


            R = rangeRGB(R * 255.0);
            G = rangeRGB(G * 255.0);
            B = rangeRGB(B * 255.0);

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
            float eps = 0.008856;

            float ref_X = 95.047; // reference white D65
            float ref_Y = 100.000;
            float ref_Z = 108.883;
            // D50 = {96.4212, 100.0, 82.5188};
            // D55 = {95.6797, 100.0, 92.1481};
            // D65 = {95.0429, 100.0, 108.8900};
            // D75 = {94.9722, 100.0, 122.6394};
            // RGB to XYZ
            r = channels[0].getValue() / 255.0; //R 0..1
            g = channels[1].getValue() / 255.0; //G 0..1
            b = channels[2].getValue() / 255.0; //B 0..1

            // assuming sRGB (D65)
            if (r <= 0.04045) {
                r = r / 12.92;
            } else {
                r = pow((r + 0.055) / 1.055, 2.4);
            }

            if (g <= 0.04045) {
                g = g / 12.92;
            } else {
                g = pow((g + 0.055) / 1.055, 2.4);
            }

            if (b <= 0.04045) {
                b = b / 12.92;
            } else {
                b = pow((b + 0.055) / 1.055, 2.4);
            }

            r = r * 100;
            g = g * 100;
            b = b * 100;

            //Observer. = 2°, Illuminant = D65
            X = 0.4124 * r + 0.3576 * g + 0.1805 * b;
            Y = 0.2126 * r + 0.7152 * g + 0.0722 * b;
            Z = 0.0193 * r + 0.1192 * g + 0.9505 * b;

            // XYZ to Lab
            X = X / ref_X;
            Y = Y / ref_Y;
            Z = Z / ref_Z;

            if (X > eps) {
                fx = pow(X, 1 / 3.0);
            } else {
                fx = (7.787 * X) + (16.0 / 116.0);
            }

            if (Y > eps) {
                fy = pow(Y, 1 / 3.0);
            } else {
                fy = (7.787 * Y + 16.0 / 116.0);
            }

            if (Z > eps) {
                fz = pow(Z, 1 / 3.0);
            } else {
                fz = (7.787 * Z + 16.0 / 116.0);
            }

            Ls = (116.0 * fy) - 16.0;
            as = 500.0 * (fx - fy);
            bs = 200.0 * (fy - fz);

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
                    if (preValue + value >= -86.185 && preValue + value <= 98.254) {
                        channels[channelIndex] = new ColorChannel(channels[channelIndex].getName(),
                            channels[channelIndex].getValue() + value);
                        return true;
                    } else {
                        println("In class Color, function increaseChannel, touch the bounds of CIELAB space.");
                        return false;
                    }
                }
                if (channelIndex == 2) {
                    if (preValue + value >= -107.863 && preValue + value <= 94.482) {
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
