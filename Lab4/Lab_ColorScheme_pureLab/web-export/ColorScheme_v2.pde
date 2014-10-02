public class ColorScheme {
    Color[] colors;
    float[][] distanceMatrix;
    private String space;

    public ColorScheme(Color[] colors, String str) {
        this.colors = colors;
        for(int i = 0; i < colors.length; i++)
        if(!str.equals(colors[i].getSpaceName())){
            println("In class ColorScheme, the color space doesn't macth!");
            exit();
        }
        space = str;
    }
    
    public ColorScheme clone(){
        Color[] colorss = new Color[schemeSize()];
        for (int i = 0; i < colors.length; i++) {
            colorss[i] = colors[i].clone();
        }
        return new ColorScheme(colorss, new String(space));
    }
    
    public boolean computeDistance() {
        float[][] distanceMatrixTmp = new float[colors.length][colors.length];

        for (int i = 0; i < colors.length; i++) {
            String spaceNamei = colors[i].getSpaceName();
            for (int j = 0; j < colors.length; j++) {
                String spaceNamej = colors[j].getSpaceName();
                if (spaceNamei.equals(spaceNamej)) {
                    distanceMatrixTmp[i][j] = colors[i].distance(colors[j]);
                } else {
                    println("In class ColorScheme, function computeDistance, the space type doesn't match!");
                    return false;
                }
            }
        }
        distanceMatrix = distanceMatrixTmp;
        return true;
    }

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
    
    public void printColors() {
        println("The colors in " + space + " space: ");

        for (int i = 0; i < colors.length; i++) {
            println(colors[i].toString()+ " \t\t");
        }
    }

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

    public Color getColor(int index) {
        if (index >= 0 && index <= colors.length - 1) {
            return colors[index];
        }
        println("In class ColorScheme, function getColor, find out of boundary!");
    }

    public int getColorChannel(int index, int channel) {
        if (index >= 0 && index < colors.length) {
            return colors[index].getChannelValue(channel);
        } else {
            println("In class ColorScheme, function getColorChannel, find out of boundary!");
            return BADRETRUN;
        }
    }

    public float getDistance(int i, int j) {
        boolean flag = computeDistance();
        if (flag) {
            if (i < colors.length && i >= 0 && j >= 0 && j < colors.length) {
                return distanceMatrix[i][j];
            } else {
                println("In class ColorScheme, function getDisatance, find out of boundary!");
                return BADRETRUN;
            }
        }
        return BADRETRUN;
    }

     public float[] getAvgVar(){
        if(!distanceMatrix){
           computeDistance();
        }
        float sum = 0;
        int count = 1;
        for(int i = 0; i < colors.length; i++){
            for(int j = 0; j < i; j++){
              sum += distanceMatrix[i][j];
              count++;           
            }
        }
        
        float avg = round(100 * sum / count)/100.0;
        float[] array = new float[2];
        
        float sumvar = 0;
        for(int i = 0; i < colors.length; i++){
            for(int j = 0; j < i; j++){
              sumvar += sq(avg - distanceMatrix[i][j]);        
            }
        }
        float variance = round(100 * sqrt(sumvar / (count - 1)))/100.0;
        
        array[0] = avg;
        array[1] = variance;
        return array;     
     }
     
     public void display() {
        pushStyle();
        noStroke();
        computeDistance();
        fill(0);
        text("Distance in " + space + " space", margin, iHeight - 0.1 * margin);
        float[] avgVar = getAvgVar();
        text("Average: " + avgVar[0], margin + 0.35 * iWidth, iHeight - 0.1 * margin);

        text("Standard deviation: " + avgVar[1], margin + 0.6 * iWidth, iHeight - 0.1 * margin); 
        
        for (int i = 0; i < colors.length; i++) {
            Color c = colors[i].clone();
            c.toRGB();
            fill(c.getChannelValue(0), c.getChannelValue(1), c.getChannelValue(2));
            rect(i * matrixWidth + margin, i * matrixHeight+ margin, matrixWidth, matrixHeight);
            //rect(0, i * matrixHeight + margin, margin, matrixHeight);
        }
        
        for (int i = 0; i < colors.length; i++) {
            toSpace("RGB");
            fill(getColorChannel(i, 0), getColorChannel(i, 1), getColorChannel(i, 2));

            rect(i * matrixWidth + margin, 0, matrixWidth, margin);
            rect(0, i * matrixHeight + margin, margin, matrixHeight);
        }

        for (int i = 0; i <= colors.length; i++) {
            stroke(1);
            line(margin, margin + i * matrixHeight, iWidth - margin, margin + i * matrixHeight);
        }

        for (int i = 0; i <= colors.length; i++) {
            stroke(1);
            line(margin + i * matrixWidth, margin, margin + i * matrixWidth, iHeight - margin);
        }

        for (int i = 0; i < colors.length; i++) {
            for (int j = 0; j < colors.length; j++) {
                fill(128);
                text(distanceMatrix[i][j], (i + 0.5) * matrixWidth, (j + 0.6) * matrixHeight + margin);
            }
        }                
        popStyle();
    }
    
    public int schemeSize(){
        return colors.length;
    }
}


public class Color {

    private String space;
    ColorChannel[] channels;

    public Color(String spaceName, int v1, int v2, int v3) {
        if (spaceName.equals("RGB")) {
          if(v1 > 255 || v1 < 0 || v2 > 255 || v2 < 0 || v3 > 255 || v3 < 0){
              println("Cry. In class color, find out of boundary in making RGB.");
              //return null;
          }
            channels = new ColorChannel[3];
            channels[0] = new ColorChannel("R", v1);
            channels[1] = new ColorChannel("G", v2);
            channels[2] = new ColorChannel("B", v3);
            space = spaceName;
        } else if (spaceName.equals("CIELAB")) {
              if(v1 - 100 > 0|| v1 < 0 || v2 - 98.254 > 0 || v2 + 86.185 < 0 
              || v3 - 94.482 > 0 || v3 + 107.863 < 0){
                  println("Cry. In class color, find out of boundary in making CIELAB.");
                  println(v1+ ", " + v2 + ", " + v3);
                  //return null;
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
    
    
    /*
     may put these conversion code in factory methods?
     */
     
    public Color clone(){ 
        return new Color(space, channels[0].getValue()
                        ,channels[1].getValue(),channels[2].getValue());
    }
    
    public Color getRGB(){
        Color c = this.clone();
        c.toRGB();
        return c; 
    }
    
    public Color getCIELAB(){
        Color c = this.clone();
        c.toCIELAB();
        return c; 
    }

    public void toRGB() {
        if (space == "RGB") {
            return;
        } else if (space == "CIELAB") {
            // from LAB to XYZ
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
            X = X / 100.0;        //X from 0 to  95.047      (Observer = 2°, Illuminant = D65)
            Y = Y / 100.0;        //Y from 0 to 100.000
            Z = Z / 100.0;        //Z from 0 to 108.883

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

            
            R = range(int(R * 255.0));
            G = range(int(G * 255.0));
            B = range(int(B * 255.0));
            
/*
            R = int(R * 255.0);
            G = int(G * 255.0);
            B = int(B * 255.0);
 */           
            space = "RGB";
            channels[0] = new ColorChannel("R", R);
            channels[1] = new ColorChannel("G", G);
            channels[2] = new ColorChannel("B", B);
        }
    }

    private int range(int n){
      if(n <= 255 && n >= 0)
          return n;
      if(n > 255)
          return 255;
      else 
          return 0;
    
    }


    public void toCIELAB() {
        if (space == "CIELAB") {
            return;
        } else if (space == "RGB") {
            float r, g, b, X, Y, Z, fx, fy, fz;
            float Ls, as, bs;
            float eps = 0.008856;

            float ref_X = 95.047;  // reference white D65
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

    public String getSpaceName() {
        return space;
    }

    public float distance(Color c) {
        String spaceName = c.getSpaceName();
        if (space.equals(spaceName)) {
            float distance = (dist(channels[0].getValue(), channels[1].getValue(), channels[2].getValue(),
                    c.channels[0].getValue(), c.channels[1].getValue(), c.channels[2].getValue()));
            return round(distance * 100.0) / 100.0;
        } else {
            println("In class Color, function distance, the type of color space doesn't macth!");
            return BADRETRUN;
        }
    }

    public boolean increaseChannel(int num, int value) {
        if (num >= 0 && num < 3) {
            int preValue = channels[num].getValue();
            if (space.equals("RGB")) {
                if (preValue + value <= 255 && preValue + value >= 0) {
                    channels[num] = new ColorChannel(channels[num].getName(),
                            channels[num].getValue() + value);
                    return true;
                } else {
                    println("Touch the boundary of RGB space.");
                    return false;
                }
            } else if (space.equals("CIELAB")) {
                int preValue = channels[num].getValue();
                if (num == 0) {
                    if (preValue + value >= 0 && preValue + value <= 100) {
                        channels[num] = new ColorChannel(channels[num].getName(),
                                channels[num].getValue() + value);
                        return true;
                    }
                }
                if (num == 1) {
                    if (preValue + value >= -86.185 && preValue + value <= 98.254) {
                        channels[num] = new ColorChannel(channels[num].getName(),
                                channels[num].getValue() + value);
                        return true;
                    }
                }
                if (num == 2) {
                    if (preValue + value >= -107.863 && preValue + value <= 94.482) {
                        channels[num] = new ColorChannel(channels[num].getName(),
                                channels[num].getValue() + value);
                        return true;
                    }
                }
                println("In class Color, function increaseChannel, find incorrect parameters!");
                return false;
            }
        } else {
            println("In class Color, function increaseChannel, find incorrect parameters!");
            return false;
        }
    }

    int getChannelValue(int index) {
        if(index < channels.length && index >= 0){
           return channels[index].getValue();
        }else {
           println("In class Color, function increaseChannel, find out of boundary!");
           return BADRETRUN;
        }
    }

    public String toString() {
        return channels[0].getName() + " = " + channels[0].getValue() + ", "
                + channels[1].getName() + " = " + channels[1].getValue() + ", "
                + channels[2].getName() + " = " + channels[2].getValue();

    }
}

public class ColorChannel{
      private String name;
      int value;
      public ColorChannel(String str, int v){
          name = str;
          value = v;        
      }
      
      public int getValue(){
          return value;
      }
      
      public String getName(){
          return name;
      }
}
int margin = 20;
int marginLeft = 20;
int marginRight = 20;
int marginTop = 20;
int marginBottom = 20;
int numberOfColor = 8;
int matrixWidth = 70;
int matrixHeight = 60;
int iWidth = numberOfColor * matrixWidth + marginLeft+ marginRight ;
int iHeight = numberOfColor * matrixHeight + 2 * margin; 
final int BADRETRUN = MIN_INT;
ColorScheme cs;
void setup(){
    size(iWidth, iHeight);
    textAlign(LEFT);
    background(255);
    example();
}
void example(){
    // how to initialize a color scheme
       
    Color[] colorsrr = new Color[numberOfColor];
    colorsrr[0] = new Color("CIELAB", 0,21,34);
    colorsrr[1] = new Color("CIELAB", 99,25,-35);
    colorsrr[2] = new Color("CIELAB", 68,48,40);
    colorsrr[3] = new Color("CIELAB", 1,-24,-34);
    colorsrr[4] = new Color("CIELAB", 100,-22,34);
    colorsrr[5] = new Color("CIELAB", 71,-47,-40);
    colorsrr[6] = new Color("CIELAB", 29,47,-39);
    colorsrr[7] = new Color("CIELAB", 32,-48,40);
   
    cs = new ColorScheme(colorsrr, "CIELAB");
    
    // print the distance matrix in current color space
    cs.printDistance();
    
    // convert the current color scheme to the other color space
    cs.toSpace("RGB");
    println(cs.colors[0].toString());
    cs.printDistance();
    
    // how to get a color in color scheme
    Color c = cs.getColor(0);
    println("1. " + c.getSpaceName());
    // do not recommmend
    Color c = cs.colors[0]; 
    
    // how to get a channel value of a color
    println("2. " + cs.getColorChannel(0, 0));
    // do not recommend
    cs.colors[0].channels[0].value;
    
    // how to get the distance between two colors in current color space  
    println("3. " + cs.getColor(0).distance(cs.getColor(2)));
    // do not recommend
    cs.colors[0].distance(cs.colors[2]);
    
    // how to get the value of an entry in the distance matrix
    println("4. " + cs.getDistance(0, 0));
    // do not recommend
    cs.distanceMatrix[0][0]; // have to check the boundary yourself
          
    // how to increase/decrease the value in a color channel
    // boolean flag = cs.getColor(0).increaseChannel(0, 1); 
    // println("5. " + flag); // if flag == false, fail in increasing the value
    // do not recommend, you have to check the boundary yourself
    // cs.colors[0].channels[0].value += 1; 
    
    //cs.toSpace("RGB");
    cs.printColors();
    cs.toSpace("CIELAB");
    cs.printColors();
    cs.display();
}


