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
